#!/usr/bin/env bash
set -euo pipefail

script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
evidence=${script_dir}/../evidence/c983-observational-mata.tsv
expected_sha256=2f720ba8c47f71ead086eba7c638477384ae90a6024fced4e618c2d16402c72d
actual_sha256=$(sha256sum "${evidence}" | awk '{print $1}')
if [[ ${actual_sha256} != "${expected_sha256}" ]]; then
  echo "SHA-256 mismatch: expected ${expected_sha256}, got ${actual_sha256}" >&2
  exit 1
fi

awk -F '\t' '
BEGIN {
  header = "implementation\tfamily\tstates\tgenerators\toutputs\trepetitions\tns_per_op\tclasses\tsplits_optional"
  families[1] = "chain"; families[2] = "random"; families[3] = "colors"; families[4] = "stable"
  implementations[1] = "ergodis"; implementations[2] = "mata"
  expected_median["ergodis", "chain"] = 14642825
  expected_median["mata", "chain"] = 23502461
  expected_median["ergodis", "random"] = 61321259
  expected_median["mata", "random"] = 202484751
  expected_median["ergodis", "colors"] = 4712073
  expected_median["mata", "colors"] = 54146309
  expected_median["ergodis", "stable"] = 589117
  expected_median["mata", "stable"] = 648201441
  expected_classes["ergodis", "chain"] = 131072; expected_splits["ergodis", "chain"] = 131070
  expected_classes["mata", "chain"] = 131072; expected_splits["mata", "chain"] = "-"
  expected_classes["ergodis", "random"] = 131072; expected_splits["ergodis", "random"] = 131070
  expected_classes["mata", "random"] = 131072; expected_splits["mata", "random"] = "-"
  expected_classes["ergodis", "colors"] = 256; expected_splits["ergodis", "colors"] = 0
  expected_classes["mata", "colors"] = 257; expected_splits["mata", "colors"] = "-"
  expected_classes["ergodis", "stable"] = 1; expected_splits["ergodis", "stable"] = 0
  expected_classes["mata", "stable"] = 1; expected_splits["mata", "stable"] = "-"
}
NR == 1 {
  if ($0 != header) fail("unexpected header")
  next
}
{
  if (NF != 9) fail("row " NR " has " NF " fields")
  key = $1 SUBSEP $2
  if (!((key) in expected_median)) fail("unexpected implementation/family at row " NR)
  if ($8 != expected_classes[key] || $9 != expected_splits[key]) fail("class/split mismatch at row " NR)
  if ($6 != 1 || $7 !~ /^[0-9]+$/) fail("invalid repetition or timing at row " NR)
  count[key]++
  timing[key, count[key]] = $7 + 0
}
END {
  if (failed) exit 1
  for (f = 1; f <= 4; f++) {
    for (i = 1; i <= 2; i++) {
      key = implementations[i] SUBSEP families[f]
      if (count[key] != 7) fail(implementations[i] "/" families[f] " has " count[key] " rows, expected 7")
      for (a = 1; a <= 7; a++) values[a] = timing[key, a]
      for (a = 1; a < 7; a++) for (b = a + 1; b <= 7; b++) if (values[b] < values[a]) {
        temporary = values[a]; values[a] = values[b]; values[b] = temporary
      }
      if (values[4] != expected_median[key]) fail(implementations[i] "/" families[f] " median " values[4] ", expected " expected_median[key])
    }
  }
  if (failed) exit 1
}
function fail(message) {
  print "c983 MATA evidence check failed: " message > "/dev/stderr"
  failed = 1
}
' "${evidence}"

echo "C983_MATA_EVIDENCE_OK sha256=${actual_sha256} groups=8 rows_per_group=7 medians=8"
