#!/bin/bash
# Start Fail2Ban service and postgres with logging enabled.
service fail2ban start && docker-entrypoint.sh -c logging_collector=on -c log_directory=/var/log/postgresql -c log_filename=postgresql.log -c log_statement=all