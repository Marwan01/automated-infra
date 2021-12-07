FROM golang:1.17 as builder

WORKDIR /app

COPY . .

RUN go mod download

RUN CGO_ENABLED=0 GOOS=linux go build -v -o go-automated-infra

# Use a Docker multi-stage build to create a lean production image.
# https://docs.docker.com/develop/develop-images/multistage-build/#use-multi-stage-builds
FROM alpine
RUN apk add --no-cache ca-certificates

COPY go-automated-infra.json .

# Copy the binary to the production image from the builder stage.
COPY --from=builder /app/go-automated-infra /go-automated-infra

# Run the web service on container startup.
CMD ["/go-automated-infra", "-project", "go-automated-infra" ]