#!/bin/bash
mkdir -p /mnt/user_data/nodered
cp -rf /etc/nodered_factorydefault/* /mnt/user_data/nodered/
systemctl disable nodered_init.service
