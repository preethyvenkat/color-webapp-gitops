#!/bin/sh
COLOR=${COLOR:-"#FF69B4"}  # Default if not set
envsubst < /usr/share/nginx/html/index.template.html > /usr/share/nginx/html/index.html
nginx -g 'daemon off;'
