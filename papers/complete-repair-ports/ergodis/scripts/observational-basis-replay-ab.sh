#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 2 ]]; then
    echo "usage: $0 BASELINE_DRIVER BASIS_REPLAY_DRIVER" >&2
    exit 2
fi

baseline=$1
basis_replay=$2
cpu=${ERGODIS_CPU:-2}
rounds=${ERGODIS_ROUNDS:-7}

printf 'implementation\tround\tns_per_compile\tpeak_rss_kb\n'
run_one() {
    local implementation=$1
    local binary=$2
    local round=$3
    local measured
    measured=$({ /usr/bin/time -f '%M' taskset -c "$cpu" "$binary" \
        redundant 131072 32 2 2 transcript; } 2>&1)
    local result rss
    result=$(printf '%s\n' "$measured" | sed -n '1p')
    rss=$(printf '%s\n' "$measured" | sed -n '2p')
    printf '%s\t%s\t%s\t%s\n' \
        "$implementation" "$round" "$(printf '%s\n' "$result" | cut -f 7)" "$rss"
}

for ((round = 1; round <= rounds; round++)); do
    run_one baseline "$baseline" "$round"
    run_one basis_replay "$basis_replay" "$round"
done
