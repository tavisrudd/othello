#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "usage: $0 LAYERED_DAG_DRIVER" >&2
  exit 2
fi

driver=$1
rounds=${ERGODIS_ROUNDS:-9}
cpu=${ERGODIS_CPU:-2}
sorts=${ERGODIS_SORTS:-32}
states=${ERGODIS_STATES:-32768}
window=${ERGODIS_WINDOW:-4}
scratch=${ERGODIS_SCRATCH:-/home/tavis/.cache/ergodis}
mkdir -p "$scratch"

printf 'round\tshape\tcase\ttotal_ns\tcompile_stream_ns\tverify_ns\tpeak_kib\tdetail\n'

run_case() {
  local round=$1
  local shape=$2
  local case_name=$3
  local mode=$4
  local time_file
  local frozen_file="$scratch/c985-dag-${case_name}-${shape}.frozen"
  local audit_file="$scratch/c985-dag-${case_name}-${shape}.audit"
  local detail
  local compile_stream_ns
  local verify_ns
  local peak_kib
  time_file=$(mktemp -p "$scratch" ergodis-dag-time.XXXXXX)
  detail=$(
    /usr/bin/time -f '%M' -o "$time_file" \
      taskset -c "$cpu" "$driver" "$mode" "$shape" "$sorts" "$states" "$window" \
      "$frozen_file" "$audit_file"
  )
  peak_kib=$(sed -n '1p' "$time_file")
  rm -f "$time_file"
  compile_stream_ns=$(awk -F '\t' '{ print $13 + $14 }' <<<"$detail")
  verify_ns=$(awk -F '\t' '{ print $15 }' <<<"$detail")
  printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \
    "$round" "$shape" "$case_name" "$((compile_stream_ns + verify_ns))" \
    "$compile_stream_ns" "$verify_ns" "$peak_kib" "$detail"
}

for ((round = 1; round <= rounds; round++)); do
  for shape in chain window full; do
    if ((round % 2 == 1)); then
      run_case "$round" "$shape" full full-certified
      run_case "$round" "$shape" frontier frontier-certified
    else
      run_case "$round" "$shape" frontier frontier-certified
      run_case "$round" "$shape" full full-certified
    fi
    cmp "$scratch/c985-dag-full-${shape}.frozen" \
      "$scratch/c985-dag-frontier-${shape}.frozen"
  done
done
