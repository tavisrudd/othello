#!/usr/bin/env bash
# Interleaved A/B for the scheduler's counted-type reduction (C1038).
#
# Compares the retained pre-change example binary against the current one on the
# scheduler rows, in rotated order, one thread, with hardware counters. Writes a
# canonical TSV to evidence/c1038-counted-type-ab.tsv.
#
# usage: counted-type-ab.sh [ROUNDS] [ROWS...]
set -euo pipefail

script_dir=$(cd "$(dirname "$0")" && pwd)
# shellcheck source=lib.sh
. "$script_dir/lib.sh"

root=$(cd "$script_dir/.." && pwd)
cache_root=$(ergodis_cache_root)
baseline="${BASELINE_BIN:-$cache_root/bin/negative_control_tier-a5e844f73}"
current=$(ergodis_bin "$root" release examples/negative_control_tier)
cpu=${CPU:-3}
rounds=${1:-11}
shift || true
rows=("$@")
if (( ${#rows[@]} == 0 )); then
  rows=(W2 W3)
fi

for binary in "$baseline" "$current"; do
  if [[ ! -x $binary ]]; then
    echo "counted-type-ab.sh: missing executable: $binary" >&2
    exit 1
  fi
done

out="$root/evidence/c1038-counted-type-ab.tsv"
printf 'row\tside\tround\telapsed_ns\tanswer\twork\tpeak_rss_kib\tinstructions\tcycles\tbranches\tbranch_misses\n' > "$out"

sample() {
  local row=$1 side=$2 round=$3 binary=$4
  local stat json
  stat=$(mktemp)
  # One solve per process, counters over the whole process, single thread.
  json=$(perf stat -x, -e instructions,cycles,branches,branch-misses -o "$stat" -- \
    choom -n 1000 -- taskset -c "$cpu" "$binary" solve "$row" 1 2>/dev/null)
  local elapsed answer work rss
  elapsed=$(printf '%s' "$json" | python3 -c 'import json,sys;print(json.load(sys.stdin)["elapsed_ns"])')
  answer=$(printf '%s' "$json" | python3 -c 'import json,sys;print(json.load(sys.stdin)["answer"])')
  work=$(printf '%s' "$json" | python3 -c 'import json,sys;print(json.load(sys.stdin)["work"])')
  rss=$(printf '%s' "$json" | python3 -c 'import json,sys;print(json.load(sys.stdin)["peak_rss_kib"])')
  # perf reports event names with a privilege-level suffix such as
  # "instructions:u"; match on the stem.
  counter() {
    awk -F, -v e="$1" '{ name=$3; sub(/:.*$/, "", name); if (name==e) { print $1; exit } }' "$stat"
  }
  printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \
    "$row" "$side" "$round" "$elapsed" "$answer" "$work" "$rss" \
    "$(counter instructions)" "$(counter cycles)" \
    "$(counter branches)" "$(counter branch-misses)" >> "$out"
  rm -f "$stat"
}

for row in "${rows[@]}"; do
  for (( round = 0; round < rounds; round++ )); do
    if (( round % 2 == 0 )); then
      sample "$row" baseline "$round" "$baseline"
      sample "$row" current "$round" "$current"
    else
      sample "$row" current "$round" "$current"
      sample "$row" baseline "$round" "$baseline"
    fi
  done
done

python3 - "$out" <<'PYTHON'
import statistics, sys
from collections import defaultdict

rows = defaultdict(lambda: defaultdict(list))
with open(sys.argv[1], encoding="utf-8") as handle:
    header = handle.readline().rstrip("\n").split("\t")
    for line in handle:
        record = dict(zip(header, line.rstrip("\n").split("\t")))
        rows[record["row"]][record["side"]].append(record)

def median(records, field):
    values = [float(r[field]) for r in records if r[field] not in ("", "<not counted>")]
    return statistics.median(values) if values else float("nan")

print(f"{'row':<4} {'side':<9} {'ms':>10} {'work':>12} {'RSS KiB':>9} "
      f"{'instr':>14} {'cycles':>14} {'branches':>13} {'br-miss':>10}")
for row, sides in rows.items():
    answers = {r["answer"] for side in sides.values() for r in side}
    assert len(answers) == 1, f"row {row}: answers disagree across sides: {answers}"
    for side in ("baseline", "current"):
        records = sides[side]
        print(f"{row:<4} {side:<9} {median(records,'elapsed_ns')/1e6:>10.3f} "
              f"{median(records,'work'):>12.0f} {median(records,'peak_rss_kib'):>9.0f} "
              f"{median(records,'instructions'):>14.0f} {median(records,'cycles'):>14.0f} "
              f"{median(records,'branches'):>13.0f} {median(records,'branch_misses'):>10.0f}")
    speedup = median(sides["baseline"], "elapsed_ns") / median(sides["current"], "elapsed_ns")
    print(f"{row:<4} {'ratio':<9} {speedup:>10.2f}x  (exact answer agreement: {answers.pop()})")
PYTHON
