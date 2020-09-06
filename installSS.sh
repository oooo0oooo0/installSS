#!/bin/bash
echo 'starting install python3'
dnf install python3

echo 'starting install ss'
pip3 install shadowsocks

echo 'replace openssl.py'
sed -i 's/EVP_CIPHER_CTX_cleanup/EVP_CIPHER_CTX_reset/' /usr/local/lib/python3.6/site-packages/shadowsocks/crypto/openssl.py

echo 'generate shadowsocks.json'
rm -f /etc/shadowsocks.json
echo 'input your IP'
read IP
echo 'input SS port'
read PORT
echo 'input SS password'
read PWD
echo "{\"server\":\"$IP\",\"port_password\":{\"$PORT\":\"$PWD\"},\"timeout\":300,\"method\":\"aes-256-cfb\"}" >> /etc/shadowsocks.json

echo 'set firewall'
firewall-cmd --permanent --zone=public --add-port=1083/tcp
firewall-cmd --reload

echo 'start ss'
ssserver -c /etc/shadowsocks.json -d start

echo 'end'
