#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"

usage() {
  cat <<'EOF'
Usage: npm run serve -- <recipe-path>

Examples:
  npm run serve -- chapter03/start_here/ng-singleton-service
  npm run serve -- chapter01/final/cc-template-vars

Each recipe is its own Angular workspace (the folder that contains angular.json).
EOF
}

if [[ $# -lt 1 ]]; then
  usage
  exit 1
fi

project_path="$1"
project_dir="$REPO_ROOT/$project_path"

if [[ ! -f "$project_dir/angular.json" ]]; then
  echo "Error: no angular.json found at $project_dir"
  echo
  usage
  exit 1
fi

node_major="$(node -v | sed 's/^v//' | cut -d. -f1)"

cp "$REPO_ROOT/scripts/project.npmrc" "$project_dir/.npmrc"

cd "$project_dir"

echo "Installing dependencies in $project_path ..."
npm install

# OpenSSL legacy provider is only needed on Node 17+. Node 16 rejects it in NODE_OPTIONS.
if [[ "$node_major" -ge 17 ]]; then
  echo "Node $(node -v) detected — enabling OpenSSL legacy provider for ng serve."
  export NODE_OPTIONS="${NODE_OPTIONS:---openssl-legacy-provider}"
fi

echo "Starting dev server for $project_path ..."
npm start
