# ADR 0001 — V1 scope and internal boundaries

- **Status:** Accepted for initial repository structure; implementation details provisional
- **Date:** 2026-11-19
- **Decision-makers:** Project maintainers

## Context

The research Python code already explores high-precision Earth/Moon coordinate-time transformations. The next step is a repeatable C numerical/test environment with clear separation between physics, numerical algorithms, ephemeris IO and independent references. Publishing an ABI before numerical behavior stabilizes would create avoidable compatibility debt.

## Decision

1. Bootstrap the repository as a C11 + CMake/CTest project with architecture documentation and CI smoke checks only.
2. Do not expose a stable ABI or claim a complete C API in V1.
3. Reserve a future dependency-light src/core directory with no mutable global state, no direct IO/SPICE, no runtime MPFR/ERFA, and no heap allocation in numerical hot paths.
4. Access ephemeris states exclusively through a core-owned internal provider interface; allow multiple backends to implement it outside core.
5. Make coordinate time scale and compatibility scaling explicit in types/names and fixture metadata.
6. Keep Python research as an external independent reference; fixtures are versioned, independently auditable outputs.
7. Introduce algorithm modules locally alongside independent tests rather than populating placeholders just to mirror a directory tree.

## Consequences

- The docs may describe intended modules not yet present in src/.
- Initial CI only checks the scaffold. Numerical pass/fail claims must wait for implementation.
- Provider callback signatures, memory layout, exact dd primitive implementation, scale path and public API remain open until experiments resolve them.
- A future extracted kernel is feasible without requiring that its ABI be designed now.

## Deferred choices

QD source vs linkage; exact epoch/ERFA split; strict-FP bitwise portability policy; provider batching shape; canonical scaling convention; physical term inclusion; anchor details; licensing.
