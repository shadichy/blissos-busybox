# syntax=docker/dockerfile:1-labs
FROM debian:latest

# Update packages
RUN apt update && apt upgrade -y

# Install debhelper
RUN apt install -y debhelper

COPY . /build
WORKDIR /build

# Install dependencies
RUN yes | dpkg-checkbuilddeps || :

# Build binary package
RUN dpkg-buildpackage -b --no-sign
