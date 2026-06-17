#!/usr/bin/env bash
# Post-compaction verification: buddyinfo recovery + THP-backing + throughput.
set -u
cd /home/tavis/src/othello/rust
echo "=== buddyinfo Normal zone (watch order-9 [2MB] and order-10) ==="
awk '/zone   Normal/{print}' /proc/buddyinfo
echo
for s in burr iso-burr; do
  ( target/release/queens solve 14 "$s" --distinct 2>&1 | sed -E 's/\x1b\[[0-9;]*m//g' > /tmp/vc-$s.log ) &
  sleep 1.2
  pid=$(pgrep -x queens | head -1)
  ahp=0; rss=0
  if [ -n "$pid" ]; then
    rss=$(awk '/^Rss:/{print $2}' /proc/$pid/smaps_rollup 2>/dev/null)
    ahp=$(awk '/^AnonHugePages:/{print $2}' /proc/$pid/smaps_rollup 2>/dev/null)
  fi
  wait
  line=$(grep -m1 searched /tmp/vc-$s.log)
  nodes=$(echo "$line" | grep -oE 'searched [0-9,]+' | tr -d 'a-z, ')
  secs=$(echo "$line" | grep -oE 'in [0-9.]+s' | tr -d 'a-zs ')
  mnps=$(awk -v n="$nodes" -v t="$secs" 'BEGIN{if(t>0)printf "%.2f",n/t/1e6; else print "?"}')
  pct=$(awk -v r="${rss:-0}" -v a="${ahp:-0}" 'BEGIN{if(r>0)printf "%.0f%%",100*a/r; else print "n/a"}')
  printf '%-9s %ss  %s M/s  RSS=%sMB AnonHugePages=%sMB (THP %s)\n' \
    "$s" "$secs" "$mnps" "$((${rss:-0}/1024))" "$((${ahp:-0}/1024))" "$pct"
done
