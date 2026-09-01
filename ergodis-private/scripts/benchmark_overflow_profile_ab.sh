#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 9 ]]; then
  echo "usage: $0 OUT RELEASE_BIN CAMPAIGN_BIN INPUT ARTIFACT PAIRS THREADS SOLVE_ROUNDS CPU" >&2
  exit 2
fi

out=$1
release_bin=$2
campaign_bin=$3
input=$4
artifact=$5
pairs=$6
threads=$7
solve_rounds=$8
cpu=$9

if [[ -e $out ]]; then
  echo "refusing to overwrite $out" >&2
  exit 2
fi
mkdir "$out"

run_arm() {
  local label=$1
  local binary=$2
  local round=$3
  perf stat -x, \
    -e cycles,instructions,branches,branch-misses \
    -o "$out/$label-$round.perf" \
    taskset -c "$cpu" "$binary" \
      --input "$input" \
      --maximum-weight 16 \
      --threads "$threads" \
      --rounds "$solve_rounds" \
      --compiled-in "$artifact" \
      >"$out/$label-$round.json"
}

run_rss() {
  local label=$1
  local binary=$2
  local round=$3
  /usr/bin/time -f '%M' -o "$out/$label-$round.rss" \
    taskset -c "$cpu" "$binary" \
      --input "$input" \
      --maximum-weight 16 \
      --threads "$threads" \
      --rounds "$solve_rounds" \
      --compiled-in "$artifact" \
      >/dev/null
}

for ((round = 1; round <= pairs; round++)); do
  if ((round % 2 == 1)); then
    run_arm release "$release_bin" "$round"
    run_rss release "$release_bin" "$round"
    run_arm campaign "$campaign_bin" "$round"
    run_rss campaign "$campaign_bin" "$round"
  else
    run_arm campaign "$campaign_bin" "$round"
    run_rss campaign "$campaign_bin" "$round"
    run_arm release "$release_bin" "$round"
    run_rss release "$release_bin" "$round"
  fi
done

reference=$(jq -S -c '{result,round_stats}' "$out/release-1.json" | sha256sum | cut -d' ' -f1)
for result in "$out"/*.json; do
  observed=$(jq -S -c '{result,round_stats}' "$result" | sha256sum | cut -d' ' -f1)
  if [[ $observed != "$reference" ]]; then
    echo "result mismatch: $result" >&2
    exit 1
  fi
done

printf '%s\n' \
  'round,release_cycles,campaign_cycles,release_instructions,campaign_instructions,release_branches,campaign_branches,release_branch_misses,campaign_branch_misses,release_search_seconds,campaign_search_seconds,release_rss_kib,campaign_rss_kib' \
  >"$out/pairs.csv"
for ((round = 1; round <= pairs; round++)); do
  metric() {
    awk -F, -v event="$2" '$3 == event { print $1; exit }' "$1"
  }
  release_perf="$out/release-$round.perf"
  campaign_perf="$out/campaign-$round.perf"
  release_seconds=$(jq -r '[.search_seconds[]] | add' "$out/release-$round.json")
  campaign_seconds=$(jq -r '[.search_seconds[]] | add' "$out/campaign-$round.json")
  printf '%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s\n' \
    "$round" \
    "$(metric "$release_perf" cycles:u)" \
    "$(metric "$campaign_perf" cycles:u)" \
    "$(metric "$release_perf" instructions:u)" \
    "$(metric "$campaign_perf" instructions:u)" \
    "$(metric "$release_perf" branches:u)" \
    "$(metric "$campaign_perf" branches:u)" \
    "$(metric "$release_perf" branch-misses:u)" \
    "$(metric "$campaign_perf" branch-misses:u)" \
    "$release_seconds" \
    "$campaign_seconds" \
    "$(<"$out/release-$round.rss")" \
    "$(<"$out/campaign-$round.rss")" \
    >>"$out/pairs.csv"
done

jq -n \
  --arg schema ergodis-private-overflow-profile-ab-v0 \
  --arg input "$input" \
  --arg input_sha256 "$(sha256sum "$input" | cut -d' ' -f1)" \
  --arg artifact "$artifact" \
  --arg artifact_sha256 "$(sha256sum "$artifact" | cut -d' ' -f1)" \
  --arg release_sha256 "$(sha256sum "$release_bin" | cut -d' ' -f1)" \
  --arg campaign_sha256 "$(sha256sum "$campaign_bin" | cut -d' ' -f1)" \
  --argjson pairs "$pairs" \
  --argjson threads "$threads" \
  --argjson solve_rounds "$solve_rounds" \
  --arg cpu "$cpu" \
  --arg result_sha256 "$reference" \
  '{$schema,$input,$input_sha256,$artifact,$artifact_sha256,$release_sha256,
    $campaign_sha256,$pairs,$threads,$solve_rounds,$cpu,$result_sha256}' \
  >"$out/metadata.json"

rm "$out"/release-*.perf "$out"/campaign-*.perf \
  "$out"/release-*.json "$out"/campaign-*.json \
  "$out"/release-*.rss "$out"/campaign-*.rss
