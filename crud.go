package main

import (
	"fmt"
	"context"
	_ "time"
	"log"

	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
    "github.com/urfave/cli/v2"
)

func curdops(cCtx *cli.Context)  error {
	fmt.Println("CRUD")
	cs := getKubehandle()

	pods, err := cs.CoreV1().Pods("").List(context.TODO(), metav1.ListOptions{})
	if err != nil {
		log.Fatalf("Error while fetching data: %s", err)
	}

	fmt.Println("## Pods ##")
	for i, pod := range pods.Items {
		fmt.Printf("%d) %v \n", i, pod.Name)
	}

 	return nil
}