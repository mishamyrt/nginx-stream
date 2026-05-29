# Nginx Stream

Hardened Alpine-based Nginx image with the stream module enabled for TCP and UDP proxying.

The image runs Nginx as the unprivileged `nginx` user, allows binding privileged ports through `cap_net_bind_service`, logs to stdout/stderr, and loads stream proxy configuration from `/etc/nginx/stream.d/*.conf`.

## Usage

Build the image:

```sh
docker build --build-arg ALPINE_VERSION=latest -t nginx-stream .
```

Run it locally:

```sh
docker run --rm -p 8080:8080 nginx-stream
```

## Configuration

Add stream server definitions to `stream.d/*.conf`. Example:

```nginx
upstream backend_tcp {
    server 10.0.0.10:5432;
}

server {
    listen 8080;
    proxy_pass backend_tcp;
}
```

The default image exposes ports `80` and `443`.

## Publishing

The GitHub Actions workflow builds multi-architecture images for `linux/amd64` and `linux/arm64` and publishes them to GitHub Container Registry.
