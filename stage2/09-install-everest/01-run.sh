#!/bin/bash -e

install -m 755 files/stm32flash "${ROOTFS_DIR}/usr/bin"
#install -m 644 files/boot-mark-good.service "${ROOTFS_DIR}/lib/systemd/system/"

mkdir -p $WORK_DIR/everest
cp files/prepare-sysroot.sh $WORK_DIR/everest
mkdir -p $WORK_DIR/everest/sysroot/usr
cp -R "${ROOTFS_DIR}/usr/include" "$WORK_DIR/everest/sysroot/usr"
cp -R "${ROOTFS_DIR}/usr/lib" "$WORK_DIR/everest/sysroot/usr"
ls -l "$WORK_DIR/everest/sysroot/usr"
(
    # prepare sysroot
    cd $WORK_DIR/everest
    ./prepare-sysroot.sh
)

(
cd $WORK_DIR/everest
git clone git@github.com:PionixInternal/everest-deploy-devkit.git || true
cd everest-deploy-devkit/belayboxr1
git checkout kh-cross-compiling
git pull || true
mkdir -p work
cp $WORK_DIR/everest/toolchain.cmake work
./build_and_install.sh work ${ROOTFS_DIR}
)
on_chroot <<EOF
systemctl enable mosquitto.service
systemctl enable everest.service
systemctl enable everest-dev.service
EOF

#install -m 644 files/yetiR1_0.5_firmware.bin "${ROOTFS_DIR}/opt/everest/modules/modules/YetiDriver"
