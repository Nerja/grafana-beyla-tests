package main

import (
	"fmt"
	"io"
	"net/http"
)

func main() {
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		resp, err := http.Get("http://banana:9001")
		if err != nil {
			fmt.Fprint(w, err.Error())
			w.WriteHeader(http.StatusInternalServerError)
			return
		}
		defer resp.Body.Close()

		if resp.StatusCode != http.StatusOK {
			fmt.Fprint(w, "Banana service is not available")
			w.WriteHeader(http.StatusInternalServerError)
			return
		}

		respBody, err := io.ReadAll(resp.Body)
		if err != nil {
			fmt.Fprint(w, err.Error())
			w.WriteHeader(http.StatusInternalServerError)
			return
		}

		fmt.Fprint(w, string(respBody))
	})
	if err := http.ListenAndServe(":9000", nil); err != nil {
		panic(err)
	}
}
