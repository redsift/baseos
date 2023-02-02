ARG VERSION
FROM alpine:${VERSION}

RUN apk add --update --no-cache curl build-base linux-headers git perl bash gflags-dev snappy-dev zlib-dev bzip2-dev lz4-dev zstd-dev

ARG ROCKSDB_DIST_VERSION="5.17.2"
ARG ROCKSDB_DIST_SHA256="101f05858650a810c90e4872338222a1a3bf3b24de7b7d74466814e6a95c2d28"

RUN echo "${ROCKSDB_DIST_SHA256}  rocksdb-${ROCKSDB_DIST_VERSION}.tar.gz" > rocksdb-${ROCKSDB_DIST_VERSION}.tar.gz.sha256
RUN curl -L -o rocksdb-${ROCKSDB_DIST_VERSION}.tar.gz -s https://github.com/facebook/rocksdb/archive/v${ROCKSDB_DIST_VERSION}.tar.gz
RUN sha256sum -csw rocksdb-${ROCKSDB_DIST_VERSION}.tar.gz.sha256
RUN tar -zxf rocksdb-${ROCKSDB_DIST_VERSION}.tar.gz -C /usr/local/share
RUN rm rocksdb-${ROCKSDB_DIST_VERSION}.tar.gz rocksdb-${ROCKSDB_DIST_VERSION}.tar.gz.sha256

WORKDIR /usr/local/share/rocksdb-${ROCKSDB_DIST_VERSION}

ENV DISABLE_WARNING_AS_ERROR=1
ENV EXTRA_CXXFLAGS=-std=c++11
RUN make static_lib && strip --strip-debug librocksdb.a
#ROCKSDB_SHARED# RUN DEBUG_LEVEL=0 make -e shared_lib

RUN mkdir -p /usr/lib && cp -dp librocksdb.* /usr/lib/
RUN mkdir -p /usr/include/rocksdb && cp -a include/* /usr/include/rocksdb/
