FROM ubuntu:20.04

RUN apt-get update \
  && apt-get install -y libncurses5 \
  && apt-get install -y libncursesw5 \
  && apt-get install -y zlib1g \
  && apt-get install -y screen \
  && apt-get install -y locales \
  && rm -rf /var/lib/apt/lists/*

ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en

ADD epic-node /root/epic-node
RUN chmod +x /root/epic-node
ADD entrypoint.sh /root/entrypoint.sh
RUN chmod +x /root/entrypoint.sh
ADD foundation.json /epic/foundation.json
ADD epic-server.toml /epic/epic-server.toml
ENTRYPOINT ["/root/entrypoint.sh"]



