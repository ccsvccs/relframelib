# relframelib

**Relativistic Reference Frames and Time Scales Library**

A research-oriented C library project for high-precision relativistic reference-frame and coordinate-time transformations, initially focused on the Earth–Moon system.

> **Status: pre-implementation / V1 architecture.** No stable API or ABI is promised. Physical/numerical implementation and testing will be developed locally and proposed through normal Git commits or pull requests.

## Scope

- **V1:** a reusable numerical core for barycentric coordinate-time rates and transformations, with strict floating-point behavior, explicit time-scale semantics, provider-independent ephemeris access, and layered verification.
- **Later research:** non-barycentric spacetime-event transformations, Jacobians, and post-Newtonian (PN) metric consistency checks.
- **Out of scope for V1:** a general relativity solver, ephemeris production, a published ABI, Python package release, distributed caching, and public plugin interfaces.

The first application and validation domain is cislunar navigation; the library's conceptual scope is not restricted to cislunar missions.

## Design constraints

1. No mutable global state in the numerical core.
2. Ephemeris states enter the core only through an internal provider function table.
3. Time scales and coordinate/GM scaling conventions are explicitly distinguished.
4. Physical computation depends on `src/core/` abstractions, never on SPICE, file I/O, Python, or tests.
5. The core is intended to have only C standard-library and math-library runtime dependencies, with no heap allocation in its hot paths.

These are **design rules**, not claims about implemented code.

## Repository guide

- [Architecture and module boundaries](docs/architecture.md)
- [Numerical representations and conventions](docs/numerics.md)
- [Validation and acceptance gates](docs/validation-plan.md)
- [Build and development environment](docs/development.md)
- [Architecture decision 0001](docs/adr/0001-v1-scope-and-boundaries.md)
- [Research references](docs/references.md)

## Build scaffold

The repository currently contains a CMake/CI configuration scaffold, **not a built numerical library**.

```sh
cmake -S . -B build -DCMAKE_BUILD_TYPE=Debug
cmake --build build
```

No C implementation targets or tests are registered yet; subsequent local development will add them. CI currently validates configuration/buildability of the scaffold, not the physics or numerical accuracy.

## Relationship to research work

The independent research/validation repository is [cislunar-timescale-experiments](https://github.com/ccsvccs/cislunar-timescale-experiments). It supplies evolving analytical/numerical reference calculations, ephemeris-based experiments, and eventually versioned golden vectors. The C core must not depend on that Python repository at runtime.

## Naming

- Repository: `relframelib`
- CMake project: `relframelib`
- Planned C symbol prefix: `relframe_` (**internal convention only; not a public ABI**)

## Licensing

No software license has been selected yet. Do not import third-party source files until their exact versions and license obligations have been reviewed.
