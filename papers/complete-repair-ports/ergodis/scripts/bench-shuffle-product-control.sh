#!/usr/bin/env bash
set -euo pipefail

binary=${1:-/home/tavis/.cache/ergodis/nix-target/release/examples/fork_join_cost_regular}
rounds=${ROUNDS:-9}
cpu=${CPU:-2}
repetitions=${ERGODIS_BENCH_REPETITIONS:-1000}

printf 'round\traw_states\tclasses\tidentity_classes\tfront\tidentity_ns\tquotient_ns\tfactorized_ns\tidentity_quotient\tquotient_factorized\n'
for ((round = 1; round <= rounds; round++)); do
    line=$(ERGODIS_BENCH_REPETITIONS=$repetitions taskset -c "$cpu" "$binary")
    awk -F '\t' -v round="$round" '
        {
            for (i = 2; i <= NF; i++) {
                split($i, pair, "=")
                value[pair[1]] = pair[2]
            }
            printf "%d\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n", round,
                value["raw_states"], value["classes"], value["identity_classes"], value["front"],
                value["identity_pareto_ns"], value["quotient_pareto_ns"],
                value["factorized_pareto_ns"], value["identity_quotient_ratio"],
                value["quotient_factorized_ratio"]
        }
    ' <<<"$line"
done
