# syntax=docker/dockerfile:1-labs
FROM debian:latest

COPY . /build
WORKDIR /build

# Build binary package
RUN ./action_build.sh

# Gen
