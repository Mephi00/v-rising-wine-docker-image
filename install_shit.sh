#!/bin/sh

sudo useradd -m steam
sudo passwd steam

sudo -u steam -s
cd /home/steam

sudo add-apt-repository multiverse
sudo dpkg --add-architecture i386
sudo apt update
sudo apt install lib32gcc-s1 steamcmd 

