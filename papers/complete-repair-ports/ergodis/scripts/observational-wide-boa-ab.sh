#!/usr/bin/env bash
set -euo pipefail
[[ $# -eq 3 ]] || { echo "usage: $0 ERGODIS_DRIVER BOA_SOURCE FIXTURE" >&2; exit 2; }
ergodis=$1
boa_source=$2
fixture=$3
cpu=${ERGODIS_CPU:-2}
rounds=${ERGODIS_ROUNDS:-7}
boa=${boa_source}/target/release/boa
[[ -x $ergodis && -x $boa && -f $fixture ]]
[[ $(git -C "$boa_source" rev-parse HEAD) == 54a556448169a83a369e039b5fa3ba27323ccfde ]]
printf 'implementation\tround\tns_per_compile\tclasses\trefinements\n'
run_ergodis() {
    local round=$1 result
    result=$(taskset -c "$cpu" "$ergodis" random 65536 128 1 2 adaptive-deferred)
    printf 'ergodis\t%s\t%s\t%s\t%s\n' "$round" \
        "$(cut -f 7 <<<"$result")" "$(cut -f 8 <<<"$result")" "$(cut -f 9 <<<"$result")"
}
run_boa() {
    local round=$1 result seconds classes refinements
    result=$(taskset -c "$cpu" "$boa" nlogn "$fixture")
    seconds=$(awk '/^algorithm_time_s:/ {print $2}' <<<"$result")
    classes=$(awk '/^n_states_min:/ {print $2}' <<<"$result")
    refinements=$(awk '/^iters:/ {print $2}' <<<"$result")
    awk -v round="$round" -v seconds="$seconds" -v classes="$classes" \
        -v refinements="$refinements" \
        'BEGIN{printf "boa\t%s\t%.0f\t%s\t%s\n",round,seconds*1e9,classes,refinements}'
}
for ((round = 1; round <= rounds; round++)); do
    if ((round % 2 == 1)); then
        run_ergodis "$round"
        run_boa "$round"
    else
        run_boa "$round"
        run_ergodis "$round"
    fi
done
