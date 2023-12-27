# delete the target of a rule if it has changed and its recipe exits with a nonzero exit status
.DELETE_ON_ERROR:

epic-node-x86: Dockerfile ./foundation.json ./epic-server.toml entrypoint.sh epic-node
ifeq ($(ARCH),aarch64)
else
	docker buildx build --tag epic-node --build-arg ARCH=x86_64 --platform=linux/amd64 -o type=docker,dest=epic-docker.tar .
endif


