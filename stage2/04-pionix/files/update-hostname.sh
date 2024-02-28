#!/bin/bash
cd /tmp
/usr/bin/hostname -F /etc/hostname
HN=`hostname`
echo Current hostname $HN
#cp /etc/hostname /tmp
SERIAL_NUMBER_FILE="/mnt/factory_data/serial_number"
if [ -f "$SERIAL_NUMBER_FILE" ]; then
    echo "Using serial number for hostname"
    sudo echo ilucharge2_`cat "$SERIAL_NUMBER_FILE"` > /tmp/hostname
else
    sudo echo ilucharge2_`cat /sys/class/net/eth0/address | awk '{split($0,a,":"); print a[5] a[6]}'` > /tmp/hostname
fi
NHN=`cat /tmp/hostname`
echo New hostname $NHN
#cp -a /etc/hosts_factory_default /mnt/user_data/etc/hosts
/usr/bin/sed -i "s/$HN/$NHN/g" /etc/hosts
/usr/bin/cp /tmp/hostname /etc
/usr/bin/hostname -F /etc/hostname
sed -i "/ssid=/c\ssid=$NHN" /etc/hostapd/hostapd.conf
