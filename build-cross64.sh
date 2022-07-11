#!/bin/bash
echo "Cross compiling"
export CC=/usr/bin/aarch64-linux-gnu-gcc
export CXX=/usr/bin/aarch64-linux-gnu-g++
export PIONIX_BUILD_SYSROOT=1
./build.sh
