#!/usr/bin/with-contenv sh

set -e # Exit immediately if a command exits with a non-zero status.
set -u # Treat unset variables as an error.

[ -f /config/prefs.properties ] || cp /defaults/prefs.properties /config/

# Take ownership of the config directory content.
chown -R $PUID:$PGID /config/*

# vim: set ft=sh :
