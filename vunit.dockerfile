ARG TAG="buster-mcode"

FROM ghdl/ghdl:$TAG AS base
ARG PY_PACKAGES
RUN apt-get update -qq \
 && DEBIAN_FRONTEND=noninteractive apt-get -y install --no-install-recommends \
    ca-certificates \
    curl \
    make \
    python3 \
    python3-pip \
 && apt-get autoclean && apt-get clean && apt-get -y autoremove \
 && update-ca-certificates \
 && rm -rf /var/lib/apt/lists/* \
 && pip3 install -U pip setuptools wheel $PY_PACKAGES

FROM base as stable
RUN pip3 install vunit_hdl

FROM alpine as get-master
RUN apk add --no-cache --update git && git clone --recurse-submodules https://github.com/VUnit/vunit /tmp/vunit

FROM base AS master
COPY --from=get-master /tmp/vunit /tmp/vunit
RUN cd /tmp/vunit \
 && pip3 install . \
 && cd .. \
 && rm -rf vunit
