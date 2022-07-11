#!/bin/bash -e

mkdir -p $WORK_DIR/everest
cp files/prepare-sysroot.sh $WORK_DIR/everest
mkdir -p $WORK_DIR/everest/sysroot/usr
cp -R "${ROOTFS_DIR}/usr/include" "$WORK_DIR/everest/sysroot/usr"
cp -R "${ROOTFS_DIR}/usr/lib" "$WORK_DIR/everest/sysroot/usr"
ls -l "$WORK_DIR/everest/sysroot/usr"
ln -sf "$WORK_DIR/everest/sysroot/usr/lib" "$WORK_DIR/everest/sysroot/lib"

# fix broken symlinks
(
    cd $WORK_DIR/everest/sysroot/usr/lib/aarch64-linux-gnu
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

(
    # prepare sysroot
    cd $WORK_DIR/everest
    ./prepare-sysroot.sh
)

if [ "${PIONIX_BUILD_SYSROOT}" = "1" ]; then
    echo "finished preparing sysroot located at $MAIN/sysroot"
    echo "please use the toolchain file located at $WORK_DIR/everest/toolchain.cmake like this:"
    echo "cmake .. -DCMAKE_TOOLCHAIN_FILE=$WORK_DIR/everest/toolchain.cmake -DLIBLOG_CROSS_COMPILE=ON"
    exit 1
fi
