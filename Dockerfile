#FROM nginx:alpine
#COPY index.html /usr/share/nginx/html/index.html

FROM nginx:alpine

COPY index.template.html /usr/share/nginx/html/index.template.html
COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

# Set entrypoint using shell so it runs properly
ENTRYPOINT ["/bin/sh", "/entrypoint.sh"]
