#!/bin/sh
set -e

composer install --no-scripts

php artisan migrate --force
php artisan optimize:clear

exec /usr/bin/supervisord -c /etc/supervisor/supervisord.conf &

exec "$@"