# syntax=docker/dockerfile:1.7

ARG ALPINE_VERSION
FROM alpine:${ALPINE_VERSION}

LABEL org.opencontainers.image.title="hardened-nginx-stream"
LABEL org.opencontainers.image.description="Hardened Alpine-based nginx image with stream module"

RUN set -eux; \
    apk add --no-cache nginx nginx-mod-stream ca-certificates libcap; \
    id nginx; \
    mkdir -p /etc/nginx/stream.d /var/cache/nginx /var/lib/nginx /tmp/nginx /run/nginx; \
    chown -R nginx:nginx /var/cache/nginx /var/lib/nginx /tmp/nginx /run/nginx; \
    setcap 'cap_net_bind_service=+ep' /usr/sbin/nginx; \
    getcap /usr/sbin/nginx

COPY nginx.conf /etc/nginx/nginx.conf
COPY stream.d/ /etc/nginx/stream.d/

USER nginx:nginx

EXPOSE 80 443

STOPSIGNAL SIGQUIT

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD nginx -t -q || exit 1

CMD ["nginx", "-g", "daemon off;"]
