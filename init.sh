#!/bin/bash
service fail2ban start && docker-entrypoint.sh -c logging_collector=on -c log_directory=/var/log/postgresql -c log_filename=postgresql.log -c log_statement=all