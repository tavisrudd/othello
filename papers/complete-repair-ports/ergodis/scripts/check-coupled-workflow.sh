#!/usr/bin/env bash
set -euo pipefail

evidence=${1:-evidence/c985-coupled-workflow.tsv}
awk -F '\t' '
    NR == 1 {
        if ($0 != "round\traw_states\tclasses\tidentity_classes\treachable_classes\tpeak_live_classes\tpeak_live_entries\tcompile_ns\tidentity_ns\tquotient_ns\tidentity_quotient") exit 2
        next
    }
    {
        if ($2 != 46656 || $3 != 349 || $4 != 46656 || $5 != 101 || $6 != 23 || $7 != 23 || $8 <= 0 || $9 <= $10 || $10 <= 0) exit 3
        x = log($9 / $10)
        crossover_log += log($8 / ($9 - $10))
        sx += x; sxx += x * x; n++
    }
    END {
        if (n < 5) exit 4
        variance = (sxx - sx * sx / n) / (n - 1)
        t = (sx / n) / sqrt(variance / n)
        printf "rounds=%d identity_quotient_geomean=%.3f identity_quotient_log_t=%.2f compile_crossover_geomean=%.2f\n", n, exp(sx / n), t, exp(crossover_log / n)
    }
' "$evidence"
