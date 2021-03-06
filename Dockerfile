FROM openjdk:8u171-jdk-alpine
LABEL maintainer="Obie Quelland"

ENV TIKA_VERSION 1.18
ENV TIKA_SERVER_URL https://archive.apache.org/dist/tika/tika-server-$TIKA_VERSION.jar

RUN apk add --no-cache \
    curl \
    gnupg \
    && curl -sSL https://people.apache.org/keys/group/tika.asc -o /tmp/tika.asc \
    && gpg --import /tmp/tika.asc \
    && curl -sSL "$TIKA_SERVER_URL.asc" -o /tmp/tika-server-${TIKA_VERSION}.jar.asc \
    && curl -sSL "$TIKA_SERVER_URL" -o /tika-server-${TIKA_VERSION}.jar \
    && gpg --verify /tmp/tika-server-${TIKA_VERSION}.jar.asc /tika-server-${TIKA_VERSION}.jar \
    && apk del curl gnupg \
    && rm -rf /tmp/* /var/tmp/*

EXPOSE 9998
ENTRYPOINT java -jar /tika-server-${TIKA_VERSION}.jar -h 0.0.0.0