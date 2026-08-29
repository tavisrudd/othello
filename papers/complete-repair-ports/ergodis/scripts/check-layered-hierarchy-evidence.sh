#!/usr/bin/env bash
set -euo pipefail

evidence=${1:-papers/complete-repair-ports/ergodis/evidence/c985-layered-hierarchy-final.tsv}

awk -F '\t' '
  NR == 1 {
    if ($1 != "round" || $2 != "case" || $3 != "internal_ns" || $4 != "peak_kib") exit 2
    next
  }
  {
    round = $1 + 0
    if ($2 == "generic") {
      if ($5 != "generic-only" || $8 != 328704 || $9 != 2049) exit 3
      generic[round] = $3 + 0
      generic_rss[round] = $4 + 0
    } else if ($2 == "layered") {
      if ($5 != "layered-only" || $8 != 328704 || $9 != 2049 || $11 != 300312) exit 4
      layered[round] = $3 + 0
      layered_rss[round] = $4 + 0
    } else {
      exit 5
    }
  }
  END {
    if (NR != 19) exit 6
    n = 9
    mean = 0
    rss_mean = 0
    for (i = 1; i <= n; i++) {
      if (!(i in generic) || !(i in layered)) exit 7
      log_ratio[i] = log(generic[i] / layered[i])
      log_rss_ratio[i] = log(generic_rss[i] / layered_rss[i])
      mean += log_ratio[i]
      rss_mean += log_rss_ratio[i]
      time_ratio[i] = generic[i] / layered[i]
      rss_ratio[i] = generic_rss[i] / layered_rss[i]
    }
    mean /= n
    rss_mean /= n
    variance = 0
    rss_variance = 0
    for (i = 1; i <= n; i++) {
      variance += (log_ratio[i] - mean) ^ 2
      rss_variance += (log_rss_ratio[i] - rss_mean) ^ 2
    }
    variance /= n - 1
    rss_variance /= n - 1
    for (i = 1; i <= n; i++) {
      for (j = i + 1; j <= n; j++) {
        if (time_ratio[j] < time_ratio[i]) {
          x = time_ratio[i]; time_ratio[i] = time_ratio[j]; time_ratio[j] = x
        }
        if (rss_ratio[j] < rss_ratio[i]) {
          x = rss_ratio[i]; rss_ratio[i] = rss_ratio[j]; rss_ratio[j] = x
        }
      }
    }
    geometric = exp(mean)
    rss_geometric = exp(rss_mean)
    t_score = mean / sqrt(variance / n)
    rss_t_score = rss_mean / sqrt(rss_variance / n)
    printf "rounds=%d geometric_time_ratio=%.3f median_paired_time_ratio=%.3f time_log_t=%.2f geometric_rss_ratio=%.3f median_paired_rss_ratio=%.3f rss_log_t=%.2f\n", n, geometric, time_ratio[5], t_score, rss_geometric, rss_ratio[5], rss_t_score
    if (time_ratio[5] < 10 || rss_ratio[5] < 4) exit 8
  }
' "$evidence"
