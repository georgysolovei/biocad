package main

import (
	"fmt"
	"log"
	"net/http"
)

func helloHandler(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintln(w, "hello world")
}

func main() {
	http.HandleFunc("/", helloHandler)

	addr := ":32777"
	log.Printf("Server starting on port %s", addr)
	if err := http.ListenAndServe(addr, nil); err != nil {
		log.Fatalf("Failed to start server: %v", err)
	}
}