#!/usr/bin/env bash
set -euo pipefail

if (( $# < 2 || $# > 5 )); then
  echo "usage: $0 RUN_DIR OUTPUT.tsv [ROUNDS] [ALIGNMENT_BINARY] [CTL_BINARY]" >&2
  exit 2
fi

run_dir=$1
output=$2
rounds=${3:-7}
script_dir=$(cd "$(dirname "$0")" && pwd)
# shellcheck source=lib.sh
. "$script_dir/lib.sh"
core_root=$(cd "$script_dir/.." && pwd)

alignment=${4:-$(ergodis_bin "$core_root" release alignment-controlled)}
ctl=${5:-$(ergodis_bin "$core_root" release ergodisctl)}

if [[ -e $output ]]; then
  echo "refusing to overwrite $output" >&2
  exit 2
fi

status=$($ctl --run-dir "$run_dir" --json status)
if [[ $(jq -r '.ok' <<<"$status") != true || $(jq -r '.result.plans' <<<"$status") != 0 ]]; then
  echo "campaign must be healthy with no active plans" >&2
  exit 2
fi

scratch=$(mktemp -d -p "$(dirname "$output")" control-event-ab.XXXXXX)
solver_pid=
flood_pid=
cleanup() {
  if [[ -n $flood_pid ]]; then kill "$flood_pid" 2>/dev/null || true; fi
  if [[ -n $solver_pid ]]; then kill "$solver_pid" 2>/dev/null || true; fi
  rm -f "$scratch"/*
  rmdir "$scratch"
}
trap cleanup EXIT INT TERM

printf 'round\tmode\twall_s\tuser_s\tsystem_s\trss_kib\tstates\tnotifications\n' >"$output"

run_one() {
  local round=$1
  local mode=$2
  local result="$scratch/result.json"
  local timing="$scratch/timing.tsv"
  local baseline=()
  if [[ $mode == baseline ]]; then baseline=(--baseline); fi

  /usr/bin/time -f '%e\t%U\t%S\t%M' -o "$timing" \
    choom -n 500 -- "$alignment" \
      --run-dir "$run_dir" --points 8 --budget 12 --initial 1 \
      --seen-capacity 4194304 --symmetry --compact-seen "${baseline[@]}" \
      >"$result" &
  solver_pid=$!
  if [[ $mode == noop ]]; then
    (
      while kill -0 "$solver_pid" 2>/dev/null; do
        "$ctl" --run-dir "$run_dir" noop >/dev/null
        sleep 1
      done
    ) &
    flood_pid=$!
  fi
  wait "$solver_pid"
  solver_pid=
  if [[ -n $flood_pid ]]; then
    wait "$flood_pid" || true
    flood_pid=
  fi

  IFS=$'\t' read -r wall user system rss <"$timing"
  printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \
    "$round" "$mode" "$wall" "$user" "$system" "$rss" \
    "$(jq -r '.metrics.states' "$result")" \
    "$(jq -r '.control.notifications // 0' "$result")" >>"$output"
}

modes=(baseline idle noop)
for ((round = 0; round < rounds; round++)); do
  for ((offset = 0; offset < 3; offset++)); do
    run_one "$round" "${modes[(round + offset) % 3]}"
  done
done

echo "CONTROL_EVENT_AB_DONE output=$output"
