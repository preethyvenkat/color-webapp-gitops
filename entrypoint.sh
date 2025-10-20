
#!/bin/sh

# Default color if none provided
COLOR=${COLOR:-"#4169E1"}

# Inject the environment variable COLOR into the HTML template
envsubst '$COLOR' < /usr/share/nginx/html/index.template.html > /usr/share/nginx/html/index.html

# Start NGINX in foreground
nginx -g 'daemon off;'
