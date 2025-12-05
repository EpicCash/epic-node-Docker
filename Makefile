# delete the target of a rule if it has changed and its recipe exits with a nonzero exit status
.DELETE_ON_ERROR:

epic-node-x86: Dockerfile epic-server.toml entrypoint.sh
	docker build --tag epic-node --build-arg ARCH=x86_64 --platform=linux/amd64 --output type=docker,dest=epic-docker.tar .


