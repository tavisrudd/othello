#!/usr/bin/env bash
set -euo pipefail

old_binary=${1:?usage: observational-compiler-old-new-ab.sh OLD NEW [ROUNDS] [CPU]}
new_binary=${2:?usage: observational-compiler-old-new-ab.sh OLD NEW [ROUNDS] [CPU]}
rounds=${3:-7}
cpu=${4:-2}
if [[ ! -x ${old_binary} || ! -x ${new_binary} ]]; then
  echo "expected two executable observational SOTA drivers" >&2
  exit 2
fi

export LC_ALL=C
printf 'implementation\tfamily\tround\tns_per_op\tclasses\tsplits\n'
cases=(
  'chain 131072 1 2'
  'random 131072 4 2'
  'colors 131072 4 256'
)
for case_spec in "${cases[@]}"; do
  read -r family states generators outputs <<<"${case_spec}"
  for ((round = 0; round < rounds; round++)); do
    if ((round % 2 == 0)); then
      implementations=(old new)
    else
      implementations=(new old)
    fi
    for implementation in "${implementations[@]}"; do
      binary=${old_binary}
      if [[ ${implementation} == new ]]; then
        binary=${new_binary}
      fi
      result=$(taskset -c "${cpu}" "${binary}" \
        "${family}" "${states}" "${generators}" 1 "${outputs}" transcript)
      awk -F '\t' -v implementation="${implementation}" -v round="${round}" \
        '{printf "%s\t%s\t%s\t%s\t%s\t%s\n", implementation, $2, round, $7, $8, $9}' \
        <<<"${result}"
    done
  done
done
