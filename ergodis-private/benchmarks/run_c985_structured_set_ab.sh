#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 2 || $# -gt 5 ]]; then
    echo "usage: $0 BINARY OUTPUT_DIR [PAIRS] [ROUNDS] [CPU]" >&2
    exit 2
fi

binary=$1
output_dir=$2
pairs=${3:-7}
rounds=${4:-100}
cpu=${5:-2}
queries=257

if [[ ! -x "$binary" || -e "$output_dir" ]]; then
    echo "binary must be executable and output directory must not exist" >&2
    exit 2
fi

mkdir -m 700 "$output_dir"
samples="$output_dir/samples.tsv"
metadata="$output_dir/metadata.txt"
printf 'round\tvariant\twall_ns\tcycles\tinstructions\tbranches\tbranch_misses\tcache_misses\twork\tchecksum\n' >"$samples"
{
    echo "schema=c985-structured-set-ab-v1"
    echo "git_commit=$(git rev-parse HEAD)"
    echo "rustc=$(rustc --version)"
    echo "binary_sha256=$(sha256sum "$binary" | cut -d' ' -f1)"
    echo "pairs=$pairs"
    echo "rounds=$rounds"
    echo "queries=$queries"
    echo "cpu=$cpu"
} >"$metadata"

run_one() {
    local pair=$1
    local variant=$2
    local mode=$3
    local perf_file="$output_dir/perf-${pair}-${variant}.csv"
    local stdout_file="$output_dir/stdout-${pair}-${variant}.txt"
    local start_ns end_ns wall_ns cycles instructions branches branch_misses cache_misses checksum
    start_ns=$(date +%s%N)
    choom -n 1000 -- taskset -c "$cpu" perf stat -x, \
        -e cycles,instructions,branches,branch-misses,cache-misses \
        -o "$perf_file" -- \
        "$binary" --mode "$mode" --rounds "$rounds" --queries "$queries" \
        >"$stdout_file"
    end_ns=$(date +%s%N)
    wall_ns=$((end_ns - start_ns))
    cycles=$(awk -F, '$3 ~ /^cycles/ {print $1}' "$perf_file")
    instructions=$(awk -F, '$3 ~ /^instructions/ {print $1}' "$perf_file")
    branches=$(awk -F, '$3 ~ /^branches/ {print $1}' "$perf_file")
    branch_misses=$(awk -F, '$3 ~ /^branch-misses/ {print $1}' "$perf_file")
    cache_misses=$(awk -F, '$3 ~ /^cache-misses/ {print $1}' "$perf_file")
    checksum=$(sed -n 's/.*checksum=\([0-9][0-9]*\).*/\1/p' "$stdout_file")
    printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \
        "$pair" "$variant" "$wall_ns" "$cycles" "$instructions" "$branches" \
        "$branch_misses" "$cache_misses" "$((rounds * queries))" "$checksum" >>"$samples"
}

for ((pair = 1; pair <= pairs; pair++)); do
    if ((pair % 2 == 1)); then
        run_one "$pair" baseline flat
        run_one "$pair" candidate structured
    else
        run_one "$pair" candidate structured
        run_one "$pair" baseline flat
    fi
done

sha256sum "$samples" "$metadata" >"$output_dir/SHA256SUMS"
