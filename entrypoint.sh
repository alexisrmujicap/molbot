#!/bin/sh

# Exit on error
set -e

# Wait for certbot to generate the certificate
until [ -f /etc/letsencrypt/live/${NGINX_HOST}/fullchain.pem ]; do
  echo "Waiting for certificate to be generated..."
  sleep 5
done

# Substitute environment variables in the template
envsubst '$${NGINX_HOST}' < /etc/nginx/templates/default.conf.template > /etc/nginx/conf.d/default.conf

# Start Nginx
exec nginx -g 'daemon off;'
