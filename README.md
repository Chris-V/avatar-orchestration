# Avatar-Media Management Scripts

This repository contains scripts to install and maintain avatar-media.

## Install

1. `sudo ./installer/make-iso.sh`
1. `dd` generated iso file.
1. Boot on it.
1. Follow install instructions displayed on screen.
1. TODO: Once rebooted, do Ansible stuff

## Partition summary

Mount | Size | FS | Parity | Comments
--- | --- | --- | --- | ---
\[SWAP] | | | | Nope
/boot | 550&nbsp;MB | ? | N | 
/ | 32&nbsp;GB | Ext4 | N | (system) appdata
/data | 6&nbsp;TB | BTRFS | N | (high write)<br>tmp, torrents, downloads, extraction, minecraft
/storage | 18&nbsp;TB | XFS| Y | (high read, low write)<br>movies, series, music, ebooks, custom backups.<br>**Max 6 disks** pooled by **MergerFS**.
/storageparity | \<*> | XFS | - | Managed by **Snapraid**.<br>Disk size is the **biggest disk from /storage**

## Links

* Official installation guide: https://wiki.archlinux.org/index.php/installation_guide
* Official archiso guides: https://wiki.archlinux.org/index.php/Archiso
* Nice init script: https://github.com/altercation/archinit/blob/master/archinit
* Look, a custom PKGBUILD to settup system... https://github.com/Earnestly/pkgbuilds/tree/master/system-config
