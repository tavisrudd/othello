#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 5 || $# -gt 6 ]]; then
    echo "usage: $0 MATA_ROOT NFA_BENCH_ROOT MATA_COMPARISON_ROOT Z3_ROOT CXX_LIBRARY_DIR [OUTPUT.json]" >&2
    exit 2
fi

mata_root=$1
nfa_bench_root=$2
comparison_root=$3
z3_root=$4
cxx_library_dir=$5
output=${6:-evidence/c985-z3-weighted-trace-suite.json}
expected_mata=e8c9310e389b1e62ece7080956550f70ceeed777
expected_nfa=94f2863ec7e76f53236c564e67f2f76b355f00d8
expected_comparison=c6781872ddfa589969d28289e4add73d2359b7d0
expected_z3_archive=d4922cebc9f0a55629231ec0c62f0bbedf8006eddaed4e68199ad19626b697f6

[[ $(git -C "$mata_root" rev-parse HEAD) == "$expected_mata" ]]
[[ $(git -C "$nfa_bench_root" rev-parse HEAD) == "$expected_nfa" ]]
[[ $(git -C "$comparison_root" rev-parse HEAD) == "$expected_comparison" ]]
[[ $("$z3_root/bin/z3" --version) == "Z3 version 5.0.0 - 64 bit" ]]

cache_root=${ERGODIS_Z3_CACHE:-/home/tavis/.cache/ergodis-z3-weighted}
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
CARGO_TARGET_DIR="$cache_root/rust-target" cargo build --release --quiet --example mata_weighted_trace

python3 python/run_z3_weighted_suite.py \
    --input-list "$comparison_root/inputs/bench-single-presburger-explicit-complement.input" \
    --nfa-bench-root "$nfa_bench_root" \
    --mata-driver "$cache_root/mata-official-driver" \
    --ergodis-driver "$cache_root/rust-target/release/examples/mata_weighted_trace" \
    --z3-script python/z3_weighted_trace.py \
    --z3-python-path "$z3_root/bin/python" \
    --z3-library-path "$z3_root/bin" \
    --cxx-library-path "$cxx_library_dir" \
    --work-dir "$cache_root/derived" \
    --output "$output" \
    --mata-revision "$expected_mata" \
    --nfa-bench-revision "$expected_nfa" \
    --comparison-revision "$expected_comparison" \
    --z3-version 5.0.0 \
    --z3-archive-sha256 "$expected_z3_archive"
python3 python/check_z3_weighted_suite.py "$output" \
    --ergodis-driver "$cache_root/rust-target/release/examples/mata_weighted_trace" \
    --mata-driver "$cache_root/mata-official-driver" \
    --z3-script python/z3_weighted_trace.py
