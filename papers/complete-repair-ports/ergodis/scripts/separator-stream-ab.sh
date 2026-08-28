#!/usr/bin/env bash
set -euo pipefail
[[ $# -eq 2 ]] || { echo "usage: $0 BASELINE_BENCH CANDIDATE_BENCH" >&2; exit 2; }
cpu=${ERGODIS_CPU:-2}
rounds=${ERGODIS_ROUNDS:-7}
filter=observational_separator_stream/long_chain/64
printf 'implementation\tround\tns_per_stream\tpeak_rss_kb\n'
run_one() {
    local implementation=$1 binary=$2 round=$3 measured result rss
    measured=$({ /usr/bin/time -f '%M' taskset -c "$cpu" "$binary" \
        --bench "$filter" --warm-up-time 0.1 --measurement-time 0.2 \
        --sample-size 10 --noplot --output-format bencher; } 2>&1)
    result=$(printf '%s\n' "$measured" | sed -n 's/.*bench:[[:space:]]*\([0-9,]*\) ns\/iter.*/\1/p' | tr -d ',')
    rss=$(printf '%s\n' "$measured" | tail -n 1)
    [[ $result =~ ^[0-9]+$ && $rss =~ ^[0-9]+$ ]]
    printf '%s\t%s\t%s\t%s\n' "$implementation" "$round" "$result" "$rss"
}
for ((round = 1; round <= rounds; round++)); do
    run_one baseline "$1" "$round"
    run_one arena "$2" "$round"
done
