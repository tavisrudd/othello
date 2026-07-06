#!/usr/bin/env bash
# fp OUTCOME-only frontier: extend the PG(2,q) outcome ladder past q=19.
# Lean u128-fingerprint memo (validated == exact class counts for q<=17), early-break.
# Falsification watch: any 'N' printed = a counterexample to G(PG(m,q))=0.
set -u
BIN=/tmp/gridcap_fp
LOG=/home/tavis/src/othello/notes/2026-07-06-gridcap-frontier.log
ulimit -Sv 21000000   # ~20 GB cap; a too-big q dies cleanly and we move on

run() {
  local q="$1" t0 t1 out rc
  t0=$(date +%s)
  out=$("$BIN" outcome "$q" 2>&1); rc=$?
  t1=$(date +%s)
  [ $rc -ne 0 ] && out="q=$q outcome DIED rc=$rc (mem cap / OOM)"
  printf '[%5ds] %s\n' "$((t1 - t0))" "$out" | tee -a "$LOG"
}

echo "=== gridcap fp frontier (outcome) $(date) ===" | tee -a "$LOG"
for q in 25 27 31 23 29; do run "$q"; done   # ≡1 mod3 (smaller) first, big ≡2 mod3 last
echo "FRONTIER_DONE" | tee -a "$LOG"
