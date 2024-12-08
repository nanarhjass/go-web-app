# Build stage
FROM golang:1.22.5 as base

WORKDIR /app

COPY go.mod .
RUN go mod download

COPY . .

# Cross-compile the binary for Linux (x86_64)
RUN GOOS=linux GOARCH=amd64 go build -o main .

# Final stage
FROM gcr.io/distroless/base
COPY --from=base /app/main .
COPY --from=base /app/static ./static
EXPOSE 8080
CMD ["/main"]
