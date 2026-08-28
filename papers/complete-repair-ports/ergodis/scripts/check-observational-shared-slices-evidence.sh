#!/usr/bin/env bash
set -euo pipefail

evidence=${1:-papers/complete-repair-ports/ergodis/evidence/c985-shared-slices-final.tsv}
[[ $(sed -n '1p' "$evidence") == $'implementation\tround\tns_per_compile\tpeak_rss_kb' ]]
[[ $(wc -l < "$evidence") -eq 15 ]]
median_field() {
    awk -F '\t' -v implementation="$1" -v field="$2" \
        'NR > 1 && $1 == implementation { print $field }' "$evidence" |
        sort -n | sed -n '4p'
}
baseline_ns=$(median_field baseline 3)
shared_ns=$(median_field basis_replay 3)
baseline_rss=$(median_field baseline 4)
shared_rss=$(median_field basis_replay 4)
awk -v old="$baseline_ns" -v new="$shared_ns" \
    'BEGIN { ratio = old / new; exit !(ratio >= 0.85 && ratio <= 1.15) }'
awk -v old="$baseline_rss" -v new="$shared_rss" 'BEGIN { exit !(old / new >= 1.2) }'
awk -v old="$baseline_ns" -v new="$shared_ns" \
    'BEGIN { printf "time_median_ns=%d/%d ratio=%.3fx\n", old, new, old / new }'
awk -v old="$baseline_rss" -v new="$shared_rss" \
    'BEGIN { printf "rss_median_kb=%d/%d reduction=%.2f%%\n", old, new, 100 * (old - new) / old }'
