#!/bin/sh

# Exit on error
set -e

# Substitute environment variables in the template
envsubst '$${NGINX_HOST}' < /etc/nginx/templates/default.conf.template > /etc/nginx/conf.d/default.conf

# Reload Nginx after the certificate appears (for HTTPS configs).
(
  until [ -f /etc/letsencrypt/live/${NGINX_HOST}/fullchain.pem ]; do
    echo "Waiting for certificate to be generated..."
    sleep 5
  done
  echo "Certificate found; reloading Nginx..."
  nginx -s reload
) &

# Start Nginx
exec nginx -g 'daemon off;'
