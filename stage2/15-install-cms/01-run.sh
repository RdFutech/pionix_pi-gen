#!/bin/bash -e

install -m 644 files/csms.service "${ROOTFS_DIR}/lib/systemd/system/"

mkdir -p $WORK_DIR/everest
(
cd $WORK_DIR/everest
git clone https://github.com/PionixInternal/ocpp-csms || true
cp -r ocpp-csms "${ROOTFS_DIR}/opt"
)
on_chroot <<EOF
pip3 install ocpp websockets
systemctl enable csms.service
EOF
