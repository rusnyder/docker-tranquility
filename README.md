Docker Tranquility
==================

[![Docker Build Status](https://img.shields.io/docker/build/rusnyder/tranquility.svg)][dockerhub]
[![Docker Image Stats](https://images.microbadger.com/badges/image/rusnyder/tranquility.svg)](https://microbadger.com/images/rusnyder/tranquility)
[![Docker Pulls](https://img.shields.io/docker/pulls/rusnyder/tranquility.svg)][dockerhub]

Tags:

- latest ([Dockerfile](https://github.com/rusnyder/docker-tranquility/blob/master/Dockerfile))

[dockerhub]: https://hub.docker.com/r/rusnyder/tranquility


What is Tranqulity?
===================

From the [Tranquility Github page](https://github.com/druid-io/tranquility):

> Tranquility helps you send real-time event streams to Druid and handles partitioning, replication, service discovery, and schema rollover, seamlessly and without downtime.

How to use?
===========

This is best used as part of a docker-compose.yml file with Druid also being
created.  By default, the container launches the Tranquility server with no
pre-loaded configs, but you can also provide a config file by mounting one
and specifying its location via the `TRANQUILITY_CONFIG_FILE` environment
variable.

So assuming you have a config file located at `conf/tranquility/config.json` in your
local working directory and a full druid stack + zookeeper running on your
local machine (or in containers w/ exposed ports), you could spin up tranquility
with the following:

```shell
docker run -it \
  --network host \
  -v `pwd`/conf/tranquility:/etc/tranquility \
  -e TRANQUILITY_CONFIG_FILE=/etc/tranquility/config.json \
  -e TRANQUILITY_ZOOKEEPER_CONNECT=localhost:2181 \
  -p 8200:8200 \
  rusnyder/tranquility
```

Alternately, you could add this as a service in a docker-compose file as follows:

```yaml
version: "2"
services:
  zookeeper:
    image: confluentinc/cp-zookeeper:latest
    environment:
      ZOOKEEPER_CLIENT_PORT: 2181
      ZOOKEEPER_TICK_TIME: 2000
    ports:
      - 2181:2181
  tranquility:
    image: rusnyder/tranquility:latest
    volumes:
      - ./conf/tranquility:/etc/tranquility
    environment:
      TRANQUILITY_CONFIG_FILE: /etc/tranquility/config.json
      TRANQUILITY_PROPERTIES_ZOOKEEPER_CONNECT: zookeeper:2181
    ports:
      - 8200:8200
```
