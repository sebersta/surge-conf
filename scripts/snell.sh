#!/bin/bash
apt-get install wget unzip -y
cd
wget https://dl.nssurge.com/snell/snell-server-v4.0.0-linux-amd64.zip
unzip snell-server-v4.0.0-linux-amd64.zip
echo \
	'[Unit]
Description=snell server
[Service]
User=root
WorkingDirectory=/root
ExecStart=/root/snell-server
Restart=always
[Install]
WantedBy=multi-user.target' >> /etc/systemd/system/snell.service


