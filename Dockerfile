FROM golang:1 AS builder

WORKDIR /app

COPY ntp-client.go .

# CGO_ENABLED=0 --> Compile with static linking (including all library code in the binary)
# CGO_ENABLED=1 --> Compile with shared libs. When no shared libs are available (e.g. scratch/alpine image) --> 'exec /server: no such file or directory'
ENV CGO_ENABLED=0

SHELL ["/bin/bash", "-e", "-c"]

# Builds a Go binary without symbol tables and debugging information, reducing the file size.
RUN <<EOF
	go mod init ntp-client
	go get github.com/beevik/ntp
	go build -ldflags="-s -w" -o /usr/bin/ntp-client
EOF
