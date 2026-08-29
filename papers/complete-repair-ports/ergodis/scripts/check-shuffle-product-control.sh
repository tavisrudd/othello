#!/usr/bin/env bash
set -euo pipefail

evidence=${1:-evidence/c985-shuffle-product-control.tsv}
awk -F '\t' '
    NR == 1 {
        if ($0 != "round\traw_states\tclasses\tidentity_classes\tfront\treachable_classes\tpeak_live_classes\tpeak_live_entries\tcompile_ns\tquery_plan_ns\tidentity_ns\tquotient_ns\tfactorized_ns\tidentity_quotient\tquotient_factorized\torder\trepetitions") exit 2
        next
    }
    {
        if ($2 != 5184 || $3 != 153 || $4 != 5184 || $5 != 3 || $6 != 96 || $7 != 22 || $8 != 26 || $9 <= 0 || $10 <= 0 || $11 <= $12 || $12 <= 0 || $13 <= 0 || $17 != 1000) exit 3
        x = log($11 / $12)
        y = log($12 / $13)
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
        printf "rounds=%d identity_quotient_geomean=%.3f identity_quotient_log_t=%.2f quotient_factorized_geomean=%.3f quotient_factorized_log_t=%.2f\n", n, exp(sx / n), tx, exp(sy / n), ty
    }
' "$evidence"
