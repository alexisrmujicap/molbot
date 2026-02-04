#!/bin/sh

# Exit on error
set -e

HTTP_TEMPLATE=/etc/nginx/templates/default.http.conf.template
HTTPS_TEMPLATE=/etc/nginx/templates/default.conf.template

# Substitute environment variables in the appropriate template
if [ -f /etc/letsencrypt/live/${NGINX_HOST}/fullchain.pem ]; then
  envsubst '$${NGINX_HOST}' < "$HTTPS_TEMPLATE" > /etc/nginx/conf.d/default.conf
else
  envsubst '$${NGINX_HOST}' < "$HTTP_TEMPLATE" > /etc/nginx/conf.d/default.conf
fi

# Reload Nginx after the certificate appears (for HTTPS configs).
(
  until [ -f /etc/letsencrypt/live/${NGINX_HOST}/fullchain.pem ]; do
    echo "Waiting for certificate to be generated..."
    sleep 5
  done
  echo "Certificate found; reloading Nginx..."
  envsubst '$${NGINX_HOST}' < "$HTTPS_TEMPLATE" > /etc/nginx/conf.d/default.conf
  nginx -s reload
) &

# Start Nginx
exec nginx -g 'daemon off;'
