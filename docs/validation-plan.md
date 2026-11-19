# Validation plan and decision gates

**State:** a research backlog, not passing-test evidence. No C numerical implementation exists in this initial commit.

## Test layers

| Layer | Initial dependencies | Principle | Eventual trigger |
| --- | --- | --- | --- |
| Unit | C core | Algebra, normalizations, invalid inputs, status behavior | Every PR after implementation |
| Oracle | C core + MPFR/GMP (test only) | Arithmetic, epochs, summation against higher precision | Every PR after implementation |
| Physics | C core + analytic provider | Symmetry, limits, scale laws, conservation/consistency tests | Every PR after implementation |
| Golden | C core + immutable vectors | Per-term rates, segment integrals, totals vs Python | Every PR after vector freeze |
| Reference | Research Python + DE440/441/LTE440 | Independent cross-check and historical residual tracking | Manual or scheduled, after setup |

A passing test means the documented acceptance contract passed; it does not certify an unmeasured physical model.

## Mandatory architecture gates (before implementing coupled physics)

| ID | Question | Expected evidence / acceptance rule |
| --- | --- | --- |
| A1 | Integer-day + dd epoch and ERFA boundary round-trip | MPFR comparisons over 1550–2650, day boundaries and anchors; **separate** lossless-internal from boundary-limited errors. Define achievable threshold per concrete split. |
| A2 | Compensated summation error growth | Repeated/day-wise sums vs MPFR; measure drift and growth, do not assume square-root scaling. |
| A3 | Separating constant rate k before integration | Analytic algebra and C experiment for direct vs k-separated integration; distinguish physical equivalence from rounding equivalence. Confirm k is convention-defined, not fitted. |
| A4 | Compiler/FMA effects | GCC/Clang/MSVC strict/default + contraction on/off; per-term and total differences, then choose tolerances. |
| B5 | Direct TDB-compatible vs TCB-compatible route | Derive compatible scaling; compare individual c^-2 and c^-4 terms before declaring equivalence. |
| B7 | Time-difference sign and independent variable | All fixtures record output-input and argument time scale; compare signs and anchor handling explicitly. |
| D12 | Provider batch shape | Benchmark callback overhead and total time at sizes such as 64, 256, 2048; choose signature only after measurement. |

**Gate:** choose the internal epoch normalization, FP contract, scaling convention and provider callback shape before these decisions leak through the rest of core.

## Other numerical/physics gates

| ID | Question | Planned test |
| --- | --- | --- |
| B6 | Scaling of accelerations, radii and multipoles | Analytic derivation and synthetic-provider scale consistency |
| B8 | TCL / 1977 anchor and TDB0 | Event-location proof, reference comparison, offset-placement trace |
| C9 | Long-span ~390–400 ps residual attribution | Controlled source/term switches: small bodies, J2EDOT, attitude, Kuiper ring; trend vs periodic decomposition |
| C10 | Modern-period ~2–3 ps residual | Term-level attribution without fitted correction |
| C11 | Solar spin / external multipole size | Quantitative bound and inclusion decision |
| D13 | Table-provider interpolation | Step/order sweeps for rates and integrated time |
| D14 | SPK segment acceleration derivative continuity | Chebyshev differentiation and segment-boundary jumps |
| D15 | Provider epoch narrowing | Two-part epoch vs single-double epoch, propagated rate/integral differences |
| E16 | Quadrature additivity | Integral[a,c] versus Integral[a,b]+Integral[b,c], with controlled tolerances |
| E17 | Inverse-map convergence | Iteration count, coverage boundaries, forward/inverse closure |
| E18 | History/cache invalidation | Model/data/quad config changes reject prior history; V1 in-memory only |
| F19 | 4D local transformations | **Python-only** flat/Lorentz/center limits |
| F20 | Metric pullback | **Python-only** PN-order Jacobian/metric residual |
| F21 | Multi-frame closed loop | **Python-only** GCRS→BCRS→LCRS→BCRS→GCRS |
| F22 | Local expansion validity | **Python-only** distance-dependent truncation in LLO/NRHO/L1 cases |
| G23 | Tolerances and comparison granularity | Distinguish per-rate ulps from absolute integrated-time tolerances |
| G24 | C vs Python reference parity | Explain every change from independent DE440t/LTE440 comparisons; no unexplained improvement or regression |

The ~390–400 ps, ~2–3 ps and example 0.01 ps figures are **investigation leads from existing research**, not automatically accepted specification values or results produced by this repository. Confirm spans, sources, signs, exact conventions and comparison code before turning them into CI thresholds.

## Golden fixture schema — preliminary

At minimum, each fixture must record:

- generating research repository URL + immutable Git commit;
- external source file identity and cryptographic hash;
- model-switch set, parameter/constants version and integration settings;
- epoch representation, independent time scale, coordinate compatibility and units;
- requested output/input time scales and difference sign;
- reference anchor and applied additive offsets;
- per-term rate contributions (c^-2, c^-4, external potential, kinetic and further terms);
- segmented integration results, totals and reference results;
- declared numeric tolerance rule per field.

Keep fixture data separate from code. Do not silently regenerate/rebaseline failing golden vectors.

## Execution order

1. Bootstrap skeleton (this commit): architecture, toolchain configuration, CI configure/build smoke checks.
2. Local C numerical work: A1–A4; add MPFR reference tests and register them with CTest.
3. Local convention work: B5/B7 and synthetic providers; validate scale/source declarations.
4. D12 provider batching benchmark, followed by provider contract stabilization.
5. Port rate decomposition and quadrature; integrate unit, physics and golden tests.
6. Independent full reference comparisons and diagnostic physics questions.
7. Investigate F19–F22 in the research environment before considering a four-dimensional C interface.

CI should only claim stages that actually have tests and reference data.
