#!/bin/bash
(cd /tmp
git clone https://github.com/qca/open-plc-utils.git
cd open-plc-utils
make -j4
make ROOTFS=/tmp/pionix-open-plc-utils -j4 install)
mkdir -p /tmp/pionix-open-plc-utils/DEBIAN
cp control /tmp/pionix-open-plc-utils/DEBIAN
dpkg-deb --build --root-owner-group /tmp/pionix-open-plc-utils
