#!/usr/bin/env bash
# Parallel (24-thread) frontier: extend the PG(2,q) outcome ladder past q=19.
# Optimized fixed-arena solver (set-hash canon, ~3.3x faster; Box<[u128]> arena sized once,
# no alloc-as-we-go). arena_log2=30 => 2^30 slots (17 GB, lazily faulted) holds ~9e8 classes.
# Live progress (tasks done/total, classes, classes/s) -> PROG (tail -f it).
set -u
BIN=/tmp/gridcapx
ARENA=30
LOG=/home/tavis/src/othello/notes/2026-07-06-gridcap-par-frontier.log
PROG=/home/tavis/src/othello/notes/2026-07-06-gridcap-par-progress.log
ulimit -Sv 25000000   # ~24 GB virtual (arena is lazy; RSS grows only with fill)
run() {
  local q="$1" t0 t1 out rc
  echo "==== q=$q start $(date +%T) ====" >> "$PROG"
  t0=$(date +%s)
  out=$("$BIN" par "$q" 24 4 "$ARENA" 2>>"$PROG"); rc=$?
  t1=$(date +%s)
  [ $rc -ne 0 ] && out="q=$q DIED rc=$rc (mem cap / arena full)"
  printf '[%6ds] %s\n' "$((t1 - t0))" "$out" | tee -a "$LOG"
}
echo "=== gridcap parallel frontier (opt, fixed-arena) $(date) ===" | tee -a "$LOG"
for q in 23 31 29 25 27; do run "$q"; done   # primes first, prime powers (biggest) last
echo "PAR_FRONTIER_DONE" | tee -a "$LOG"
