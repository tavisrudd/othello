#!/usr/bin/env bash
# Replay the C1038 negative-control benchmark tier end to end.
#
# Builds the ergodis-side example into the crate's shared target directory,
# provisions the pinned control environment, runs every row on both sides with
# the paired-round protocol, and rewrites
# evidence/c1038-negative-control-tier.json and its raw transcript.
#
# usage: negative-control-tier.sh [--rows L1,L2,...]
set -euo pipefail

script_dir=$(cd "$(dirname "$0")" && pwd)
# shellcheck source=lib.sh
. "$script_dir/lib.sh"

root=$(cd "$script_dir/.." && pwd)
cache_root=$(ergodis_cache_root)
venv="$cache_root/application-ab-venv"
mkdir -p "$cache_root"

rows=${ROWS:-L1,L2,L3,W1,W2,W3}
while (( $# )); do
  case $1 in
    --rows) rows=${2:?--rows needs a value}; shift 2 ;;
    *) echo "negative-control-tier.sh: unknown argument: $1" >&2; exit 2 ;;
  esac
done

( cd "$root" && nix shell nixpkgs#cargo nixpkgs#rustc --command \
    cargo build --release --example negative_control_tier )

driver=$(ergodis_bin "$root" release examples/negative_control_tier)
if [[ ! -x $driver ]]; then
  echo "negative-control-tier.sh: expected executable not found: $driver" >&2
  exit 1
fi

if [[ ! -x "$venv/bin/python" ]]; then
  nix shell nixpkgs#uv --command uv venv --python 3.12 "$venv"
fi
nix shell nixpkgs#uv --command uv pip install --python "$venv/bin/python" \
  'ortools==9.14.6206'

python3 "$script_dir/negative_control_tier_run.py" \
  --ergodis "$driver" \
  --python "$venv/bin/python" \
  --control "$script_dir/negative_control_tier_control.py" \
  --output "$root/evidence/c1038-negative-control-tier.json" \
  --raw-jsonl "$root/evidence/c1038-negative-control-tier.raw.jsonl" \
  --rounds "${ROUNDS:-7}" \
  --timeout "${TIMEOUT_S:-600}" \
  --cpu "${CPU:-3}" \
  --rows "$rows"

"$script_dir/check-c1038-negative-control-evidence.sh"
