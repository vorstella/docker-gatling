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

FROM denvazh/gatling:2.2.4

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

ENV \
    GATLINGCQL_VERSION=0.0.6 \
    GATLINGCQL_SHA=3fe9321515526fcb3981b28f07a4d7849d58471293a72166d44230c754ebe73f \
    GATLINGCQL_DOWNLOAD_PATH=/gatling-cql.tar.gz \
    GATLINGCQL_EXTRACT_PATH=/gatling-cql


# Interesting sub-directories
#
# user-files/
# user-files/bodies
# user-files/simulations
# user-files/data

VOLUME ["/opt/gatling/conf", "/opt/gatling/results", "/opt/gatling/user-files"]

RUN \
    set -ex \
    && apk --update add tar \
    && wget -q -O - "https://github.com/gatling-cql/GatlingCql/releases/download/GatlingCql-${GATLINGCQL_VERSION}/GatlingCql-${GATLINGCQL_VERSION}-release.tar.gz" > $GATLINGCQL_DOWNLOAD_PATH \
    && echo "$GATLINGCQL_SHA  $GATLINGCQL_DOWNLOAD_PATH" | sha256sum -c - \
    && mkdir $GATLINGCQL_EXTRACT_PATH \
    && tar zxf $GATLINGCQL_DOWNLOAD_PATH -C $GATLINGCQL_EXTRACT_PATH --strip-components 1 \
    && mv $GATLINGCQL_EXTRACT_PATH/*.jar /opt/gatling/lib/ \
    && apk del tar \
    && rm -rf $GATLINGCQL_EXTRACT_PATH $GATLINGCQL_DOWNLOAD_PATH /var/cache/apk/*
