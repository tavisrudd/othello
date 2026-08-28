#!/usr/bin/env bash
set -euo pipefail
evidence=${1:-papers/complete-repair-ports/ergodis/evidence/c985-wide-adaptive-final.tsv}
[[ $(sed -n '1p' "$evidence") == $'family\timplementation\tround\tns_per_compile\tpeak_rss_kb' ]]
[[ $(wc -l < "$evidence") -eq 29 ]]
median() {
    awk -F '\t' -v family="$1" -v implementation="$2" -v field="$3" \
        'NR > 1 && $1 == family && $2 == implementation { print $field }' "$evidence" |
        sort -n | sed -n '4p'
}
for family in random-32 random-128; do
    old_ns=$(median "$family" baseline 4); new_ns=$(median "$family" wide 4)
    old_rss=$(median "$family" baseline 5); new_rss=$(median "$family" wide 5)
    awk -v old="$old_ns" -v new="$new_ns" 'BEGIN { exit !(old / new >= 3) }'
    awk -v old="$old_rss" -v new="$new_rss" 'BEGIN { exit !(old / new >= 1.5) }'
    awk -v family="$family" -v old="$old_ns" -v new="$new_ns" \
        -v old_rss="$old_rss" -v new_rss="$new_rss" \
        'BEGIN { printf "%s time=%d/%d speedup=%.3fx rss=%d/%d reduction=%.2f%%\n", family, old, new, old/new, old_rss, new_rss, 100*(old_rss-new_rss)/old_rss }'
done
