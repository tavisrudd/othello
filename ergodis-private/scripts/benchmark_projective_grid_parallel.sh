#!/usr/bin/env bash
set -euo pipefail

# BINARY is the `ergodis-tools` executable; the scout subcommand is added here.
binary=${1:?usage: benchmark_projective_grid_parallel.sh BINARY [ROUNDS] [STATES] [THREADS]}
rounds=${2:-7}
states=${3:-10000}
parallel_threads=${4:-24}

printf 'round\tserial_seconds\tparallel_seconds\n'
for ((round = 1; round <= rounds; round++)); do
    if ((round % 2)); then
        first=1
        second=$parallel_threads
    else
        first=$parallel_threads
        second=1
    fi
    first_output=$(
        "$binary" projective-grid-scout --q 11 --states "$states" --threads "$first"
    )
    second_output=$(
        "$binary" projective-grid-scout --q 11 --states "$states" --threads "$second"
    )
    first_seconds=$(sed -E 's/.*"elapsed_seconds":([^,]+).*/\1/' <<<"$first_output")
    second_seconds=$(sed -E 's/.*"elapsed_seconds":([^,]+).*/\1/' <<<"$second_output")
    first_metrics=$(sed -E 's/.*"metrics":(\{[^}]+\}).*/\1/' <<<"$first_output")
    second_metrics=$(sed -E 's/.*"metrics":(\{[^}]+\}).*/\1/' <<<"$second_output")
    if [[ $first_metrics != "$second_metrics" ]]; then
        echo "serial/parallel metric mismatch in round $round" >&2
        exit 2
    fi
    if ((first == 1)); then
        printf '%s\t%s\t%s\n' "$round" "$first_seconds" "$second_seconds"
    else
        printf '%s\t%s\t%s\n' "$round" "$second_seconds" "$first_seconds"
    fi
done
