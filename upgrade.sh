#!/bin/bash
# Pull latest version
sudo docker compose pull

# Stop and remove older version
sudo docker compose down

# Start the container
sudo docker compose up -d

sudo docker image prune -f -a

for db in $(psql -h your-db-host -U your-user -t -c "SELECT datname FROM pg_database WHERE datistemplate = false;"); do
  echo "🔄 Actualizando $db..."
  python3 -m odoo -d $db -u all --stop-after-init --no-http
done