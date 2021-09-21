#!/bin/bash
cd ~
echo "start git install"
sudo yum install git -y
echo "git install finished"
echo "git clone"
sudo rm podtatohead-oauth -R -f
sudo git clone https://github.com/2110781006/podtatohead-oauth.git
echo "git clone finished"
cd podtatohead-oauth/
sudo ./install.sh
