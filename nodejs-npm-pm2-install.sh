#!/bin/bash

#################################################################################
#Script Name	: nodejs-npm-pm2-install.sh
#Description	: script that installs nodejs, npm and pm2 on a Raspbery Pi 4b  
#Author       	: Adrian Ambroziak
#Email         	: adrian.ambroziak@gmail.com
#################################################################################

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

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
npm audit fix
npm audit

#install uuid latest package
npm update uuid@latest

# update npm to check is everything updated
npm update

# Start and enable pm2 startup service and check the status
sudo systemctl start pm2-pi.service
sudo systemctl enable pm2-pi.service
