#!/usr/bin/env bash
set -euo pipefail

script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
evidence=${script_dir}/../evidence/c987-observational-hierarchy.tsv
memory_evidence=${script_dir}/../evidence/c987-observational-hierarchy-memory.tsv
expected_sha256=ae835c06fe486ccc9163f034b97b223e75df12e7d7923d576035c59214852fc5
expected_memory_sha256=ca7faf079e60fe5d5ba4fd885ea6951d2d5d344ccd6daa0e603c76d4fc31cdff
actual_sha256=$(sha256sum "${evidence}" | awk '{print $1}')
actual_memory_sha256=$(sha256sum "${memory_evidence}" | awk '{print $1}')
if [[ ${actual_sha256} != "${expected_sha256}" ]]; then
  echo "SHA-256 mismatch: expected ${expected_sha256}, got ${actual_sha256}" >&2
  exit 1
fi
if [[ ${actual_memory_sha256} != "${expected_memory_sha256}" ]]; then
  echo "memory SHA-256 mismatch: expected ${expected_memory_sha256}, got ${actual_memory_sha256}" >&2
  exit 1
fi

awk -F '\t' '
BEGIN {
  header = "application\tdepth\tseed_bound\tprofiles\traw_states\tclasses\traw_payload_bytes\tquotient_bytes\tcertificate_bytes\traw_build_ns\tquotient_build_ns\tdirect_ns_per_query\traw_sequential_ns_per_query\tquotient_sequential_ns_per_query\traw_random_ns_per_query\tquotient_random_ns_per_query\tdirect_checksum\traw_checksum\tquotient_checksum\tquotient_first\tsequential_queries\traw_sequential_total_ns\tquotient_sequential_total_ns\trandom_queries\traw_random_total_ns\tquotient_random_total_ns"
  seeds[1] = 3; seeds[2] = 256
  profiles[3] = "[9, 12, 12, 12, 12]"
  profiles[256] = "[65536, 65792, 65792, 65792, 65792]"
  raw_states[3] = 57; raw_states[256] = 328704
  classes[3] = 25; classes[256] = 2049
  raw_bytes[3] = 768; raw_bytes[256] = 4469760
  quotient_bytes[3] = 912; quotient_bytes[256] = 1352944
  certificate_bytes[3] = 128; certificate_bytes[256] = 16320
  expected_build[3] = 618813; expected_build[256] = 2060993263
  expected_compile[3] = 16972; expected_compile[256] = 26143921
  expected_raw_seq[3] = 30390541; expected_raw_seq[256] = 44073843
  expected_quotient_seq[3] = 30469408; expected_quotient_seq[256] = 44303101
  expected_raw_random[3] = 33555615; expected_raw_random[256] = 23024741
  expected_quotient_random[3] = 34683246; expected_quotient_random[256] = 9829206
}
NR == 1 {
  if ($0 != header) fail("unexpected header")
  next
}
{
  if (NF != 26) fail("row " NR " has " NF " fields")
  seed = $3 + 0
  if (!(seed in profiles)) fail("unexpected seed bound at row " NR)
  if ($1 != "hierarchy" || $2 != 4 || $4 != profiles[seed]) fail("application shape mismatch at row " NR)
  if ($5 != raw_states[seed] || $6 != classes[seed]) fail("state count mismatch at row " NR)
  if ($7 != raw_bytes[seed] || $8 != quotient_bytes[seed] || $9 != certificate_bytes[seed]) fail("storage mismatch at row " NR)
  if ($18 != $19) fail("raw/quotient checksum mismatch at row " NR)
  if ($20 == "false") raw_first[seed]++
  else if ($20 == "true") quotient_first[seed]++
  else fail("invalid order at row " NR)
  count[seed]++
  build[seed, count[seed]] = $10 + 0
  compile[seed, count[seed]] = $11 + 0
  raw_seq[seed, count[seed]] = $22 + 0
  quotient_seq[seed, count[seed]] = $23 + 0
  raw_random[seed, count[seed]] = $25 + 0
  quotient_random[seed, count[seed]] = $26 + 0
}
END {
  if (failed) exit 1
  for (i = 1; i <= 2; i++) {
    seed = seeds[i]
    if (count[seed] != 7 || raw_first[seed] != 4 || quotient_first[seed] != 3) fail("round/order count mismatch for seed " seed)
    if (median(build, seed) != expected_build[seed]) fail("raw-build median mismatch for seed " seed)
    if (median(compile, seed) != expected_compile[seed]) fail("quotient-build median mismatch for seed " seed)
    if (median(raw_seq, seed) != expected_raw_seq[seed]) fail("raw-sequential median mismatch for seed " seed)
    if (median(quotient_seq, seed) != expected_quotient_seq[seed]) fail("quotient-sequential median mismatch for seed " seed)
    if (median(raw_random, seed) != expected_raw_random[seed]) fail("raw-random median mismatch for seed " seed)
    if (median(quotient_random, seed) != expected_quotient_random[seed]) fail("quotient-random median mismatch for seed " seed)
  }
  if (failed) exit 1
}
function median(values, seed, copy, a, b, temporary) {
  for (a = 1; a <= 7; a++) copy[a] = values[seed, a]
  for (a = 1; a < 7; a++) for (b = a + 1; b <= 7; b++) if (copy[b] < copy[a]) {
    temporary = copy[a]; copy[a] = copy[b]; copy[b] = temporary
  }
  return copy[4]
}
function fail(message) {
  print "c987 hierarchy evidence check failed: " message > "/dev/stderr"
  failed = 1
}
' "${evidence}"

awk -F '\t' '
NR == 1 {
  if ($0 != "metric\tround\tmode\tkib") fail("unexpected header")
  next
}
{
  if (NF != 4 || $1 != "peak_rss_kib" || $2 !~ /^[0-6]$/ || $4 !~ /^[0-9]+$/) fail("invalid row " NR)
  if ($3 != "raw-build-only" && $3 != "full") fail("invalid mode at row " NR)
  count[$3]++
  value[$3, count[$3]] = $4 + 0
}
END {
  if (failed) exit 1
  if (median("raw-build-only") != 22500) fail("raw peak-RSS median mismatch")
  if (median("full") != 38332) fail("full peak-RSS median mismatch")
  if (failed) exit 1
}
function median(mode, copy, a, b, temporary) {
  if (count[mode] != 7) { fail(mode " row count mismatch"); return -1 }
  for (a = 1; a <= 7; a++) copy[a] = value[mode, a]
  for (a = 1; a < 7; a++) for (b = a + 1; b <= 7; b++) if (copy[b] < copy[a]) {
    temporary = copy[a]; copy[a] = copy[b]; copy[b] = temporary
  }
  return copy[4]
}
function fail(message) {
  print "c987 hierarchy memory evidence check failed: " message > "/dev/stderr"
  failed = 1
}
' "${memory_evidence}"

echo "C987_HIERARCHY_EVIDENCE_OK sha256=${actual_sha256} memory_sha256=${actual_memory_sha256} cases=2 rows_per_case=7 parity=exact"
