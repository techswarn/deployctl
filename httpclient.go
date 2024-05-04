package main
//https://medium.com/@faruqisan/how-to-create-an-api-client-in-golang-a5d3f56b4080
import (
	"net/http"
	"time"
	"os"
	"log"
	"io"
	"fmt"
)

//Define base URL
const (
	defaultBaseURL = "https://api.digitalocean.com/v2/"
)

func NewClient(method string, path string, request io.Reader) (*http.Client, *http.Request) {
	client := &http.Client{
		Timeout: 4 * time.Second,
	}
    url := defaultBaseURL + path


	req, err := http.NewRequest(method, url, request)
	if err != nil {
		log.Printf("Error while creating new rwquest: %#v", err)
	}
	log.Printf("Token: %s", os.Getenv("DO_TOKEN"))
	req.Header.Add("Content-Type", `application/json`)
	req.Header.Add("Authorization", fmt.Sprintf("Bearer %s", os.Getenv("DO_TOKEN")))
    
	return client, req
}

