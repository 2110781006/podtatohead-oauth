#!/bin/bash
cd ~
echo "install docker"
sudo yum update -y
sudo yum install docker -y
sudo service docker start
sudo usermod -a -G docker ec2-user
echo "install docker finished"
sudo docker run -d -p 8080:9000 ghcr.io/podtato-head/podtatoserver:v0.1.2
sudo export PUBLIC_IPV4_ADDRESS="$(curl http://169.254.169.254/latest/meta-data/public-ipv4)"
sudo cat << EOF


=======
Application name: 
-- podtatohead-on-aws

Homepage URL:     
- https://$PUBLIC_IPV4_ADDRESS.nip.io

Authorization callback URL: 
- https://$PUBLIC_IPV4_ADDRESS.nip.io/oauth2/callback
=======


EOF