FROM alpine:latest AS deb

RUN apk add --no-cache curl ca-certificates
RUN curl https://github.com/tensorchord/pgvecto.rs/releases/download/v0.3.0/vectors-pg17_0.3.0_amd64_vectors.deb -Lo /tmp/vectors.deb


FROM docker.io/bitnami/postgresql:17.5.0

COPY --from=deb /tmp/vectors.deb /tmp/vectors.deb
USER root
RUN apt-get install -y /tmp/vectors.deb && rm -f /tmp/vectors.deb && \
     mv /usr/lib/postgresql/*/lib/*.so /opt/bitnami/postgresql/lib/ && \
     mv /usr/share/postgresql/*/extension/* /opt/bitnami/postgresql/share/extension/

USER 1001
ENV POSTGRESQL_EXTRA_FLAGS="-c shared_preload_libraries=vectors.so"