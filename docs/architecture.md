# Architecture — V1 (proposed, not yet implemented)

## 1. Purpose and boundary

relframelib is a research-oriented C implementation of high-precision relativistic reference-frame and coordinate-time transformations under explicitly stated IAU conventions.

- Initial numerical scope: barycentric coordinate-time relations for the Earth/Moon system, together with their rate models, ephemeris states, quadrature and inverse transformations.
- Later scope (separate research gate): spacetime-event transformations, Jacobians and PN metric consistency.
- It is not a planetary ephemeris producer, a general GR solver, or a packaged navigation estimator.
- V1 has **no public ABI**. Names, layouts, and algorithms may change during validation.

The research repository, [cislunar-timescale-experiments](https://github.com/ccsvccs/cislunar-timescale-experiments), remains independent. It provides Python experiments and carefully versioned reference vectors, **not** runtime logic for the C core.

## 2. Structural invariants

1. No mutable process-wide state: all configuration, integration history, diagnostics and provider context are explicitly supplied by callers.
2. An internal ephemeris provider function table is the only way physical code receives body states. No direct SPICE/file/network access from core.
3. Types and variable names identify **time scale**, **coordinate compatibility/scaling** and **units**. Never silently mix TCB-compatible and TDB-compatible quantities.
4. Physics modules depend only on core abstractions; provider backends, ERFA bridges, tests and Python bindings cannot be dependencies of core.
5. Core targets only the C standard library plus libm, with no dynamic allocation on its numerical hot path. Scratch buffers and integration history have explicit ownership.

These constraints do not require freezing a public interface; an internal struct/function-pointer contract is sufficient for V1.

## 3. Intended layout (roadmap; not all paths exist yet)

~~~text
relframelib/
├── CMakeLists.txt
├── cmake/
│   ├── StrictFP.cmake
│   └── Sanitizers.cmake
├── docs/
│   ├── architecture.md
│   ├── numerics.md
│   ├── validation-plan.md
│   ├── development.md
│   ├── references.md
│   └── adr/
├── src/
│   ├── core/                # Future dependency-light kernel
│   │   ├── dd.h, dd.c
│   │   ├── epoch.h, epoch.c
│   │   ├── scales.h, scales.c
│   │   ├── provider.h
│   │   ├── sources.h, sources.c
│   │   ├── potential.c
│   │   ├── pn_rate.c
│   │   ├── quad.c
│   │   ├── history.c
│   │   ├── center_time.c
│   │   └── status.h
│   ├── providers/           # Future analytic/table/SPICE adapters
│   └── io/                  # Future ERFA and reference-vector bridges
├── tests/
│   ├── unit/
│   ├── oracle/
│   ├── physics/
│   ├── golden/
│   └── fixtures/
├── python/                  # Research-only bindings/exporters; no wheel
└── tools/
    └── check_deps.sh
~~~

The layout is descriptive: source modules will be introduced in **local development**, only when their contracts and acceptance tests are ready.

## 4. Dependency direction

~~~text
 Research/Python calculations --export--> immutable golden vectors
              |                                 |
              | reference comparisons            v
              +------------------------------ tests/golden
                                                |
                                           [internal C target]
                                                |
                    center_time -> history -> quadrature
                         |                  |
                         +----> pn_rate -> potential -> sources
                                     |              |
                                  scales <----------+
                                     |
                    provider interface / epoch / dd
                                     ^
                        only callbacks + context
                                     |
        providers/analytic, providers/table, providers/spice
          (implement interface, never called directly by physics)

 tests/oracle -> MPFR/GMP; io/erfa_bridge -> ERFA
 Neither MPFR nor ERFA may be an implicit runtime dependency of core.
~~~

The internal provider supplies a batched sequence of epochs × bodies where the performance experiment justifies it. Exact callback signature, batch size, error policy and scratch ownership are deliberately undecided until the D12 experiment.

## 5. Representation and provenance

- Internally represent an epoch as integer uniform-coordinate day plus double-double seconds; see [numerics.md](numerics.md).
- Distinguish a point/event's coordinate time from its spatial coordinate and the chosen compatible gravitational parameter conventions.
- Provider metadata must specify the ephemeris/time argument, reference frame, units, scaling convention, interpolation/differentiation policy, source identity and coverage.
- Explicitly record model-term switches and Earth/Moon/EMB source composition. Reject double counting rather than silently correcting it.
- Core may ingest an ephemeris provider, but must not internally install or assume a single external dataset.

## 6. Numerical flow

For a specified target interval and scale convention:

1. Resolve a validated source/model configuration and a reference anchor.
2. Request ephemeris states via provider callbacks with the appropriate independent time variable.
3. Compute PN rate contributions **separately** (external potential, kinematics, higher-order terms), retaining term-level diagnostics.
4. Integrate the chosen rate difference with a stated quadrature and error estimate; use compensated accumulation/history when needed.
5. Apply documented affine scale conventions and anchor offsets in the specified order.
6. Solve inverse relations iteratively if needed, with convergence diagnostics.
7. Compare term-level rates and accumulated changes to independent golden vectors; investigate, do not hide, residual differences.

Do not assume direct TDB-compatible evaluation is algebraically/numerically interchangeable with a TCB-compatible route until the relevant PN-order scaling experiment is complete.

## 7. Explicit non-goals for V1

No public ABI, no generic four-dimensional event-transform API, no disk cache, no threading promises, no plugin ABI, no installed Python package, and no automatic SPICE download. V1's purpose is to establish physically interpretable, reproducible numerical behavior prior to a library extraction.
