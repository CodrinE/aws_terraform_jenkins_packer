#!/bin/bash

echo "Install necessary packages"
yum upgrade -y

yum install docker jq java-11-amazon-corretto-devel git -y
usermod -aG docker ec2-user
systemctl enable docker


