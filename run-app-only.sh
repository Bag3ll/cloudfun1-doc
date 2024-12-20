#!/bin/bash

# cd into app folder
cd sparta-app/app

# set enviroment variables
export DB_HOST=mongodb://10.0.3.4:27017/posts

# install app
npm install

# populate database
node seeds/seed.js

# stop all apps
pm2 kill

# start app
pm2 start app.js
