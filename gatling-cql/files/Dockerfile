ARG FROM

FROM $FROM
ENV \
    GATLINGCQL_VERSION=0.0.6 \
    GATLINGCQL_SHA=3fe9321515526fcb3981b28f07a4d7849d58471293a72166d44230c754ebe73f \
    GATLINGCQL_DOWNLOAD_PATH=/gatling-cql.tar.gz \
    GATLINGCQL_EXTRACT_PATH=/gatling-cql

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

# Interesting sub-directories
#
# user-files/
# user-files/bodies
# user-files/simulations
# user-files/data

VOLUME ["/opt/gatling/conf", "/opt/gatling/results", "/opt/gatling/user-files"]
