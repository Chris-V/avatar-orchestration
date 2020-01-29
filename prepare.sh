#!/usr/bin/env bash

sudo pacman -Sy archiso ansible ansible-lint --noconfirm --needed
yay -Sy ansible-aur-git --noconfirm --needed
