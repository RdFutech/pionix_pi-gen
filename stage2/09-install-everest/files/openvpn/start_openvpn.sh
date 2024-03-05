#!/bin/bash

if ps -C openvpn > /dev/null
then
   echo "openvpn already is running"
   # Do something knowing the pid exists, i.e. the process with $PID is running
else
   echo "starting openvpn"
   exec /usr/bin/sudo /usr/sbin/openvpn --config /home/futech/openvpn/futech.conf --daemon openvpn_futech
fi
