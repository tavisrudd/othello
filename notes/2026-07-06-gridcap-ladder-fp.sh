#!/usr/bin/env bash
# Fingerprint-keyed frontier ladder (memory-lean). Complements the exact-key ladder:
# exact-key handles q<=19 (+23,25 outcome); this pushes the min-dev-size diagnostic to q=23
# and the outcome ladder to q=27,29,31 (the falsification frontier). u128-fingerprint memo,
# validated to match exact class counts at q<=17.
set -u
BIN=/tmp/gridcap_fp
LOG=/home/tavis/src/othello/notes/2026-07-06-gridcap-ladder-fp.log
ulimit -Sv 22000000   # ~21 GB cap

run() {
  local mode="$1" q="$2"
  local t0 t1 out rc
  t0=$(date +%s)
  out=$("$BIN" "$mode" "$q" 2>&1); rc=$?
  t1=$(date +%s)
  [ $rc -ne 0 ] && out="q=$q mode=$mode DIED rc=$rc (mem cap / OOM)"
  printf '[%5ds] %s\n' "$((t1 - t0))" "$out" | tee -a "$LOG"
}

echo "=== gridcap-fp frontier ladder $(date) ===" | tee -a "$LOG"
run defect  23   # min-dev-size at q=23 (new diagnostic)
run outcome 27   # NEW (3^3, char 3) — falsification frontier
run outcome 29   # NEW (prime)
run outcome 31   # NEW (prime, N=961, MAXW ceiling)
echo "FP_LADDER_DONE" | tee -a "$LOG"
