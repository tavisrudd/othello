#!/usr/bin/env bash
set -euo pipefail

root=$(cd "$(dirname "$0")/.." && pwd)
cache=${ERGODIS_VLSAT2_CACHE:-/home/tavis/.cache/ergodis-external/vlsat2}
index=${ERGODIS_VLSAT2_INDEX:-$cache/index.html}
cpu=${ERGODIS_BENCH_CPU:-3}
manifest="$root/evidence/c985-vlsat2-full-manifest.json"
raw="$root/evidence/c985-vlsat2-full-coverage.raw.jsonl"
output="$root/evidence/c985-vlsat2-full-coverage.json"
export RUSTFLAGS=${ERGODIS_RUSTFLAGS:-${RUSTFLAGS:--C target-cpu=x86-64}}

cd "$root"
if [[ ! -f $index ]]; then
  curl -L --fail --silent --show-error \
    https://cadp.inria.fr/resources/vlsat/2.html -o "$index"
fi
python3 python/build_vlsat2_full_manifest.py --index "$index" --output "$manifest"
python3 python/fetch_vlsat2_prefix.py --manifest "$manifest" --cache-dir "$cache"
cargo build --release --example vlsat_clique_certificate
python3 python/run_vlsat2_coverage.py \
  --manifest "$manifest" \
  --cache-dir "$cache" \
  --ergodis target/release/examples/vlsat_clique_certificate \
  --raw-jsonl "$raw" \
  --output "$output" \
  --timeout 120 \
  --cpu "$cpu"
python3 python/check_vlsat2_coverage.py "$output" \
  --manifest "$manifest" \
  --raw-jsonl "$raw" \
  --cache-dir "$cache" \
  --ergodis target/release/examples/vlsat_clique_certificate
