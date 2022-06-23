#!/bin/bash
echo "Cross compiling"
export CC=/usr/bin/arm-linux-gnueabihf-gcc
export CXX=/usr/bin/arm-linux-gnueabihf-g++
./build.sh
