#!/bin/bash
(cd /tmp
git clone https://github.com/MatrixOrbital/HTT-Utility.git
cd HTT-Utility
git pull
mkdir build
cd build
cmake ..
make -j4
)
install -m 755 /tmp/HTT-Utility/build/htt_util "${ROOTFS_DIR}/usr/bin"
install -m 755 files/matrix-orbital.sh "${ROOTFS_DIR}/usr/bin"
install -m 644 files/matrix-orbital.service "${ROOTFS_DIR}/lib/systemd/system/"
on_chroot <<EOF
systemctl enable matrix-orbital.service
EOF
