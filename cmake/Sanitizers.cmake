include_guard(GLOBAL)

# V1 scaffold: opt-in per first-party target; not all compilers support these.
function(relframe_target_sanitizers target)
    if(NOT TARGET "${target}")
        message(FATAL_ERROR "Unknown sanitizer target: ${target}")
    endif()

    if(NOT RELFRAME_ENABLE_SANITIZERS)
        return()
    endif()

    if(MSVC OR CMAKE_C_COMPILER_FRONTEND_VARIANT STREQUAL "MSVC")
        message(FATAL_ERROR "ASan/UBSan helper is not configured for MSVC")
    elseif(CMAKE_C_COMPILER_ID MATCHES "GNU|Clang|AppleClang")
        target_compile_options(${target} PRIVATE -fsanitize=address,undefined -fno-omit-frame-pointer)
        target_link_options(${target} PRIVATE -fsanitize=address,undefined)
    else()
        message(FATAL_ERROR "Sanitizers are not configured for ${CMAKE_C_COMPILER_ID}")
    endif()
endfunction()
