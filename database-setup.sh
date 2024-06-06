#!/usr/bin/env bash

# Copyright (c) 2024 Sagun Khatri. All Rights Reserved.

## Install MYSQL-SERVER
sudo apt install mysql-server -y

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

echo -e "DATABASE SETUP COMPLETE"
