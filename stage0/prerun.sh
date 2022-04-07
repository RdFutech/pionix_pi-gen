#!/bin/bash -e

EXCLUDE="gcc-10-base,gcc-7-base,gcc-8-base,gcc-9-base,adduser,bsdfiles,libgcc-s1,pinentry-curses"
if [ ! -d "${ROOTFS_DIR}" ] || [ "${USE_QCOW2}" = "1" ]; then
	bootstrap --variant=minbase --exclude=${EXCLUDE} ${RELEASE} "${ROOTFS_DIR}" http://raspbian.raspberrypi.org/raspbian/
fi
