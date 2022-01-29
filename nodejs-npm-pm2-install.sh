#!/bin/bash

#################################################################################
# Script Name: nodejs-npm-pm2-install.sh
# Description: script that installs nodejs, npm and pm2 on a Raspbery Pi 4b  
# Author:      Adrian Ambroziak
# Email:       adrian.ambroziak@gmail.com
#################################################################################

# NVM (Node Version Manager) is a bash script that allows you to install and manage multiple Node.js versions. 
# Use this method if you need to install a specific Node.js version or if you need to have more than one Node.js versions installed on your Raspberry Pi.
# To install nvm run the following curl command which will download and run the nvm installation script:

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash

# run the following to use nvm now:
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Read the explanation about version installation: https://linuxize.com/post/how-to-install-node-js-on-raspberry-pi/

#install the long term supported version
nvm install --lts

# Check the version
node -v
npm -v

#turn off the iritating fund info 
#see details here: https://stackoverflow.com/questions/58972251/what-does-x-packages-are-looking-for-funding-mean-when-running-npm-install
npm config set fund false --global

#install pm2 latest package
npm install -g pm2@latest

#perform an upgrade to version 8.4.0
npm install -g npm@8.4.0

#fix after upgrade
npm audit fix

#audit check
npm audit

#install uuid latest package
npm update uuid@latest

# update npm to check is everything updated
npm update

# Start and enable pm2 startup service and check the status
pm2 status

#Add variable homedir
homedir="$(getent passwd $( /usr/bin/id -u ) | cut -d: -f6)"

# Add variable user
user="$(getent passwd $( /usr/bin/id -u ) | cut -d: -f1)"

#Add PATH for pm2 and make a startup unit
sudo env PATH=$PATH:/$homedir/.nvm/versions/node/v16.13.2/bin /$homedir/.nvm/versions/node/v16.13.2/lib/node_modules/pm2/bin/pm2 startup systemd -u $user --hp $homedir

#start the pm2 service
sudo systemctl start pm2-pi.service

#enable the pm2 service during boot
sudo systemctl enable pm2-pi.service

#Install development tools
#To be able to compile and install native add-ons from the npm registry you need to install the development tools:
sudo apt install build-essential

# recommended reboot after the installation
sudo reboot
