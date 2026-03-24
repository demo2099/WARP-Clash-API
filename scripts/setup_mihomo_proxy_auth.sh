#!/usr/bin/env bash
set -euo pipefail

TARGET_DIR="${1:-/root/mihomo-warp-proxy}"
PROXY_PORT="${PROXY_PORT:-7890}"
WARP_ENDPOINT="${WARP_ENDPOINT:-engage.cloudflareclient.com:2408}"

mkdir -p "${TARGET_DIR}"

gen_alnum() {
  local len="$1"
  python3 - "$len" <<'PY'
import secrets
import string
import sys

length = int(sys.argv[1])
alphabet = string.ascii_letters + string.digits
print(''.join(secrets.choice(alphabet) for _ in range(length)))
PY
}

PROXY_USER="${PROXY_USER:-$(gen_alnum 16)}"
PROXY_PASS="${PROXY_PASS:-$(gen_alnum 48)}"

cat > "${TARGET_DIR}/docker-compose.override.yml" <<EOF
services:
  mihomo-proxy:
    environment:
      PROXY_USER: "${PROXY_USER}"
      PROXY_PASS: "${PROXY_PASS}"
      PROXY_PORT: "${PROXY_PORT}"
      WARP_ENDPOINT: "${WARP_ENDPOINT}"
EOF

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

PROXY_USER="${PROXY_USER}" \
PROXY_PASS="${PROXY_PASS}" \
PROXY_PORT="${PROXY_PORT}" \
WARP_ENDPOINT="${WARP_ENDPOINT}" \
docker compose "${compose_args[@]}" up -d --force-recreate

cat > "${TARGET_DIR}/proxy_creds.txt" <<EOF
PROXY_USER=${PROXY_USER}
PROXY_PASS=${PROXY_PASS}
PROXY_PORT=${PROXY_PORT}
HTTP_URL=http://${PROXY_USER}:${PROXY_PASS}@$(curl -s ipv4.ip.sb):${PROXY_PORT}
SOCKS5_URL=socks5://${PROXY_USER}:${PROXY_PASS}@$(curl -s ipv4.ip.sb):${PROXY_PORT}
EOF

echo "Written: ${TARGET_DIR}/proxy_creds.txt"
cat "${TARGET_DIR}/proxy_creds.txt"
docker compose "${compose_args[@]}" logs --tail=80
