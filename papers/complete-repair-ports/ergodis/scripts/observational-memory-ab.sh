#!/usr/bin/env bash
set -euo pipefail

if (($# < 1 || $# > 2)); then
  echo "usage: $0 <shared-target-dir>/release/deps/observational_compiler-<hash> [rounds]" >&2
  echo "  the bench binary lives in the crate's shared out-of-tree target" >&2
  echo "  directory, not in an in-tree target/; see PERFORMANCE.md, \"Build artifacts\"" >&2
  exit 2
fi
bench_binary=$1
rounds=${2:-3}

pairs=(
  "observational_long_chain/quotient_only/256|observational_long_chain/split_transcript/256"
  "observational_separated/quotient_only/16384|observational_separated/split_transcript/16384"
)

run_one() {
  local tag=$1
  echo "BEGIN ${tag}"
  /usr/bin/time -f "MAXRSS_KIB ${tag} %M" \
    "${bench_binary}" --bench "^${tag}$" \
    --sample-size 10 \
    --measurement-time 0.2 \
    --warm-up-time 0.2 \
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

echo OBSERVATIONAL_MEMORY_AB_DONE
