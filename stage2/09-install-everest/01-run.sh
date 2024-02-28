#!/bin/bash -e

install -m 755 files/stm32flash "${ROOTFS_DIR}/usr/bin"
#install -m 644 files/boot-mark-good.service "${ROOTFS_DIR}/lib/systemd/system/"
install -m 644 files/mosquitto-config-init.service "${ROOTFS_DIR}/lib/systemd/system/"
install -m 644 files/fluent-bit.service "${ROOTFS_DIR}/lib/systemd/system/"
install -m 644 files/fluent-bit.conf "${ROOTFS_DIR}/etc/fluent-bit/"
install -D -m 644 files/known_hosts "${ROOTFS_DIR}/home/${FIRST_USER_NAME}/.ssh/known_hosts"
install -D -m 644 files/known_hosts "${ROOTFS_DIR}/root/.ssh/known_hosts"
install -D -m 644 files/mosquitto.conf "${ROOTFS_DIR}/etc/mosquitto/"
mkdir -p "${ROOTFS_DIR}/mnt/user_data/ocpp"
mkdir -p "${ROOTFS_DIR}/mnt/user_data/openvpn"
for file in files/ocpp/*;do
    install -m 644 "$file" "${ROOTFS_DIR}/mnt/user_data/ocpp/"
done
for file in files/openvpn/*;do
    install -m 644 "$file" "${ROOTFS_DIR}/mnt/user_data/openvpn/"
done
mkdir -p "${ROOTFS_DIR}/mnt/user_data/user-config"
install -D -m 644 files/conf_user/config-futech.yaml "${ROOTFS_DIR}/mnt/user_data/user-config/"

mkdir -p $WORK_DIR/everest
(
cd $WORK_DIR/everest
git clone git@github.com:PionixInternal/everest-deploy-devkit.git || true
cd everest-deploy-devkit/futech
git pull || true
git checkout futech_prod
mkdir -p work
./build_and_install.sh work ${ROOTFS_DIR}
)
on_chroot <<EOF
systemctl enable mosquitto.service
systemctl enable everest.service
systemctl enable everest-rpi.service
systemctl enable everest-dev.service
systemctl enable mosquitto-config-init.service
#ln -s /mnt/user_data/user-config/ocpp /opt/everest/share/everest/ocpp/

if [ -L "/etc/mosquitto/conf.d" ]; then
    echo Rebuilding over existing work directory, skipping mosquitto config magic
else
    echo Clean build, symlinking mosquitto config
    mkdir -p /mnt/user_data/etc/mosquitto/conf.d
    mv /etc/mosquitto/conf.d /etc/mosquitto/conf.d-factory-default
    ln -s /mnt/user_data/etc/mosquitto/conf.d /etc/mosquitto/conf.d
fi
pip3 install py4j aiofile environs
EOF