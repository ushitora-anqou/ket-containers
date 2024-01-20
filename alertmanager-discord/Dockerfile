FROM golang:alpine as builder
RUN apk update && \
    apk add git && \
    apk add ca-certificates
RUN adduser -D -g '' appuser
WORKDIR $GOPATH/src/mypackage/
RUN git clone https://github.com/benjojo/alertmanager-discord.git myapp && \
    cd myapp && \
    git checkout 89ef841a7ef43c5520df49d0c28335d899230eb9
WORKDIR $GOPATH/src/mypackage/myapp
RUN go get -d -v
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -ldflags="-w -s" -o /go/bin/alertmanager-discord

FROM scratch
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=builder /etc/passwd /etc/passwd
COPY --from=builder /go/bin/alertmanager-discord /go/bin/alertmanager-discord

ENV LISTEN_ADDRESS=0.0.0.0:9094
EXPOSE 9094
USER appuser
ENTRYPOINT ["/go/bin/alertmanager-discord"]
