#!/bin/bash -e

#install -m 755 files/install_update "${ROOTFS_DIR}/usr/bin"
#install -m 644 files/boot-mark-good.service "${ROOTFS_DIR}/lib/systemd/system/"

mkdir -p $WORK_DIR/everest
(
cd $WORK_DIR/everest
git clone git@github.com:PionixInternal/everest-deploy-devkit.git || true
cd everest-deploy-devkit/belayboxr1
git pull || true
mkdir -p work
./build_and_install.sh work ${ROOTFS_DIR}
)
on_chroot <<EOF
systemctl enable mosquitto.service
systemctl enable everest.service
EOF

