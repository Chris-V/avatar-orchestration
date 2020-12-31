#!/usr/bin/env bash

sudo pacman -Sy archiso ansible ansible-lint parallel --noconfirm --needed
ansible-galaxy install -r requirements.yml
