#!/usr/bin/with-contenv sh

set -e # Exit immediately if a command exits with a non-zero status.
set -u # Treat unset variables as an error.

[ -f /config/prefs.properties ] || cp /defaults/prefs.properties /config/

# Take ownership of the config directory content.
chown -R abc:abc /config/*

# Allow execution of startup scripts
chown +x /opt/filebot/filebot /opt/filebot/filebot-gui

# vim: set ft=sh :
