#!/usr/bin/env bash
set -u

cd "$(dirname "$0")/.."

DATE="$(date +%F)"
NOTES="../notes/${DATE}-codex-border-overlap-graph.md"

perl -0pi -e 's/anti-diagonal `q-1\\\), and main diagonal `0`/anti-diagonal `q-1`, and main diagonal `0`/g; s/`M\(x,y\)=tau\(A\(x,y\)\)\\\), equivalently/`M(x,y)=tau(A(x,y))`, equivalently/g' "$NOTES"
