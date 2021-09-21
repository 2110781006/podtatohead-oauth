#!/bin/bash
cd ~
echo "install docker"
sudo yum update -y
sudo yum install docker -y
sudo service docker start
sudo usermod -a -G docker ec2-user
echo "install docker finished"
sudo docker run -d -p 8080:9000 ghcr.io/podtato-head/podtatoserver:v0.1.2
export PUBLIC_IPV4_ADDRESS="$(curl http://169.254.169.254/latest/meta-data/public-ipv4)"
cat << EOF


=======
Application name: 
-- podtatohead-on-aws

Homepage URL:     
- https://$PUBLIC_IPV4_ADDRESS.nip.io

Authorization callback URL: 
- https://$PUBLIC_IPV4_ADDRESS.nip.io/oauth2/callback
=======


EOF

sudo amazon-linux-extras install epel -y
sudo yum-config-manager --enable epel

sudo yum install certbot -y

export PUBLIC_IPV4_ADDRESS="$(curl http://169.254.169.254/latest/meta-data/public-ipv4)"
export PUBLIC_INSTANCE_NAME="$(curl http://169.254.169.254/latest/meta-data/public-hostname)"

sudo certbot certonly --standalone --preferred-challenges http -d $PUBLIC_IPV4_ADDRESS.nip.io --dry-run

sudo certbot certonly --standalone --preferred-challenges http -d $PUBLIC_IPV4_ADDRESS.nip.io --staging

#oaouth
sudo mkdir -p /tmp/oauth2-proxy
sudo mkdir -p /opt/oauth2-proxy

cd /tmp/oauth2-proxy
curl -sfL https://github.com/oauth2-proxy/oauth2-proxy/releases/download/v7.1.3/oauth2-proxy-v7.1.3.linux-amd64.tar.gz | tar -xzvf -

sudo mv oauth2-proxy-v7.1.3.linux-amd64/oauth2-proxy /opt/oauth2-proxy/

export COOKIE_SECRET=$(python -c 'import os,base64; print(base64.urlsafe_b64encode(os.urandom(16)).decode())')

export GITHUB_USER==$( echo "Y0t+mPZbCH87A5FTjHpAH/rvaB/3s+FQS7IFmEtdszvKaEdMwjVjmzjCGQPdBSi7 fXf3uBMertBJ6lBE2RUCm39BGRVuANUIzuf6lYYgGsdyW1mdLiHn1UCOr3gAnYWI zn+CZOV3tUceTh2hnG3am9b8B0SQ9VqWqOlfkCHNpfw=" | openssl enc -base64 -d | openssl rsautl -decrypt -inkey ~/podtatohead-oauth/myPrivate.pem)
echo $GITHUB_USER
#export GITHUB_CLIENT_ID=<GITHUB_CLIENT_ID>
#export GITHUB_CLIENT_SECRET=<GITHUB_CLIENT_SECRET>
#export PUBLIC_URL=$(curl http://169.254.169.254/latest/meta-data/public-ipv4).nip.io

#sudo /opt/oauth2-proxy/oauth2-proxy --github-user="${GITHUB_USER}"  --cookie-secret="${COOKIE_SECRET}" --client-id="${GITHUB_CLIENT_ID}" --client-secret="${GITHUB_CLIENT_SECRET}" --email-domain="*" --upstream=http://127.0.0.1:8080 --provider github --cookie-secure false --redirect-url=https://${PUBLIC_URL}/oauth2/callback --https-address=":443" --force-https --tls-cert-file=/etc/letsencrypt/live/$PUBLIC_URL/fullchain.pem --tls-key-file=/etc/letsencrypt/live/$PUBLIC_URL/privkey.pem