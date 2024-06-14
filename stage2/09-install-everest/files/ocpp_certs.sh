#!/bin/bash
mkdir -p /mnt/user_data/ocpp
cp -rf /home/futech/ocpp/* /mnt/user_data/ocpp
mkdir -p /mnt/user_data/ocpp/certs/ca/cso
mkdir -p /mnt/user_data/ocpp/certs/ca/csms
mkdir -p /mnt/user_data/ocpp/certs/ca/mf
mkdir -p /mnt/user_data/ocpp/certs/ca/mo
mkdir -p /mnt/user_data/ocpp/certs/ca/oem
mkdir -p /mnt/user_data/ocpp/certs/ca/v2g
rm -rf /home/futech/ocpp
systemctl disable ocpp_certs.service
