#!/usr/bin/env bash
# Re-assemble every certificate with the current certdist (which pins the
# enumerator's SHA-256 into the job and the certificate). Every shard resumes
# from disk, so this re-runs no search; it is also a second, incidental
# demonstration that resume is a no-op when the work is already done.
set -u
CD="$HOME/.cache/ergodis/certdist"
# certdist is now the `css certdist` subcommand of the ergodis-tools binary.
TOOLS="${ERGODIS_TOOLS:-$HOME/.cache/ergodis/target/ergodis-private/release/ergodis-tools}"
Q="$HOME/.cache/ergodis/c1018/qldpc"
NATIVE="$CD/core-target/release/css_distance_native"
LOG="$CD/regen.log"
: >"$LOG"

regen() {
  local code="$1" side="$2" radius="$3"
  "$TOOLS" css certdist run --input "$Q/${code}-${side}.json" --job "$CD/jobs/${code}-${side}" \
    --radius "$radius" --shards 32 --threads 8 --upper none --native "$NATIVE" 2>&1 \
    | rg '^(shards|bracket|certificate sha256)' | sed "s|^|${code}-${side}  |" | tee -a "$LOG"
}

for spec in "r1elite01 16" "r1elite02 16" "r3elite01 14" "r3elite02 14" "r3elitep01 17" "r3elitep02 19"; do
  set -- $spec
  regen "$1" x "$2"
  regen "$1" z "$2"
  "$TOOLS" css certdist combine \
    --certificate "$CD/jobs/$1-x/certificate.json" \
    --certificate "$CD/jobs/$1-z/certificate.json" \
    --label "$1" --out "$CD/jobs/$1-combined.json" 2>&1 | tee -a "$LOG"
done
echo "REGEN DONE" | tee -a "$LOG"
