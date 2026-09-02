#!/usr/bin/env bash
set -euo pipefail

if (($# != 1)); then
  echo "usage: $0 <shared-target-dir>/release/deps/contextual_state-<hash>" >&2
  echo "  the bench binary lives in the crate's shared out-of-tree target" >&2
  echo "  directory, not in an in-tree target/; see PERFORMANCE.md, \"Build artifacts\"" >&2
  exit 2
fi
bench_binary=$1

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

for pair in "${pairs[@]}"; do
  left=${pair%%|*}
  right=${pair#*|}
  for tag in "${left}" "${right}"; do
    /usr/bin/time -f "MAXRSS_KIB ${tag} %M" \
      "${bench_binary}" --bench "${tag}" \
      --sample-size 10 \
      --measurement-time 0.2 \
      --warm-up-time 0.2 \
      --noplot
  done
done

echo CONTEXTUAL_MEMORY_AB_DONE
