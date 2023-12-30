FROM ubuntu:20.04

RUN apt-get update \
  && apt-get install -y sudo openssl libncurses5 libncursesw5 libncursesw6 zlib1g screen locales \
  && rm -rf /var/lib/apt/lists/*

ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en
RUN locale-gen en_US.UTF-8

RUN useradd -u 1000 -G sudo -U -m -s /bin/bash epicnode \
  && echo "epicnode ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

WORKDIR /home/epicnode
USER epicnode
RUN mkdir -p /home/epicnode/.epic/main

COPY --chown=epicnode:epicnode entrypoint.sh .
RUN chmod +x entrypoint.sh

COPY --chown=epicnode:epicnode epic-node .
RUN chmod +x epic-node

COPY --chown=epicnode:epicnode foundation.json .epic/main/foundation.json
COPY --chown=epicnode:epicnode epic-server.toml .epic/main/epic-server.toml

ENTRYPOINT ["/home/epicnode/entrypoint.sh"]



