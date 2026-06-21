#!/usr/bin/env bash
# Interleaved n=16 A/B over several QUEENS_DENSE_K values on one binary (abenv does 2 values;
# this sweeps a list). Same lessons: bare run for the live bar, results from --to-file JSON,
# cyc from perf stat -o, 12 GB TT, per-K means + deltas vs the first K. DONE only as output.
#   ksweep.sh <n> <bin> <tt_slots> <rounds> <K1> <K2> ...
set -u
N=${1:?n}; BIN=${2:?bin}; TT=${3:?tt}; ROUNDS=${4:?rounds}; shift 4; KS=("$@")
OUT=$(mktemp -d /tmp/ksweep.XXXXXX)
tt=""; [ "$TT" != 0 ] && tt="QUEENS_TT_SLOTS=$TT"
echo "######## ksweep n=$N bin=$BIN TT=$TT rounds=$ROUNDS Ks=${KS[*]} out=$OUT ########"
for r in $(seq 1 "$ROUNDS"); do
  for k in "${KS[@]}"; do
    tag="K${k}_r${r}"
    echo "=== BEGIN $tag ==="
    env $tt "QUEENS_DENSE_K=$k" perf stat -o "$OUT/$tag.perf" -e cycles -- "$BIN" solve "$N" iso-dense --to-file "$OUT/$tag.json" 2>/dev/null
    n=$(grep -oE '"nodes": [0-9]+' "$OUT/$tag.json" | grep -oE '[0-9]+')
    w=$(grep -oE '"wall_secs": [0-9.]+' "$OUT/$tag.json" | grep -oE '[0-9.]+')
    c=$(grep -E 'cycles' "$OUT/$tag.perf" | grep -oE '^[ ]*[0-9,]+' | tr -d ' ,')
    awk -v t="$tag" -v n="$n" -v w="$w" -v c="$c" 'BEGIN{printf "RESULT %s nodes=%s wall=%.2f cyc/node=%.1f\n", t, n, w, c/n}'
    echo "=== END $tag ==="
  done
done
echo "==== AGGREGATE ===="
{ for r in $(seq 1 "$ROUNDS"); do for k in "${KS[@]}"; do
    j="$OUT/K${k}_r${r}.json"; p="$OUT/K${k}_r${r}.perf"
    n=$(grep -oE '"nodes": [0-9]+' "$j" | grep -oE '[0-9]+'); w=$(grep -oE '"wall_secs": [0-9.]+' "$j" | grep -oE '[0-9.]+')
    c=$(grep -E 'cycles' "$p" | grep -oE '^[ ]*[0-9,]+' | tr -d ' ,'); echo "$k $n $w $c"
  done; done; } | awk '
    {cnt[$1]++; nn[$1]+=$2; ww[$1]+=$3; cc[$1]+=$4; if(ord[$1]==0){order[++no]=$1; ord[$1]=1}}
    END{ for(i=1;i<=no;i++){k=order[i]; an=nn[k]/cnt[k]; aw=ww[k]/cnt[k]; ac=cc[k]/nn[k];
           if(i==1){bw=aw}
           printf "K=%s mean: nodes=%.0f wall=%.2f cyc/node=%.1f  wall_vs_first=%+.1f%%\n",k,an,aw,ac,100*(aw-bw)/bw; } }'
echo "KSWEEP_DONE out=$OUT"
