package main

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"time"
)

type HealthResponse struct {
	Status    string    `json:"status"`
	Timestamp time.Time `json:"timestamp"`
	Version   string    `json:"version"`
}

type ServerStatus struct {
	ActiveConnections int      `json:"active_connections"`
	ServerLoad        float64  `json:"server_load"`
	Uptime            string   `json:"uptime"`
	Region            string   `json:"region"`
}

var startTime time.Time

func main() {
	startTime = time.Now()

	http.HandleFunc("/health", healthHandler)
	http.HandleFunc("/status", statusHandler)

	port := ":8080"
	fmt.Printf("FastVPN API Gateway starting on %s\n", port)
	log.Fatal(http.ListenAndServe(port, nil))
}

func healthHandler(w http.ResponseWriter, r *http.Request) {
	response := HealthResponse{
		Status:    "UP",
		Timestamp: time.Now(),
		Version:   "1.0.0-mvp",
	}
	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(response)
}

func statusHandler(w http.ResponseWriter, r *http.Request) {
	status := ServerStatus{
		ActiveConnections: 0, // Placeholder
		ServerLoad:        0.05,
		Uptime:            time.Since(startTime).String(),
		Region:            "us-east-1",
	}
	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(status)
}
