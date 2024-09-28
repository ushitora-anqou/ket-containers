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

USER 1000

CMD ["sleep", "infinity"]
