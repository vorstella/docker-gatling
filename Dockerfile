# Copyright 2017 Vorstella
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Gatling is a highly capable load testing tool.
#
# Documentation: http://gatling.io/docs/2.2.2/
# Cheat sheet: http://gatling.io/#/cheat-sheet/2.2.2

FROM openjdk:8-jdk-alpine

ARG BUILD_DATE
ARG VCS_REF

LABEL \
    org.label-schema.build-date=$BUILD_DATE \
    org.label-schema.docker.dockerfile="/Dockerfile" \
    org.label-schema.license="Apache License 2.0" \
    org.label-schema.name="Gatling with Cassandra CQL support" \
    org.label-schema.url="https://github.com/vorstella/docker-gatling-cql" \
    org.label-schema.vcs-ref=$VCS_REF \
    org.label-schema.vcs-type="Git" \
    org.label-schema.vcs-url="https://github.com/vorstella/docker-gatling-cql"

# working directory for gatling
WORKDIR /opt

# gating version
ENV GATLING_VERSION 2.2.4

# create directory for gatling install
RUN mkdir -p gatling

# install gatling
RUN apk add --update wget && \
  mkdir -p /tmp/downloads && \
  wget -q -O /tmp/downloads/gatling-$GATLING_VERSION.zip \
  https://repo1.maven.org/maven2/io/gatling/highcharts/gatling-charts-highcharts-bundle/$GATLING_VERSION/gatling-charts-highcharts-bundle-$GATLING_VERSION-bundle.zip && \
  mkdir -p /tmp/archive && cd /tmp/archive && \
  unzip /tmp/downloads/gatling-$GATLING_VERSION.zip && \
  mv /tmp/archive/gatling-charts-highcharts-bundle-$GATLING_VERSION/* /opt/gatling/ && \
  wget -O /opt/gatling/lib/GatlingCql.jar "https://github.com/mstump/GatlingCql/releases/download/0.0.7-alpha1/GatlingCql-0.0.7-SNAPSHOT.jar" && \
  rm -rf /tmp/*

# change context to gatling directory
WORKDIR  /opt/gatling

# Set directories below to be mountable from host
# Interesting sub-directories
#
# /opt/gatling/user-files
# /opt/gatling/user-files/bodies
# /opt/gatling/user-files/simulations
# /opt/gatling/user-files/data

VOLUME ["/opt/gatling/conf", "/opt/gatling/results", "/opt/gatling/user-files"]

# set environment variables
ENV PATH /opt/gatling/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV GATLING_HOME /opt/gatling

ENTRYPOINT ["gatling.sh"]
