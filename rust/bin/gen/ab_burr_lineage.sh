#!/usr/bin/env bash
# burr across last night's lineage: pre-rewrite (8edc10a, 05debb5) vs append-only (64d86db
# =1c6f390) vs HEAD+fix. If the early ones are fast now → the rewrite was a code regression;
# if all slow → box. n=14 has 0 freezes so the store rewrite shouldn't matter, but verify.
set -u
cd /home/tavis/src/othello/rust
printf '%-4s %-9s %14s %7s %7s %10s\n' rnd commit nodes secs Mnps cyc/node
for r in 1 2; do
  for e in "8edc10a:bin/gen/queens-8edc10a" "05debb5:bin/gen/queens-05debb5" "64d86db:bin/gen/queens-1c6f390" "HEAD:target/release/queens"; do
    tag=${e%%:*}; p=${e#*:}
    [ -x "$p" ] || { printf '%-4s %-9s   (missing binary)\n' "$r" "$tag"; continue; }
    out=$(perf stat -e cycles "$p" solve 14 burr --distinct 2>&1 | sed -E 's/\x1b\[[0-9;]*m//g')
    line=$(echo "$out" | grep -m1 searched)
    nodes=$(echo "$line" | grep -oE 'searched [0-9,]+' | tr -d 'a-z, ')
    secs=$(echo "$line"  | grep -oE 'in [0-9.]+s'      | tr -d 'a-zs ')
    cyc=$(echo "$out" | grep -oE '[0-9,]+ +cycles' | tr -d 'a-z, ' | head -1)
    mnps=$(awk -v n="$nodes" -v t="$secs" 'BEGIN{if(t>0)printf "%.2f",n/t/1e6; else print "?"}')
    cpn=$(awk -v c="${cyc:-0}" -v n="${nodes:-1}" 'BEGIN{if(n>0)printf "%.0f",c/n; else print "?"}')
    printf '%-4s %-9s %14s %7s %7s %10s\n' "$r" "$tag" "$nodes" "$secs" "$mnps" "$cpn"
  done
done
echo DONE
