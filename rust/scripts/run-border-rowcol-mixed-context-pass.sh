#!/usr/bin/env bash
set -u

cd "$(dirname "$0")/.."

DATE="$(date +%F)"
NOTES="../notes/${DATE}-codex-border-overlap-graph.md"
CSV="../notes/${DATE}-border-pair-features.csv"
OUT="/tmp/codex-border-rowcol-mixed-context.out"
ERR="/tmp/codex-border-rowcol-mixed-context.time"
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

{
  echo
  echo "### Wrapper row/col mixed-context continuation run"
  echo
  echo 'Command: `ulimit -v 1000000; timeout 180s time -v python3 scripts/border_rowcol_mixed_context_pass.py --csv ../notes/$(date +%F)-border-pair-features.csv`'
  echo
} >> "$NOTES"

(
  ulimit -v 1000000
  "$TIMEOUT_BIN" 180s "$TIME_BIN" -v python3 scripts/border_rowcol_mixed_context_pass.py --csv "$CSV" > "$OUT" 2> "$ERR"
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
    echo "Row/col mixed-context continuation failed or timed out with status $status."
    echo
    echo '```text'
    cat "$ERR"
    echo '```'
  fi
  echo
} >> "$NOTES"

exit "$status"
