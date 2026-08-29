#!/usr/bin/env bash
set -euo pipefail

driver=${1:-/home/tavis/.cache/ergodis/nix-target/release/examples/observational_hierarchy_driver}
audit=${2:-papers/complete-repair-ports/ergodis/evidence/c985-layered-audit-v1.bin}
expected=742b7e0860d927ff0b4b4521e065b14eecb8bf7885cb7db5367fb3e26e63af50
actual=$(sha256sum "$audit" | awk '{ print $1 }')
if [[ $actual != "$expected" ]]; then
  echo "layered audit SHA-256 mismatch" >&2
  exit 1
fi

result=$(taskset -c "${ERGODIS_CPU:-2}" "$driver" \
  4 0 0 256 raw-first layered-audit-verify "$audit")
awk -F '\t' '
  $1 != "layered-audit" || $2 != 4 || $3 != 256 || $4 != 300312 || $5 != 3005633 || $7 != 0 {
    exit 2
  }
  { printf "sha256=%s frozen_bytes=%s audit_bytes=%s compile_ns=%s replay_ns=%s\n", sha, $4, $5, $6, $8 }
' sha="$actual" <<<"$result"
