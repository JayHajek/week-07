#!/bin/bash
sudo yum update -y
sudo install nginx -y
sudo systemctl start nginx
sudo systemctl enable nginx
