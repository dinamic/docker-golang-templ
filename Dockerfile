FROM golang:1.24-alpine

RUN apk update && apk add --no-cache libwebp-dev g++ git
RUN go install github.com/a-h/templ/cmd/templ@v0.3.857

# Add a command that keeps the container running
# This allows GitHub Actions to execute steps inside it
CMD ["/bin/sh"]
