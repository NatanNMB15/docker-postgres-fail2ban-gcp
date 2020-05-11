FROM postgres:12.2

# Set Debian shell as non-interactive
ARG DEBIAN_FRONTEND=noninteractive

# Timezone
ENV TZ=America/Sao_Paulo
# Environment variables for Locale settings
ENV CHAR_ENCODING UTF-8
ENV LANG pt_BR.$CHAR_ENCODING
ENV LC_ALL pt_BR.$CHAR_ENCODING


# Copy file with required libraries for Python
COPY requirements.txt /opt/requirements.txt

# Install the Linux dependencies, configure timezone, locale, install Python libraries
# and clean unnecessary files and packages
RUN apt-get update && apt-get install -yq --no-install-recommends fail2ban curl locales ca-certificates python3-pip python3-setuptools \
   && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone \
   && dpkg-reconfigure --frontend=noninteractive tzdata \
   && sed -i -e 's/# '"${LANG}"' '"${CHAR_ENCODING}"'/'"${LANG}"' '"${CHAR_ENCODING}"'/' /etc/locale.gen \
   && dpkg-reconfigure --frontend=noninteractive locales \
   && python3 -m pip install --upgrade pip && python3 -m pip install -r /opt/requirements.txt \
   # Change default environment variables of Fail2Ban service file to include Docker variables
   && sed -i 's|PATH=/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/bin|PATH=/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/bin:/proc/1/environ|' /etc/init.d/fail2ban \
   && rm -rf /opt/requirements.txt \
   && rm -rf /etc/fail2ban/jail.d/defaults-debian.conf \
   && apt-get purge -y python3-pip python3-setuptools && apt-get autoremove -y && apt-get clean -y \
   && rm -rf /var/lib/apt/lists/*

# Copy files
COPY jail.local /etc/fail2ban/
COPY filter.d/ /etc/fail2ban/filter.d/
COPY action.d/ /etc/fail2ban/action.d/
COPY jail.d/ /etc/fail2ban/jail.d/
COPY ddosblock.py /opt/ddosblock.py
COPY service-account.json /opt/
COPY docker-entrypoint-fail2ban.sh /usr/local/bin/

# Environment variable for Google service account credentials
ENV GOOGLE_APPLICATION_CREDENTIALS /opt/service-account.json

# Make init.sh executable, 
# create postgres log file and set owner to postgres user,
# and make service account file with read permissions for everyone.
RUN touch /var/log/postgresql/postgresql.log && chown -R postgres.postgres /var/log/postgresql/ \
      && chmod 755 /opt/service-account.json

# Default command to docker-entrypoint-fail2ban.sh Shell Script
RUN chmod +x /usr/local/bin/docker-entrypoint-fail2ban.sh && \
      ln -s usr/local/bin/docker-entrypoint-fail2ban.sh /
ENTRYPOINT [ "docker-entrypoint-fail2ban.sh" ]

# Default Command with postgres Logging enabled
CMD [ "postgres", "-c", "logging_collector=on", "-c", "log_directory=/var/log/postgresql", "-c", "log_filename=postgresql.log", "-c", "log_statement=all", "-c", "log_line_prefix='%m [%p] IP=%h '" ]