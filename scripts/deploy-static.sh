#!/usr/bin/env bash
set -euo pipefail

ENVIRONMENT="${1:-dev}"
REMOTE_HOST="${REMOTE_HOST:-apesch@192.168.1.131}"

case "$ENVIRONMENT" in
  dev)
    DOMAIN="w8df-dev.peschpit.com"
    WEB_ROOT="/var/www/w8df-dev.peschpit.com"
    ;;
  prod|production)
    DOMAIN="w8df.peschpit.com"
    WEB_ROOT="/var/www/w8df.peschpit.com"
    ;;
  *)
    echo "Usage: $0 [dev|prod]" >&2
    exit 2
    ;;
esac

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMP_TARBALL="/tmp/w8df-${ENVIRONMENT}-deploy.tgz"
REMOTE_TARBALL="/tmp/w8df-${ENVIRONMENT}-deploy.tgz"
REMOTE_STAGE="/tmp/w8df-${ENVIRONMENT}-deploy"

echo "Deploying ${REPO_ROOT} to ${DOMAIN}:${WEB_ROOT}"
cd "$REPO_ROOT"
tar --exclude='.git' --exclude='.DS_Store' -czf "$TMP_TARBALL" .
scp -q "$TMP_TARBALL" "$REMOTE_HOST:$REMOTE_TARBALL"
ssh -o BatchMode=yes "$REMOTE_HOST" "set -euo pipefail
  stamp=\$(date +%Y%m%d-%H%M%S)
  sudo mkdir -p '$WEB_ROOT'
  sudo cp -a '$WEB_ROOT' '${WEB_ROOT}.backup.'\$stamp
  rm -rf '$REMOTE_STAGE'
  mkdir -p '$REMOTE_STAGE'
  tar -xzf '$REMOTE_TARBALL' -C '$REMOTE_STAGE'
  sudo find '$WEB_ROOT' -mindepth 1 -maxdepth 1 -exec rm -rf {} +
  sudo cp -a '$REMOTE_STAGE'/. '$WEB_ROOT'/
  sudo chown -R www-data:www-data '$WEB_ROOT'
  sudo chmod -R a+rX '$WEB_ROOT'
  sudo nginx -t
  sudo systemctl reload nginx
  echo backup='${WEB_ROOT}.backup.'\$stamp
"
curl -fsSI "https://${DOMAIN}/" | sed -n '1,12p'
echo "Deployed https://${DOMAIN}/"
