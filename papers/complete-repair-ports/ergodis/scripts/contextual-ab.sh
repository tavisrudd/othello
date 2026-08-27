#!/usr/bin/env bash
set -euo pipefail

rounds=${1:-2}
sample_size=${2:-20}
measurement_seconds=${3:-1}

pairs=(
  "rank_one_radius_decision/A_exact_then_compare|rank_one_radius_decision/B_radius_certificate"
  "complete_transfer_all_ranks/A_compute_each_rank|complete_transfer_all_ranks/B_rank_one_certificate"
  "projective_line_cache_warm/A_direct_vectors|projective_line_cache_warm/B_cached_lines"
  "projective_line_cache_cold/A_direct_vectors|projective_line_cache_cold/B_build_and_query"
  "projective_auto_one_shot/A_direct_vectors|projective_auto_one_shot/B_auto_cached"
  "rank_bounded_context_cache_warm/A_direct_maps|rank_bounded_context_cache_warm/B_cached_subspaces"
  "rank_bounded_context_cache_cold/A_direct_maps|rank_bounded_context_cache_cold/B_build_and_query"
  "rank_bounded_auto_one_shot/A_direct_maps|rank_bounded_auto_one_shot/B_auto_direct"
)

run_one() {
  local tag=$1
  echo "BEGIN ${tag}"
  cargo bench --bench contextual_state -- "${tag}" \
    --sample-size "${sample_size}" \
    --measurement-time "${measurement_seconds}" \
    --warm-up-time 1 \
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

echo CONTEXTUAL_AB_DONE
