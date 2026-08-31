#!/usr/bin/env bash
# Head-to-head on the same host at the same time: the core's one-shot search
# against certdist's 32-shard resumable cover, same radius, same thread count,
# same compiled filter. Answers "how much does resumability cost?" directly.
set -u
CD="$HOME/.cache/ergodis/certdist"
BIN="$CD/shim-target/release/certdist"
Q="$HOME/.cache/ergodis/c1018/qldpc"
NATIVE="$CD/core-target/release/css_distance_native"
LOG="$CD/headtohead.log"
: >"$LOG"
rm -rf "$CD/h2h"
mkdir -p "$CD/h2h"

pair() {
  local target="$1" radius="$2"
  local job="$CD/h2h/$target"
  echo "=== $target radius $radius ===" | tee -a "$LOG"
  # Build the job (and its filter) without running the cover, by planning zero shards.
  "$BIN" run --input "$Q/$target.json" --job "$job" --radius "$radius" \
    --shards 32 --threads 8 --upper none --wall-budget 0.001 --native "$NATIVE" >/dev/null 2>&1

  echo "--- one shot, unsharded, 8 threads" | tee -a "$LOG"
  /usr/bin/env time -f "ONESHOT $target wall=%e maxrss_kib=%M" \
    "$NATIVE" --input "$job/input.json" --compiled-in "$job/filter.ergocsl" \
      --maximum-weight "$radius" --threads 8 --pulse-interval 4096 2>&1 \
    | python3 -c "
import json,sys
for line in sys.stdin:
    line=line.strip()
    if line.startswith('{'):
        d=json.loads(line)
        print('  search %.2f s, %d candidates, distance %s' % (
            sum(d['search_seconds']), d['result']['stats']['candidates'], d['result']['distance']))
    elif line:
        print(line)
" | tee -a "$LOG"

  echo "--- 32 resumable shards, 8 threads each, sequential" | tee -a "$LOG"
  /usr/bin/env time -f "SHARDED $target wall=%e maxrss_kib=%M" \
    "$BIN" run --input "$Q/$target.json" --job "$job" --radius "$radius" \
      --shards 32 --threads 8 --upper none --native "$NATIVE" 2>&1 \
    | rg '^(shards|bracket)' | tee -a "$LOG"
}

pair r1elite02-x 16
pair r3elitep02-z 19
echo "HEAD TO HEAD DONE" | tee -a "$LOG"
