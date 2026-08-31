#!/usr/bin/env bash
# Verification-cost measurement: structural verification of a real certificate,
# then the same certificate with a sampled shard re-run, against the recorded
# production cost of the job that produced it.
set -u
CD="$HOME/.cache/ergodis/certdist"
BIN="$CD/shim-target/release/certdist"
Q="$HOME/.cache/ergodis/c1018/qldpc"
NATIVE="$CD/core-target/release/css_distance_native"
LOG="$CD/verify.log"
: >"$LOG"

for target in r1elite02-x r3elitep02-z; do
  code="${target%-*}"
  side="${target##*-}"
  job="$CD/jobs/$target"
  echo "=== $target ===" | tee -a "$LOG"
  echo "--- production cost recorded during the run:" | tee -a "$LOG"
  python3 - "$job/metrics.jsonl" <<'PY' | tee -a "$LOG"
import json, sys
rows = [json.loads(line) for line in open(sys.argv[1])]
shard = [r for r in rows if r["step"] == "shard"]
job = [r for r in rows if r["step"] == "job"]
upper = [r for r in rows if r["step"] == "upper"]
compile_ = [r for r in rows if r["step"] == "compile"]
print("  shards run          %d" % len(shard))
print("  shard search s      %.2f" % sum(r["search_seconds"] for r in shard))
print("  shard wall s        %.2f" % sum(r["wall_seconds"] for r in shard))
print("  compile wall s      %.2f" % sum(r["wall_seconds"] for r in compile_))
print("  upper pass wall s   %.2f" % sum(r["wall_seconds"] for r in upper))
print("  peak shard RSS MiB  %.1f" % (max(r["peak_rss_kib"] for r in shard) / 1024.0))
print("  candidates          %d" % sum(r["candidates"] for r in shard))
if job:
    print("  whole job wall s    %.2f" % job[-1]["wall_seconds"])
PY
  echo "--- structural verification:" | tee -a "$LOG"
  /usr/bin/env time -f "TIMING verify-structural $target wall=%e maxrss_kib=%M" \
    "$BIN" verify --certificate "$job/certificate.json" --input "$Q/$code-$side.json" 2>&1 | tee -a "$LOG"
  echo "--- verification with two shards re-run:" | tee -a "$LOG"
  /usr/bin/env time -f "TIMING verify-recheck2 $target wall=%e maxrss_kib=%M" \
    "$BIN" verify --certificate "$job/certificate.json" --input "$Q/$code-$side.json" \
      --recheck-shards 2 --job "$job" --threads 8 --native "$NATIVE" 2>&1 | tee -a "$LOG"
done

echo "--- negative control: a tampered certificate must be refused" | tee -a "$LOG"
python3 - "$CD/jobs/r1elite02-x/certificate.json" "$CD/tampered.json" <<'PY'
import json, sys
cert = json.load(open(sys.argv[1]))
# flip one coordinate of the enumeration witness
for level in cert["levels"]:
    if level["minimum_witness"]:
        level["minimum_witness"][0] = (level["minimum_witness"][0] + 1) % cert["code"]["coordinate_count"]
        break
json.dump(cert, open(sys.argv[2], "w"), indent=2)
PY
"$BIN" verify --certificate "$CD/tampered.json" --input "$Q/r1elite02-x.json" 2>&1 | tail -n 6 | tee -a "$LOG"
echo "VERIFY DEMO DONE" | tee -a "$LOG"
