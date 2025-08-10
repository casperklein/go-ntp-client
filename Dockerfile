FROM golang:1 AS builder

ARG APP="APP"
ARG MULTIARCH=""

ENV DEST_DIR=/build

SHELL ["/bin/bash", "-e", "-c"]

WORKDIR /app

COPY . .

# CGO_ENABLED=0 --> Compile with static linking (including all library code in the binary)
# CGO_ENABLED=1 --> Compile with shared libs. When no shared libs are available (e.g. scratch/alpine image) --> 'exec /server: no such file or directory'
ENV CGO_ENABLED=0

# Builds a Go binary without symbol tables and debugging information, reducing the file size.
RUN <<EOF
	if [ ! -f go.mod ]; then
		go mod init "$APP"
		# go get ./...
		go mod tidy
	fi

	if [ -z "$MULTIARCH" ]; then
		go build -ldflags="-s -w" -o "$DEST_DIR/"
	else
		GOOS=linux   GOARCH=amd64 go build -ldflags="-s -w" -o "$DEST_DIR/$APP-linux-amd64"
		GOOS=linux   GOARCH=arm64 go build -ldflags="-s -w" -o "$DEST_DIR/$APP-linux-arm64"
		GOOS=windows GOARCH=amd64 go build -ldflags="-s -w" -o "$DEST_DIR/$APP-windows-amd64.exe"
	fi
EOF
