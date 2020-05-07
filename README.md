# Docker postgres-fail2ban for Google Cloud Platform

Docker Build Image for postgres and fail2ban to invoke Google Cloud Function for Firewall rules.

To use this Build Image you will need the file "service-account.json" from Google Cloud Service Account with Cloud Functions Invoker permission.

After Build, to run this Image you will need set following environment variables:

```
POSTGRES_USER       = user to acess postgres databases. (optional, default to = postgres)
POSTGRES_PASSWORD   = password for user.
POSTGRES_DATABASE   = default database schema to user. (optional, default to = postgres)
You can create more databases using interactive Shell to running container, with shell psql commands.

HOST_FUNCTION_DDOS_BLOCK    = full URL for Cloud Function to use.
SERVICE_ACCOUNT_ID          = client ID from provided "service-account.json" file.
```
