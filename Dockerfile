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

RUN git clone https://github.com/EpicCash/epic.git
WORKDIR epic
COPY . .
RUN cargo build --release

FROM ubuntu:24.04

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        sudo \
        cron \
        wget \
        unzip \
        screen \
        locales \
        openssl \
        libncursesw6 \
        nginx \
        python3 \
        certbot \
        python3-certbot-nginx \
    && rm -rf /var/lib/apt/lists/*

ENV LANG=en_US.UTF-8  
ENV LANGUAGE=en_US:en
RUN locale-gen en_US.UTF-8

#RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && locale-gen

RUN useradd -u 1001 -G sudo -U -m -s /bin/bash epicsvcs \
  && echo "epicsvcs ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

WORKDIR /home/epicsvcs

RUN sudo -u epicsvcs mkdir -p /home/epicsvcs/.epic/main

COPY --chown=epicsvcs:epicsvcs entrypoint.sh .
RUN chmod +x entrypoint.sh

COPY --from=builder /epic/target/release/epic ./epic-node

RUN chown epicsvcs:epicsvcs ./epic-node

RUN chmod +x ./epic-node

COPY --chown=epicsvcs:epicsvcs epic-server.toml .epic/main/epic-server.toml

# nginx

COPY epicnode.nginx /etc/nginx/sites-enabled

USER epicsvcs

# schedule restarts

RUN (echo "7 23 * * 2,4,6 screen -S epicnode -X quit && sleep 15 && /usr/bin/screen -dmS epicnode /home/epicsvcs/epic-node") | crontab -
#RUN (crontab -l && echo "18 22 * * * screen -S epicbox -X quit && sleep 15 && /usr/bin/screen -dmS epicbox /home/epicsvcs/epicbox") | crontab -

#EXPOSE 80 443 3413 3414

# nginx load balancing or crontab to restart

ENTRYPOINT ["/home/epicsvcs/entrypoint.sh"]

