#!/usr/bin/env bash
set -euo pipefail

evidence=${1:-papers/complete-repair-ports/ergodis/evidence/c985-layered-dag-certified-final.tsv}

awk -F '\t' '
  NR == 1 {
    if ($1 != "round" || $2 != "shape" || $3 != "case" || $4 != "total_ns") exit 2
    next
  }
  {
    round = $1 + 0
    shape = $2
    case_name = $3
    if ($8 != "dag" || $10 != shape || $11 != 32 || $12 != 32768 ||
        $14 != 1048576 || $15 != 32) exit 3
    if (shape == "chain") {
      if ($13 != 31 || $16 != 132460) exit 4
      expected_live = 65536; expected_maps = 2; expected_signatures = 65536
    } else if (shape == "window") {
      if ($13 != 118 || $16 != 134200) exit 5
      expected_live = 163840; expected_maps = 5; expected_signatures = 163840
    } else if (shape == "full") {
      if ($13 != 496 || $16 != 141760) exit 6
      expected_live = 1048576; expected_maps = 32; expected_signatures = 1048576
    } else exit 7
    if (case_name == "frontier") {
      if ($9 != "frontier-certified" || $17 != expected_live ||
          $18 != expected_maps || $19 != expected_signatures) exit 8
      frontier[shape, round] = $4 + 0
      frontier_rss[shape, round] = $7 + 0
    } else if (case_name == "full") {
      if ($9 != "full-certified" || $17 != 0 || $18 != 0 || $19 != 0) exit 9
      full[shape, round] = $4 + 0
      full_rss[shape, round] = $7 + 0
    } else exit 10
  }
  END {
    if (NR != 55) exit 11
    split("chain window full", shapes, " ")
    for (s = 1; s <= 3; s++) {
      shape = shapes[s]
      time_mean = rss_mean = 0
      for (i = 1; i <= 9; i++) {
        if (!((shape, i) in full) || !((shape, i) in frontier)) exit 12
        time_mean += log(full[shape, i] / frontier[shape, i])
        rss_mean += log(full_rss[shape, i] / frontier_rss[shape, i])
      }
      time_mean /= 9; rss_mean /= 9
      time_var = rss_var = 0
      for (i = 1; i <= 9; i++) {
        time_log = log(full[shape, i] / frontier[shape, i])
        rss_log = log(full_rss[shape, i] / frontier_rss[shape, i])
        time_var += (time_log - time_mean) ^ 2
        rss_var += (rss_log - rss_mean) ^ 2
      }
      time_var /= 8; rss_var /= 8
      printf "%s_time_ratio=%.3f %s_time_t=%.2f %s_rss_ratio=%.3f %s_rss_t=%.2f%s", \
        shape, exp(time_mean), shape, time_mean / sqrt(time_var / 9), \
        shape, exp(rss_mean), shape, rss_mean / sqrt(rss_var / 9), \
        s == 3 ? "\n" : " "
    }
  }
' "$evidence"
