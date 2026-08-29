#!/usr/bin/env bash
set -euo pipefail

evidence=${1:-evidence/c985-coupled-workflow.tsv}
awk -F '\t' '
    NR == 1 {
        if ($0 != "round\traw_states\tclasses\tidentity_classes\treachable_classes\tpeak_live_classes\tpeak_live_entries\tcompile_ns\tidentity_ns\tquotient_ns\tfactorized_ns\tidentity_quotient\tquotient_factorized") exit 2
        next
    }
    {
        if ($2 != 46656 || $3 != 349 || $4 != 46656 || $5 != 101 || $6 != 23 || $7 != 23 || $8 <= 0 || $9 <= $10 || $10 <= 0 || $11 <= 0) exit 3
        x = log($9 / $10)
        y = log($10 / $11)
        crossover_log += log($8 / ($9 - $10))
        sx += x; sxx += x * x
        sy += y; syy += y * y; n++
    }
    END {
        if (n < 5) exit 4
        variance = (sxx - sx * sx / n) / (n - 1)
        t = (sx / n) / sqrt(variance / n)
        variance_y = (syy - sy * sy / n) / (n - 1)
        t_y = (sy / n) / sqrt(variance_y / n)
        printf "rounds=%d identity_quotient_geomean=%.3f identity_quotient_log_t=%.2f quotient_factorized_geomean=%.3f quotient_factorized_log_t=%.2f compile_crossover_geomean=%.2f\n", n, exp(sx / n), t, exp(sy / n), t_y, exp(crossover_log / n)
    }
' "$evidence"
