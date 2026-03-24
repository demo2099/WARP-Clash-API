#!/usr/bin/env bash
set -euo pipefail

TARGET_DIR="${1:-/root/mihomo-warp-proxy}"
PROXY_USER="${PROXY_USER:-warpuser12345678}"
PROXY_PASS="${PROXY_PASS:-Abcdefghijklmnop1234567890QRSTUV}"
PROXY_PORT="${PROXY_PORT:-7890}"
WARP_ENDPOINT="${WARP_ENDPOINT:-engage.cloudflareclient.com:2408}"

mkdir -p "${TARGET_DIR}"

cat > "${TARGET_DIR}/docker-compose.override.yml" <<EOF
services:
  mihomo-proxy:
    environment:
      PROXY_USER: "${PROXY_USER}"
      PROXY_PASS: "${PROXY_PASS}"
      PROXY_PORT: "${PROXY_PORT}"
      WARP_ENDPOINT: "${WARP_ENDPOINT}"
    ports:
      - "${PROXY_PORT}:${PROXY_PORT}"
EOF

echo "Written: ${TARGET_DIR}/docker-compose.override.yml"
cat "${TARGET_DIR}/docker-compose.override.yml"

docker compose -f "${TARGET_DIR}/docker-compose.yaml" -f "${TARGET_DIR}/docker-compose.override.yml" up -d --force-recreate
docker compose -f "${TARGET_DIR}/docker-compose.yaml" -f "${TARGET_DIR}/docker-compose.override.yml" logs --tail=80
