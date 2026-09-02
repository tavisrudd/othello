#!/usr/bin/env bash
# certdist acceptance sweep: the six Liu-Marquardt lifted-product candidates,
# both CSS sides each, driven entirely through the certdist job interface.
set -u
CD="$HOME/.cache/ergodis/certdist"
# certdist is now the `css certdist` subcommand of the ergodis-tools binary.
TOOLS="${ERGODIS_TOOLS:-$HOME/.cache/ergodis/target/ergodis-private/release/ergodis-tools}"
Q="$HOME/.cache/ergodis/c1018/qldpc"
NATIVE="$CD/core-target/release/css_distance_native"
RANDOM_BIN="$CD/core-target/release/css_distance_random"
LOG="$CD/acceptance.log"
: >"$LOG"

run_side() {
  local code="$1" side="$2" radius="$3"
  local job="$CD/jobs/${code}-${side}"
  echo "=== ${code}-${side} radius ${radius} ===" | tee -a "$LOG"
  /usr/bin/env time -f "TIMING ${code}-${side} wall=%e maxrss_kib=%M" \
    "$TOOLS" css certdist run \
      --input "$Q/${code}-${side}.json" \
      --job "$job" \
      --radius "$radius" \
      --shards 32 \
      --threads 8 \
      --upper builtin-osd \
      --upper-trials 20000 \
      --upper-order 2 \
      --upper-window 96 \
      --upper-threads 8 \
      --native "$NATIVE" \
      --random-bin "$RANDOM_BIN" 2>&1 | tee -a "$LOG"
}

combine() {
  local code="$1"
  "$TOOLS" css certdist combine \
    --certificate "$CD/jobs/${code}-x/certificate.json" \
    --certificate "$CD/jobs/${code}-z/certificate.json" \
    --label "$code" \
    --out "$CD/jobs/${code}-combined.json" 2>&1 | tee -a "$LOG"
}

run_side r1elite01 x 16;  run_side r1elite01 z 16;  combine r1elite01
run_side r1elite02 x 16;  run_side r1elite02 z 16;  combine r1elite02
run_side r3elite01 x 14;  run_side r3elite01 z 14;  combine r3elite01
run_side r3elite02 x 14;  run_side r3elite02 z 14;  combine r3elite02
run_side r3elitep01 x 17; run_side r3elitep01 z 17; combine r3elitep01
run_side r3elitep02 x 19; run_side r3elitep02 z 19; combine r3elitep02
echo "ACCEPTANCE SWEEP DONE" | tee -a "$LOG"
