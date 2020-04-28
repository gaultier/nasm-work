FROM alpine

RUN apk update && apk add nasm make gcc musl-dev

WORKDIR /tmp

ENV LINUX 1
COPY *.nasm Makefile .
