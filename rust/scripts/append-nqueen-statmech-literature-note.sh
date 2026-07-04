#!/usr/bin/env bash
set -u

cd "$(dirname "$0")/.."

DATE="$(date +%F)"
NOTES="../notes/${DATE}-codex-border-overlap-graph.md"

mkdir -p ../notes
if [[ ! -s "$NOTES" ]]; then
  {
    echo "# Border overlap-graph pass"
    echo "Date: ${DATE}"
    echo "## Running log"
  } > "$NOTES"
fi

{
  echo
  echo "## Literature note: statistical-mechanics N-Queens paper"
  echo
  echo "Status: heuristic / external vocabulary, not a game-theoretic result."
  echo
  echo "Reference: arXiv:2605.10326, https://arxiv.org/abs/2605.10326"
  echo
  echo "Useful translation into this project:"
  echo
  echo
  echo "- The paper's energy formulation is line-label native: rows, columns, and both diagonal families contribute conflicts through line occupancy counts. This is the same additive vocabulary used here as row/col/sum/diff labels."
  echo "- The row/column/diagonal constraint hierarchy supports separating reservoir density from diagonal scar damage. That matches the current proof direction: keep a dense core/reservoir while treating border scar lines as structured perturbations."
  echo "- The tensor-network encoding is a compact four-signal line-state checker: an occupied square consumes/emits row, column, sum-diagonal, and diff-diagonal signals. This is a useful external model for certificate verification or completion-count diagnostics after fixed scar states."
  echo "- The counting method could, in principle, count completions of a residual board with fixed consumed labels or boundary signals. That is mobility/counting evidence, not a P/N or Grundy solver."
  echo
  echo "What not to import:"
  echo
  echo "- The thermodynamic-integration and asymptotic counting results do not directly address the impartial game, central strike, border repair, or nimbers."
  echo "- The tensor network is exact but exponential under naive contraction, so it should be used only for tiny residual checks or as theorem/certificate vocabulary unless a specialized contraction is developed."
  echo
  echo "Candidate use in future notes:"
  echo
  echo
  echo "- Define a four-channel line-signal certificate for a fixed position: consumed row labels, consumed column labels, consumed sum labels, and consumed diff labels."
  echo "- Add reservoir diagnostics based on line loads: max row/col load, max diagonal load, and scar-induced line-load imbalance."
  echo "- When solver telemetry is available, log line-load energy deltas for chosen repair replies alongside the existing asymmetry and edge-overlap hashes."
  echo
} >> "$NOTES"
