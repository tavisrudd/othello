#!/usr/bin/env bash
set -u

cd "$(dirname "$0")/.."

DATE="$(date +%F)"
NOTES="../notes/${DATE}-codex-border-pair-classifier.md"
CSV="../notes/${DATE}-border-pair-features.csv"
OUT="/tmp/codex-border-pair-classifier.out"
ERR="/tmp/codex-border-pair-classifier.time"
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
    echo "# Border-pair classifier pass"
    echo "Date: ${DATE}"
    echo "## Running log"
  } > "$NOTES"
fi

if grep -q '^### Wrapper classifier run$' "$NOTES"; then
  TMP_NOTES="$(mktemp /tmp/codex-border-pair-notes.XXXXXX)"
  awk '/^### Wrapper classifier run$/ { exit } { print }' "$NOTES" > "$TMP_NOTES"
  mv "$TMP_NOTES" "$NOTES"
fi

{
  echo
  echo "### Wrapper classifier run"
  echo
  echo 'Command: `ulimit -v 1000000; timeout 60s time -v python3 scripts/border_pair_classifier.py --csv ../notes/$(date +%F)-border-pair-features.csv --max-n 100`'
  echo
} >> "$NOTES"

(
  ulimit -v 1000000
  "$TIMEOUT_BIN" 60s "$TIME_BIN" -v python3 scripts/border_pair_classifier.py --csv "$CSV" --max-n 100 > "$OUT" 2> "$ERR"
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
    echo "Classifier run failed or timed out with status $status."
    echo
    echo '```text'
    cat "$ERR"
    echo '```'
  fi
  echo
} >> "$NOTES"

exit "$status"
