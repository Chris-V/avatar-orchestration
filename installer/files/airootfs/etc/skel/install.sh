#!/usr/bin/env bash

set -e -u -o pipefail
trap 's=$?; echo "$0: Error on line "$LINENO": $BASH_COMMAND"; exit $s' ERR

# -- Variables & Constants

DIALOG_HEIGHT=12
DIALOG_WIDTH=50

BOOT_UUID=238A759D-574B-480C-8259-F77313E7F4B3
ROOT_UUID=8085638B-3D09-416A-B2C5-E6D65767E1AD
SRV_UUID=2F2DD333-0858-4634-89BD-EB10FCF3990D

MOUNT=/mnt

PACKAGES="base base-devel syslinux gptfdisk openssh sudo python"

hostname=avatar
install_disk=
root_password=
ssh_port=

function prompt {
    local options=$1
    local title=${2^}
    local label=${2,,}
    local default=${3:-}
    local result=

    function __ask {
        result=$(dialog --stdout --title "$title" ${options} "Enter $label" "$DIALOG_HEIGHT" "$DIALOG_WIDTH" "$default") || return $?
        result=${result//[^a-zA-Z0-9_-]/}
    }

    __ask || return $?
    until [[ "$result" ]]; do
        dialog --stdout --colors --title "$title" --msgbox "\Zb$label\Zn cannot be empty." "$DIALOG_HEIGHT" "$DIALOG_WIDTH"
        __ask || return $?
    done

    echo "$result"
}

function prompt_password {
    local title=${1^}
    local label=${1,,}

    local password=
    local password_confirmation=

    function __ask {
        password=$(prompt "--insecure --passwordbox" "$label") || return $?
        password_confirmation=$(prompt "--insecure --passwordbox" "$label confirmation") || return $?
    }

    __ask || return $?
    until [[ "$password" == "$password_confirmation" ]]; do
        dialog --stdout --colors --title "$title" --msgbox "Passwords do not match." "$DIALOG_HEIGHT" "$DIALOG_WIDTH"
        __ask || return $?
    done

    echo "$password"
}

function prompt_settings {
    hostname=$(prompt "--inputbox" "hostname" "$hostname")
    root_password=$(prompt_password "root password")
    ssh_port=$(prompt "--inputbox" "SSH port" "22")

    available_disks=$(lsblk -dplnx size -o name,size | grep -Ev "boot|rpmb|loop" | tac)
    install_disk=$(dialog --stdout --title "Installation disk" --default-item "$install_disk" --menu "Select installation disk" "$DIALOG_HEIGHT" "$DIALOG_WIDTH" 0 ${available_disks})
}

prompt_settings
while : ; do
    confirmation=0
    dialog --stdout --colors --title "Confirm settings" --defaultno --extra-button --extra-label "Modify" --ok-label "Yes" --yesno "
    Hostname: ${hostname}
    Installation disk: ${install_disk}
    SSH port: ${ssh_port}

    \Zb\Z1The installation disk will be wiped.\Zn

    Are these settings good?" "$DIALOG_HEIGHT" "$DIALOG_WIDTH" || confirmation=$?

    case $confirmation in
        0)
            break
            ;;
        1)
            exit 1
            ;;
        3)
            prompt_settings
    esac
done

dialog --stdout --colors --defaultno --pause "Starting installation in 10 seconds.

\Zb\Z1${install_disk} will be wiped.\Zn

Cancel now or never!" "$DIALOG_HEIGHT" "$DIALOG_WIDTH" 10 || exit 1

clear

exec 1> >(tee "stdout.log")
exec 2> >(tee "stderr.log")

timedatectl set-ntp true

echo
echo "--- Partitioning main disk ---"
echo

dd if=/dev/zero of=${install_disk} bs=1024 count=1024

sfdisk ${install_disk} <<EOF
label: gpt
size=550M,type=0FC63DAF-8483-4772-8E79-3D69D8477DE4,bootable,uuid=${BOOT_UUID},name=boot
size=32G,type=4F68BCE3-E8CD-4DB1-96E7-FBCAF984B709,uuid=${ROOT_UUID},name=arch
type=3B8F8425-20E0-4F3B-907F-1A25A76F98E8,uuid=${SRV_UUID},name=server
EOF

mkfs.ext4 ${install_disk}1
mkfs.ext4 ${install_disk}2
mkfs.ext4 ${install_disk}3

mount PARTLABEL=arch $MOUNT
mkdir -p $MOUNT/boot $MOUNT/srv
mount PARTLABEL=boot $MOUNT/boot
mount PARTLABEL=server $MOUNT/srv

echo
echo "--- Install system ---"
echo

