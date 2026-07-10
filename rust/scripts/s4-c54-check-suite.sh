#!/usr/bin/env bash
set -euo pipefail

bin=${1:-target/gridcap-c54}
log=${2:-s4-dumps/2026-07-09/c54-q23-pncheck.log}
time_bin=/run/current-system/sw/bin/time

mkdir -p "$(dirname "$log")"
exec > >(tee "$log") 2>&1

rows=(
  "0|1,3,4,9|s4-dumps/2026-07-09/c37-q23-raw/q23-bucket00-1349.raw"
  "1|1,2,3,8|s4-dumps/2026-07-09/c37-q23-raw/q23-bucket01-1238.raw"
  "2|1,2,3,5|s4-dumps/2026-07-09/c37-q23-raw/q23-bucket02-1235.raw"
  "3|1,2,5,11|s4-dumps/2026-07-09/c37-q23-raw/q23-bucket03-12511.raw"
  "4|1,2,5,10|s4-dumps/2026-07-09/c37-q23-raw/q23-bucket04-12510.raw"
  "5|1,2,6,8|s4-dumps/2026-07-09/c37-q23-raw/q23-bucket05-1268.raw"
  "6|1,3,4,11|s4-dumps/2026-07-09/c37-q23-raw/q23-bucket06-13411.raw"
  "7|1,2,3,11|s4-dumps/2026-07-09/c37-q23-raw/q23-bucket07-12311.raw"
  "8|1,2,3,4|s4-dumps/2026-07-08/q23-root-1234-1-2-3-4.raw"
  "9|1,2,3,7|s4-dumps/2026-07-09/c37-q23-raw/q23-bucket09-1237.raw"
  "10|1,2,5,15|s4-dumps/2026-07-09/c37-q23-raw/q23-bucket10-12515.raw"
  "11|1,2,5,18|s4-dumps/2026-07-09/c37-q23-raw/q23-bucket11-12518.raw"
  "12|1,2,5,6|s4-dumps/2026-07-08/q23-bucket09-1256-1-2-5-6.raw"
  "13|1,2,3,6|s4-dumps/2026-07-09/c37-q23-raw/q23-bucket13-1236.raw"
  "14|1,2,5,7|s4-dumps/2026-07-09/c37-q23-raw/q23-bucket14-1257.raw"
  "15|1,2,6,19|s4-dumps/2026-07-09/c37-q23-raw/q23-bucket15-12619.raw"
  "16|1,2,3,10|s4-dumps/2026-07-09/c37-q23-raw/q23-bucket16-12310.raw"
  "17|1,2,6,14|s4-dumps/2026-07-09/c37-q23-raw/q23-bucket17-12614.raw"
  "18|1,2,6,10|s4-dumps/2026-07-09/c37-q23-raw/q23-bucket18-12610.raw"
  "19|1,2,3,12|s4-dumps/2026-07-09/c37-q23-raw/q23-bucket19-12312.raw"
  "20|1,2,3,13|s4-dumps/2026-07-09/c37-q23-raw/q23-bucket20-12313.raw"
  "21|1,3,7,10|s4-dumps/2026-07-09/c37-q23-raw/q23-bucket21-13710.raw"
)

echo "C54_BEGIN roots=${#rows[@]} bin=$bin"
for row in "${rows[@]}"; do
  IFS='|' read -r idx rep raw <<<"$row"
  echo "C54_ROOT_BEGIN idx=$idx rep=$rep raw=$raw"
  "$time_bin" -f "C54_TIME idx=$idx wall=%e user=%U sys=%S maxrss_kb=%M exit=%x" \
    "$bin" s4pncheck 23 "$rep" --raw "$raw"
  echo "C54_ROOT_END idx=$idx"
done
echo "C54_DONE roots=${#rows[@]}"
