# bro-manager docker container

This repo contains everything that is needed to run the [Bro Network Security Monitor](https://www.bro.org/) manager node in the docker environment. This way you can easily set up Bro cluster having dockerized manager node, and number of workers running on physical machines (pfring enabled) - all managed from a single docker. 

## FAQ

### Why another bro docker?

I couldn't find any bro docker that is built with pf_ring support and allows cluster mode operation. This one does.

### Will pf_ring work with this image?

Yes, because the following container is only a manager node and doesn't really sniff anything at all. Upon a container start bro will be deployed to worker machines defined in `nodes.cfg` file.

Bear in mind that you need to prepare worker machines before starting the bro-manager. Make sure pf_ring kernel module is loaded in and pf_ring libpcap is installed at `/opt/PF_RING`.

### Why phusion/baseimage base?

Phusion/baseimage does a couple of things for you. First of all it solves [zombie reaping problem](https://blog.phusion.nl/2015/01/20/docker-and-the-pid-1-zombie-reaping-problem/). Moreover it support internal cron daemon that keeps bro running in case of crashes. Read more [here](https://github.com/phusion/baseimage-docker).

### How to prepare a worker machine?

Just install clean Ubuntu 16.04 (master branch) or 14.04 (14.04 branch), install pf_ring kernel module and libraries and permit network traffic.

|git branch/docker tag|phusion/baseimage ver|based on Ubuntu|
|-|-|-|
|master/latest|0.9.19|16.04 LTS|
|14.04|0.9.18|14.04 LTS|

## Quickstart

1. Make proper directories (/opt/bro/{etc|data|site}) and fill it with your specific configuration
2. Make sure your node.cfg is configured properly and worker machines are set up and ready
3. Generate and deploy ssh keys to you worker machines, make sure worker hosts are present in known_hosts!
4. Permit network traffic between manager and worker nodes.
5. Run docker container like this:

```
docker run --net=host -v /root/.ssh:/root/.ssh -v /opt/bro/etc:/opt/bro/etc -v /opt/bro/site:/opt/bro/share/bro/site -v /opt/bro/data:/data -itd --name bro-manager srozb/bro-manager
```

You can verify bro running like this:

```
# docker exec -it bro-manager broctl status

Getting process status ...
Getting peer status ...
Name         Type    Host             Status    Pid    Peers  Started
manager      manager 10.0.0.1     running   472    7      11 Jul 16:00:10
proxy-1      proxy   10.0.0.1     running   511    7      11 Jul 16:00:11
worker-1     worker  10.0.0.100       running   14572  2      11 Jul 16:00:30
worker-2     worker  10.0.0.100       running   14575  2      11 Jul 16:00:31
worker-3     worker  10.0.0.100       running   14577  2      11 Jul 16:00:32
```

```
# docker logs bro-manager

*** Running /etc/my_init.d/00_regen_ssh_host_keys.sh...
*** Running /etc/rc.local...
*** Booting runit daemon...
*** Runit started as PID 545
```

## Additional resources 

* [Phusion/baseimage](https://github.com/phusion/baseimage-docker)
* [Bro documentation](https://www.bro.org/documentation/index.html)
* [PF_RING site](http://www.ntop.org/products/packet-capture/pf_ring/)
* [Bro cluster configuration](https://www.bro.org/sphinx/configuration/index.html)
* [My companion criticalstack-intel client docker repo](https://github.com/srozb/criticalstack-client)


