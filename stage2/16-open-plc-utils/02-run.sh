#!/bin/bash -e

# install on HOST system as well
apt install -y /tmp/pionix-open-plc-utils.deb
cp /tmp/pionix-open-plc-utils.deb "${ROOTFS_DIR}"
on_chroot <<EOF
apt install -y /pionix-open-plc-utils.deb
rm /pionix-open-plc-utils.deb
EOF

