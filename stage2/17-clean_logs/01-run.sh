#!/bin/bash -e

install -m 755 files/clean_tmp_logs.sh "${ROOTFS_DIR}/usr/bin"
install -m 644 files/clean_tmp_folder.timer "${ROOTFS_DIR}/lib/systemd/system/"
install -m 644 files/clean_tmp_folder.service "${ROOTFS_DIR}/lib/systemd/system/"

on_chroot <<EOF
systemctl enable clean_tmp_folder.timer
EOF

