# Development environment (initial scaffold)

## Philosophy

This repository starts with documentation and portable build configuration. **All substantive C implementation and its tests are developed locally first.** Only reviewed source changes should be pushed as subsequent commits/PRs. There is no installed library target and no public API.

## Prerequisites

- Git
- CMake >= 3.24
- A C11 compiler: GCC, Clang/AppleClang or MSVC
- Unix shell for the optional dependency-boundary lint helper (Windows developers may run it in Git Bash/WSL)

Future dependencies are **not** mandatory for this initial scaffold:
- MPFR/GMP for independent high-precision oracle tests (test-only)
- ERFA for research comparisons and boundary adapters
- QD or reviewed double-double primitives, subject to license/API/accuracy review
- SPICE only for optional ephemeris provider adapters, never for core

## Configure/build smoke check

~~~sh
cmake -S . -B build -DCMAKE_BUILD_TYPE=Debug
cmake --build build
sh tools/check_deps.sh
~~~

On Windows/MSVC, use:

~~~powershell
cmake -S . -B build -A x64
cmake --build build --config Debug
~~~

**What this verifies today:** CMake project configuration; compiler detection; build-system generation; initial dependency-boundary lint's ability to execute. No numeric targets or test cases exist yet.

## CMake policy

- C11; no GNU language extensions are required by the core.
- No fast-math in core numerical targets.
- The per-target helper in cmake/StrictFP.cmake will be applied to each future numerical target.
- Optional ASan/UBSan helper in cmake/Sanitizers.cmake is for supported non-MSVC debug builds; do not silently claim all matrix cells have sanitizers.
- CTest is enabled for future tests. No test is currently registered.
- Do not globally inject compiler flags into unrelated test providers or third-party libraries.
- Vendor/link decisions for external numerical libraries remain explicit and reviewable.

## CI status

The initial GitHub Actions workflow performs a **scaffold smoke check** on Linux GCC/Clang, macOS Apple Silicon/Clang and Windows/MSVC. It does not assert cross-compiler numerical parity or reference accuracy. Once numerical tests are added, extend CI to run unit/oracle/physics/golden and include sanitizer-enabled debug variants.

## Proposed local workflow

~~~sh
git clone https://github.com/ccsvccs/relframelib.git
cd relframelib
git switch -c feat/epoch-dd
# Develop and test C implementation locally; keep public API unstable.
# Add tests, provenance and documented tolerances in the same patch.
git add .
git commit -m "feat: add validated double-double epoch primitives"
git push -u origin feat/epoch-dd
~~~

Review changes against [architecture.md](architecture.md), [numerics.md](numerics.md) and [validation-plan.md](validation-plan.md). A change that alters time scale, ephemeris convention, anchor, floating-point assumptions or golden fixture rules must document that change.

## Third-party licensing

No license for this repository or vendored code has been selected in this bootstrap commit. Verify the chosen upstream version and applicable obligations before importing QD, ERFA or other sources. Do not assume a library's header license covers every copied implementation.
