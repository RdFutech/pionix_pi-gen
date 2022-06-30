#!/bin/bash

MAIN_DIR=$(pwd)

SYSROOT_DIR="$MAIN_DIR/sysroot"

cat >toolchain.cmake <<EOL
set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR arm)
set(CMAKE_C_COMPILER "/usr/bin/arm-linux-gnueabihf-gcc")
set(CMAKE_CXX_COMPILER "/usr/bin/arm-linux-gnueabihf-g++")
set(CMAKE_FIND_ROOT_PATH "${SYSROOT_DIR};${SYSROOT_DIR}/usr/lib/arm-linux-gnueabihf;${SYSROOT_DIR}/usr/include/arm-linux-gnueabihf")
set(CMAKE_PREFIX_PATH "${SYSROOT_DIR};${SYSROOT_DIR}/usr/lib/arm-linux-gnueabihf;${SYSROOT_DIR}/usr/include/arm-linux-gnueabihf")
set(CMAKE_SYSROOT ${SYSROOT_DIR})
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
include_directories("${SYSROOT_DIR}/usr/include")
link_directories("${SYSROOT_DIR}/usr/lib/arm-linux-gnueabihf")
set(CMAKE_TRY_COMPILE_TARGET_TYPE "STATIC_LIBRARY")
link_libraries(pthread)
EOL
