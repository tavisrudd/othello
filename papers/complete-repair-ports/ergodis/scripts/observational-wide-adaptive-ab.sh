#!/usr/bin/env bash
set -euo pipefail
[[ $# -eq 2 ]] || { echo "usage: $0 BASELINE_DRIVER WIDE_DRIVER" >&2; exit 2; }
cpu=${ERGODIS_CPU:-2}
rounds=${ERGODIS_ROUNDS:-7}
printf 'family\timplementation\tround\tns_per_compile\tpeak_rss_kb\n'
run_one() {
    local family=$1 states=$2 generators=$3 implementation=$4 binary=$5 round=$6 measured result
    measured=$({ /usr/bin/time -f '%M' taskset -c "$cpu" "$binary" \
        "$family" "$states" "$generators" 1 2 adaptive-deferred; } 2>&1)
    result=$(printf '%s\n' "$measured" | sed -n '1p')
    printf '%s\t%s\t%s\t%s\t%s\n' "$family-$generators" "$implementation" "$round" \
        "$(printf '%s\n' "$result" | cut -f 7)" "$(printf '%s\n' "$measured" | sed -n '2p')"
}
for ((round = 1; round <= rounds; round++)); do
    for spec in 'random 131072 32' 'random 65536 128'; do
        read -r family states generators <<< "$spec"
        run_one "$family" "$states" "$generators" baseline "$1" "$round"
        run_one "$family" "$states" "$generators" wide "$2" "$round"
    done
done
