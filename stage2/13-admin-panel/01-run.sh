#!/bin/bash
(cd /tmp
rm -rf /tmp/everest-admin-panel
git clone git@github.com:EVerest/everest-admin-panel.git
cd everest-admin-panel
#git pull
npm install
npm run build
# target directory is /var/www/html
rm ${ROOTFS_DIR}/var/www/html/*
cp -r dist/* ${ROOTFS_DIR}/var/www/html
)
on_chroot <<EOF
systemctl enable lighttpd.service
EOF
