#!/bin/bash

MAIN_DIR=$(pwd)

SYSROOT_DIR="$MAIN_DIR/sysroot"

cat >toolchain.cmake <<EOL
set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR arm)
set(CMAKE_C_COMPILER "/usr/bin/aarch64-linux-gnu-gcc")
set(CMAKE_CXX_COMPILER "/usr/bin/aarch64-linux-gnu-g++")
set(CMAKE_FIND_ROOT_PATH "${SYSROOT_DIR};${SYSROOT_DIR}/usr/lib/aarch64-linux-gnu;${SYSROOT_DIR}/usr/include/aarch64-linux-gnu")
set(CMAKE_PREFIX_PATH "${SYSROOT_DIR};${SYSROOT_DIR}/usr/lib/aarch64-linux-gnu;${SYSROOT_DIR}/usr/include/aarch64-linux-gnu")
set(CMAKE_SYSROOT ${SYSROOT_DIR})
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
include_directories("${SYSROOT_DIR}/usr/include")
link_directories("${SYSROOT_DIR}/usr/lib/aarch64-linux-gnu")
set(CMAKE_TRY_COMPILE_TARGET_TYPE "STATIC_LIBRARY")
link_libraries(pthread)
EOL
