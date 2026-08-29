#!/usr/bin/env bash
set -euo pipefail

evidence=${1:-papers/complete-repair-ports/ergodis/evidence/c985-layered-certified-final.tsv}

awk -F '\t' '
  NR == 1 {
    if ($1 != "round" || $2 != "case" || $3 != "total_ns" || $6 != "peak_kib") exit 2
    next
  }
  {
    round = $1 + 0
    if ($2 == "full") {
      if ($9 != "layered-audit" || $10 != 64 || $11 != 256 || $12 != 918552 ||
          $13 != 46401954 || $17 != 501173) exit 3
      full[round] = $3 + 0
      full_compile[round] = $4 + 0
      full_verify[round] = $5 + 0
      full_rss[round] = $6 + 0
    } else if ($2 == "frontier") {
      if ($9 != "layered-chain-audit" || $10 != 64 || $11 != 256 || $12 != 918552 ||
          $13 != 38984421 || $16 != 501173) exit 4
      frontier[round] = $3 + 0
      frontier_compile[round] = $4 + 0
      frontier_verify[round] = $5 + 0
      frontier_rss[round] = $6 + 0
    } else {
      exit 5
    }
  }
  END {
    if (NR != 19) exit 6
    n = 9
    total_mean = rss_mean = compile_mean = verify_mean = 0
    for (i = 1; i <= n; i++) {
      if (!(i in full) || !(i in frontier)) exit 7
      total_log[i] = log(full[i] / frontier[i])
      rss_log[i] = log(full_rss[i] / frontier_rss[i])
      compile_log[i] = log(full_compile[i] / frontier_compile[i])
      verify_log[i] = log(full_verify[i] / frontier_verify[i])
      total_mean += total_log[i]
      rss_mean += rss_log[i]
      compile_mean += compile_log[i]
      verify_mean += verify_log[i]
    }
    total_mean /= n; rss_mean /= n; compile_mean /= n; verify_mean /= n
    total_var = rss_var = 0
    for (i = 1; i <= n; i++) {
      total_var += (total_log[i] - total_mean) ^ 2
      rss_var += (rss_log[i] - rss_mean) ^ 2
    }
    total_var /= n - 1; rss_var /= n - 1
    printf "rounds=%d certified_total_ratio=%.3f total_log_t=%.2f compile_stream_ratio=%.3f replay_ratio=%.3f rss_ratio=%.3f rss_log_t=%.2f audit_size_ratio=%.3f\n", \
      n, exp(total_mean), total_mean / sqrt(total_var / n), exp(compile_mean), \
      exp(verify_mean), exp(rss_mean), rss_mean / sqrt(rss_var / n), 46401954 / 38984421
    if (exp(total_mean) < 1.3 || exp(rss_mean) < 3.0) exit 8
  }
' "$evidence"
