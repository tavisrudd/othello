#!/usr/bin/env bash
set -u

cd "$(dirname "$0")/.."

DATE="$(date +%F)"
NOTES="../notes/${DATE}-codex-border-overlap-graph.md"
CSV="../notes/${DATE}-border-pair-features.csv"
OUT="/tmp/codex-border-overlap-graph.out"
ERR="/tmp/codex-border-overlap-graph.time"
TIME_BIN="/run/current-system/sw/bin/time"
TIMEOUT_BIN="/run/current-system/sw/bin/timeout"

if [[ ! -x "$TIME_BIN" ]]; then
  TIME_BIN="/usr/bin/time"
fi
if [[ ! -x "$TIMEOUT_BIN" ]]; then
  TIMEOUT_BIN="timeout"
fi

mkdir -p ../notes
if [[ ! -s "$NOTES" ]]; then
  {
    echo "# Border overlap-graph pass"
    echo "Date: ${DATE}"
    echo "## Running log"
  } > "$NOTES"
fi

if grep -q '^### Wrapper overlap-graph run$' "$NOTES"; then
  TMP_NOTES="$(mktemp /tmp/codex-border-overlap-notes.XXXXXX)"
  awk '/^### Wrapper overlap-graph run$/ { exit } { print }' "$NOTES" > "$TMP_NOTES"
  mv "$TMP_NOTES" "$NOTES"
fi

{
  echo
  echo "### Wrapper overlap-graph run"
  echo
  echo 'Command: `ulimit -v 1000000; timeout 60s time -v python3 scripts/border_overlap_graph_pass.py --csv ../notes/$(date +%F)-border-pair-features.csv --max-exact-n 40`'
  echo
} >> "$NOTES"

(
  ulimit -v 1000000
  "$TIMEOUT_BIN" 60s "$TIME_BIN" -v python3 scripts/border_overlap_graph_pass.py --csv "$CSV" --max-exact-n 40 > "$OUT" 2> "$ERR"
)
status=$?

{
  echo "Resource results:"
  echo
  echo '```text'
  grep -E 'Command being timed|Elapsed|Maximum resident|Exit status' "$ERR" || cat "$ERR"
  echo '```'
  echo
  if [[ $status -eq 0 ]]; then
    cat "$OUT"
  else
    echo "Overlap-graph run failed or timed out with status $status."
    echo
    echo '```text'
    cat "$ERR"
    echo '```'
  fi
  echo
} >> "$NOTES"

exit "$status"
