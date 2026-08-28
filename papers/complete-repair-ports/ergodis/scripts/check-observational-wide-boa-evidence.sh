#!/usr/bin/env bash
set -euo pipefail
evidence=${1:-papers/complete-repair-ports/ergodis/evidence/c985-wide-boa-final.tsv}
[[ $(wc -l < "$evidence") -eq 15 ]]
median() {
    awk -F '\t' -v implementation="$1" \
        'NR>1&&$1==implementation{print $3}' "$evidence" | sort -n | sed -n '4p'
}
for implementation in ergodis boa; do
    awk -F '\t' -v implementation="$implementation" \
        'NR>1&&$1==implementation{if($4!=65536)exit 1; count++}END{exit count==7?0:1}' "$evidence"
done
ergodis=$(median ergodis)
boa=$(median boa)
awk -v ergodis="$ergodis" -v boa="$boa" 'BEGIN{exit !(boa/ergodis>=1.02)}'
awk -v ergodis="$ergodis" -v boa="$boa" \
    'BEGIN{printf "random-128 ergodis=%d boa=%d ergodis_speedup=%.3fx\n",ergodis,boa,boa/ergodis}'
