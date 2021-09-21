#!/bin/bash
cd ~
echo "install docker"
sudo yum update -y
sudo yum install docker -y
sudo service docker start
sudo usermod -a -G docker ec2-user
echo "install docker finished"