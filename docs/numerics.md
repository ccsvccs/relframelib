# Numerical representations and conventions (V1 contract proposal)

## 1. Precision requirements are different from accuracy claims

The eventual cislunar clock/navigation goal motivates sub-picosecond analysis, but **internal representational resolution**, **numerical integration error**, **model error**, and **residual against a reference ephemeris** are different quantities. Passing an arithmetic oracle test does not establish an end-to-end physical accuracy claim.

Use explicit SI units, signs and independent variables throughout a test vector.

## 2. Proposed internal epoch

- Integer day: signed 64-bit day index on a **uniform coordinate-time** Julian-day axis.
- Subday: double-double (hi, lo) seconds, normalized to [0, 86400) with a clear boundary/overflow policy.
- Choose and document the day boundary (astronomical JD integer boundaries occur at noon, rather than civil midnight).
- A coordinate day is treated as exactly 86400 SI seconds within the declared idealized coordinate-time convention. This is **not** a UTC calendar/leap-second representation.
- Do not represent absolute epochs solely as a binary64 count of seconds or a binary64 Julian date.

TwoSum/TwoProd, double-double add/multiply, normalization, epoch differences and conversion rounding must be explicitly tested. Confirm behavior for negative epochs, day crossings, anchors and covered endpoints.

## 3. ERFA/SOFA-style two-part JD boundary

A two-part Julian date is **not automatically** a femtosecond-accurate interchange format for an arbitrary decomposition. In particular, integer day + a **single binary64 fractional day** loses fine subday detail near half-day offsets; a far-off fixed epoch + large fractional-day component can lose even more.

The bridge must:

1. document an exact splitting/rounding convention;
2. keep a remainder component at a scale appropriate for the required precision, rather than assuming arbitrary (jd1, jd2) arrangements are equivalent numerically;
3. compare its forward/reverse behavior with an independent high-precision oracle;
4. distinguish representational limits of ERFA call inputs from the internal epoch representation.

**Do not set a universal 1 fs round-trip assertion for every arbitrary ERFA-style split.** First prove a concrete conversion policy and specify the valid domain. Keep this bridge outside the core.

## 4. Arithmetic and dependencies

- Candidate: independently reviewed double-double primitives informed by QD, but **no imported third-party source or pinned implementation yet**. Verify both the particular API/license and behavior before choosing vendoring versus linkage.
- MPFR/GMP: high-precision independent reference in test-only targets.
- ERFA: conventions/comparison and boundary conversion outside the core.
- GCC/Clang libquadmath and compiler long double: optional experimental oracles, never required by kernel.
- Prohibit fast-math in numerical targets; initially disable implicit FP contraction to compare compilers. Explore explicit FMA as a separate experimental configuration.

Do not promise bitwise identical output across unrelated compilers without measurements. Handle non-finite values, signed zeros, overflow and input domain errors intentionally.

## 5. Scale semantics

Model and data must explicitly declare whether quantities are TCB-compatible or TDB-compatible, and whether a quantity is a time argument, position, velocity, acceleration, mass parameter, radius or multipole coefficient.

An affine scale conversion is not just a numeric timestamp rename. The matching coordinate/GM conventions for ephemerides must be carried consistently into the PN-rate model. Derive the transformation for each geometric/physical quantity (including multipoles) before selecting a single internal convention.

## 6. Anchors and signs

- Define every modeled difference as **output coordinate time minus input coordinate time**, with both scale labels recorded.
- Verify Earth and Moon anchor events independently; do not assume their 1977 anchor construction or offsets are symmetric.
- The placement of TDB0 and other conventional additive offsets is an explicit decision pending reference confirmation.
- A transformation's independent variable and its integration variable must be recorded separately from the reported difference.

## 7. Error budgets / diagnostics

Each golden vector should include: source commit, model config, external data hashes, ephemeris coverage, time scale, scale convention, units, sign, independent variable, anchor, quadrature settings, component rates and segment-integrated contributions.

Evaluate absolute time errors, rate errors, boundary behavior, cumulative drift and periodic residual structure separately. Where physically justified, compare both relative tolerances and absolute SI tolerances.
