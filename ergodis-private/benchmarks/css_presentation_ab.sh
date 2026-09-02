#!/bin/sh
set -eu

if [ "$#" -ne 9 ] && [ "$#" -ne 10 ]; then
    echo "usage: $0 BASE_BIN INPUT SEED MAX_WEIGHT SHARD_INDEX SHARD_COUNT THREADS ROUNDS OUTPUT [CANDIDATE_BIN]" >&2
    exit 2
fi

baseline_binary=$1
input=$2
candidate_seed=$3
maximum_weight=$4
shard_index=$5
shard_count=$6
threads=$7
rounds=$8
output=$9
candidate_binary=${10:-$baseline_binary}
solve_rounds=${CSS_PRESENTATION_AB_SOLVE_ROUNDS:-1}
work_dir="${output}.work"

test -x "$baseline_binary"
test -x "$candidate_binary"
test -f "$input"
case "$solve_rounds" in
    ''|*[!0-9]*|0) echo "CSS_PRESENTATION_AB_SOLVE_ROUNDS must be a positive integer" >&2; exit 2 ;;
esac
test ! -e "$output"
test ! -e "$work_dir"
mkdir "$work_dir"
cleanup() {
    find "$work_dir" -depth -delete
}
trap cleanup EXIT HUP INT TERM

set -C
printf 'round\tvariant\tseed\tcandidates\tduration_ns\ttask_clock_ms\tcycles\tinstructions\tbranches\tbranch_misses\tcache_misses\n' > "$output"
set +C

run_one() {
    round=$1
    variant=$2
    binary=$3
    seed=$4
    stats="$work_dir/$round-$variant.perf"
    result="$work_dir/$round-$variant.json"
    if [ "$seed" = none ]; then
        perf stat -x '\t' -o "$stats" \
            -e duration_time,task-clock,cycles,instructions,branches,branch-misses,cache-misses \
            -- choom -n 500 -- "$binary" \
            --input "$input" --maximum-weight "$maximum_weight" \
            --threads "$threads" --shard-index "$shard_index" --shard-count "$shard_count" \
            --rounds "$solve_rounds" \
            > "$result"
    else
        perf stat -x '\t' -o "$stats" \
            -e duration_time,task-clock,cycles,instructions,branches,branch-misses,cache-misses \
            -- choom -n 500 -- "$binary" \
            --input "$input" --maximum-weight "$maximum_weight" \
            --threads "$threads" --shard-index "$shard_index" --shard-count "$shard_count" \
            --rounds "$solve_rounds" \
            --check-presentation-seed "$seed" > "$result"
    fi
    candidates=$(jq -r '.result.stats.candidates' "$result")
    awk -F '\t' -v round="$round" -v variant="$variant" -v seed="$seed" \
        -v candidates="$candidates" '
        $3 == "duration_time" { duration = $1 }
        $3 == "task-clock:u" { task = $1 }
        $3 == "cycles:u" { cycles = $1 }
        $3 == "instructions:u" { instructions = $1 }
        $3 == "branches:u" { branches = $1 }
        $3 == "branch-misses:u" { branch_misses = $1 }
        $3 == "cache-misses:u" { cache_misses = $1 }
        END {
            if (duration == "" || task == "" || cycles == "" || instructions == "" ||
                branches == "" || branch_misses == "" || cache_misses == "") exit 1
            printf "%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n",
                round, variant, seed, candidates, duration, task, cycles, instructions,
                branches, branch_misses, cache_misses
        }
    ' "$stats" >> "$output"
    unlink "$stats"
    unlink "$result"
}

round=0
while [ "$round" -lt "$rounds" ]; do
    if [ $((round & 1)) -eq 0 ]; then
        run_one "$round" baseline "$baseline_binary" none
        run_one "$round" candidate "$candidate_binary" "$candidate_seed"
    else
        run_one "$round" candidate "$candidate_binary" "$candidate_seed"
        run_one "$round" baseline "$baseline_binary" none
    fi
    round=$((round + 1))
done
