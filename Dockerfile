FROM postgres:12.2

# Set Debian shell as non-interactive
ARG DEBIAN_FRONTEND=noninteractive

# Timezone
ENV TZ=America/Sao_Paulo

# Copy file with required libraries for Python
COPY requirements.txt /opt/requirements.txt

# Install the Linux dependencies, configure timezone, locale, install Python libraries
# and clean unnecessary files and packages
RUN apt-get update && apt-get install -yq --no-install-recommends fail2ban curl locales ca-certificates python3-pip python3-setuptools \
   && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone \
   && dpkg-reconfigure --frontend=noninteractive tzdata \
   && sed -i -e 's/# pt_BR.UTF-8 UTF-8/pt_BR.UTF-8 UTF-8/' /etc/locale.gen \
   && dpkg-reconfigure --frontend=noninteractive locales \
   && python3 -m pip install --upgrade pip && python3 -m pip install -r /opt/requirements.txt \
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
COPY init.sh .

# Environment variables for Locale settings
ENV LANG pt_BR.UTF-8
ENV LC_ALL pt_BR.UTF-8

# Environment variable for Google service account credentials
ENV GOOGLE_APPLICATION_CREDENTIALS /opt/service-account.json

# Make init.sh executable, 
# create postgres log file and set owner to postgres user,
# and make service account file with read permissions for everyone.
RUN chmod u+x init.sh \
      && touch /var/log/postgresql/postgresql.log && chown -R postgres.postgres /var/log/postgresql/ \
      && chmod 755 /opt/service-account.json

# Default command to init.sh Shell Script
CMD ["./init.sh"]