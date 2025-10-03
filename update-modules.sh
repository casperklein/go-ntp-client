#!/bin/bash

set -e

# Show available dependency updates
# go list -u -m all

# Update modules
go get -u

# Prune go.sum and go.mod by removing unnecessary checksums and transitive dependencies
go mod tidy
