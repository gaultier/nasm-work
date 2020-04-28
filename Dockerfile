FROM alpine

RUN apk update && apk add nasm binutils make musl-dev

WORKDIR /tmp

COPY *.nasm Makefile .
