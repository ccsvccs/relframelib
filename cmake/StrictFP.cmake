include_guard(GLOBAL)

# Apply only to a future first-party numerical target, never globally to vendors.
function(relframe_target_strict_fp target)
    if(NOT TARGET "${target}")
        message(FATAL_ERROR "Unknown strict-FP target: ${target}")
    endif()

    if(MSVC OR CMAKE_C_COMPILER_FRONTEND_VARIANT STREQUAL "MSVC")
        target_compile_options(${target} PRIVATE /fp:strict)
    elseif(CMAKE_C_COMPILER_ID MATCHES "GNU|Clang|AppleClang")
        target_compile_options(${target} PRIVATE -fno-fast-math -ffp-contract=off)
    else()
        message(FATAL_ERROR "Strict-FP policy is not defined for ${CMAKE_C_COMPILER_ID}")
    endif()
endfunction()
