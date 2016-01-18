package main

import (
	"fmt"
)

var (
	buildDate string
)

func main() {
	fmt.Printf("Drone Chef Supermarket Plugin built at %s\n", buildDate)
}
