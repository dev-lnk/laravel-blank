#!/bin/sh
set -e

composer install --no-scripts

# Clear configurations to avoid caching issues in development
php artisan migrate --force
php artisan optimize:clear

exec /usr/bin/supervisord -c /etc/supervisor/supervisord.conf &

# Run the default command (e.g., php-fpm or bash)
exec "$@"