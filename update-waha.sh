#!/bin/bash
# ─────────────────────────────────────────────────────────────
#  update-waha.sh — auto-update script for devlikeapro/waha-plus
#  https://github.com/Komorebihost/wahaplus-docker-autoupdate
# ─────────────────────────────────────────────────────────────
#
#  BEFORE RUNNING:
#  1. Set COMPOSE_DIR to the folder containing your docker-compose.yml
#     (leave /root if that's where it lives — works in 99% of cases)
#  2. Set DOCKER_PASS to your devlikeapro Docker Hub password
#
# ─────────────────────────────────────────────────────────────

IMAGE="devlikeapro/waha-plus:latest"
COMPOSE_DIR="/PATH"          # <-- change if needed (default: /root)
DOCKER_USER="devlikeapro"
DOCKER_PASS="YOUR_PASSWORD"  # <-- required

docker login -u "$DOCKER_USER" -p "$DOCKER_PASS" --quiet 2>/dev/null \
  || { echo "Login failed — check credentials"; exit 1; }

PULL=$(docker pull "$IMAGE" 2>&1)

if ! echo "$PULL" | grep -q "up to date"; then
  cd "$COMPOSE_DIR" && docker-compose down && docker rmi "$IMAGE" 2>/dev/null
  docker pull "$IMAGE" && docker-compose up -d
fi

docker logout 2>/dev/null
