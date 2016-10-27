#!/bin/bash

set -e

host="$1"
user="$2"
pass="$3"
auth_magic="$4"

export PGPASSWORD=$pass
export DBSERVER=$host
export AUTH_MAGIC=$auth_magic

until psql -h "$host" -U "$user" -d "template1" -c '\l'; do
  >&2 echo "Postgres is unavailable - sleeping"
  sleep 1
done

>&2 echo "Postgres is up - executing command"
/var/www/exec_env.sh
php /var/www/eccube_install.php pgsql none --skip-createdb --verbose
chown -R www-data:www-data /var/www
apache2-foreground
