#!/bin/bash
WIFI_AP_PSK_FILE="/mnt/factory_data/wifi_ap_passphrase"
if [ -f "$WIFI_AP_PSK_FILE" ]; then
    echo "Using wifi_ap_psk file for wifi password"
    WIFI_AP_PSK=`cat $WIFI_AP_PSK_FILE`
    sed -i "/wpa_passphrase=/c\wpa_passphrase=$WIFI_AP_PSK" /etc/hostapd/hostapd.conf
fi
