#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 3 || $# -gt 4 ]]; then
    echo "usage: $0 MATA_ROOT NFA_BENCH_ROOT MATA_COMPARISON_ROOT [OUTPUT.json]" >&2
    exit 2
fi

mata_root=$1
nfa_bench_root=$2
comparison_root=$3
output=${4:-evidence/c985-mata-official-ab.json}
expected_mata=e8c9310e389b1e62ece7080956550f70ceeed777
expected_nfa=94f2863ec7e76f53236c564e67f2f76b355f00d8
expected_comparison=c6781872ddfa589969d28289e4add73d2359b7d0

[[ $(git -C "$mata_root" rev-parse HEAD) == "$expected_mata" ]]
[[ $(git -C "$nfa_bench_root" rev-parse HEAD) == "$expected_nfa" ]]
[[ $(git -C "$comparison_root" rev-parse HEAD) == "$expected_comparison" ]]

cache_root=${ERGODIS_MATA_CACHE:-/home/tavis/.cache/ergodis-mata-official}
mkdir -p "$cache_root/derived"
cmake -B "$mata_root/build" -S "$mata_root" \
    -DMATA_BUILD_EXAMPLES:BOOL=OFF -DBUILD_TESTING:BOOL=OFF -DCMAKE_BUILD_TYPE=Release
cmake --build "$mata_root/build" --parallel
g++ -std=c++20 -O3 -DNDEBUG \
    -I"$mata_root/include" \
    -I"$mata_root/3rdparty/cudd/include" \
    -I"$mata_root/3rdparty/simlib/include" \
    -I"$mata_root/3rdparty/re2" \
    benches/mata_official_dfa_driver.cc "$mata_root/build/src/libmata.a" -pthread \
    -o "$cache_root/mata-official-driver"
CARGO_TARGET_DIR="$cache_root/rust-target" cargo build --release --quiet --example mata_official_dfa

python3 python/run_mata_official_ab.py \
    --input-list "$comparison_root/inputs/bench-single-presburger-explicit-complement.input" \
    --nfa-bench-root "$nfa_bench_root" \
    --mata-driver "$cache_root/mata-official-driver" \
    --ergodis-driver "$cache_root/rust-target/release/examples/mata_official_dfa" \
    --mata-revision "$expected_mata" \
    --nfa-bench-revision "$expected_nfa" \
    --comparison-revision "$expected_comparison" \
    --work-dir "$cache_root/derived" \
    --output "$output"
python3 python/check_mata_official_ab.py "$output"
