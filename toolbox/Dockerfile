FROM ubuntu:22.04

RUN apt-get update && \
    apt-get install -y wget gnupg curl inetutils-ping && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

CMD ["sleep", "infinity"]
