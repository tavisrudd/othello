#!/usr/bin/env bash
set -euo pipefail

evidence=${1:-evidence/c985-coupled-workflow.tsv}
awk -F '\t' '
    NR == 1 {
        if ($0 != "round\traw_states\tclasses\tidentity_classes\treachable_classes\tpeak_live_classes\tpeak_live_entries\tcompile_ns\tquery_plan_ns\tidentity_ns\tquotient_ns\tfactorized_ns\tidentity_quotient\tquotient_factorized\torder\trepetitions") exit 2
        next
    }
    {
        expected_order = ($1 % 2) ? "identity quotient factorized" : "factorized quotient identity"
        if ($1 != NR - 1 || $15 != expected_order || $2 != 46656 || $3 != 349 || $4 != 46656 || $5 != 101 || $6 != 23 || $7 != 23 || $8 <= 0 || $9 <= 0 || $10 <= $11 || $11 <= 0 || $12 <= 0 || $16 != 1000) exit 3
        x = log($10 / $11)
        y = log($11 / $12)
        crossover_log += log(($8 + $9) / ($10 - $11))
        sx += x; sxx += x * x
        sy += y; syy += y * y; n++
    }
    END {
        if (n != 9) exit 4
        variance = (sxx - sx * sx / n) / (n - 1)
        t = (sx / n) / sqrt(variance / n)
        variance_y = (syy - sy * sy / n) / (n - 1)
        t_y = (sy / n) / sqrt(variance_y / n)
        printf "rounds=%d identity_quotient_geomean=%.3f identity_quotient_log_t=%.2f quotient_factorized_geomean=%.3f quotient_factorized_log_t=%.2f compile_crossover_geomean=%.2f\n", n, exp(sx / n), t, exp(sy / n), t_y, exp(crossover_log / n)
    }
' "$evidence"
