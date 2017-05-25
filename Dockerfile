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
    GATLINGCQL_VERSION=0.0.7-alpha1 \
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

ADD "https://github.com/mstump/GatlingCql/releases/download/0.0.7-alpha1/GatlingCql-0.0.7-SNAPSHOT.jar" /

RUN \
    set -ex \
    && mv /*.jar /opt/gatling/lib/
