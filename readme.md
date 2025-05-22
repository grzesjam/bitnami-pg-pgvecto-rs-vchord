# Bitnami Postgres images w/ pgvecto.rs and vchord

I'm using the [Bitnami postgres helm](https://github.com/bitnami/charts/blob/main/bitnami/postgresql/README.md) chart as my backing store for immich(not using the immich helm chart).  

Immich use to require [pgvecto.rs](https://pgvecto.rs/) installed and now [vchord](https://github.com/tensorchord/VectorChord), which isn't part of the bitnami image.

## Usage

This is a drop in replacement for bitnami postgres debian container for the bitnami postgres helm chart. Just swap the image with mine and if you're using this for immich, you'll need to following configs.

In your `values.yaml`:

```yaml
image:
  registry: ghcr.io
  repository: grzesjam/bitnami-pg-pgvecto-rs-vchord
  tag: pg16.6-pgv0.3.0-vchord0.3.0
primary:
  initdb:
    scripts: 
      00-create-extensions.sql: |
        CREATE EXTENSION IF NOT EXISTS cube;
        CREATE EXTENSION IF NOT EXISTS earthdistance;
        CREATE EXTENSION IF NOT EXISTS vectors;
        CREATE EXTENSION IF NOT EXISTS vchord;

```
