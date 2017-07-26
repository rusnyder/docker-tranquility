FROM openjdk:8-jre-alpine
MAINTAINER Russell Snyder <ru.snyder@gmail.com>

# Java config
ENV TRANQUILITY_VERSION   0.8.0

# Dependencies
RUN apk update && apk add bash

# Install
RUN wget -q -O - \
    http://static.druid.io/tranquility/releases/tranquility-distribution-$TRANQUILITY_VERSION.tgz \
    | tar -xzf - -C /usr/share \
    && ln -s /usr/share/tranquility-distribution-$TRANQUILITY_VERSION /usr/share/tranquility

COPY conf /usr/share/tranquility-distribution-$TRANQUILITY_VERSION/conf

WORKDIR /usr/share/tranquility

ENTRYPOINT ["bin/tranquility", "server", "-configFile", "conf/tranquility/server.json"]
