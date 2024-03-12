FROM golang:1.22-alpine

RUN apk update && apk add libwebp-dev g++ git
RUN go install github.com/a-h/templ/cmd/templ@v0.2.598
