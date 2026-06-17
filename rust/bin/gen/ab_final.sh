#!/usr/bin/env bash
# A/B after a power-state change or reboot:
#   queens-1c6f390      = last-night code (no fused, no madvise fix)
#   target/release/queens = current HEAD + madvise fix
# Interleaved, n=14 burr + iso-burr, with per-node cycles via perf.
# Degraded baseline to beat: burr ~7.3s / ~5,600 cyc-node was last-night-fast,
#   ~11,800 cyc-node was the regression; IPC 0.23 degraded.
set -u
cd /home/tavis/src/othello/rust
OLD=bin/gen/queens-1c6f390
NEW=target/release/queens
printf '%-4s %-8s %-9s %14s %7s %7s %10s\n' rnd bin solver nodes secs Mnps cyc/node
for r in 1 2; do
  for entry in "1c6f390:$OLD" "HEAD+fix:$NEW"; do
    tag=${entry%%:*}; path=${entry#*:}
    for s in burr iso-burr; do
      out=$(perf stat -e cycles "$path" solve 14 "$s" --distinct 2>&1 | sed -E 's/\x1b\[[0-9;]*m//g')
      line=$(echo "$out" | grep -m1 searched)
      nodes=$(echo "$line" | grep -oE 'searched [0-9,]+' | tr -d 'a-z, ')
      secs=$(echo "$line"  | grep -oE 'in [0-9.]+s'      | tr -d 'a-zs ')
      cyc=$(echo "$out" | grep -oE '[0-9,]+ +cycles' | tr -d 'a-z, ' | head -1)
      mnps=$(awk -v n="$nodes" -v t="$secs" 'BEGIN{if(t>0)printf "%.2f",n/t/1e6; else print "?"}')
      cpn=$(awk -v c="${cyc:-0}" -v n="${nodes:-1}" 'BEGIN{if(n>0)printf "%.0f",c/n; else print "?"}')
      printf '%-4s %-8s %-9s %14s %7s %7s %10s\n' "$r" "$tag" "$s" "$nodes" "$secs" "$mnps" "$cpn"
    done
  done
done
echo "DONE"
