#FROM nginx:alpine
#COPY index.html /usr/share/nginx/html/index.html

FROM nginx:alpine

COPY index.html /usr/share/nginx/html/index.template.html
COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
