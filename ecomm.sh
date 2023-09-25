#!/bin/bash
sudo yum update -y
sudo yum install -y httpd
sudo systemctl status httpd
sudo systemctl enable httpd
sudo systemctl status httpd
sudo yum install -y git
sudo rm -rf /var/www/html/*
sudo git clone https://github.com/itsme-srikanth/ecomm.git /var/www/html