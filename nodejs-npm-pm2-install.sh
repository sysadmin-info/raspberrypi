#!/bin/bash

#################################################################################
#Script Name	: nodejs-npm-pm2-install.sh
#Description	: script that installs nodejs, npm and pm2 on a Raspbery Pi 4b  
#Author       	: Adrian Ambroziak
#Email         	: adrian.ambroziak@gmail.com
#################################################################################

# Use the same method used by login, which avoids being fooled by redefinitions of $HOME:
homedir="$(getent passwd $( /usr/bin/id -u ) | cut -d: -f6)"
cd "$homedir"

# check the current directory
pwd

# create a directory for nodejs file, that can be later deleted
mkdir -p nodejs

# enter the nodejs directory
cd nodejs

## install nodejs on Raspberry Pi 4b

# The Raspberry Pi runs off the ARM architecture and as of the writing of this article, NodeJS releases compiled Linux binaries for ARMv6, ARMv7 and ARMv8 architecture boards. To find out which architecture your Raspberry Pi is running on, run the following command in the terminal

uname -m

# For example, if we run the above command on the Raspberry Pi Zero W, we get the following output. 
# armv7l

#script that is doing the detection of the architecture and downloads the proper version for us

if [ "$(uname -m)" == "armv7l" ]; then
#download for ARM7
	wget https://nodejs.org/dist/v16.13.2/node-v16.13.2-linux-armv7l.tar.xz
elif [ "$(uname -m)" == "armv81" ]; then
#download for ARM8
	wget https://nodejs.org/dist/v16.13.2/node-v16.13.2-linux-arm64.tar.xz
else 
	echo "The architecture is not for Rasberry Pi 4b"
fi

# This part detects the archive file and extracts it

if [ -f node-v16.13.2-linux-armv7l.tar.xz ]; then
	tar -xvf node-v16.13.2-linux-armv7l.tar.xz
elif [ -f node-v16.13.2-linux-arm64.tar.xz ]; then
	tar -xvf node-v16.13.2-linux-arm64.tar.xz
else
  echo "There is no archive file because the architecture is not for Rasberry Pi 4b"
fi

# This part detects does the extracted directory exist and copy the content to /usr/local
if [ -d node-v16.13.2-linux-armv7l ]; then
	cd node-v16.13.2-linux-armv7l/
	# list the content of the directory
	ls -alh
	# copy the content of the directory to /usr/local
	sudo cp -R * /usr/local/
elif [ -d node-v16.13.2-linux-arm64 ]; then
	cd node-v16.13.2-linux-arm64
	# list the content of the directory
	ls -alh
	# copy the content of the directory to /usr/local
	sudo cp -R * /usr/local/
else
	echo "The directory does not exist because the architecture is not for Rasberry Pi 4b"
fi

# Check the version
sudo node -v
sudo npm -v

#turn off the iritating fund info 
#see details here: https://stackoverflow.com/questions/58972251/what-does-x-packages-are-looking-for-funding-mean-when-running-npm-install

sudo npm config set fund false --global

#install pm2 latest
sudo npm install -g pm2@latest

# update npm
sudo npm update

sudo npm update uuid@latest

# Start and enable pm2 startup service and check the status
sudo systemctl start pm2-pi.service
sudo systemctl enable pm2-pi.service

# remove the nodejs directory that is unwanted
cd "$homedir"
sudo rm -rf nodejs
