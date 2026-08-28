#!/usr/bin/env bash
set -euo pipefail
evidence=${1:-papers/complete-repair-ports/ergodis/evidence/c985-fused-dense-final.tsv}
[[ $(wc -l < "$evidence") -eq 15 ]]
median() {
    awk -F '\t' -v implementation="$1" -v column="$2" \
        'NR>1&&$1==implementation{print $column}' "$evidence" | sort -n | sed -n '4p'
}
old=$(median baseline 3)
new=$(median full_rank_cache 3)
old_rss=$(median baseline 4)
new_rss=$(median full_rank_cache 4)
awk -v old="$old" -v new="$new" 'BEGIN{exit !(old/new>=1.40)}'
awk -v old="$old_rss" -v new="$new_rss" 'BEGIN{exit !(new/old<=1.10)}'
awk -v old="$old" -v new="$new" -v old_rss="$old_rss" -v new_rss="$new_rss" \
    'BEGIN{printf "rank-fused-dense time=%d/%d speedup=%.3fx rss=%d/%d\n",old,new,old/new,old_rss,new_rss}'
