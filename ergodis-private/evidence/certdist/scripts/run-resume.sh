#!/usr/bin/env bash
# Resume demonstration: an uninterrupted run against a run killed mid-radius
# (SIGKILL to the whole process group, so the in-flight css_distance_native
# child dies too) and then restarted. Both use --upper none so the certificates
# are directly comparable byte-for-byte.
set -u
CD="$HOME/.cache/ergodis/certdist"
# certdist is now the `css certdist` subcommand of the ergodis-tools binary.
TOOLS="${ERGODIS_TOOLS:-$HOME/.cache/ergodis/target/ergodis-private/release/ergodis-tools}"
Q="$HOME/.cache/ergodis/c1018/qldpc"
NATIVE="$CD/core-target/release/css_distance_native"
IN="$Q/r1elite01-z.json"
LOG="$CD/resume.log"
: >"$LOG"
rm -rf "$CD/resume"
mkdir -p "$CD/resume"

common=(run --input "$IN" --radius 16 --shards 32 --threads 8 --upper none --native "$NATIVE")

echo "### A: uninterrupted" | tee -a "$LOG"
/usr/bin/env time -f "TIMING A wall=%e maxrss_kib=%M" \
  "$TOOLS" css certdist "${common[@]}" --job "$CD/resume/a" 2>&1 | tee -a "$LOG"

echo "### B: killed mid-radius, then resumed" | tee -a "$LOG"
setsid "$TOOLS" css certdist "${common[@]}" --job "$CD/resume/b" >"$CD/resume/b-first.log" 2>&1 &
pid=$!
sleep 25
echo "--- SIGKILL to process group $pid after 25 s" | tee -a "$LOG"
kill -KILL -"$pid" 2>/dev/null
wait "$pid" 2>/dev/null
sleep 1
echo "--- shard records surviving the kill: $(ls "$CD"/resume/b/w016-n0032/shard-*.json 2>/dev/null | wc -l) of 32" | tee -a "$LOG"
echo "--- live bracket from the interrupted job:" | tee -a "$LOG"
"$TOOLS" css certdist status --job "$CD/resume/b" 2>&1 | tee -a "$LOG"

echo "--- second kill, deeper in the radius" | tee -a "$LOG"
setsid "$TOOLS" css certdist "${common[@]}" --job "$CD/resume/b" >"$CD/resume/b-second.log" 2>&1 &
pid=$!
sleep 40
kill -KILL -"$pid" 2>/dev/null
wait "$pid" 2>/dev/null
sleep 1
echo "--- shard records now: $(ls "$CD"/resume/b/w016-n0032/shard-*.json 2>/dev/null | wc -l) of 32" | tee -a "$LOG"

echo "### B: final restart to completion" | tee -a "$LOG"
/usr/bin/env time -f "TIMING B-final wall=%e maxrss_kib=%M" \
  "$TOOLS" css certdist "${common[@]}" --job "$CD/resume/b" 2>&1 | tee -a "$LOG"

echo "### certificate comparison" | tee -a "$LOG"
sha256sum "$CD/resume/a/certificate.json" "$CD/resume/b/certificate.json" | tee -a "$LOG"
if diff -q "$CD/resume/a/certificate.json" "$CD/resume/b/certificate.json" >/dev/null; then
  echo "RESUME MATCH: byte-identical certificates" | tee -a "$LOG"
else
  echo "RESUME MISMATCH" | tee -a "$LOG"
  diff "$CD/resume/a/certificate.json" "$CD/resume/b/certificate.json" | head -n 40 | tee -a "$LOG"
fi
echo "RESUME DEMO DONE" | tee -a "$LOG"
