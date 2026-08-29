#!/usr/bin/env bash
set -euo pipefail

binary=${1:-/home/tavis/.cache/ergodis/nix-target/release/examples/fork_join_cost_regular}
rounds=${ROUNDS:-9}
cpu=${CPU:-2}
repetitions=${ERGODIS_BENCH_REPETITIONS:-1000}

printf 'round\traw_states\tclasses\tidentity_classes\tfront\treachable_classes\tpeak_live_classes\tpeak_live_entries\tcompile_ns\tquery_plan_ns\tidentity_ns\tquotient_ns\tfactorized_ns\tidentity_quotient\tquotient_factorized\torder\trepetitions\n'
for ((round = 1; round <= rounds; round++)); do
    if ((round % 2)); then
        order=(identity quotient factorized)
    else
        order=(factorized quotient identity)
    fi
    declare -A stage_line=()
    for stage in "${order[@]}"; do
        stage_line[$stage]=$(ERGODIS_PROFILE_STAGE=$stage ERGODIS_BENCH_REPETITIONS=$repetitions taskset -c "$cpu" "$binary")
    done
    printf '%s\n%s\n%s\n' "${stage_line[identity]}" "${stage_line[quotient]}" "${stage_line[factorized]}" | awk -F '\t' -v round="$round" -v order="${order[*]}" -v repetitions="$repetitions" '
        {
            delete value
            for (i = 2; i <= NF; i++) {
                split($i, pair, "=")
                value[pair[1]] = pair[2]
            }
            if (NR == 1) identity_ns = value["identity_pareto_ns"]
            if (NR == 2) {
                raw_states = value["raw_states"]; classes = value["classes"]
                identity_classes = value["identity_classes"]; front = value["front"]
                reachable = value["reachable_classes"]; peak_classes = value["peak_live_classes"]
                peak_entries = value["peak_live_entries"]; compile_ns = value["compile_ns"]
                query_plan_ns = value["query_plan_ns"]; quotient_ns = value["quotient_pareto_ns"]
            }
            if (NR == 3) factorized_ns = value["factorized_pareto_ns"]
        }
        END {
            printf "%d\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%.3f\t%.3f\t%s\t%s\n", round,
                raw_states, classes, identity_classes, front, reachable, peak_classes, peak_entries,
                compile_ns, query_plan_ns, identity_ns, quotient_ns, factorized_ns,
                identity_ns / quotient_ns, quotient_ns / factorized_ns, order, repetitions
        }
    '
done
