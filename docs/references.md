# Research and standards references

The list documents the research lineage and interoperability context. It is **not** a statement that the V1 repository implements or validates each reference.

## Primary research

- Turyshev and collaborators, *High-Precision Relativistic Time Scales for Cislunar Navigation* — primary theoretical and numerical target.
- Turyshev and collaborators, *Relativistic Time Transformations Between the Solar System Barycenter, Earth, and Moon* — related coordinate-time transformations.
- *A relativistic framework to establish coordinate time on the Moon and beyond* — local lunar coordinate-time context.
- *Relativistic framework for high-precision GNSS processing in GCRS/BCRS with extension to cislunar space* — broader reference-frame/navigation context.

Verify the canonical bibliographic metadata and versions in the research repository before adding DOI-specific citations to published documentation.

## Conventions and software

- IAU BCRS/GCRS relativistic reference-frame and coordinate-time resolutions; distinguish defining conventions from implementation approximations.
- [ERFA](https://github.com/liberfa/erfa) — astronomical routines and two-part Julian-date conventions; potential comparison/bridge component.
- [SOFA](https://www.iausofa.org/) — reference astronomical standards and algorithms.
- [QD](https://www.davidhbailey.com/dhbsoftware/) — extended floating-point arithmetic lineage; verify the actual artifact and license before copying sources.
- [GNU MPFR](https://www.mpfr.org/) and [GMP](https://gmplib.org/) — possible higher-precision test oracles.
- [NAIF SPICE](https://naif.jpl.nasa.gov/naif/) — optional ephemeris adapter tooling, never a core runtime requirement.

## Ephemerides and comparisons

- JPL DE440/DE441 planetary/lunar ephemerides and their associated documentation.
- JPL time ephemeris DE440t where supported by the relevant dataset and conventions.
- Lunar Time Ephemeris LTE440; reproduce provenance/version/coverage, not just a reported scalar residual.
- Park et al., *The JPL Planetary and Lunar Ephemerides DE440 and DE441* (2021).

## Companion work

- [cislunar-timescale-experiments](https://github.com/ccsvccs/cislunar-timescale-experiments) — experiment code, Python numerical cross-checks and future fixture generation.

No numerical residual figures in a draft document should be treated as verified results until the datasets, exact interval and sign convention are recoverable.
