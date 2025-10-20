
FROM nginx:alpine

COPY index.template.html /usr/share/nginx/html/index.template.html
COPY entrypoint.sh /entrypoint.sh

RUN apk add --no-cache gettext \
    && chmod +x /entrypoint.sh

ENTRYPOINT ["/bin/sh", "/entrypoint.sh"]

