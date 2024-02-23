package main

import (
	"fmt"
	"net/http"
)

func main() {
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprint(w, "Hello, Banana!")
	})
	if err := http.ListenAndServe(":9001", nil); err != nil {
		panic(err)
	}
}
