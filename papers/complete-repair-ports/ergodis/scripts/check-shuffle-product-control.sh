#!/usr/bin/env bash
set -euo pipefail

evidence=${1:-evidence/c985-shuffle-product-control.tsv}
awk -F '\t' '
    NR == 1 {
        if ($0 != "round\traw_states\tclasses\tfront\traw_ns\tquotient_ns\tfactorized_ns\traw_quotient\tquotient_factorized") exit 2
        next
    }
    {
        if ($2 != 5184 || $3 != 153 || $4 != 3 || $5 <= 0 || $6 <= 0 || $7 <= 0) exit 3
        x = log($5 / $6)
        y = log($6 / $7)
        sx += x; sxx += x * x
        sy += y; syy += y * y
        n++
    }
    END {
        if (n < 5) exit 4
        vx = (sxx - sx * sx / n) / (n - 1)
        vy = (syy - sy * sy / n) / (n - 1)
        tx = (sx / n) / sqrt(vx / n)
        ty = (sy / n) / sqrt(vy / n)
        printf "rounds=%d raw_quotient_geomean=%.3f raw_quotient_log_t=%.2f quotient_factorized_geomean=%.3f quotient_factorized_log_t=%.2f\n", n, exp(sx / n), tx, exp(sy / n), ty
    }
' "$evidence"
