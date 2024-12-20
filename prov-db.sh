#!/bin/bash

#


# update
sudo apt update -y

# upgrade exclude debian
sudo DEBIAN_FRONTEND=noninteractive apt upgrade -y

# install gnupg and curl if not already installed
sudo DEBIAN_FRONTEND=noninteractive apt-get install gnupg curl

# import MongoDB public GPG key
curl -fsSL https://www.mongodb.org/static/pgp/server-7.0.asc | \
    sudo gpg --yes -o /usr/share/keyrings/mongodb-server-7.0.gpg \
    --dearmor

# create the list file
echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list

# update for MongoDB
sudo apt-get update -y

# Install mongoDB Community server 7.0.6
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y mongodb-org=7.0.6 mongodb-org-database=7.0.6 mongodb-org-server=7.0.6 mongodb-mongosh mongodb-org-mongos=7.0.6 mongodb-org-tools=7.0.6

# protects MongoDB version control
echo "mongodb-org hold" | sudo dpkg --set-selections
echo "mongodb-org-database hold" | sudo dpkg --set-selections
echo "mongodb-org-server hold" | sudo dpkg --set-selections
echo "mongodb-mongosh hold" | sudo dpkg --set-selections
echo "mongodb-org-mongos hold" | sudo dpkg --set-selections
echo "mongodb-org-tools hold" | sudo dpkg --set-selections

# start MongoDB
sudo systemctl start mongod

# edit conf file ip for testing to accept any
sudo sed -i 's/bindIp: 127.0.0.1/bindIp: 0.0.0.0/' /etc/mongod.conf

# restart MongoDB
sudo systemctl restart mongod

# enable MongoDB on startup
echo enable mongod ...
sudo systemctl enable mongod
echo done!
