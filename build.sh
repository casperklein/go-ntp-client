#!/bin/bash

set -e

APP="ntp-client"

_cleanUp() {
	docker rm "$APP"
	docker rmi "$APP"
} &>/dev/null
trap _cleanUp EXIT

echo "Start building '$APP'"

docker build -t "$APP" .
docker create --name "$APP" "$APP"
docker cp ntp-client:/usr/bin/"$APP" .

echo "Build was successful."
echo
