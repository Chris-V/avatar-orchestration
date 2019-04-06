# Avatar-Media Management Scripts

This repository contains scripts to install and maintain avatar-media.

## Install

1. `make prepare`
1. `make installer`
    1. `dd` generated iso file.
    1. Boot on it.
    1. Follow install instructions displayed on screen.
    1. Reboot target
1. `make ansible-prod`
    1. ¯\\\_(ツ)\_/¯
1. Start apps
    1. `docker-compose pull`
    1. `docker-compose up -d`

## Partition summary

Mount | Size | FS | Parity | Comments
--- | --- | --- | --- | ---
\[SWAP] | | | | Nope
/boot | 550&nbsp;MB | ? | N | 
/ | 32&nbsp;GB | Ext4 | N | (system) appdata
/data | 6&nbsp;TB | BTRFS | N | (high write)<br>tmp, torrents, downloads, extraction, games
/media | 18&nbsp;TB | XFS| Y | (high read, low write)<br>movies, series, music, ebooks, custom backups.<br>**Max 6 disks** pooled by **MergerFS**.
/mediaparity | \<*> | XFS | - | Managed by **Snapraid**.<br>Disk size is the **biggest disk from /media**

## Links

### Live ISO
* Official installation guide: https://wiki.archlinux.org/index.php/installation_guide
* Official archiso guides: https://wiki.archlinux.org/index.php/Archiso
* Nice init script: https://github.com/altercation/archinit/blob/master/archinit

### Server orchestration
* Ansible doc: https://docs.ansible.com/ansible/latest
* Look, a custom PKGBUILD to settup system... https://github.com/Earnestly/pkgbuilds/tree/master/system-config
* Ansible getting started: https://serversforhackers.com/c/an-ansible2-tutorial
* Ansible stuff from the lsio guy: https://www.youtube.com/watch?v=lumHT3MAS_w
    * https://github.com/IronicBadger/ansible
