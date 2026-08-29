#!/usr/bin/env bash
set -euo pipefail

binary=${1:-/home/tavis/.cache/ergodis/nix-target/release/examples/fork_join_cost_regular}
rounds=${ROUNDS:-9}
cpu=${CPU:-2}
repetitions=${ERGODIS_BENCH_REPETITIONS:-1000}

printf 'round\traw_states\tclasses\tidentity_classes\treachable_classes\tpeak_live_classes\tpeak_live_entries\tcompile_ns\tidentity_ns\tquotient_ns\tidentity_quotient\n'
for ((round = 1; round <= rounds; round++)); do
    line=$(ERGODIS_COUPLED=1 ERGODIS_BENCH_REPETITIONS=$repetitions taskset -c "$cpu" "$binary")
    awk -F '\t' -v round="$round" '
        {
            for (i = 2; i <= NF; i++) {
                split($i, pair, "=")
                value[pair[1]] = pair[2]
            }
            printf "%d\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n", round,
                value["raw_states"], value["classes"], value["identity_classes"],
                value["reachable_classes"], value["peak_live_classes"], value["peak_live_entries"],
                value["compile_ns"], value["identity_pareto_ns"], value["quotient_pareto_ns"],
                value["identity_quotient_ratio"]
        }
    ' <<<"$line"
done
