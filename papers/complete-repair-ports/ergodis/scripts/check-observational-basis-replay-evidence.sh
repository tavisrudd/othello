#!/usr/bin/env bash
set -euo pipefail

evidence=${1:-papers/complete-repair-ports/ergodis/evidence/c985-basis-replay-final.tsv}
expected=$'implementation\tround\tns_per_compile\tpeak_rss_kb'
[[ $(sed -n '1p' "$evidence") == "$expected" ]]
[[ $(wc -l < "$evidence") -eq 15 ]]

median_field() {
    local implementation=$1 field=$2
    awk -F '\t' -v implementation="$implementation" -v field="$field" \
        'NR > 1 && $1 == implementation { print $field }' "$evidence" |
        sort -n | sed -n '4p'
}

baseline_ns=$(median_field baseline 3)
basis_ns=$(median_field basis_replay 3)
baseline_rss=$(median_field baseline 4)
basis_rss=$(median_field basis_replay 4)
awk -v old="$baseline_ns" -v new="$basis_ns" 'BEGIN { exit !(old / new >= 1.5) }'
awk -v old="$baseline_rss" -v new="$basis_rss" 'BEGIN { exit !(old / new >= 1.3) }'
awk -v old="$baseline_ns" -v new="$basis_ns" \
    'BEGIN { printf "time_median_ns=%d/%d speedup=%.3fx\n", old, new, old / new }'
awk -v old="$baseline_rss" -v new="$basis_rss" \
    'BEGIN { printf "rss_median_kb=%d/%d reduction=%.2f%%\n", old, new, 100 * (old - new) / old }'
