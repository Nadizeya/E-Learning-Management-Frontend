#!/bin/sh

# Cloud Run sets the PORT environment variable
# We need to update nginx config to use this port
PORT=${PORT:-8080}

# Replace the port in nginx config
sed -i "s/listen 8080;/listen ${PORT};/g" /etc/nginx/conf.d/default.conf

# Start nginx
exec nginx -g 'daemon off;'

