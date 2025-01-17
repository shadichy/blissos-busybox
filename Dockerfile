# syntax=docker/dockerfile:1-labs
FROM debian:latest

# Update packages
RUN apt update && apt upgrade -y

# Install debhelper
RUN apt install -y debhelper

# Install dependencies
RUN yes | dpkg-checkbuilddeps || :

COPY . /build
WORKDIR /build

# Build binary package
RUN dpkg-buildpackage -b --no-sign
