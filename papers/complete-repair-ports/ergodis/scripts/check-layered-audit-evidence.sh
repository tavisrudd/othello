#!/usr/bin/env bash
set -euo pipefail

driver=${1:-/home/tavis/.cache/ergodis/nix-target/release/examples/observational_hierarchy_driver}
frozen=${2:-papers/complete-repair-ports/ergodis/evidence/c985-layered-frozen-v1.bin}
audit=${3:-papers/complete-repair-ports/ergodis/evidence/c985-layered-audit-v1.bin}
expected_frozen=af6d000ec8d205e5250f7d1bfec3543f9c4f1aecfcd80ab0c795061faad9ac50
expected_audit=742b7e0860d927ff0b4b4521e065b14eecb8bf7885cb7db5367fb3e26e63af50
actual_frozen=$(sha256sum "$frozen" | awk '{ print $1 }')
actual_audit=$(sha256sum "$audit" | awk '{ print $1 }')
if [[ $actual_frozen != "$expected_frozen" || $actual_audit != "$expected_audit" ]]; then
  echo "layered audit SHA-256 mismatch" >&2
  exit 1
fi

result=$(taskset -c "${ERGODIS_CPU:-2}" "$driver" \
  4 0 0 256 raw-first layered-artifacts-verify "$frozen" "$audit")
awk -F '\t' '
  $1 != "layered-audit" || $2 != 4 || $3 != 256 || $4 != 300312 || $5 != 3005633 || $7 != 0 || $9 != 117856 {
    exit 2
  }
  { printf "frozen_sha256=%s audit_sha256=%s frozen_payload_bytes=%s frozen_file_bytes=%s audit_bytes=%s load_ns=%s replay_ns=%s\n", frozen_sha, audit_sha, $4, $9, $5, $6, $8 }
' frozen_sha="$actual_frozen" audit_sha="$actual_audit" <<<"$result"
