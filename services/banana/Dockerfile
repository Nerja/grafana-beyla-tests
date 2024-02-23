FROM golang:1.20

WORKDIR /app

RUN ls

COPY go.mod ./
COPY main.go ./
RUN go build -o main .

EXPOSE 9001

CMD ["./main"]
