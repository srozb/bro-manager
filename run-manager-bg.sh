#!/bin/bash

docker run --net=host -v /root/.ssh/known_hosts:/root/.ssh/known_hosts -v /root/.ssh/id_rsa:/root/.ssh/id_rsa -v /data:/data -v /opt/bro-web-sniff/etc:/opt/bro/etc --name bro-web-manager -dt srozb/bro-manager
