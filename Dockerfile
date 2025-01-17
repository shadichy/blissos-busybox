# syntax=docker/dockerfile:1-labs
FROM debian:latest

# Update packages
RUN apt update && apt upgrade -y

# Install debhelper
RUN apt install -y debhelper

COPY . /build
WORKDIR /build

# Install dependencies
RUN yes | apt install -y $(dpkg-checkbuilddeps 2>&1 | grep 'Unmet build dependencies' | awk -F ':' '{print $4}') || :

# Build binary package
RUN dpkg-buildpackage -b --no-sign
