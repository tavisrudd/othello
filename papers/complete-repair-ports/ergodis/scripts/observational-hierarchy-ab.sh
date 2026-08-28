#!/usr/bin/env bash
set -euo pipefail

binary=${1:?usage: observational-hierarchy-ab.sh DRIVER [ROUNDS] [CPU]}
rounds=${2:-7}
cpu=${3:-2}
if [[ ! -x ${binary} ]]; then
  echo "not an executable: ${binary}" >&2
  exit 2
fi

export LC_ALL=C
printf '%s\n' 'application	depth	seed_bound	profiles	raw_states	classes	raw_payload_bytes	quotient_bytes	certificate_bytes	raw_build_ns	quotient_build_ns	direct_ns_per_query	raw_sequential_ns_per_query	quotient_sequential_ns_per_query	raw_random_ns_per_query	quotient_random_ns_per_query	direct_checksum	raw_checksum	quotient_checksum	quotient_first	sequential_queries	raw_sequential_total_ns	quotient_sequential_total_ns	random_queries	raw_random_total_ns	quotient_random_total_ns'

cases=(
  '4 10000 10 3'
  '4 2 0 256'
)
for case_spec in "${cases[@]}"; do
  read -r depth cached_repetitions direct_repetitions seed_bound <<<"${case_spec}"
  for ((round = 0; round < rounds; round++)); do
    if ((round % 2 == 0)); then
      order=raw-first
    else
      order=quotient-first
    fi
    taskset -c "${cpu}" "${binary}" \
      "${depth}" "${cached_repetitions}" "${direct_repetitions}" \
      "${seed_bound}" "${order}"
  done
done
