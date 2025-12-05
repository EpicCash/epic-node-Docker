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

#ENV LANG en_US.UTF-8  
#ENV LANGUAGE en_US:en
#RUN locale-gen en_US.UTF-8

FROM debian:stable-slim

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        sudo \
        wget \
        unzip \
        locales \
        openssl \
        libncursesw6 \
    && rm -rf /var/lib/apt/lists/*

RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen

RUN useradd -u 1000 -G sudo -U -m -s /bin/bash epicnode \
  && echo "epicnode ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

WORKDIR /home/epicnode
#USER epicnode
RUN sudo -u epicnode mkdir -p /home/epicnode/.epic/main

COPY --chown=epicnode:epicnode entrypoint.sh .
RUN chmod +x entrypoint.sh

COPY --from=builder /usr/src/epic/target/release/epic ./epic-node
#COPY --chown=epicnode:epicnode epic-node .
RUN chown epicnode:epicnode ./epic-node

RUN chmod +x ./epic-node

COPY --chown=epicnode:epicnode epic-server.toml .epic/main/epic-server.toml

EXPOSE 3413 3414 3415 3416

ENTRYPOINT ["/home/epicnode/entrypoint.sh"]

