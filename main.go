package main

import (
    "log"
    "os"
    "github.com/joho/godotenv"
    "github.com/urfave/cli/v2"
)

func main() {

    //Load environment variables
    err := godotenv.Load()
    if err != nil {
      log.Fatal("Error loading .env file")
    }

    //Get handle

    app := &cli.App{
        Commands: []*cli.Command{
            {
                Name:    "curd",
                Aliases: []string{"a"},
                Usage:   "CRUD operation",
                Action: curdops,
            },
            {
                Name:    "droplet",
                Aliases: []string{"d"},
                Usage:   "CRUD Droplet",
                Action: createDroplet,
            },
        },
    }
	app.Name = "deployctl"
	app.Usage = "Deploy and manage K8s on DigitalOcean"

    if err := app.Run(os.Args); err != nil {
        log.Fatal(err)
    }
}
