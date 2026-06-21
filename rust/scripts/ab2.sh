#!/usr/bin/env bash
# Two-BINARY interleaved A/B (the committed queens-ab.sh toggles one env flag on ONE binary;
# this compares two DIFFERENT binaries A vs B, for code-vs-code changes). Same hard-won lessons:
# fresh tmux window, bare command so the live bar renders, results parsed from --to-file JSON,
# cyc/node from `perf stat -o` (so the bar on stderr is untouched), 12 GB TT (memory-safe),
# BEGIN/END markers, a final DONE marker that only appears as OUTPUT.
#   ab2.sh <n> <binA> <binB> [rounds] [tt_slots] [solver] [extra_env]
set -u
N=${1:?n}; A=${2:?binA}; B=${3:?binB}; ROUNDS=${4:-3}
TT=${5:-1500000000}; SOLVER=${6:-iso-dense}; XENV=${7:-}
OUT=$(mktemp -d /tmp/ab2.XXXXXX)
tt=""; [ "$TT" != 0 ] && tt="QUEENS_TT_SLOTS=$TT"
echo "######## ab2 n=$N A=$A B=$B rounds=$ROUNDS TT=$TT env=[$XENV] out=$OUT ########"
run() { # $1=tag $2=bin
  echo "=== BEGIN $1 ==="
  env $tt $XENV perf stat -o "$OUT/$1.perf" -e cycles -- "$2" solve "$N" "$SOLVER" --to-file "$OUT/$1.json" 2>/dev/null
  local nodes wall cyc
  nodes=$(grep -oE '"nodes": [0-9]+' "$OUT/$1.json" | grep -oE '[0-9]+')
  wall=$(grep -oE '"wall_secs": [0-9.]+' "$OUT/$1.json" | grep -oE '[0-9.]+')
  cyc=$(grep -E 'cycles' "$OUT/$1.perf" | grep -oE '^[ ]*[0-9,]+' | tr -d ' ,')
  awk -v t="$1" -v n="$nodes" -v w="$wall" -v c="$cyc" 'BEGIN{printf "RESULT %s nodes=%s wall=%.2f cyc=%s cyc/node=%.1f\n", t, n, w, c, c/n}'
  echo "=== END $1 ==="
}
for r in $(seq 1 "$ROUNDS"); do run "A_$r" "$A"; run "B_$r" "$B"; done
echo "==== AGGREGATE ===="
grep -h "^RESULT" "$OUT"/*.json.notused 2>/dev/null
{ for r in $(seq 1 "$ROUNDS"); do
    for s in A B; do
      j="$OUT/${s}_${r}.json"; p="$OUT/${s}_${r}.perf"
      n=$(grep -oE '"nodes": [0-9]+' "$j" | grep -oE '[0-9]+'); w=$(grep -oE '"wall_secs": [0-9.]+' "$j" | grep -oE '[0-9.]+')
      c=$(grep -E 'cycles' "$p" | grep -oE '^[ ]*[0-9,]+' | tr -d ' ,')
      echo "$s $n $w $c"
    done
  done; } | awk '
    {cnt[$1]++; nn[$1]+=$2; ww[$1]+=$3; cc[$1]+=$4}
    END{
      an=nn["A"]/cnt["A"]; aw=ww["A"]/cnt["A"]; ac=cc["A"]/cnt["A"];
      bn=nn["B"]/cnt["B"]; bw=ww["B"]/cnt["B"]; bc=cc["B"]/cnt["B"];
      printf "A mean: nodes=%.0f wall=%.2f cyc/node=%.1f\n", an, aw, ac/an;
      printf "B mean: nodes=%.0f wall=%.2f cyc/node=%.1f\n", bn, bw, bc/bn;
      printf "DELTA B vs A: nodes %+.1f%%  wall %+.1f%%  cyc/node %+.1f%%  totalcyc %+.1f%%\n",
        100*(bn-an)/an, 100*(bw-aw)/aw, 100*(bc/bn-ac/an)/(ac/an), 100*(bc-cc["A"]/cnt["A"])/(cc["A"]/cnt["A"]);
    }'
echo "AB2_DONE out=$OUT"
