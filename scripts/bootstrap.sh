#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
NPMRC_TEMPLATE="$REPO_ROOT/scripts/project.npmrc"
count=0

while IFS= read -r angular_json; do
  project_dir="$(dirname "$angular_json")"
  cp "$NPMRC_TEMPLATE" "$project_dir/.npmrc"
  count=$((count + 1))
done < <(find "$REPO_ROOT" -name angular.json -not -path '*/node_modules/*' | sort)

echo "Applied project .npmrc to $count Angular workspaces."
