#!/usr/bin/env bash
# Parallel (24-thread) outcome frontier: extend the PG(2,q) ladder to q=23..31.
# Each q is internally multi-threaded (sharded memo + depth-4 frontier split); run
# sequentially so threads never oversubscribe. Memory-capped so a too-big q dies clean.
set -u
BIN=/tmp/gridcap_par
LOG=/home/tavis/src/othello/notes/2026-07-06-gridcap-par-frontier.log
ulimit -Sv 23000000   # ~22 GB
run() {
  local q="$1" t0 t1 out rc
  t0=$(date +%s)
  out=$("$BIN" par "$q" 24 4 2>&1); rc=$?
  t1=$(date +%s)
  [ $rc -ne 0 ] && out="q=$q DIED rc=$rc (mem cap / OOM)"
  printf '[%6ds] %s\n' "$((t1 - t0))" "$out" | tee -a "$LOG"
}
echo "=== gridcap parallel frontier $(date) ===" | tee -a "$LOG"
for q in 25 27 31 23 29; do run "$q"; done
echo "PAR_FRONTIER_DONE" | tee -a "$LOG"
