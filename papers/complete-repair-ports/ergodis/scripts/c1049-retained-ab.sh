#!/usr/bin/env bash
# Interleaved end-to-end A/B of the C1038 L2 row against the retained
# pre-change executable, with hardware performance counters.
#
# The control is a retained binary, not a rebuild: `retain-bin.sh` copied it to
# ~/.cache/ergodis/bin before any source edit. Both sides run the whole process
# — parsing, compilation, startup, solve, certificate replay, and output are
# inside the timed region — pinned to one CPU under choom, one round at a time
# with the arm order rotated.
#
# usage: c1049-retained-ab.sh [rounds] [row]
set -euo pipefail

script_dir=$(cd "$(dirname "$0")" && pwd)
# shellcheck source=lib.sh
. "$script_dir/lib.sh"

rounds=${1:-3}
row=${2:-L2}
cpu=${ERGODIS_AB_CPU:-3}

cache_root=$(ergodis_cache_root)
control="$cache_root/bin/negative_control_tier-7062bbfee"
candidate=$(ergodis_target_dir "$script_dir/..")/release/examples/negative_control_tier

for binary in "$control" "$candidate"; do
  if [[ ! -x $binary ]]; then
    echo "c1049-retained-ab.sh: not executable: $binary" >&2
    exit 1
  fi
done

echo "control   $control" >&2
echo "  sha256  $(sha256sum "$control" | cut -d' ' -f1)" >&2
echo "candidate $candidate" >&2
echo "  sha256  $(sha256sum "$candidate" | cut -d' ' -f1)" >&2

counters=instructions,cycles,branches,branch-misses
have_perf=1
perf stat -e "$counters" true >/dev/null 2>&1 || have_perf=0

printf 'round\tarm\twall_ns\tanswer\twork\tpeak_states\tpruned\twitness_bytes\tmax_rss_kib\tinstructions\tcycles\tbranches\tbranch_misses\n'

run_arm() {
  local round=$1 arm=$2 binary=$3
  local mode=exact
  case $arm in
    control) mode= ;;
    exact) mode=exact ;;
    clamped) mode=clamped ;;
  esac

  local tmp
  tmp=$(mktemp -d)
  local perf_out="$tmp/perf" time_out="$tmp/time" json_out="$tmp/json"

  local -a prefix=(choom -n 1000 -- taskset -c "$cpu")
  if (( have_perf )); then
    prefix=(perf stat -x, -e "$counters" -o "$perf_out" -- "${prefix[@]}")
  fi

  if [[ -n $mode ]]; then
    env ERGODIS_DOMINANCE_MODE="$mode" /usr/bin/time -v -o "$time_out" \
      "${prefix[@]}" "$binary" solve "$row" 1 > "$json_out" 2>/dev/null
  else
    /usr/bin/time -v -o "$time_out" \
      "${prefix[@]}" "$binary" solve "$row" 1 > "$json_out" 2>/dev/null
  fi

  local rss
  rss=$(awk '/Maximum resident set size/ {print $NF}' "$time_out")

  local ins cyc br bmiss
  if (( have_perf )); then
    # perf appends a modifier to the event name (`instructions:u`), so match a
    # prefix rather than the bare event.
    ins=$(awk -F, '$3 ~ /^instructions/ {print $1}' "$perf_out")
    cyc=$(awk -F, '$3 ~ /^cycles/ {print $1}' "$perf_out")
    br=$(awk -F, '$3 ~ /^branches/ {print $1}' "$perf_out")
    bmiss=$(awk -F, '$3 ~ /^branch-misses/ {print $1}' "$perf_out")
  fi

  python3 - "$round" "$arm" "$json_out" "${rss:-0}" \
    "${ins:-0}" "${cyc:-0}" "${br:-0}" "${bmiss:-0}" <<'PYTHON'
import json
import sys

round_index, arm, path, rss, ins, cyc, br, bmiss = sys.argv[1:9]
with open(path, encoding="utf-8") as handle:
    record = json.load(handle)
dominance = record.get("dominance") or {}
print(
    "\t".join(
        str(value)
        for value in (
            round_index,
            arm,
            record["elapsed_ns"],
            record["answer"],
            record["work"],
            record["representation"],
            dominance.get("pruned_states", 0),
            dominance.get("witness_bytes", 0),
            rss,
            ins,
            cyc,
            br,
            bmiss,
        )
    )
)
PYTHON
  rm -rf "$tmp"
}

arms=(control exact clamped)
for (( round = 0; round < rounds; round++ )); do
  for (( offset = 0; offset < ${#arms[@]}; offset++ )); do
    arm=${arms[$(( (offset + round) % ${#arms[@]} ))]}
    if [[ $arm == control ]]; then
      run_arm "$round" "$arm" "$control"
    else
      run_arm "$round" "$arm" "$candidate"
    fi
  done
done
