#!/bin/bash

# # making the script idempotent
# rm -rf sparta-app

# update
sudo apt update -y

# upgrade exclude debian
sudo DEBIAN_FRONTEND=noninteractive apt upgrade -y

# install nginx exclude debian
sudo DEBIAN_FRONTEND=noninteractive apt-get install nginx -y

# create the reverse proxy
sudo sed -i 's|try_files.*;|proxy_pass http://localhost:3000/;|' /etc/nginx/sites-available/default

# restart nginx
sudo systemctl restart nginx

# enable nginx
sudo systemctl enable nginx

# use curl to download the nodejs setup file
curl -fsSL https://deb.nodesource.com/setup_20.x -o setup_nodejs.sh

# run the setup file through bash
sudo DEBIAN_FRONTEND=noninteractive bash setup_nodejs.sh

# install nodejs
sudo DEBIAN_FRONTEND=noninteractive apt install nodejs -y

# download sparta-app from github
git clone https://github.com/Bag3ll/sparta-app.git sparta-app

# set enviroment variables
export DB_HOST=mongodb://10.0.3.4:27017/posts

# make enviroment variable persist through restart
# echo 'export DB_HOST=mongodb://10.0.3.4:27017/posts' >> ~/.bashrc

# exclude everything below from user data when using VM to create image

# Install pm2 process manager
sudo npm install -g pm2

# cd into app folder
cd sparta-app/app

# install app
npm install

# populate database (npm install does also do this)
node seeds/seed.js

# stop all apps
pm2 kill

# start app
pm2 start app.js

# # show that the app is running
# echo "Checking if the app is running..."
# sleep 5
# if curl -s http://localhost:3000 > /dev/null; then
#     echo "App is running successfully on port 3000!"
# else
#     echo "Failed to start the app. Check logs for more details."
# fi
