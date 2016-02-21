package main

import (
	"fmt"
)

var (
	buildCommit string
)

func main() {
	fmt.Printf("Drone Chef Supermarket Plugin built from %s\n", buildCommit)
}
