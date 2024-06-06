#!/usr/bin/env bash

# Copyright (c) 2024 Sagun Khatri. All Rights Reserved.
#
read -p "Enter public IP address: " NEWIP
echo $NEWIP

# Update System
sudo apt update
sudo apt upgrade -y
sudo apt install tmux git mysql-server nodejs npm nginx neovim -y

## Cloning Project Repo
cd $HOME
git clone https://github.com/sshresthadh/devops-class.git

# Install NVM Version 14
#curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash
#source ~/.bashrc
#nvm install 14

# Install modules
#Server
cd $HOME/devops-class/all_in_docker/server/
tmux new-session -d -s server-term
tmux send-keys 'npm update && npm install && exit' C-m
#tmux detach -s server-term

# Client
cd $HOME/devops-class/all_in_docker/client/
#adding legacy provideer due to depreacated packaage
sed -i 's/"react-scripts start"'/"react-scripts --openssl-legacy-provider start"/ package.json
tmux new-session -d -s client-term
tmux send-keys 'npm update && npm install && exit' C-m
#tmux detach -s client-term

## MYSQL-SERVER Setup

sudo mysql -u root <<MYSQL_SCRIPT
CREATE DATABASE IF NOT EXISTS employeeSystem;
CREATE USER 'test'@'localhost' IDENTIFIED BY 'mauFJcuf5dhRMQrjj';
GRANT ALL PRIVILEGES ON employeeSystem.* TO 'test'@'localhost';
CREATE USER 'test'@'%' IDENTIFIED BY 'mauFJcuf5dhRMQrjj';
GRANT ALL PRIVILEGES ON employeeSystem.* TO 'test'@'%';
FLUSH PRIVILEGES;
MYSQL_SCRIPT

# USER ALTERATION
sudo mysql -u root <<MYSQL_SCRIPT
ALTER USER 'test'@'localhost' IDENTIFIED WITH 'mysql_native_password' BY 'mauFJcuf5dhRMQrjj';
ALTER USER 'test'@'%' IDENTIFIED WITH 'mysql_native_password' BY 'mauFJcuf5dhRMQrjj';

FLUSH PRIVILEGES;
MYSQL_SCRIPT

## Table Setup
sudo mysql -u root <<MYSQL_SCRIPT
USE employeeSystem;
CREATE TABLE IF NOT EXISTS employees (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255),
    age INT,
    country VARCHAR(255),
    position VARCHAR(255),
    wage DECIMAL(10, 2)
);
MYSQL_SCRIPT

## Change default public ip
sed -ri 's/(\b[0-9]{1,3}\.){3}[0-9]{1,3}\b'/"$NEWIP"/ $HOME/devops-class/all_in_docker/client/.env
