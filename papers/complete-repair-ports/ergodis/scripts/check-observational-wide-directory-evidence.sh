#!/usr/bin/env bash
set -euo pipefail
evidence=${1:-papers/complete-repair-ports/ergodis/evidence/c985-wide-directory-final.tsv}
[[ $(wc -l < "$evidence") -eq 29 ]]
median() { awk -F '\t' -v f="$1" -v i="$2" -v n="$3" 'NR>1&&$1==f&&$2==i{print $n}' "$evidence" | sort -n | sed -n '4p'; }
for family in random-32 random-128; do
    old=$(median "$family" baseline 4); new=$(median "$family" wide 4)
    old_rss=$(median "$family" baseline 5); new_rss=$(median "$family" wide 5)
    awk -v old="$old" -v new="$new" 'BEGIN{exit !(old/new>=1.05)}'
    awk -v old="$old_rss" -v new="$new_rss" 'BEGIN{exit !(new/old<=1.05)}'
    awk -v f="$family" -v old="$old" -v new="$new" -v old_rss="$old_rss" -v new_rss="$new_rss" \
      'BEGIN{printf "%s time=%d/%d speedup=%.3fx rss=%d/%d\n",f,old,new,old/new,old_rss,new_rss}'
done
