#!/usr/bin/env bash
# Sequential ladder run for the Rust grid cap solver. Logs each line with wall time.
# Memory-capped (ulimit -Sv) so a too-big q dies cleanly instead of OOMing the box.
set -u
BIN=/tmp/gridcap
LOG=/home/tavis/src/othello/notes/2026-07-06-gridcap-ladder.log
ulimit -Sv 21000000   # ~20 GB virtual-memory cap

run() {
  local mode="$1" q="$2"
  local t0 t1
  t0=$(date +%s)
  local out
  out=$("$BIN" "$mode" "$q" 2>&1)
  local rc=$?
  t1=$(date +%s)
  if [ $rc -ne 0 ]; then
    out="q=$q mode=$mode DIED rc=$rc (likely mem cap or OOM)"
  fi
  printf '[%4ds] %s\n' "$((t1 - t0))" "$out" | tee -a "$LOG"
}

echo "=== gridcap ladder $(date) ===" | tee -a "$LOG"
run defect  17
run outcome 19
run defect  19
run outcome 23
run outcome 25
echo "LADDER_DONE" | tee -a "$LOG"
