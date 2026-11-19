cmake_minimum_required(VERSION 3.24)

project(relframelib
    LANGUAGES C
    DESCRIPTION "Relativistic Reference Frames and Time Scales Library"
)

set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_C_EXTENSIONS OFF)

option(RELFRAME_ENABLE_SANITIZERS "Enable ASan/UBSan on supported future targets" OFF)

include(CTest)
include(cmake/StrictFP.cmake)
include(cmake/Sanitizers.cmake)

# Bootstrap only: no library/source/test targets are defined in this commit.
# Future locally developed numerical targets should opt in to the per-target
# relframe_target_strict_fp() and optional relframe_target_sanitizers() helpers.
message(STATUS "relframelib architecture scaffold: no C implementation or tests yet")
