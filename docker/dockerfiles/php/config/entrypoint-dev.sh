#!/bin/sh
set -e

exec /usr/bin/supervisord -c /etc/supervisor/supervisord.conf &

exec "$@"