echo "Fetching pacman mirrors..."
curl -s "https://www.archlinux.org/mirrorlist/?country=CA&country=US&protocol=https&use_mirror_status=on" | \
  sed -e 's/^#Server/Server/' -e '/^#/d' | \
  rankmirrors -n 5 - \
> /etc/pacman.d/mirrorlist

echo "Copying OS files..."
pacstrap $MOUNT $PACKAGES

echo "Generating fstab..."
genfstab -t PARTLABEL $MOUNT >> $MOUNT/etc/fstab

echo
echo "--- Configure system ---"
echo
chrooted () { arch-chroot $MOUNT bash -c "$*"; }

echo "Setting up timezone..."
chrooted ln -sfn /usr/share/zoneinfo/America/Montreal /etc/localtime
echo 'America/Montreal' > $MOUNT/etc/timezone
chrooted hwclock --systohc --utc

echo "Setting up locale..."
echo "en_US.UTF-8 UTF-8" >> $MOUNT/etc/locale.gen
chrooted locale-gen
echo "LANG=en_US.UTF-8" > $MOUNT/etc/locale.conf

echo "Setting up hostname..."
echo "${hostname}" > $MOUNT/etc/hostname
echo "127.0.0.1 localhost ${hostname}" >> $MOUNT/etc/hosts

echo "Setting up pacman..."
chrooted pacman-key --init
chrooted pacman-key --populate archlinux
chrooted pacman-key --refresh-keys

echo
echo "--- Configure bootloader ---"
echo

syslinux-install_update -i -a -m -c $MOUNT

cp splash.png $MOUNT/boot/syslinux/

cat <<EOF > $MOUNT/boot/syslinux/syslinux.cfg
DEFAULT arch
PROMPT 0
TIMEOUT 30
TOTALTIMEOUT 9000

UI vesamenu.c32

MENU WIDTH 78
MENU MARGIN 4
MENU ROWS 5
MENU VSHIFT 10
MENU TIMEOUTROW 13
MENU TABMSGROW 11
MENU CMDLINEROW 11
MENU HELPMSGROW 16
MENU HELPMSGENDROW 29

MENU TITLE Arch Linux
MENU BACKGROUND splash.png
MENU COLOR border       30;44   #40ffffff #a0000000 std
MENU COLOR title        1;36;44 #9033ccff #a0000000 std
MENU COLOR sel          7;37;40 #e0ffffff #20ffffff all
MENU COLOR unsel        37;44   #50ffffff #a0000000 std
MENU COLOR help         37;40   #c0ffffff #a0000000 std
MENU COLOR timeout_msg  37;40   #80ffffff #00000000 std
MENU COLOR timeout      1;37;40 #c0ffffff #00000000 std
MENU COLOR msg07        37;40   #90ffffff #a0000000 std
MENU COLOR tabmsg       31;40   #30ffffff #00000000 std

LABEL arch
	MENU LABEL Arch Linux
	LINUX ../vmlinuz-linux
	APPEND root=PARTLABEL=arch rw
	INITRD ../initramfs-linux.img

LABEL archfallback
	MENU LABEL Arch Linux (fallback)
	LINUX ../vmlinuz-linux
	APPEND root=PARTLABEL=arch rw
	INITRD ../initramfs-linux-fallback.img

LABEL reboot
	MENU LABEL Reboot
	COM32 reboot.c32

LABEL poweroff
	MENU LABEL Poweroff
	COM32 poweroff.c32
EOF

echo
echo "--- Configure SSH ---"
echo

echo "Port ${ssh_port}" >> /mnt/etc/ssh/sshd_config
chrooted systemctl enable sshd.service

echo
echo "--- Configure network ---"
echo

echo '
[Match]

[Network]
DHCP=yes
' >> /mnt/etc/systemd/network/20-all.network
chrooted systemctl enable systemd-networkd.service
chrooted systemctl enable systemd-resolved.service

echo
echo "--- Configure users and groups ---"
echo

useradd --root $MOUNT -m -s /bin/bash ansible

echo "root:${root_password}
ansible:${root_password}" | chpasswd --root $MOUNT

tmpfile=$(mktemp)
echo "ansible ALL=(ALL) NOPASSWD: ALL" > $tmpfile
visudo -cf $tmpfile \
    && mv $tmpfile $MOUNT/etc/sudoers.d/ansible \
    || echo "ERROR updating sudoers: no change made."
chmod 440 $MOUNT/etc/sudoers.d/ansible

mkdir -p /mnt/home/ansible/.ssh
cp ansible_rsa.pub /mnt/home/ansible/.ssh/authorized_keys

chrooted chown -R ansible:ansible /home/ansible/.ssh
chmod 700 /mnt/home/ansible/.ssh
chmod 600 /mnt/home/ansible/.ssh/authorized_keys

echo
echo "--- DONE! ---"
echo
echo "\$ unmount -R $MOUNT && reboot"
