#!/usr/bin/env bash
set -u

cd "$(dirname "$0")/.."

NOTES="../notes/$(date +%F)-codex-border-scar-formulas.md"
OUT="/tmp/codex-border-scar-formulas.out"
ERR="/tmp/codex-border-scar-formulas.time"
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
    echo "# Border/scar formula pass"
    echo "Date: $(date +%F)"
    echo "## Running log"
  } > "$NOTES"
fi

if grep -q '^### Wrapper formula run$' "$NOTES"; then
  TMP_NOTES="$(mktemp /tmp/codex-border-scar-notes.XXXXXX)"
  awk '/^### Wrapper formula run$/ { exit } { print }' "$NOTES" > "$TMP_NOTES"
  mv "$TMP_NOTES" "$NOTES"
fi

{
  echo
  echo "### Wrapper formula run"
  echo
  echo 'Command: `ulimit -v 1000000; timeout 60s time -v python3 scripts/codex_border_scar_formulas.py`'
  echo
} >> "$NOTES"

(
  ulimit -v 1000000
  "$TIMEOUT_BIN" 60s "$TIME_BIN" -v python3 scripts/codex_border_scar_formulas.py > "$OUT" 2> "$ERR"
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
    echo "Formula run failed or timed out with status $status."
    echo
    echo '```text'
    cat "$ERR"
    echo '```'
  fi
  echo
} >> "$NOTES"

exit "$status"
