#!/bin/bash


# prerequisites:
# sudo apt-get install g++-arm-linux-gnueabihf
# sudo apt-get install gcc-arm-linux-gnueabihf
# sudo apt-get install binutils-arm-linux-gnueabihf
# TODO: FIXME: make sure to find the appropriate versions of openssl, sqlite and boost in the image sysroot and download them based on that

MAIN_DIR=$(pwd)

OUT_DIR="$MAIN_DIR/out"
SQLITE_DIR="$OUT_DIR/sqlite"
OPENSSL_INSTALL_DIR="$OUT_DIR/openssl"

echo "$MAIN_DIR $OUT_DIR $SQLITE_DIR $OPENSSL_INSTALL_DIR"

SYSROOT_DIR="$MAIN_DIR/sysroot"
BOOST_DIR="$MAIN_DIR/boost_1_74_0"

cat >toolchain.cmake <<EOL
set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR arm)
set(CMAKE_C_COMPILER "/usr/bin/arm-linux-gnueabihf-gcc")
set(CMAKE_CXX_COMPILER "/usr/bin/arm-linux-gnueabihf-g++")
set(CMAKE_FIND_ROOT_PATH "${SYSROOT_DIR};${BOOST_DIR};${BOOST_DIR}/stage/lib")
set(CMAKE_SYSROOT ${SYSROOT_DIR})
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(BOOST_ROOT "${BOOST_DIR}")
set(Boost_INCLUDE_DIR "${BOOST_DIR}")
include_directories("${BOOST_DIR}" "${SYSROOT_DIR}/usr/include")
link_directories("${SYSROOT_DIR}/usr/lib/arm-linux-gnueabihf")
set(Boost_NO_SYSTEM_PATHS ON)
set(BOOST_LIBRARYDIR "${SYSROOT_DIR}/usr/lib/arm-linux-gnueabihf")
set(CMAKE_TRY_COMPILE_TARGET_TYPE "STATIC_LIBRARY")
link_libraries(pthread)
EOL

if [[ -f sysroot_prepared ]]
then
    echo "sysroot already prepared"
    exit 0
fi

ls -l "$SYSROOT_DIR"

# TODO only build these things when the respective "out" folders are empty

# cross compile sqlite3
if [[ ! -f sqlite-autoconf-3340100.tar.gz ]]
then
    wget https://www.sqlite.org/2021/sqlite-autoconf-3340100.tar.gz
    tar xvzf sqlite-autoconf-3340100.tar.gz
fi

cd sqlite-autoconf-3340100
./configure --host=arm-linux --prefix="$SQLITE_DIR" CC=/usr/bin/arm-linux-gnueabihf-gcc
make -j8
make install

cp $SQLITE_DIR/include/*.h "$SYSROOT_DIR/usr/include/"
cp $SQLITE_DIR/lib/lib* "$SYSROOT_DIR/usr/lib/"

cd $MAIN_DIR

# cross compile openssl
if [[ ! -d openssl ]]
then
    git clone https://github.com/openssl/openssl.git
    cd openssl
    git checkout OpenSSL_1_1_1-stable 
    cd $MAIN_DIR
fi

cd openssl
./Configure linux-generic32 shared --prefix=$OPENSSL_INSTALL_DIR --openssldir=$OPENSSL_INSTALL_DIR
make depend -j8
make -j8
make install

cp -R $OPENSSL_INSTALL_DIR/include/openssl "$SYSROOT_DIR/usr/include/"
cp $OPENSSL_INSTALL_DIR/lib/lib* "$SYSROOT_DIR/usr/lib/"

cd $MAIN_DIR

#cross compile boost
if [[ ! -f boost_1_74_0.tar.bz2 ]]
then
    wget https://sourceforge.net/projects/boost/files/boost/1.74.0/boost_1_74_0.tar.bz2
    tar xjvf boost_1_74_0.tar.bz2
fi

cd boost_1_74_0

# we must go back to the host compiler for building the "b2" tool
export CC=/usr/bin/gcc
export CXX=/usr/bin/g++

./bootstrap.sh

CONFIG_JAM=$(mktemp)

echo "using gcc : arm : /usr/bin/arm-linux-gnueabihf-g++ ;" > "$CONFIG_JAM"
./b2 --user-config="$CONFIG_JAM" --with-system --with-filesystem --with-exception --with-log --with-program_options --with-date_time --no-samples --no-tests toolset=gcc-arm link=shared cxxflags=-fPIC

cd $MAIN_DIR

# here we can safely go back to the cross compiler
export CC=/usr/bin/arm-linux-gnueabihf-gcc
export CXX=/usr/bin/arm-linux-gnueabihf-g++

touch sysroot_prepared

