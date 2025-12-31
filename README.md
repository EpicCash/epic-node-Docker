# epic-node-Docker

Requires nginx and certbot to access node via https publically - optional. (https://node.mydomain.somedomain.dom:3413/v1/status)

Requirements: docker.io, docker-compose, containerd

If running Docker on a device behind a Router, port forward 3413 to the device IP.
If using ddns also forward 80 and 443

Access on LAN from wallet .toml example: http://192.168.2.44:3413
