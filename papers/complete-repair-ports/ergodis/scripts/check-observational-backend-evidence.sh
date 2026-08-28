#!/usr/bin/env bash
set -euo pipefail

script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
root=$(cd -- "${script_dir}/.." && pwd)
immediate=${root}/evidence/c985-backend-immediate.tsv
deferred=${root}/evidence/c985-backend-deferred.tsv
rss=${root}/evidence/c985-backend-rss.tsv
theorem=${root}/evidence/c985-theorem-final.tsv
monoid=${root}/evidence/c985-monoid-final.tsv
composition_internal=${root}/evidence/c985-composition-internal.tsv

check_timing() {
  local file=$1 boundary=$2
  awk -F '\t' -v boundary="${boundary}" '
    NR == 1 {
      expected = "implementation\tfamily\tstates\tgenerators\toutputs\trepetitions\tns_per_op\tclasses\tsplits_optional"
      if ($0 != expected) exit 2
      next
    }
    {
      if ($1 != "ergodis" && $1 != "boa") exit 3
      if ($2 != "chain" && $2 != "random" && $2 != "colors") exit 4
      if ($3 != 131072 || $6 != 1 || $7 !~ /^[0-9]+$/) exit 5
      key = $1 SUBSEP $2
      count[key]++
      value[key, count[key]] = $7 + 0
      rows++
    }
    END {
      if (rows != 66) exit 6
      for (key in count) {
        if (count[key] != 11) exit 7
        n = count[key]
        for (i = 1; i <= n; i++) sorted[i] = value[key, i]
        for (i = 1; i <= n; i++) for (j = i + 1; j <= n; j++) {
          if (sorted[j] < sorted[i]) {
            temporary = sorted[i]; sorted[i] = sorted[j]; sorted[j] = temporary
          }
        }
        median[key] = sorted[6]
        delete sorted
      }
      if (!(median["ergodis" SUBSEP "chain"] < median["boa" SUBSEP "chain"] && median["ergodis" SUBSEP "colors"] < median["boa" SUBSEP "colors"])) exit 8
      if (boundary == "deferred" && !(median["ergodis" SUBSEP "random"] < median["boa" SUBSEP "random"])) exit 9
      printf "%s", boundary
      for (i = 1; i <= 3; i++) {
        family = (i == 1 ? "chain" : (i == 2 ? "random" : "colors"))
        printf "\t%s=%.3f/%.3fms", family,
          median["ergodis" SUBSEP family] / 1000000,
          median["boa" SUBSEP family] / 1000000
      }
      printf "\n"
    }
  ' "${file}"
}

check_timing "${immediate}" immediate
check_timing "${deferred}" deferred
awk -F '\t' '
  NR == 1 {
    expected = "implementation\tfamily\tstates\tgenerators\toutputs\trepetitions\tns_per_op\tclasses\tsplits_optional"
    if ($0 != expected) exit 2
    next
  }
  {
    if ($1 != "ergodis" && $1 != "boa") exit 3
    if ($2 != "chain" && $2 != "random" && $2 != "redundant" && $2 != "colors") exit 4
    generators = ($2 == "chain" ? 1 : ($2 == "redundant" ? 16 : 4))
    outputs = ($2 == "colors" ? 256 : 2)
    classes = ($2 == "colors" ? 256 : 131072)
    if ($3 != 131072 || $4 != generators || $5 != outputs || $6 != 1 || $7 !~ /^[0-9]+$/ || $8 != classes) exit 5
    key = $1 SUBSEP $2
    count[key]++
    value[key, count[key]] = $7 + 0
    rows++
  }
  END {
    if (rows != 88) exit 6
    for (key in count) {
      if (count[key] != 11) exit 7
      for (i = 1; i <= 11; i++) sorted[i] = value[key, i]
      for (i = 1; i <= 11; i++) for (j = i + 1; j <= 11; j++) {
        if (sorted[j] < sorted[i]) {
          temporary = sorted[i]; sorted[i] = sorted[j]; sorted[j] = temporary
        }
      }
      median[key] = sorted[6]
      delete sorted
    }
    for (i = 1; i <= 4; i++) {
      family = (i == 1 ? "chain" : (i == 2 ? "random" : (i == 3 ? "redundant" : "colors")))
      if (!(median["ergodis" SUBSEP family] < median["boa" SUBSEP family])) exit 8
      printf "%s%s=%.3f/%.3fms", (i == 1 ? "theorem\t" : "\t"), family,
        median["ergodis" SUBSEP family] / 1000000,
        median["boa" SUBSEP family] / 1000000
    }
    printf "\n"
  }
