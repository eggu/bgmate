#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ENV_FILE="$ROOT_DIR/.env.local"

cd "$ROOT_DIR"

if [[ -f "$ENV_FILE" ]]; then
  exec flutter "$@" --dart-define-from-file="$ENV_FILE"
fi

exec flutter "$@"
