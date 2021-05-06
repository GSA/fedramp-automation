FROM openjdk:17-jdk-buster

# Install htmltidy
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
    tidy && \
    rm -rf /var/lib/apt/lists/*

# Add contents of this directory to the root user's home directory.
ADD . /root
