#!/bin/bash -e

install -m 644 files/umwc-init-mnt-userdata.tgz "${ROOTFS_DIR}/opt/everest/"

mkdir -p $WORK_DIR/pionixctrl

(
cd $WORK_DIR/pionixctrl
git clone git@github.com:PionixInternal/pionix-control.git || true
cp -r pionix-control ${ROOTFS_DIR}
cd pionix-control
git pull || true
install ./everest-control.service "${ROOTFS_DIR}/lib/systemd/system/"
install ./pionix-control.service "${ROOTFS_DIR}/lib/systemd/system/"
)

on_chroot <<EOF
cd /pionix-control
pip install --upgrade pip
pip3 install .
cd /
rm -rf /pionix-control
systemctl enable everest-control.service
systemctl enable pionix-control.service
EOF

