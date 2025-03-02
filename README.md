# ntp-client

## Description

`ntp-client` is a simple Go program that queries an NTP (Network Time Protocol) server to fetch the current time. Optionally, it can display detailed information about the NTP response.

It is based on the excellent work of [beevik/ntp](https://github.com/beevik/ntp).

## Features

- Fetches the current time from an NTP server.
- Displays additional NTP details when using the `-v` flag.
- Provides information such as stratum, offset, round-trip delay (RTT), jitter, and more.

## Build from source

### Prerequisites

- Go (>=1.16)

### Build ntp-client binary

```bash
git clone https://github.com/casperklein/go-ntp-client
cd go-ntp-client

go mod init ntp-client
go get github.com/beevik/ntp

# CGO_ENABLED=0 --> Compile with static linking (including all library code in the binary)
# CGO_ENABLED=1 --> Compile with shared libs
CGO_ENABLED=0 go build -ldflags="-s -w" -o ntp-client
```

## Build using Docker

```bash
# Build ntp-client and copy binary to the current directory
./build.sh
```

## Usage

### Basic usage (fetch current time)

```bash
./ntp-client time.google.com
```

**Example Output:**

```text
time.google.com: Fri, 28 Feb 2025 22:43:56 +0100
```

### Verbose mode (show additional NTP details)

```bash
./ntp-client -v time.google.com
```

**Example Output:**

```text
time.google.com: Fri, 28 Feb 2025 22:33:38 +0100

Additional NTP information:
  Stratum:                1
  Reference ID:           1196379575
  Offset:                 0.000014 seconds
  Round-trip delay (RTT): 0.010480 seconds
  Root delay:             0.000000 seconds
  Jitter (dispersion):    0.000061 seconds
  Polling interval:       0 seconds
  Precision:              953 (≈ 3.722656 seconds)
  Reference timestamp:    Fri, 28 Feb 2025 21:33:38 UTC
  Leap indicator:         0
  NTP version:            4
```

## Explanation of NTP Data

- **Stratum:** Shows the hierarchy of the server (1 = atomic clock, higher values = further away).
- **Reference ID:** Identifies the time source (e.g., "GOOG" for Google).
- **Offset:** Difference between local system time and NTP server time.
- **RTT (Round-trip delay):** Time taken for an NTP packet to travel to the server and back.
- **Root delay:** Total delay from the primary time source to the server.
- **Jitter (Root dispersion):** Variations in time measurements.
- **Polling interval:** Time in seconds between synchronization requests.
- **Precision:** Accuracy of the server (negative values indicate higher precision).
- **Reference timestamp:** Last time the server synchronized with a higher authority.
- **Leap indicator:** Indicates whether a leap second is added.
- **NTP version:** The version of the NTP protocol used by the server.
