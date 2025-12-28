# Multistage Docker build for Epic mainnet (latest Rust & Linux)

# ---- Builder Stage ----
FROM rust:latest AS builder

RUN apt-get update --fix-missing && \
    apt-get install --no-install-recommends -y \
        clang \
        libclang-dev \
        llvm-dev \
        cmake \
        git \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/epic

COPY . .

RUN cargo build --release

# ---- Runtime Stage ----
#FROM ubuntu:24.04

#RUN apt-get update \
#  && apt-get install -y sudo openssl libncurses5 libncursesw5 libncursesw6 zlib1g screen locales \
#  && rm -rf /var/lib/apt/lists/*

FROM debian:stable-slim

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        sudo \
        wget \
        unzip \
        screen \
        locales \
        openssl \
        libncursesw6 \
        nginx \
        certbot \
    && rm -rf /var/lib/apt/lists/*

ENV LANG=en_US.UTF-8  
ENV LANGUAGE=en_US:en
RUN locale-gen en_US.UTF-8

#RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && locale-gen

RUN useradd -u 1000 -G sudo -U -m -s /bin/bash epicsvcs \
  && echo "epicsvcs ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

WORKDIR /home/epicsvcs

RUN sudo -u epicsvcs mkdir -p /home/epicsvcs/.epic/main

COPY --chown=epicsvcs:epicsvcs entrypoint.sh .
RUN chmod +x entrypoint.sh

COPY --from=builder /usr/src/epic/target/release/epic ./epic-node
#COPY --chown=epicnode:epicnode epic-node .
RUN chown epicsvcs:epicsvcs ./epic-node

RUN chmod +x ./epic-node

COPY --chown=epicsvcs:epicsvcs epic-server.toml .epic/main/epic-server.toml

#epicbox

COPY --chown=epicsvcs:epicsvcs epicbox config.json epicboxlib .
RUN chmod +x epicbox

COPY epicnode.service /etc/systemd/system/epicnode.service
COPY epicbox.service /etc/systemd/system/epicbox.service
COPY epicnode.nginx /etc/nginx/sites-enabled/epicnode.nginx
COPY epicbox.nginx /etc/nginx/sites-enabled/epicbox.nginx
RUN systemctl daemon-reload
RUN systemctl enable epicnode.service
RUN systemctl enable epicbox.service

USER epicsvcs
EXPOSE 3413 3414 3415 3416 3423

# nginx load balancing

ENTRYPOINT ["/home/epicsvcs/entrypoint.sh"]

