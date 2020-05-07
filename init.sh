#!/bin/bash
# Start Fail2Ban service, restart and reload Fail2Ban client, and start postgres with logging enabled.
service fail2ban start && fail2ban-client restart && fail2ban-client reload \
    && docker-entrypoint.sh -c logging_collector=on -c log_directory=/var/log/postgresql -c log_filename=postgresql.log -c log_statement=all -c log_line_prefix='%m [%p] IP=%h '