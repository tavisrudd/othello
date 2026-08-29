#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "usage: $0 HIERARCHY_DRIVER" >&2
  exit 2
fi

driver=$1
rounds=${ERGODIS_ROUNDS:-9}
cpu=${ERGODIS_CPU:-2}
scratch=${ERGODIS_SCRATCH:-/home/tavis/.cache/ergodis}
mkdir -p "$scratch"

printf 'round\tcase\tinternal_ns\tpeak_kib\tdetail\n'

run_case() {
  local round=$1
  local case_name=$2
  local mode=$3
  local time_file
  local detail
  local internal_ns
  local peak_kib
  time_file=$(mktemp -p "$scratch" ergodis-layered-time.XXXXXX)
  detail=$(
    /usr/bin/time -f '%M' -o "$time_file" \
      taskset -c "$cpu" "$driver" 4 0 0 256 raw-first "$mode"
  )
  peak_kib=$(sed -n '1p' "$time_file")
  rm -f "$time_file"
  if [[ $case_name == generic ]]; then
    internal_ns=$(awk -F '\t' '{ print $6 + $7 }' <<<"$detail")
  else
    internal_ns=$(awk -F '\t' '{ print $9 }' <<<"$detail")
  fi
  printf '%s\t%s\t%s\t%s\t%s\n' \
    "$round" "$case_name" "$internal_ns" "$peak_kib" "$detail"
}

for ((round = 1; round <= rounds; round++)); do
  if ((round % 2 == 1)); then
    run_case "$round" generic generic-build-only
    run_case "$round" layered layered-build-only
  else
    run_case "$round" layered layered-build-only
    run_case "$round" generic generic-build-only
  fi
done
