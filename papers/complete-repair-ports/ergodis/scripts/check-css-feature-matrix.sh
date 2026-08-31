#!/usr/bin/env bash
set -euo pipefail

root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
cargo_cmd=${CARGO:-cargo}

cd "$root"

for features in '' parallel large-css large-css,parallel; do
  args=(--no-default-features)
  label=default
  if [[ -n "$features" ]]; then
    args+=(--features "$features")
    label=$features
  fi
  echo "checking css_distance_native features=$label"
  "$cargo_cmd" check "${args[@]}" --lib --bin css_distance_native
done

"$cargo_cmd" test --lib --no-default-features --features large-css,parallel \
  deterministic_search_shards_cover_compact_and_wide_searches -- --nocapture
