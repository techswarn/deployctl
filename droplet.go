package main

import (
	"encoding/json"
	"log"
	"os"
	"github.com/urfave/cli/v2"
	"bytes"
)

type Key struct {
	ID          int    `json:"id,float64,omitempty"`
	Name        string `json:"name,omitempty"`
	Fingerprint string `json:"fingerprint,omitempty"`
	PublicKey   string `json:"public_key,omitempty"`
}

type keysRoot struct {
	SSHKeys []Key  `json:"ssh_keys"`
	Links   *Links `json:"links"`
	Meta    *Meta  `json:"meta"`
}

// Links manages links that are returned along with a List
type Links struct {
	Pages   *Pages       `json:"pages,omitempty"`
	Actions []LinkAction `json:"actions,omitempty"`
}

// Pages are pages specified in Links
type Pages struct {
	First string `json:"first,omitempty"`
	Prev  string `json:"prev,omitempty"`
	Last  string `json:"last,omitempty"`
	Next  string `json:"next,omitempty"`
}

type LinkAction struct {
	ID   int    `json:"id,omitempty"`
	Rel  string `json:"rel,omitempty"`
	HREF string `json:"href,omitempty"`
}

type Meta struct {
	Total int `json:"total"`
}

type MultiDropletCreateRequest struct {
	Names             []string              `json:"names"`
	Region            string                `json:"region"`
	Size              string                `json:"size"`
	Image             string                `json:"image"`
	SSHKeys           []string          `json:"ssh_keys"`
	Backups           bool                  `json:"backups"`
	IPv6              bool                  `json:"ipv6"`
	Monitoring        bool                  `json:"monitoring"`
	UserData          string                `json:"user_data,omitempty"`
	Tags              []string              `json:"tags"`
	VPCUUID           string                `json:"vpc_uuid,omitempty"`
}



var token string = "Bearer " + os.Getenv("DO_TOKEN")

func createDroplet(cCtx *cli.Context) error {
	
	log.Println("Create droplet")
	log.Println("added task: ", cCtx.Args())
	keys := fetchSslKeys()

	var fingerPrints []string
	for _, value := range keys {
		log.Printf("Value %v", value.Fingerprint)
		if value.Name == "k8deploy" {
			fingerPrints = append(fingerPrints, value.Fingerprint)
		}
	}

	//Need to improve this
	kubemaster := cCtx.Args().Get(0)
	worker1 := cCtx.Args().Get(1)
	worker2 := cCtx.Args().Get(2)

	names := []string{kubemaster, worker1, worker2}
	tags := []string{"cluster1"}
	body := &MultiDropletCreateRequest{
		Names: names,
		Region: "blr",
		Size: "s-4vcpu-8gb",
		Image: "ubuntu-20-04-x64",
		SSHKeys: fingerPrints,
		Tags: tags,
	}

	var buf bytes.Buffer
    err := json.NewEncoder(&buf).Encode(body)
    if err != nil {
        log.Fatal(err)
    }
	c, req := NewClient("POST", "droplets", &buf)

	resp, err := c.Do(req)
    if err != nil {
        log.Fatal(err)
    }
	defer resp.Body.Close()

    log.Println("Droplet create response Status code" + resp.Status)
	if resp.Status != "202" {
		log.Println("Something went wrong!! Status code: " + resp.Status)

	}
	var r map[string]interface{}

	err = json.NewDecoder(resp.Body).Decode(&r)

	
	if err != nil {
		panic(err)
	}
	for _, details := range r	{
		log.Printf("#%v", details)
	}

	return nil
}

func fetchSslKeys() []Key {

	root := new(keysRoot)
	c, req := NewClient("GET", "account/keys", nil)

	resp, err := c.Do(req)
	
	if err != nil {
		log.Printf("Error while making API request: %#v", err)
	}
	if resp.Status == "401" {
		log.Fatal("Request return")
	}
	defer resp.Body.Close()
	err = json.NewDecoder(resp.Body).Decode(&root)
	if err != nil {
		panic(err)
	}

	return root.SSHKeys;
}