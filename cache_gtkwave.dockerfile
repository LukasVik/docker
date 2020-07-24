ARG IMAGE="debian:buster-slim"

#---

FROM $IMAGE AS build
RUN apt-get update -qq \
 && apt-get -y install \
   build-essential \
   clang \
   flex \
   gawk \
   gperf \
   libbz2-dev \
   libreadline-dev \
   libffi-dev \
   libgtk-3-dev \
   liblzma-dev \
   pkg-config \
   subversion \
   tcl-dev \
   tk-dev \
 && mkdir /tmp/gtkwave && cd /tmp/gtkwave \
 && svn checkout svn://svn.code.sf.net/p/gtkwave/code/gtkwave3-gtk3 ./ \
 && ./configure --with-tk=/usr/lib --enable-gtk3 \
 && make -j$(nproc) \
 && make DESTDIR=/opt/gtkwave check install \
 && tar -zcvf /tmp/gtkwave.tgz -C /opt/gtkwave/usr/local/ .

#---

FROM scratch
COPY --from=build ./tmp/*.tgz ./
