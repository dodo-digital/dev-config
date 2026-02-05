#!/bin/bash
# One-liner install: curl -fsSL https://raw.githubusercontent.com/dodo-digital/dev-config/main/setup.sh | bash
set -e

REPO_URL="https://github.com/dodo-digital/dev-config.git"
TEMP_DIR=$(mktemp -d)

cleanup() {
    rm -rf "$TEMP_DIR"
}
trap cleanup EXIT

echo "🚀 Fetching dev-config..."
git clone --depth 1 -q "$REPO_URL" "$TEMP_DIR"

echo ""
cd "$TEMP_DIR"
bash install.sh "$@"
