#!/usr/bin/env bash
# Production-proxy node counts: one n=16 run per K at a 16 GB TT (2e9 slots), single runs with a
# `sync` + settle between so huge-page reclaim finishes (no back-to-back-large OOM). Node count is
# the only TT-dependent quantity for the default decision (cyc/node is TT-independent, from the
# 12 GB sweep). Aborts loudly if a run is Killed (OOM). Bare runs for the live bar.
#   knodes16g.sh <bin> <K1> <K2> ...
set -u
BIN=${1:?bin}; shift; KS=("$@")
echo "######## knodes16g bin=$BIN Ks=${KS[*]} (TT 2e9 = 16 GB) ########"
for k in "${KS[@]}"; do
  sync; sleep 6
  echo "=== BEGIN K=$k ==="
  QUEENS_TT_SLOTS=2000000000 QUEENS_DENSE_K="$k" "$BIN" solve 16 iso-dense --to-file "/tmp/kn16_$k.json"
  rc=$?
  if [ $rc -ne 0 ]; then echo "!!! K=$k EXIT $rc (possible OOM/Killed) — ABORT"; break; fi
  n=$(grep -oE '"nodes": [0-9]+' "/tmp/kn16_$k.json" | grep -oE '[0-9]+')
  w=$(grep -oE '"wall_secs": [0-9.]+' "/tmp/kn16_$k.json" | grep -oE '[0-9.]+')
  echo "RESULT16G K=$k nodes=$n wall=$w"
  echo "=== END K=$k ==="
done
echo "KNODES16G_DONE"
