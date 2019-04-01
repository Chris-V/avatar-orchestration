#!/usr/bin/env bash

echo "--- Preparing live environment ---"

timedatectl set-ntp true

fdisk -l

# TODO: readline
echo "Enter main drive to be partitioned"
DRIVE=/dev/sdX

echo "Enter hostname"
HOST_NAME=avatar-media

BOOT_UUID=238A759D-574B-480C-8259-F77313E7F4B3
ROOT_UUID=8085638B-3D09-416A-B2C5-E6D65767E1AD
SRV_UUID=2F2DD333-0858-4634-89BD-EB10FCF3990D

echo "--- Partitioning main disk ---"

dd if=/dev/zero of=${DRIVE} bs=1024 count=1024

sfdisk ${DRIVE} <<EOF
label: gpt
size=550M,type=L,bootable,uuid=${BOOT_UUID},name=boot
size=32G,type=4F68BCE3-E8CD-4DB1-96E7-FBCAF984B709,uuid=${ROOT_UUID},name=root
type=3B8F8425-20E0-4F3B-907F-1A25A76F98E8,uuid=${SRV_UUID},name=server
,,,-
EOF

mkfs.ext4 ${DRIVE}1
mkfs.ext4 ${DRIVE}2
mkfs.ext4 ${DRIVE}3


echo "--- Setup OS ---"

mount UUID=${ROOT_UUID} /mnt
mkdir -p /mnt/boot /mnt/srv
mount UUID=${BOOT_UUID} /mnt/boot
mount UUID=${SRV_UUID} /mnt/srv

echo "Fetching pacman mirrors..."
curl -s "https://www.archlinux.org/mirrorlist/?country=CA&country=US&protocol=https&use_mirror_status=on" | \
  sed -e 's/^#Server/Server/' -e '/^#/d' | \
  rankmirrors -n 5 - \
> /etc/pacman.d/mirrorlist

echo "Copying OS files..."
pacstrap /mnt base base-devel pacman-contrib syslinux gptfdisk git


echo "--- Configure system ---"

echo "Generating FS cache..."
genfstab -U /mnt >> /mnt/etc/fstab

echo "Chroot..."
arch-chroot /mnt

echo "Setting up timezone..."
ln -sf /usr/share/zoneinfo/America/Montreal /etc/localtime
hwclock --systohc

echo "Setting up locale..."
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf

echo "Setting up hostname..."
echo "${HOST_NAME}" > /etc/hostname
echo "127.0.0.1 ${HOST_NAME}" >> /etc/hosts

echo "Enter root password:"
passwd


echo "--- Configure bootloader ---"
# Sadly, the current hardware is not UEFI based

syslinux-install_update -i -a -m -c /mnt

echo <<EOF > /boot/syslinux/syslinux.cfg
PROMPT 0
TIMEOUT 0
DEFAULT arch

LABEL arch
	LINUX ../vmlinuz-linux
	APPEND root=UUID=${ROOT_UUID} rw
	INITRD ../initramfs-linux.img
LABEL archfallback
	LINUX ../vmlinuz-linux
	APPEND root=UUID=${ROOT_UUID} rw
	INITRD ../initramfs-linux-fallback.img
EOF


echo "--- Preparing reboot ---"

# TODO: Clone setup repo to root's home

umount -R /mnt
reboot
