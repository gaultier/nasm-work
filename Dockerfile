FROM alpine

RUN apk update && apk add nasm binutils make

WORKDIR /tmp

COPY *.asm Makefile .
