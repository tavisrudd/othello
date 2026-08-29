#!/usr/bin/env bash
set -euo pipefail

driver=${1:-/home/tavis/.cache/ergodis/nix-target/release/examples/observational_hierarchy_driver}
frozen=${2:-papers/complete-repair-ports/ergodis/evidence/c985-layered-frozen-v2.bin}
audit=${3:-papers/complete-repair-ports/ergodis/evidence/c985-layered-chain-audit-v2.bin}
expected_frozen=99a93ca87566291ca33e0e7b4bd66e18d32cf95bb7a1a23bb1eda27caf377bd0
expected_audit=5295518ae0565b86aff9a54a7cd938032b804accb977fb1105abd61f1d656b7d
actual_frozen=$(sha256sum "$frozen" | awk '{ print $1 }')
actual_audit=$(sha256sum "$audit" | awk '{ print $1 }')
if [[ $actual_frozen != "$expected_frozen" || $actual_audit != "$expected_audit" ]]; then
  echo "layered audit SHA-256 mismatch" >&2
  exit 1
fi

result=$(taskset -c "${ERGODIS_CPU:-2}" "$driver" \
  4 0 0 256 raw-first layered-chain-artifacts-verify "$frozen" "$audit")
awk -F '\t' '
  $1 != "layered-chain-audit" || $2 != 4 || $3 != 256 || $4 != 300312 || $5 != 2496020 || $8 != 117856 {
    exit 2
  }
  { printf "frozen_sha256=%s audit_sha256=%s frozen_payload_bytes=%s frozen_file_bytes=%s audit_bytes=%s load_ns=%s replay_ns=%s\n", frozen_sha, audit_sha, $4, $8, $5, $6, $7 }
' frozen_sha="$actual_frozen" audit_sha="$actual_audit" <<<"$result"
