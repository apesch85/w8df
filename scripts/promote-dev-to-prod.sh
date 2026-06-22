#!/usr/bin/env bash
set -euo pipefail

# Promote the tested dev branch to production:
# 1. fast-forward/merge dev into main
# 2. push main
# 3. deploy main to w8df.peschpit.com

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

git fetch origin
if [[ -n "$(git status --porcelain)" ]]; then
  echo "Working tree is dirty; commit or stash changes first." >&2
  exit 1
fi

git checkout dev
git pull --ff-only origin dev

git checkout main
git pull --ff-only origin main

# Prefer a fast-forward when possible. If main has diverged, create a normal merge commit.
if git merge-base --is-ancestor main dev; then
  git merge --ff-only dev
else
  git merge --no-ff dev -m "Promote dev to production"
fi

git push origin main
./scripts/deploy-static.sh prod

git checkout dev
