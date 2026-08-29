#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "usage: $0 HIERARCHY_DRIVER" >&2
  exit 2
fi

driver=$1
rounds=${ERGODIS_ROUNDS:-9}
cpu=${ERGODIS_CPU:-2}
depth=${ERGODIS_DEPTH:-64}
seed_bound=${ERGODIS_SEED_BOUND:-256}
scratch=${ERGODIS_SCRATCH:-/home/tavis/.cache/ergodis}
mkdir -p "$scratch"

printf 'round\tcase\ttotal_ns\tcompile_stream_ns\tverify_ns\tpeak_kib\taudit_bytes\tfrozen_bytes\tdetail\n'

run_case() {
  local round=$1
  local case_name=$2
  local mode=$3
  local time_file
  local frozen_file="$scratch/c985-certified-${case_name}.frozen"
  local audit_file="$scratch/c985-certified-${case_name}.audit"
  local detail
  local compile_stream_ns
  local verify_ns
  local total_ns
  local peak_kib
  local audit_bytes
  local frozen_bytes
  time_file=$(mktemp -p "$scratch" ergodis-certified-time.XXXXXX)
  detail=$(
    /usr/bin/time -f '%M' -o "$time_file" \
      taskset -c "$cpu" "$driver" "$depth" 0 0 "$seed_bound" raw-first "$mode" \
      "$frozen_file" "$audit_file"
  )
  peak_kib=$(sed -n '1p' "$time_file")
  rm -f "$time_file"
  if [[ $case_name == full ]]; then
    compile_stream_ns=$(awk -F '\t' '{ print $6 + $7 }' <<<"$detail")
    verify_ns=$(awk -F '\t' '{ print $8 }' <<<"$detail")
    audit_bytes=$(awk -F '\t' '{ print $5 }' <<<"$detail")
    frozen_bytes=$(awk -F '\t' '{ print $9 }' <<<"$detail")
  else
    compile_stream_ns=$(awk -F '\t' '{ print $6 }' <<<"$detail")
    verify_ns=$(awk -F '\t' '{ print $7 }' <<<"$detail")
    audit_bytes=$(awk -F '\t' '{ print $5 }' <<<"$detail")
    frozen_bytes=$(awk -F '\t' '{ print $8 }' <<<"$detail")
  fi
  total_ns=$((compile_stream_ns + verify_ns))
  printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \
    "$round" "$case_name" "$total_ns" "$compile_stream_ns" "$verify_ns" \
    "$peak_kib" "$audit_bytes" "$frozen_bytes" "$detail"
}

for ((round = 1; round <= rounds; round++)); do
  if ((round % 2 == 1)); then
    run_case "$round" full layered-artifacts
    run_case "$round" frontier layered-chain-artifacts
  else
    run_case "$round" frontier layered-chain-artifacts
    run_case "$round" full layered-artifacts
  fi
done
