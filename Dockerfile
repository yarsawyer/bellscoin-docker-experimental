FROM ubuntu:22.04

ARG OPENSSL_VERSION=0.9.8zh

ENV DEBIAN_FRONTEND noninteractive

# Install package dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential \
        wget \
        dos2unix \
        libqrencode-dev \
	libdb5.3++-dev \
	libdb5.3-dev \
        libboost-all-dev \
        libminiupnpc-dev && \
    apt-get clean

RUN apt-get purge -y openssl

RUN wget https://www.openssl.org/source/old/0.9.x/openssl-${OPENSSL_VERSION}.tar.gz --no-check-certificate \
  && tar -xvf openssl-${OPENSSL_VERSION}.tar.gz \
  && cd openssl-${OPENSSL_VERSION} \
  && ./config \
  && make


# Copy the project files into the Docker image
COPY . .

# Convert shell scripts
# RUN find . -type f -iname "*.sh" -exec dos2unix {} \;

# Build the project
WORKDIR bellscoin/src/
RUN make -f makefile.unix -j8