FROM golang:1.22 AS buildbot

WORKDIR /

RUN git clone https://github.com/ushitora-anqou/factorio-notify-bot2.git && \
    cd factorio-notify-bot2 && \
    git checkout 0.1.3 && \
    CGO_ENABLED=0 go build -o factorio-notify-bot2 main.go

FROM debian:bookworm-slim

RUN apt-get update && \
    apt-get install -y ca-certificates && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /

RUN addgroup --system --gid 1001 factorio && \
    adduser --system --uid 1001 factorio
COPY --from=buildbot --chown=factorio:factorio /factorio-notify-bot2/factorio-notify-bot2 /factorio-notify-bot2

ENV TINI_VERSION=v0.19.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini

USER factorio

ENTRYPOINT ["bash"]
