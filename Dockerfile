FROM openjdk:8-jre-alpine
MAINTAINER Russell Snyder <ru.snyder@gmail.com>

# Build config
ARG tranquility_version=0.8.3
ARG vcs_ref=unspecified
ARG build_date=unspecified

LABEL org.label-schema.name="tranquility" \
      org.label-schema.description="Druid Tranquility" \
      org.label-schema.build-date="${build_date}" \
      org.label-schema.vcs-url="https://github.com/rusnyder/docker-tranquility" \
      org.label-schema.vcs-ref="${vcs_ref}" \
      org.label-schema.version="${tranquility_version}" \
      org.label-schema.schema-version="1.0" \
      maintainer="Russell Snyder <ru.snyder@gmail.com>"

# Default runtime config
ENV TRANQUILITY_PROPERTIES_ZOOKEEPER_CONNECT    zookeeper
ENV TRANQUILITY_PROPERTIES_HTTP_PORT            8200
ENV TRANQUILITY_CONFIG_FILE                     conf/tranquility/config.json

# Install
RUN apk update \
 && apk add bash jq \
 && rm -rf /var/cache/apk/* \
 && wget -q -O - \
    http://static.druid.io/tranquility/releases/tranquility-distribution-${tranquility_version}.tgz \
    | tar -xzf - -C /usr/share \
 && ln -s /usr/share/tranquility-distribution-${tranquility_version} /usr/share/tranquility

COPY conf /usr/share/tranquility-distribution-${tranquility_version}/conf
COPY start-tranquility.sh /start-tranquility.sh

WORKDIR /usr/share/tranquility

ENTRYPOINT /start-tranquility.sh
