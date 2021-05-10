FROM openjdk:17-alpine

# Install htmltidy
RUN apk add --no-cache \
    bash \
    tidyhtml

WORKDIR /root

# Add contents of this directory to the root user's home directory.
ADD . /root
