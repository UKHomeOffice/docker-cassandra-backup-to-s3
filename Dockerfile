FROM alpine:3.4

ENV JAVA_VERSION=8u111 \
    JAVA_ALPINE_VERSION=8.111.14-r0 \
    CASSANDRA_VERSION=2.2.8

ENV JAVA_HOME /usr/lib/jvm/java-1.8-openjdk
ENV PATH $PATH:/usr/lib/jvm/java-1.8-openjdk/jre/bin:/usr/lib/jvm/java-1.8-openjdk/bin:/opt/dsc-cassandra-${CASSANDRA_VERSION}/bin

# Default to UTF-8 file.encoding
ENV LANG C.UTF-8

# add a simple script that can auto-detect the appropriate JAVA_HOME value
# based on whether the JDK or only the JRE is installed
RUN { \
		echo '#!/bin/sh'; \
		echo 'set -e'; \
		echo; \
		echo 'dirname "$(dirname "$(readlink -f "$(which javac || which java)")")"'; \
	} > /usr/local/bin/docker-java-home \
	&& chmod +x /usr/local/bin/docker-java-home

RUN apk -Uuv --no-cache add \
    bash \
    curl \
    ca-certificates \
    python \
    py-pip \
    dcron \
		openjdk8="$JAVA_ALPINE_VERSION" && \
    [ "$JAVA_HOME" = "$(docker-java-home)" ] && \
    pip install awscli

# Download cassandra, for the nodetool binary
RUN mkdir /opt && cd /opt && \
    curl -O http://downloads.datastax.com/community/dsc-cassandra-${CASSANDRA_VERSION}-bin.tar.gz && \
    tar xvf dsc-cassandra-${CASSANDRA_VERSION}-bin.tar.gz && \
    chmod 755 dsc-cassandra-${CASSANDRA_VERSION}/bin

COPY backup /usr/local/bin/backup
COPY entrypoint /usr/local/bin/entrypoint

# Check the params are correct on start-up
ENTRYPOINT /usr/local/bin/entrypoint
