#!/bin/bash -e

# install nodered in chroot env
on_chroot <<EOF
cd /tmp
echo -------------------------------------------------------------------------
cat /etc/resolv.conf
echo -------------------------------------------------------------------------
echo nameserver 8.8.8.8 > /tmp/dhcpcd.resolv.conf
echo 2-------------------------------------------------------------------------
cat /etc/resolv.conf
echo 2-------------------------------------------------------------------------
curl -sL https://raw.githubusercontent.com/node-red/linux-installers/master/deb/update-nodejs-and-nodered -o nodered.sh
chmod a+x nodered.sh
./nodered.sh --confirm-root --confirm-install --confirm-pi --node18 || true
EOF

# replace systemd unit file with our own version to not run nodered as root user
install -m 644 files/nodered.service "${ROOTFS_DIR}/lib/systemd/system/"
install -m 644 files/nodered_init.service "${ROOTFS_DIR}/lib/systemd/system/"
install -m 755 files/nodered_init.sh "${ROOTFS_DIR}/usr/bin"

# deploy flows somehow
#/etc/nodered_factorydefault

on_chroot <<EOF
mkdir -p /etc/nodered_factorydefault/
cd /etc/nodered_factorydefault/
npm install node-red-dashboard
npm install node-red-contrib-ui-actions
npm install node-red-node-ui-table
npm install node-red-contrib-ui-level
systemctl enable nodered
systemctl enable nodered_init
EOF
