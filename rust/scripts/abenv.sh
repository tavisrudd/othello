#!/usr/bin/env bash
# Interleaved A/B toggling ONE env var between two VALUES on one binary (the committed
# queens-ab.sh only toggles 0/1; this takes arbitrary value pairs — e.g. QUEENS_DENSE_K 12 vs 13,
# QUEENS_WARM_SECS 2 vs 3). Same lessons: bare run so the live bar renders, results from --to-file
# JSON, cyc from `perf stat -o`, 12 GB TT, BEGIN/END markers, DONE only as output.
#   abenv.sh <n> <bin> <ENVNAME> <valA> <valB> [rounds] [tt_slots] [solver]
set -u
N=${1:?n}; BIN=${2:?bin}; EV=${3:?envname}; VA=${4:?valA}; VB=${5:?valB}
ROUNDS=${6:-3}; TT=${7:-1500000000}; SOLVER=${8:-iso-dense}
OUT=$(mktemp -d /tmp/abenv.XXXXXX)
tt=""; [ "$TT" != 0 ] && tt="QUEENS_TT_SLOTS=$TT"
echo "######## abenv n=$N bin=$BIN $EV: A=$VA B=$VB rounds=$ROUNDS TT=$TT out=$OUT ########"
run() { # $1=tag $2=val
  echo "=== BEGIN $1 ($EV=$2) ==="
  env $tt "$EV=$2" perf stat -o "$OUT/$1.perf" -e cycles -- "$BIN" solve "$N" "$SOLVER" --to-file "$OUT/$1.json" 2>/dev/null
  local n w c
  n=$(grep -oE '"nodes": [0-9]+' "$OUT/$1.json" | grep -oE '[0-9]+')
  w=$(grep -oE '"wall_secs": [0-9.]+' "$OUT/$1.json" | grep -oE '[0-9.]+')
  c=$(grep -E 'cycles' "$OUT/$1.perf" | grep -oE '^[ ]*[0-9,]+' | tr -d ' ,')
  awk -v t="$1" -v n="$n" -v w="$w" -v c="$c" 'BEGIN{printf "RESULT %s nodes=%s wall=%.2f cyc=%s cyc/node=%.1f\n", t, n, w, c, c/n}'
  echo "=== END $1 ==="
}
for r in $(seq 1 "$ROUNDS"); do run "A_$r" "$VA"; run "B_$r" "$VB"; done
echo "==== AGGREGATE ===="
{ for r in $(seq 1 "$ROUNDS"); do for s in A B; do
    j="$OUT/${s}_${r}.json"; p="$OUT/${s}_${r}.perf"
    n=$(grep -oE '"nodes": [0-9]+' "$j" | grep -oE '[0-9]+'); w=$(grep -oE '"wall_secs": [0-9.]+' "$j" | grep -oE '[0-9.]+')
    c=$(grep -E 'cycles' "$p" | grep -oE '^[ ]*[0-9,]+' | tr -d ' ,'); echo "$s $n $w $c"
  done; done; } | awk '
    {cnt[$1]++; nn[$1]+=$2; ww[$1]+=$3; cc[$1]+=$4}
    END{ an=nn["A"]/cnt["A"];aw=ww["A"]/cnt["A"];ac=cc["A"]/cnt["A"];bn=nn["B"]/cnt["B"];bw=ww["B"]/cnt["B"];bc=cc["B"]/cnt["B"];
      printf "A(%s) mean: nodes=%.0f wall=%.2f cyc/node=%.1f\n","'"$VA"'",an,aw,ac/an;
      printf "B(%s) mean: nodes=%.0f wall=%.2f cyc/node=%.1f\n","'"$VB"'",bn,bw,bc/bn;
      printf "DELTA B vs A: nodes %+.1f%%  wall %+.1f%%  cyc/node %+.1f%%\n",100*(bn-an)/an,100*(bw-aw)/aw,100*(bc/bn-ac/an)/(ac/an); }'
echo "ABENV_DONE out=$OUT"
