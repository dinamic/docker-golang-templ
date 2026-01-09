FROM golang:1.25.5-alpine

RUN apk update && apk add --no-cache libwebp-dev g++ git
RUN go install github.com/a-h/templ/cmd/templ@v0.3.977

# Add a command that keeps the container running
# This allows GitHub Actions to execute steps inside it
CMD ["/bin/sh"]
