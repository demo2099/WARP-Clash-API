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
EOF

echo "Written: ${TARGET_DIR}/docker-compose.override.yml"
cat "${TARGET_DIR}/docker-compose.override.yml"

# Avoid duplicate port mappings from base compose + override.
# Base file maps to localhost by default; expose publicly for remote clients.
if [[ -f "${TARGET_DIR}/docker-compose.yaml" ]]; then
  sed -i "s#127.0.0.1:\\\${PROXY_PORT:-7890}:\\\${PROXY_PORT:-7890}#\\\${PROXY_PORT:-7890}:\\\${PROXY_PORT:-7890}#g" \
    "${TARGET_DIR}/docker-compose.yaml"
fi

compose_args=(
  --project-directory "${TARGET_DIR}"
  -f "${TARGET_DIR}/docker-compose.yaml"
  -f "${TARGET_DIR}/docker-compose.override.yml"
)

if [[ -f "${TARGET_DIR}/.env" ]]; then
  compose_args=(--env-file "${TARGET_DIR}/.env" "${compose_args[@]}")
fi

# Export runtime vars explicitly so base file interpolation cannot override
# the values from override with empty shell variables.
PROXY_USER="${PROXY_USER}" \
PROXY_PASS="${PROXY_PASS}" \
PROXY_PORT="${PROXY_PORT}" \
WARP_ENDPOINT="${WARP_ENDPOINT}" \
docker compose "${compose_args[@]}" up -d --force-recreate

PROXY_USER="${PROXY_USER}" \
PROXY_PASS="${PROXY_PASS}" \
PROXY_PORT="${PROXY_PORT}" \
WARP_ENDPOINT="${WARP_ENDPOINT}" \
docker compose "${compose_args[@]}" logs --tail=80
