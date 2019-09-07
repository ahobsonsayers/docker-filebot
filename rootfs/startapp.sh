#!/usr/bin/with-contenv sh

# Redirect stderr to stdout.
fdmove -c 2 1

# Wait until guacamole is running
s6-svwait -t 10000 -U /var/run/s6/services/guacamole/

# Wait for 2 seconds after guacamole has started so filebot output appears at the end 
sleep 2 

# Run FileBot
/opt/filebot/filebot -script fn:sysinfo
exec s6-setuidgid abc /opt/filebot/filebot-gui
