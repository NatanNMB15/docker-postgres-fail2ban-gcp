# Docker postgres-fail2ban for Google Cloud Platform

![Docker Image CI](https://github.com/NatanNMB15/docker-postgres-fail2ban-gcp/workflows/Docker%20Image%20CI/badge.svg)

Docker Build Image for postgres and fail2ban to invoke Google Cloud Function for Firewall rules.

To use this Build Image you will need the file "service-account.json" from Google Cloud Service Account with Cloud Functions Invoker permission.

For use with Cloud Build you need to upload "service-account.json" file to Google Storage Bucket.
With Google Cloud Platform SDK installed, upload "service-account.json" file to your Storage Bucket:

```
gsutil cp service-account.json gs://YOUR-PROJECT-ID.appspot.com/secrets/database/fail2ban/service-account.json
```

After Build, to run this Image you will need set following environment variables:

```
POSTGRES_USER       = user to acess postgres databases. (optional, default to = postgres)
POSTGRES_PASSWORD   = password for user.
POSTGRES_DATABASE   = default database schema to user. (optional, default to = postgres)
You can create more databases using interactive Shell to running container, with shell psql commands.

HOST_FUNCTION_DDOS_BLOCK    = full URL for Cloud Function to use.
SERVICE_ACCOUNT_ID          = client ID from provided "service-account.json" file.
```

You can set Timezone, Char Encoding and Locale Language variable in Dockerfile to your needs.

```
# Timezone
ENV TZ=America/Sao_Paulo
# Environment variables for Locale settings
ENV CHAR_ENCODING UTF-8
ENV LANG pt_BR.$CHAR_ENCODING
ENV LC_ALL pt_BR.$CHAR_ENCODING
```

You can use this [Cloud Function](https://github.com/NatanNMB15/nodejs-ddosblock-function-gcp) to work with Fail2Ban, specifiying URL for Cloud Function.

Credits to SuperITMan for Fail2Ban Jail and Filter configuration. Original source: https://github.com/SuperITMan/docker-fail2ban
