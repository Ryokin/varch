#!/bin/zsh

# This is Valentina's Arch Linux Installation Script.

echo "Valentinas Rimeika Arch Installer"

# Verify which boot mode
if [ -d "/sys/firmware/efi/" ]
then
	echo "Booted in UEFI mode"
else
	echo "Booted in Legacy mode (BIOS or CSM)"
fi

# Set up network connection (Check automatically?)
read -p 'Are you connected to internet? [y/N]: ' neton
if ! [ $neton = 'y' ] && ! [ $neton = 'Y']
then
	echo "Connect to internet to continue..."
	echo "Start by using <ip link> and finding device id"
	echo "Then use <ip link set [DEVICE_ID] down"
	echo "<ping [SERVER_ADDRESS]>(eg. google.com) to test network"
	exit
fi

# Create partitions via script
sed -e 's/[\s]+#.*//1' << EOF | sfdisk /dev/sda
,512MiB,ef,*	# Create boot partition type (ef) 'EFI (FAT-12/16/32)' of 512MB size & set it to boot
,8GiB,82	# Create swap partition type (82) 'Linux swap / Solaris' of 8GB size
,25GiB,83	# Create linux partition type (83) 'Linux' of 25GB size for 'Root'
,,5	# Create extended linux partition (5) 'Extended' of remaining space for 'Home'
EOF

# Format the partitions to filesystems (FAT32 & Ext4)
mkfs.fat -F32 /dev/sda1
mkfs.ext4 /dev/sda3
mkfs.ext4 /dev/sda4

# Set up system clock
timedatectl set-ntp true

# Initiate pacman keyring
pacman-key --init
pacman-key --populate archlinux
pacman-key --refresh-keys

# Mount 'Root' partition
mount /dev/sda3 /mnt

# Mount 'Home' partition
mkdir /mnt/home
mount /dev/sda4 /mnt/home

# Show currently mounted ext4 partitions
mount -t ext4

# Mount boot EFI partition 
mkdir -pv /mnt/boot/efi
mount /dev/sda1 /mnt/boot/efi

# Swap partition
mkswap /dev/sda2
swapon /dev/sda2

# --- Stop here

# Install Arch Linux
echo "Starting Arch Linux installation"
pacstrap /mnt base base-devel

# --- Add more packages from other file

# Generate fstab (automates the process of mounting partitions)
genfstab -U /mnt >> /mnt/etc/fstab

# Chroot into new system
arch-chroot /mnt /bin/zsh

# --- Add post-installation script execution

# Setting Timezone
ln -sf /usr/share/zoneinfo/Europe/Vilnius /etc/localtime
hwclock --systohc --utc

# --- Set keyboard keymaps (DT)

# --- Set Locale
# sed -i '/en_US.UTF-8 UTF-8/s/^#//g' /etc/locale.gen
# locale-gen
# echo LANG=en_US.UTF-8 > /etc/locale.conf
# export LANG=en_US.UTF-8

# --- Set Hostname
# --- Generate initramfs?
# --- Set Root password
# --- Install bootloader
# --- Create new user
# --- Set privileges (DT)
# --- Setup display manager
# --- Enable services


# Finish
reboot