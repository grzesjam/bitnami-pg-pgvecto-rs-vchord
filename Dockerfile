FROM alpine:latest AS deb

RUN apk add --no-cache curl ca-certificates
RUN curl https://github.com/tensorchord/VectorChord/releases/download/0.3.0/postgresql-17-vchord_0.3.0-1_amd64.deb -Lo /tmp/vchord.deb


FROM docker.io/bitnami/postgresql:17.5.0

COPY --from=deb /tmp/vchord.deb /tmp/vchord.deb
COPY --from=tensorchord/pgvecto-rs-binary:pg17-v0.4.0-amd64 /pgvecto-rs-binary-release.deb /tmp/vectors.deb
USER root
RUN apt-get install -y /tmp/vchord.deb && rm -f /tmp/vchord.deb && \
    apt-get install -y /tmp/vectors.deb && rm -f /tmp/vectors.deb && \
     mv /usr/lib/postgresql/*/lib/*.so /opt/bitnami/postgresql/lib/ && \
     mv /usr/share/postgresql/*/extension/* /opt/bitnami/postgresql/share/extension/

USER 1001
ENV POSTGRESQL_EXTRA_FLAGS="-c shared_preload_libraries=vchord.so,vectors.so"
