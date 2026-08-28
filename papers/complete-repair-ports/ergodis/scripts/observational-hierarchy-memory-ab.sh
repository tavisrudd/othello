#!/usr/bin/env bash
set -euo pipefail

binary=${1:?usage: observational-hierarchy-memory-ab.sh DRIVER [ROUNDS] [CPU]}
rounds=${2:-7}
cpu=${3:-2}
if [[ ! -x ${binary} ]]; then
  echo "not an executable: ${binary}" >&2
  exit 2
fi

export LC_ALL=C
printf 'metric\tround\tmode\tkib\n'
for ((round = 0; round < rounds; round++)); do
  if ((round % 2 == 0)); then
    modes=(raw-build-only full)
  else
    modes=(full raw-build-only)
  fi
  for mode in "${modes[@]}"; do
    measurement=$(
      {
        /usr/bin/time -f "peak_rss_kib\t${round}\t${mode}\t%M" \
          taskset -c "${cpu}" "${binary}" 4 1 0 256 raw-first "${mode}" \
          >/dev/null
      } 2>&1
    )
    printf '%s\n' "${measurement}"
  done
done
