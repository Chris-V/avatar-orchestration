#!/usr/bin/env bash

echo "Installing binaries..."

# TODO: All the following stuff should be possible for ansible

pacman -Syu sudo ssh nftables ethtool vim fish docker docker-compose

git clone https://aur.archlinux.org/yay.git
( cd yay ; makepkg -si )
rm -rf yay


echo "Configuring permissions..."
groupadd poweroff
groupadd ssh

cat ./configs/etc/sudoers.d/poweroff > /etc/sudoers.d/poweroff
cat ./configs/etc/sudoers.d/wheel > /etc/sudoers.d/wheel
chmod 0440 /etc/sudoers.d/poweroff /etc/sudoers.d/wheel


echo "Configuring WOL..."
ethtool -s enp2s0 wol g
cat ./configs/etc/systemd/network/50-wired.link > /etc/systemd/network/50-wired.link

echo "Configuring ssh daemon..."
cat ./configs/etc/ssh/sshd_config > /etc/ssh/sshd_config

echo "Configuring NFTables..."
cat ./configs/etc/nftables.conf > /etc/nftables.conf


echo "Setting up 'avatar'..."

useradd -m -G wheel,poweroff,ssh -S /usr/bin/fish avatar

echo "Enter avatar's password: "
passwd avatar

su avatar -c <<EOF
curl -L https://get.oh-my.fish | fish;
omf i sudope archlinux colored-man-pages bobthefish;

mkdir -p /home/avatar/.ssh;
touch /home/avatar/.ssh/authorized_keys;

chmod 700 /home/avatar/.ssh;
chmod 600 /home/avatar/.ssh/authorized_keys;
EOF

cat ./configs/home/avatar/.ssh/authorized_keys > /home/avatar/.ssh/authorized_keys

echo 'avatar setup complete!'


echo "Setting up 'homeassistant'..."

useradd -m -G poweroff,ssh -S /bin/bash homeassistant

echo "Enter homeassistant's password: "
passwd homeassistant

su avatar -c <<EOF
mkdir -p /home/homeassistant/.ssh;
touch /home/homeassistant/.ssh/authorized_keys;

chmod 700 /home/homeassistant/.ssh;
chmod 600 /home/homeassistant/.ssh/authorized_keys;
EOF

cat ./configs/home/homeassistant/.ssh/authorized_keys > /home/homeassistant/.ssh/authorized_keys

echo 'homeassistant setup complete! Make sure to `ssh avatar-automate-hass "ssh media | yes"`.'


echo "Setting up storage disks..."
# TODO: /data and /storage
#  Partition other hard drives
#  mergerfs and snapraid
#  Update fstab
#  Initialize media folders


echo "Starting services..."

systemctl enable sshd nftables docker --now

# TODO: Copy docker-compose .env secrets and finally start containers
