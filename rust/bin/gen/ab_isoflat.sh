#!/usr/bin/env bash
# Interleaved A/B: iso-flat vs incremental at n=14, from tmpfs, all 24 cores.
# Alternate the two binaries round-by-round to cancel thermal drift (this box
# throttles ~1s over a ~12s n=14 solve). Reports nodes + wall + M/s per round.
# Node counts are deterministic (iso ~14.8M, D4 ~53.2M); the wall + M/s are the signal.
set -u
Q=/tmp/q-ab
cp "$(dirname "$0")/../../target/release/queens" "$Q"
ROUNDS="${ROUNDS:-3}"
N="${N:-14}"
run() { # $1 = solver
  cd /tmp || exit 1
  local out t
  out=$("$Q" solve "$N" "$1" --distinct 2>&1)
  t=$(printf '%s\n' "$out" | grep -oiE 'searched [0-9,]+ nodes in [0-9.]+s')
  printf '  %-12s %s\n' "$1" "$t"
}
echo "=== iso-flat vs incremental, n=$N, tmpfs, $(nproc) cores, $ROUNDS interleaved rounds ==="
for r in $(seq 1 "$ROUNDS"); do
  echo "round $r:"
  run incremental
  run iso-flat
done
