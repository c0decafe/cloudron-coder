#!/bin/bash

set -eu

OWN="cloudron:cloudron"
GSU="/usr/local/bin/gosu $OWN"
ENV="/app/data/env"

if [[ ! -f $ENV  ]]; then
     $GSU cat > $ENV <<EOF
EOF
fi

source $ENV

export CODER_HTTP_ADDRESS=0.0.0.0:8000
export CODER_TLS_ENABLE=false
export CODER_ACCESS_URL=${CLOUDRON_APP_ORIGIN}
export CODER_WILDCARD_ACCESS_URL=*.${CLOUDRON_APP_DOMAIN}
export CODER_PG_CONNECTION_URL=${CLOUDRON_POSTGRESQL_URL}?sslmode=disable
export CODER_CACHE_DIRECTORY=/run/cache

export CODER_DISABLE_PASSWORD_AUTH=false
export CODER_OIDC_ALLOW_SIGNUPS=true
export CODER_OIDC_CLIENT_ID=$CLOUDRON_OIDC_CLIENT_ID
export CODER_OIDC_CLIENT_SECRET=$CLOUDRON_OIDC_CLIENT_SECRET
export CODER_OIDC_ISSUER_URL=$CLOUDRON_OIDC_ISSUER

export DOCKER_HOST=${CLOUDRON_DOCKER_HOST}

if [[ ! -f /app/data/.initialized  ]]; then
      echo "Fresh installation, init"
      $GSU coder server create-admin-user \
           --username admin\
           --email admin@cloudron.local\
           --password changeme123
      touch /app/data/.initialized
fi

mkdir -p $CODER_CACHE_DIRECTORY
echo "==> Ensure permissions"
chown -R $OWN $CODER_CACHE_DIRECTORY /app/data

echo "==> Starting coder"
exec $GSU coder server
