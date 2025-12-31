# epic-node-Docker
Note: Under Construction - requires nginx and certbot to access node via https 

Docker Files for Epic Server Node - see repo epic-node-epicbox-docker - remove mongodb and epicbox parts for just node

~~See epic-docker-guide.txt for instructions to use .tar created with make from repos

Note: node runs as user:epicnode in Container with Screen session to view TUI using -r to attach~~

Requirements: docker.io, docker-buildx, containerd

If running Docker on a device behind Router, port forward 3413 to the device IP.
