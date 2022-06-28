#!/bin/bash
if [ "${PIONIX_BUILD_SYSROOT}" = "1" ]; then
    exit 0
fi

# build rauc for arm

mkdir -p $WORK_DIR/rauc-arm/pionix-rauc
ARM_INSTALL_DIR=$WORK_DIR/rauc-arm/pionix-rauc
mkdir -p $WORK_DIR/rauc-host/pionix-rauc
HOST_INSTALL_DIR=$WORK_DIR/rauc-host/pionix-rauc

mkdir -p "${ARM_INSTALL_DIR}/DEBIAN"
cp control-arm "${ARM_INSTALL_DIR}/DEBIAN/control"

mkdir -p "${HOST_INSTALL_DIR}/DEBIAN"
cp control-amd64 "${HOST_INSTALL_DIR}/DEBIAN/control"
(
# copy sysroot
cd $WORK_DIR/rauc-arm
MAIN_DIR=$WORK_DIR/rauc-arm
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

git clone https://github.com/rauc/rauc.git
cd rauc
git checkout master
git pull
git checkout v1.6
export GLIB_CFLAGS="-pthread -I${SYSROOT_DIR}/usr/include/arm-linux-gnueabihf -I${SYSROOT_DIR}/usr/include -I${SYSROOT_DIR}/usr/include/glib-2.0/gobject -I${SYSROOT_DIR}/usr/include/glib-2.0/glib -I${SYSROOT_DIR}/usr/include/glib-2.0 -I${SYSROOT_DIR}/usr/lib/arm-linux-gnueabihf/glib-2.0/include -I${SYSROOT_DIR}/usr/include/gio-unix-2.0"
export JSON_GLIB_CFLAGS="-pthread -I${SYSROOT_DIR}/usr/include/arm-linux-gnueabihf -I${SYSROOT_DIR}/usr/include -I${SYSROOT_DIR}/usr/include/glib-2.0/gobject -I${SYSROOT_DIR}/usr/include/glib-2.0/glib -I${SYSROOT_DIR}/usr/include/json-glib-1.0 -I${SYSROOT_DIR}/usr/lib/arm-linux-gnueabihf/glib-2.0/include -I${SYSROOT_DIR}/usr/include/gio-unix-2.0"
export GLIB_LDFLAGS="--sysroot=${SYSROOT_DIR} -L${SYSROOT_DIR}/usr/lib -L${SYSROOT_DIR}/usr -L${SYSROOT_DIR}/lib -L${SYSROOT_DIR}/usr/lib/arm-linux-gnueabihf"
# make clean || true
./autogen.sh
./configure --prefix=/usr --enable-streaming --host=arm-linux-gnueabihf --build=x86_64-linux-gnu --with-sysroot="${SYSROOT_DIR}"
make -j4
export DESTDIR="${ARM_INSTALL_DIR}" && make -j4 install
)

echo "built rauc (arm)"

# package arm build into .deb file


dpkg-deb --build --root-owner-group "${ARM_INSTALL_DIR}"



# build rauc for the host

# we must go back to the host compiler for building rauc for the host
export CC=/usr/bin/gcc
export CXX=/usr/bin/g++
cd $WORK_DIR/rauc-host

(
git clone https://github.com/rauc/rauc.git
cd rauc
git checkout master
git pull
git checkout v1.6
# make clean || true
./autogen.sh
./configure --prefix=/usr --enable-streaming
make -j4
export DESTDIR="${HOST_INSTALL_DIR}" && make -j4 install
)

echo "built rauc (host)"

# package host build into .deb file


dpkg-deb --build --root-owner-group "${HOST_INSTALL_DIR}"

# here we can safely go back to the cross compiler
export CC=/usr/bin/arm-linux-gnueabihf-gcc
export CXX=/usr/bin/arm-linux-gnueabihf-g++

