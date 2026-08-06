#!/usr/bin/env bash
set -euo pipefail

script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
singular=${SINGULAR:-Singular}
output=$(mktemp)
trap 'rm -f "$output"' EXIT

"$singular" -q "$script_dir/check_low_degree_loci.sing" | tee "$output"

if grep -Fq 'ASSERTION FAILED' "$output"; then
  exit 1
fi

grep -Fqx 'all assertions passed' "$output"
