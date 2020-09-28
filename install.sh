#! /bin/bash

# This is Valentina's Arch Linux Installation Script.

echo "Valentinas Rimeika Arch Installer"

# Set up network connection
read -p 'Are you connected to internet? [y/N]: ' neton
if ! [ $neton = 'y' ] && ! [ $neton = 'Y']
then
	echo "Connect to internet to continue..."
	echo "Start by using <ip link> and finding device id"
	echo "Then use <ip link set [DEVICE_ID] down"
	echo "<ping [SERVER_ADDRESS]>(eg. google.com) to test network"
	exit
fi

