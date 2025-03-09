FROM ubuntu:22.04

# https://github.com/aquaproj/aqua/releases
ARG AQUA_VERSION=2.37.2
# https://kubernetes.io/ja/releases/
ARG KUBECTL_VERSION=1.31.2
# https://github.com/krallin/tini
ARG TINI_VERSION=0.19.0
# https://github.com/gorcon/rcon-cli/releases
ARG RCON_VERSION=0.10.3

ENV DEBIAN_FRONTEND=noniteractive

RUN apt-get update && \
    apt-get install -y make wget gnupg curl inetutils-ping awscli jq dnsutils backblaze-b2 && \
    sh -c 'echo "deb https://apt.postgresql.org/pub/repos/apt jammy-pgdg main" > /etc/apt/sources.list.d/pgdg.list' && \
    wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - && \
    apt-get update && \
    apt-get install -y postgresql-client-17 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN wget https://github.com/aquaproj/aqua/releases/download/v${AQUA_VERSION}/aqua_linux_amd64.tar.gz && \
    mkdir aqua && \
    tar xf aqua_linux_amd64.tar.gz -C aqua && \
    cp -a aqua/aqua /usr/local/bin/

ADD https://dl.k8s.io/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl /usr/local/bin/kubectl
RUN chmod +x /usr/local/bin/kubectl

ADD https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini /usr/local/bin/tini
RUN chmod +x /usr/local/bin/tini

WORKDIR /
ENV RCON_VERSION=${RCON_VERSION}
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
