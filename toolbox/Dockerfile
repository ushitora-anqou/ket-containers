FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noniteractive

RUN apt-get update && \
    apt-get install -y make wget gnupg curl inetutils-ping awscli jq && \
    sh -c 'echo "deb https://apt.postgresql.org/pub/repos/apt jammy-pgdg main" > /etc/apt/sources.list.d/pgdg.list' && \
    wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - && \
    apt-get update && \
    apt-get install -y postgresql-client-16 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN wget https://github.com/aquaproj/aqua/releases/download/v2.35.0/aqua_linux_amd64.tar.gz && \
    mkdir aqua && \
    tar xf aqua_linux_amd64.tar.gz -C aqua && \
    cp -a aqua/aqua /usr/local/bin/

ADD https://dl.k8s.io/v1.31.2/bin/linux/amd64/kubectl /usr/local/bin/kubectl
RUN chmod +x /usr/local/bin/kubectl

ADD https://github.com/krallin/tini/releases/download/v0.19.0/tini /usr/local/bin/tini
RUN chmod +x /usr/local/bin/tini

WORKDIR /
ENV RCON_VERSION=0.10.3
ADD https://github.com/gorcon/rcon-cli/releases/download/v${RCON_VERSION}/rcon-${RCON_VERSION}-amd64_linux.tar.gz /rcon-${RCON_VERSION}-amd64_linux.tar.gz
RUN tar xf rcon-${RCON_VERSION}-amd64_linux.tar.gz && \
    cp -a rcon-${RCON_VERSION}-amd64_linux/rcon /usr/local/bin/rcon && \
    rm rcon-${RCON_VERSION}-amd64_linux.tar.gz && \
    rm -rf rcon-${RCON_VERSION}-amd64_linux

USER 1000

WORKDIR /workdir

ENV HOME=/workdir
ENV PATH=${PATH}:${HOME}/.local/share/aquaproj-aqua/bin

CMD ["sleep", "infinity"]
