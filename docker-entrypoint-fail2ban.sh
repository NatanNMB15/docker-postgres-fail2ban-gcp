#!/bin/bash
# Stop and Start Fail2Ban service, remove old Fail2Ban files if have any,
# restart and reload Fail2Ban client, 
# and start new shell for postgres with logging enabled.
service fail2ban stop
rm -rf /var/run/fail2ban/
service fail2ban start
fail2ban-client restart
fail2ban-client reload
exec docker-entrypoint.sh "$@"