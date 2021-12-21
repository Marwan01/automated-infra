package main

import (
	"context"
	"flag"
	"fmt"
	"net/http"
	"os"
	"os/signal"
	"syscall"

	"github.com/gorilla/mux"
	"github.com/sirupsen/logrus"
	"google.golang.org/api/option"

	"cloud.google.com/go/bigtable"
)

func readRow(ctx context.Context, tbl *bigtable.Table, columnFamily string, rowKey string) (string, error) {
	row, err := tbl.ReadRow(ctx, rowKey)
	if err != nil {
		logrus.Errorf("Could not read row with key: %v", rowKey)
		return "", err
	}
	return string(row[columnFamily][0].Value), nil
}

func bigTableNewClient(ctx context.Context, projectID string, instanceID string) *bigtable.Client {
	// Set up Bigtable data operations client.
	client, err := bigtable.NewClient(ctx, projectID, instanceID, option.WithCredentialsFile("go-automated-infra.json"))
	if err != nil {
		logrus.Errorf("Could not create data operations client: %v", err)
	}
	logrus.Info("Big Table Client Started")
	return client
}

func bigTableClientStop(ctx context.Context, client *bigtable.Client) {
	err := client.Close()
	if err != nil {
		logrus.Panicf("Could not close data operations client: %v", err)
	}
	logrus.Info("Big Table Client Stopped")
}

func main() {
	ctx := context.Background()

	projectID := "go-automated-infra"           // The Google Cloud Platform project ID
	instanceID := "go-automated-infra-instance" // The Google Cloud Bigtable instance ID
	tableID := "go-automated-infra-table"       // The Google Cloud Bigtable table
	rowKey := "r1"                              // The Google Cloud Bigtable table row
	columnFamily := "cf1"                       // The Google Cloud Bigtable table column

	// Override with -project, -instance, -table flags
	flag.StringVar(&projectID, "project", projectID, "The Google Cloud Platform project ID.")
	flag.StringVar(&instanceID, "instance", instanceID, "The Google Cloud Bigtable instance ID.")
	flag.StringVar(&tableID, "table", tableID, "The Google Cloud Bigtable table ID.")
	flag.StringVar(&rowKey, "row", rowKey, "The Google Cloud Bigtable rowKey value.")
	flag.StringVar(&columnFamily, "colum", columnFamily, "The Google Cloud Bigtable columnFamily value.")
	flag.Parse()

	// start bigTable go client
	client := bigTableNewClient(ctx, projectID, instanceID)
	tbl := client.Open(tableID)

	// Gracefully handle ^C and close the bigTable client to avoid memery leak
	c := make(chan os.Signal)
	signal.Notify(c, os.Interrupt, syscall.SIGTERM)
	go func() {
		<-c
		logrus.Infof("User exited via ^C")
		bigTableClientStop(ctx, client)
		os.Exit(1)
	}()

	//create router and set up two routes
	router := mux.NewRouter().StrictSlash(true)
	router.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		w.WriteHeader(http.StatusAccepted)
		fmt.Fprintf(w, "Welcome home!")
	})
	router.HandleFunc("/bigtable", func(w http.ResponseWriter, r *http.Request) {
		row, err := readRow(ctx, tbl, columnFamily, rowKey)
		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			logrus.Error(err)
		}
		fmt.Fprint(w, row)
	})

	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}

	logrus.Printf("Listening on localhost:%s", port)
	err := http.ListenAndServe(fmt.Sprintf(":%s", port), router)
	if err != nil {
		logrus.Error(err)
		bigTableClientStop(ctx, client)
	}
}
