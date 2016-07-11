# bro-manager

## quickstart

1. Make proper directories (/opt/bro/{etc|data|site}) and fill it with your specific configuration
2. Make sure your node.cfg is configured properly and worker machines are set up (vanilla Ubuntu 14.10 64bit with PF-RING kernel module loaded in)
3. Generate and deploy ssh keys to you worker machines
4. Permit network traffic between manager and worker nodes.
5. Run docker container like this:

```
docker run --net=host -v /root/.ssh:/root/.ssh -v /opt/bro/etc:/opt/bro/etc -v /opt/bro/site:/opt/bro/share/bro/site -v /opt/bro/data:/data --rm -it --name bro-manager srozb/bro-manager
```

documentation will be expanded later.
