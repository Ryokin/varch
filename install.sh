#!/bin/zsh

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

sed -e 's/[\s]+#.*//1' << EOF | sfdisk /dev/sda
,512MiB,ef,*	# Create boot partition type (ef) 'EFI (FAT-12/16/32)' of 512MB size & set it to boot
,8GiB,82	# Create swap partition type (82) 'Linux swap / Solaris' of 8GB size
,,83	# Create linux partition type (83) 'Linux' of the remaining hard drive
EOF