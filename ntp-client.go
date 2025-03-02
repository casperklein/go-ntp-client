package main

import (
	"flag"
	"fmt"
	"os"
	"time"

	"github.com/beevik/ntp"
)

func main() {
	// Parse arguments
	verbose := flag.Bool("v", false, "Show detailed NTP information")
	flag.Parse()

	// Check if an NTP server is provided
	if flag.NArg() < 1 {
		fmt.Println("Usage: ntp-client [-v] <NTP Server>")
		fmt.Println("")
		return
	}

	ntpServer := flag.Arg(0)

	// Query NTP server
	resp, err := ntp.Query(ntpServer)
	if err != nil {
		fmt.Printf("Error:  Failed to fetch time from %s: \n", ntpServer)
		fmt.Printf("Detail: %v\n\n", err)
		os.Exit(1)
	}

	// Calculate and display the synchronized time
	currentTime := time.Now().Add(resp.ClockOffset)
	fmt.Printf("%s: %s\n\n", ntpServer, currentTime.Format(time.RFC1123Z))

	// If -v flag is set, show additional details
	if *verbose {
		fmt.Println("Additional NTP information:")
		fmt.Printf("  Stratum:                %d\n", resp.Stratum)
		fmt.Printf("  Reference ID:           %v\n", resp.ReferenceID)
		fmt.Printf("  Offset:                 %.6f seconds\n", resp.ClockOffset.Seconds())
		fmt.Printf("  Round-trip delay (RTT): %.6f seconds\n", resp.RTT.Seconds())
		fmt.Printf("  Root delay:             %.6f seconds\n", resp.RootDelay.Seconds())
		fmt.Printf("  Jitter (dispersion):    %.6f seconds\n", resp.RootDispersion.Seconds())
		fmt.Printf("  Polling interval:       %d seconds\n", 1<<resp.Poll)
		fmt.Printf("  Precision:              %d (≈ %.6f seconds)\n", resp.Precision, float64(resp.Precision)/256.0)
		fmt.Printf("  Reference timestamp:    %s\n", resp.ReferenceTime.Format(time.RFC1123))
		fmt.Printf("  Leap indicator:         %d\n", resp.Leap)
		fmt.Printf("  NTP version:            %d\n\n", resp.Version)
	}
}
