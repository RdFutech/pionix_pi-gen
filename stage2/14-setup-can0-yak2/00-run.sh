#!/bin/bash

install -m 644 files/*.dtbo "${ROOTFS_DIR}/boot/overlays/"
install -m 644 files/can0 "${ROOTFS_DIR}/etc/network/interfaces.d/"
on_chroot <<EOF
EOF
