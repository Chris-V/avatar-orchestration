# Media server's bootstrap configuration

This repository contains bootstrapping scripts to get the media server up and running.

## Arch Linux install

1. Boot live environment
1. Setup network
1. Clone this repository on the live environment
1. Run `install.sh`
1. Once rebooted, run `setup.sh`

## Partition summary

Mount | Size | FS | Parity | Comments
--- | --- | --- | --- | ---
\[SWAP] | | | | Nope
/boot | 550&nbsp;MB | ? | N | 
/ | 32&nbsp;GB | Ext4 | N | (system) appdata
/data | 6&nbsp;TB | BTRFS | N | (high write)<br>tmp, torrents, downloads, extraction, minecraft
/storage | 18&nbsp;TB | XFS| Y | (high read, low write)<br>movies, series, music, ebooks, custom backups.<br>**Max 6 disks** pooled by **MergerFS**.
/storageparity | \<*> | XFS | - | Managed by **Snapraid**.<br>Disk size is the **biggest disk from /storage**

## Resources

https://wiki.archlinux.org/index.php/installation_guide
