# epic-node-Docker
Note: Under Construction - requires nginx and certbot to access node via https 

Docker Files for Epic Server Node

See epic-docker-guide.txt for instructions to use .tar created with make from repos

Note: node runs as user:epicnode in Container with Screen session to view TUI using -r to attach

Requirements: docker.io, docker-buildx, containerd

If running Docker on a device behind Router, open firewall ports 3413, 3414, 3415, 3416 and port forward these to the device IP.
