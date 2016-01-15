#!/bin/bash

docker run --net=host -v /etc/hosts:/etc/hosts -v /opt/bro-web-sniff/Bro-IFD-rules/:/opt/bro/share/bro/site/Bro-IFD-rules/ -v /root/.ssh/known_hosts:/root/.ssh/known_hosts -v /root/.ssh/id_rsa:/root/.ssh/id_rsa -v /opt/bro-web-sniff/etc:/opt/bro/etc -v /data:/data --rm -it --name bro-web-manager srozb/bro-manager $1