' "${theorem}"
awk -F '\t' '
  NR == 1 { next }
  {
    if ($1 != "ergodis" && $1 != "boa") exit 2
    if ($2 != "chain" && $2 != "random" && $2 != "redundant" && $2 != "composed" && $2 != "powers" && $2 != "colors") exit 3
    key = $1 SUBSEP $2
    count[key]++
    value[key, count[key]] = $7 + 0
    rows++
  }
  END {
    if (rows != 132) exit 4
    for (key in count) {
      if (count[key] != 11) exit 5
      for (i = 1; i <= 11; i++) sorted[i] = value[key, i]
      for (i = 1; i <= 11; i++) for (j = i + 1; j <= 11; j++) if (sorted[j] < sorted[i]) {
        temporary = sorted[i]; sorted[i] = sorted[j]; sorted[j] = temporary
      }
      median[key] = sorted[6]
      delete sorted
    }
    for (i = 1; i <= 6; i++) {
      family = (i == 1 ? "chain" : (i == 2 ? "random" : (i == 3 ? "redundant" : (i == 4 ? "composed" : (i == 5 ? "powers" : "colors")))))
      if (!(median["ergodis" SUBSEP family] < median["boa" SUBSEP family])) exit 6
      printf "%s%s=%.3f/%.3fms", (i == 1 ? "monoid\t" : "\t"), family,
        median["ergodis" SUBSEP family] / 1000000, median["boa" SUBSEP family] / 1000000
    }
    printf "\n"
  }
' "${monoid}"
awk -F '\t' '
  NR == 1 { next }
  {
    if ($1 != "ergodis" || $2 != "composed" || $3 != 131072 || $4 != 16 || $8 != 131072) exit 2
    side = (NR % 2 == 0 ? "baseline" : "reduced")
    count[side]++
    value[side, count[side]] = $7 + 0
    rows++
  }
  END {
    if (rows != 22 || count["baseline"] != 11 || count["reduced"] != 11) exit 3
    for (side in count) {
      for (i = 1; i <= 11; i++) sorted[i] = value[side, i]
      for (i = 1; i <= 11; i++) for (j = i + 1; j <= 11; j++) if (sorted[j] < sorted[i]) {
        temporary = sorted[i]; sorted[i] = sorted[j]; sorted[j] = temporary
      }
      median[side] = sorted[6]
      delete sorted
    }
    if (!(median["reduced"] * 5 < median["baseline"])) exit 4
    printf "composition-internal\tbaseline=%.3fms\treduced=%.3fms\n", median["baseline"] / 1000000, median["reduced"] / 1000000
  }
' "${composition_internal}"
awk -F '\t' '
  NF != 2 || $1 !~ /^(transcript|adaptive|adaptive-deferred)$/ || $2 !~ /^[0-9]+$/ { exit 2 }
  { count[$1]++; value[$1, count[$1]] = $2 + 0 }
  END {
    for (mode in count) {
      if (count[mode] != 7) exit 3
      for (i = 1; i <= 7; i++) sorted[i] = value[mode, i]
      for (i = 1; i <= 7; i++) for (j = i + 1; j <= 7; j++) {
        if (sorted[j] < sorted[i]) {
          temporary = sorted[i]; sorted[i] = sorted[j]; sorted[j] = temporary
        }
      }
      median[mode] = sorted[4]
      delete sorted
    }
    if (!(median["adaptive-deferred"] < median["transcript"])) exit 4
    printf "rss\ttranscript=%dKiB\tadaptive=%dKiB\tadaptive-deferred=%dKiB\n",
      median["transcript"], median["adaptive"], median["adaptive-deferred"]
  }
' "${rss}"
