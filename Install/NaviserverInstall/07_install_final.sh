#!/bin/bash

#####################
# Enable Naviserver #
#####################

echo "[Unit]
Description=Naviserver BPT
Requires=remote-fs.target
After=remote-fs.target syslog.target network.target

[Service]
StandardOutput=syslog
StandardError=syslog
SyslogIdentifier=nsd
SyslogFacility=local4
Type=simple
Environment=http_proxy=http://10.10.1.1:3128/
Environment=https_proxy=http://10.10.1.1:3128/
ExecStart=/httpd/Naviserver49/bin/nsd -i -t /httpd/Naviserver49/nsd-bpt.tcl -u aolserv -b 0.0.0.0:80
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
" > /lib/systemd/system/aolserver-bpt.service

systemctl daemon-reload
systemctl start aolserver-bpt
systemctl enable aolserver-bpt

# shutdown -r now
