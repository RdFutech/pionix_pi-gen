#!/bin/bash -e

#install -m 755 files/install_update "${ROOTFS_DIR}/usr/bin"
install -m 644 files/display-app.service "${ROOTFS_DIR}/lib/systemd/system/"

# update font cache
on_chroot <<EOF
#apt install -y ttf-mscorefonts-installer
fc-cache
EOF

mkdir -p $WORK_DIR/pionixbox

(
# copy sysroot
cd $WORK_DIR/pionixbox
MAIN_DIR=$WORK_DIR/pionixbox
mkdir -p $MAIN_DIR/sysroot/usr
cp -R "${ROOTFS_DIR}/usr/include" "$MAIN_DIR/sysroot/usr"
cp -R "${ROOTFS_DIR}/usr/lib" "$MAIN_DIR/sysroot/usr"
ls -l "$MAIN_DIR/sysroot/usr"
SYSROOT_DIR="$MAIN_DIR/sysroot"
ln -sf "$SYSROOT_DIR/usr/lib" "$SYSROOT_DIR/lib"

# fix broken symlinks
(
    cd $SYSROOT_DIR/usr/lib/arm-linux-gnueabihf
    ln -sf libanl.so.1 libanl.so
    ln -sf libBrokenLocale.so.1 libBrokenLocale.so
    ln -sf libcrypt.so.1 libcrypt.so
    ln -sf libdl.so.2 libdl.so
    ln -sf libm.so.6 libm.so
    ln -sf libnss_compat.so.2 libnss_compat.so
    ln -sf libnss_dns.so.2 libnss_dns.so
    ln -sf libnss_files.so.2 libnss_files.so
    ln -sf libnss_hesiod.so.2 libnss_hesiod.so
    ln -sf libpcre.so.3 libpcre.so
    ln -sf libpthread.so.0 libpthread.so
    ln -sf libresolv.so.2 libresolv.so
    ln -sf librt.so.1 librt.so
    ln -sf libselinux.so.1 libselinux.so
    ln -sf libsepol.so.1 libsepol.so
    ln -sf libthread_db.so.1 libthread_db.so
    ln -sf libtirpc.so.3 libtirpc.so
    ln -sf libutil.so.1 libutil.so
    ln -sf libz.so.1 libz.so
)

ARM_SYSROOT_DIR="$SYSROOT_DIR/usr/lib/arm-linux-gnueabihf"
# fix lib symlinks
ln -sf "$ARM_SYSROOT_DIR/libdrm.so.2" "$ARM_SYSROOT_DIR/libdrm.so"
ln -sf "$ARM_SYSROOT_DIR/libgbm.so.1" "$ARM_SYSROOT_DIR/libgbm.so"
ln -sf "$ARM_SYSROOT_DIR/libEGL.so.1" "$ARM_SYSROOT_DIR/libEGL.so"
ln -sf "$ARM_SYSROOT_DIR/libGLESv2.so.2" "$ARM_SYSROOT_DIR/libGLESv2.so"
ln -sf "$ARM_SYSROOT_DIR/libsystemd.so.0" "$ARM_SYSROOT_DIR/libsystemd.so"
ln -sf "$ARM_SYSROOT_DIR/libinput.so.10" "$ARM_SYSROOT_DIR/libinput.so"
ln -sf "$ARM_SYSROOT_DIR/libudev.so.1" "$ARM_SYSROOT_DIR/libudev.so"
ln -sf "$ARM_SYSROOT_DIR/libxkbcommon.so.0" "$ARM_SYSROOT_DIR/libxkbcommon.so"

cat >toolchain.cmake <<EOL
set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR arm)
set(CMAKE_C_COMPILER "/usr/bin/arm-linux-gnueabihf-gcc")
set(CMAKE_CXX_COMPILER "/usr/bin/arm-linux-gnueabihf-g++")
set(CMAKE_FIND_ROOT_PATH "${SYSROOT_DIR}")
set(CMAKE_SYSROOT ${SYSROOT_DIR})
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
include_directories("${SYSROOT_DIR}/usr/include")
link_directories("${SYSROOT_DIR}/usr/lib/arm-linux-gnueabihf")
set(CMAKE_TRY_COMPILE_TARGET_TYPE "STATIC_LIBRARY")
EOL

git clone https://github.com/ardera/flutter-engine-binaries-for-arm.git || true
cd flutter-engine-binaries-for-arm
git pull || true
git checkout deaf44bacae971edfa1ffe84ba39874118a622cc
#sudo ./install.sh: dont run this as it will install on the host OS!
ARM=arm
install ./$ARM/libflutter_engine.so.* ./$ARM/icudtl.dat ${ROOTFS_DIR}/usr/lib
install ./flutter_embedder.h ${ROOTFS_DIR}/usr/include
)

(
cd $WORK_DIR/pionixbox
git clone https://github.com/ardera/flutter-pi.git || true
cd flutter-pi
git pull || true
git checkout a11107b95920861e4bb8f19c4e71cb870c3aa42e
mkdir -p build && cd build
cmake .. -DCMAKE_TOOLCHAIN_FILE=../toolchain.cmake
make -j8
DESTDIR=${ROOTFS_DIR} make install
)

(
cd $WORK_DIR/pionixbox
git clone git@github.com:PionixInternal/pionixbox.git || true
cd pionixbox
git pull || true
mkdir -p build && cd build
cmake ..
make install
 mkdir -p ${ROOTFS_DIR}/opt/displayapp
 cp -r $WORK_DIR/pionixbox/pionixbox/build/dist/flutter_assets/*  ${ROOTFS_DIR}/opt/displayapp
)

on_chroot <<EOF
systemctl enable display-app.service
EOF

