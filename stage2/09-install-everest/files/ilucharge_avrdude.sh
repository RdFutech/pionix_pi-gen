#!/bin/bash
echo "Trying to stop everest services"
sudo systemctl stop everest.service
sleep 1
echo "Resetting ilucharge v2 pcb"
echo 0 > /sys/class/gpio/gpio27/value
sleep 0.1
echo 1 > /sys/class/gpio/gpio27/value
echo "Programming ilucharge v2 pcb..."
avrdude -v -p atmega64 -c arduino -b 115200 -D -P /dev/serial0 -U flash:w:/opt/everest/firmware/ILUCHARGE-2_0_8.hex:i
echo "Trying to start everest services"
sudo systemctl start everest.service