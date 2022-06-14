#!/bin/bash
(cd /tmp
git clone git@github.com:PionixInternal/everest-admin-tool.git
cd everest-admin-tool/frontend
git pull
npm install
npm run build
# target directory is /var/www/html
rm ${ROOTFS_DIR}/var/www/html/*
cp -r dist/* ${ROOTFS_DIR}/var/www/html
)
on_chroot <<EOF
systemctl enable lighttpd.service
EOF
