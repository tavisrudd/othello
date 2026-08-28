#!/usr/bin/env bash
set -euo pipefail

rounds=${1:-3}
sample_size=${2:-20}
measurement_seconds=${3:-1}

pairs=(
  "observational_long_chain/quotient_only/256|observational_long_chain/split_transcript/256"
  "observational_separated/quotient_only/16384|observational_separated/split_transcript/16384"
)

run_one() {
  local tag=$1
  echo "BEGIN ${tag}"
  cargo bench --bench observational_compiler -- "^${tag}$" \
    --sample-size "${sample_size}" \
    --measurement-time "${measurement_seconds}" \
    --warm-up-time 0.5 \
    --noplot
  echo "END ${tag}"
}

for pair in "${pairs[@]}"; do
  left=${pair%%|*}
  right=${pair#*|}
  for ((round = 0; round < rounds; round++)); do
    if ((round % 2 == 0)); then
      run_one "${left}"
      run_one "${right}"
    else
      run_one "${right}"
      run_one "${left}"
    fi
  done
done

echo OBSERVATIONAL_AB_DONE
