#!/bin/bash
WIFI_AP_PSK_FILE="/mnt/factory_data/wifi_ap_psk"
if [ -f "$WIFI_AP_PSK_FILE" ]; then
    echo "Using wifi_ap_psk file for wifi password"
    WIFI_AP_PSK=`cat $WIFI_AP_PSK_FILE`
    sed -i "/wpa_psk=/c\wpa_psk=$WIFI_AP_PSK" /etc/hostapd/hostapd.conf
fi
