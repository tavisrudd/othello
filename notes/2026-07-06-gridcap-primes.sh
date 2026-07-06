#!/usr/bin/env bash
# Test whether the untested PRIMES fit exhaustively (prime powers 25/27 OOM'd at 22 GB).
# Ordered smallest-first; each capped so an OOM dies clean and we move on. Live progress -> PROG.
set -u
BIN=/tmp/gridcap_par2
LOG=/home/tavis/src/othello/notes/2026-07-06-gridcap-primes.log
PROG=/home/tavis/src/othello/notes/2026-07-06-gridcap-primes-progress.log
ulimit -Sv 24000000   # ~23 GB (leave ~2-3 GB for OS)
run() {
  local q="$1" t0 t1 out rc
  echo "==== q=$q start $(date +%T) ====" >> "$PROG"
  t0=$(date +%s)
  out=$("$BIN" par "$q" 24 4 2>>"$PROG"); rc=$?
  t1=$(date +%s)
  [ $rc -ne 0 ] && out="q=$q DIED rc=$rc (mem cap / OOM)"
  printf '[%6ds] %s\n' "$((t1 - t0))" "$out" | tee -a "$LOG"
}
echo "=== gridcap primes $(date) ===" | tee -a "$LOG"
for q in 23 31 29; do run "$q"; done
echo "PRIMES_DONE" | tee -a "$LOG"
