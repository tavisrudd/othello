#!/usr/bin/env bash
set -euo pipefail

root=$(cd "$(dirname "$0")/.." && pwd)
cache=${ERGODIS_VLSAT2_CACHE:-/home/tavis/.cache/ergodis-external/vlsat2}
kissat=${ERGODIS_KISSAT:-/home/tavis/.cache/ergodis-external/kissat/build/kissat}
kissat_revision=${ERGODIS_KISSAT_REVISION:-8af8e56f174b778aef3aa45af9f739b2a5f492c2}
cpu=${ERGODIS_BENCH_CPU:-3}
manifest="$root/evidence/c985-vlsat2-prefix-manifest.json"
raw="$root/evidence/c985-vlsat2-prefix.raw.jsonl"
output="$root/evidence/c985-vlsat2-prefix-ab.json"
diagnostic=()
export RUSTFLAGS=${ERGODIS_RUSTFLAGS:-${RUSTFLAGS:--C target-cpu=x86-64}}
if [[ ${ERGODIS_DIAGNOSTIC_HOST:-0} == 1 ]]; then
  diagnostic=(--diagnostic-host)
fi

cd "$root"
python3 python/build_vlsat2_prefix_manifest.py --output "$manifest"
python3 python/fetch_vlsat2_prefix.py --manifest "$manifest" --cache-dir "$cache"
cargo build --release --example vlsat_clique_certificate
python3 python/run_vlsat2_prefix.py \
  --manifest "$manifest" \
  --cache-dir "$cache" \
  --ergodis target/release/examples/vlsat_clique_certificate \
  --kissat "$kissat" \
  --raw-jsonl "$raw" \
  --output "$output" \
  --ergodis-rounds 15 \
  --kissat-rounds 7 \
  --timeout 10 \
  --cpu "$cpu" \
  --kissat-revision "$kissat_revision" \
  "${diagnostic[@]}"
python3 python/check_vlsat2_prefix.py "$output" \
  --manifest "$manifest" \
  --raw-jsonl "$raw" \
  --cache-dir "$cache" \
  --ergodis target/release/examples/vlsat_clique_certificate \
  --kissat "$kissat"
