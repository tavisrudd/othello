#!/usr/bin/env bash
set -euo pipefail

script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
evidence=${1:-${script_dir}/../../../../notes/2026-08-27-c983-observational-boa-ab.tsv}
expected_sha=d3b31e0a5998f7a195da44eeb486e7657acbfe976ddcfdf6dff5f3f076d54447
actual_sha=$(sha256sum "${evidence}" | awk '{print $1}')
if [[ ${actual_sha} != "${expected_sha}" ]]; then
  echo "evidence SHA-256 mismatch: ${actual_sha}" >&2
  exit 1
fi

header=$'implementation\tfamily\tstates\tgenerators\toutputs\trepetitions\tns_per_op\tclasses\tsplits_optional'
if [[ $(sed -n '1p' "${evidence}") != "${header}" ]]; then
  echo "unexpected evidence header" >&2
  exit 1
fi

controls=(
  "ergodis chain 131072 10761527"
  "boa chain 131072 19525726"
  "ergodis random 131072 62105057"
  "boa random 131072 25016439"
  "ergodis colors 256 4725228"
  "boa colors 256 8295075"
)
for control in "${controls[@]}"; do
  read -r implementation family expected_classes expected_median <<<"${control}"
  count=$(awk -F '\t' -v i="${implementation}" -v f="${family}" \
    'NR > 1 && $1 == i && $2 == f { if ($8 != expected) bad = 1; count++ } END { if (bad) exit 2; print count + 0 }' \
    expected="${expected_classes}" "${evidence}")
  if [[ ${count} != 7 ]]; then
    echo "expected seven ${implementation}/${family} rounds, found ${count}" >&2
    exit 1
  fi
  median=$(awk -F '\t' -v i="${implementation}" -v f="${family}" \
    'NR > 1 && $1 == i && $2 == f { print $7 }' "${evidence}" | sort -n | sed -n '4p')
  if [[ ${median} != "${expected_median}" ]]; then
    echo "unexpected ${implementation}/${family} median: ${median}" >&2
    exit 1
  fi
  printf '%s\t%s\t%s\t%s\n' "${implementation}" "${family}" "${median}" "${expected_classes}"
done
