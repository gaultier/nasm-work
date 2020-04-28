FROM alpine

RUN apk update && apk add nasm make gcc musl-dev

WORKDIR /tmp

COPY *.nasm Makefile .
