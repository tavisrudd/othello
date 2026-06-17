#!/usr/bin/env bash
# A/B the `incremental` solver (canonical memory-latency baseline): 1c6f390 vs HEAD+fix.
# Handoff reference: incremental cold ~14 M/s at n=14. ~7 M/s = the 2x memory regression.
set -u
cd /home/tavis/src/othello/rust
OLD=bin/gen/queens-1c6f390
NEW=target/release/queens
printf '%-4s %-8s %-11s %14s %7s %7s %10s\n' rnd bin solver nodes secs Mnps cyc/node
for r in 1 2 3; do
  for entry in "1c6f390:$OLD" "HEAD+fix:$NEW"; do
    tag=${entry%%:*}; path=${entry#*:}
    out=$(perf stat -e cycles "$path" solve 14 incremental --distinct 2>&1 | sed -E 's/\x1b\[[0-9;]*m//g')
    line=$(echo "$out" | grep -m1 searched)
    nodes=$(echo "$line" | grep -oE 'searched [0-9,]+' | tr -d 'a-z, ')
    secs=$(echo "$line"  | grep -oE 'in [0-9.]+s'      | tr -d 'a-zs ')
    cyc=$(echo "$out" | grep -oE '[0-9,]+ +cycles' | tr -d 'a-z, ' | head -1)
    mnps=$(awk -v n="$nodes" -v t="$secs" 'BEGIN{if(t>0)printf "%.2f",n/t/1e6; else print "?"}')
    cpn=$(awk -v c="${cyc:-0}" -v n="${nodes:-1}" 'BEGIN{if(n>0)printf "%.0f",c/n; else print "?"}')
    printf '%-4s %-8s %-11s %14s %7s %7s %10s\n' "$r" "$tag" incremental "$nodes" "$secs" "$mnps" "$cpn"
  done
done
echo DONE
