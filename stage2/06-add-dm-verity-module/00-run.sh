#!/bin/bash
# dm_verity module is missing from default RPI4 installation.
# ensure we have a compatible binary version here...
# use build_linux_modules.sh from root of this repo to build a new kernel module

# install module
#cp "files/5.15.32-v7l+/dm-verity.ko" "${ROOTFS_DIR}/lib/modules/5.15.32-v7l+/kernel/drivers/md/"
cp "files/5.15.56-v7l+/dm-verity.ko" "${ROOTFS_DIR}/lib/modules/5.15.56-v7l+/kernel/drivers/md/"

on_chroot <<EOF
depmod -a 5.15.56-v7l+
echo dm-verity >> /etc/modules
EOF


