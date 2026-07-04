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
  echo "## Search-structure implications from older handoffs"
  echo
  echo "Status: synthesis / heuristic, with references to measured older data."
  echo
  echo "References read:"
  echo
  echo "- \`../notes/handoffs/2026-06-17-per-ply-distinct-measurement.md\`: transpositions are strictly intra-ply; per-ply distinct distribution is the sizing gate for ply-windowing and value-only layers."
  echo "- \`../notes/handoffs/2026-06-15-queens-memory-roadmap.md\`: BuRR/value-only density is only sound under known membership; graph-iso freeze key gives a measured ~3.4x merge at freeze/archive time; staged root clearing without archive loses cross-root reuse."
  echo "- \`../notes/handoffs/2026-06-17-root-ordering-exploration.md\`: root order has weak upside; most positions are root-private and no universal trunk exists."
  echo "- \`../notes/handoffs/2026-06-19-explicit-stack-frontier.md\`: move-ordering scalar features failed; recurse-weighted ranklab showed much apparent ordering loss was cheap getK-leaf work."
  echo "- \`../notes/handoffs/2026-06-22-push-past-floor-levers.md\`: canonical getK value layer, code-key memo, component decomposition, treewidth DP, and canon-skip were all killed by measurement; compression signals usually appeared where work was cheap."
  echo "- \`../notes/proposal-2026-07-02-tt-reexpansion-law.md\`: TT re-expansion should be modeled per band; small-n curves degrade gracefully, while large-n pain comes from high R_infinity / expensive band structure rather than a literal mathematical divergence."
  echo "- \`../notes/handoffs/2026-06-23-queens-n18-umbrella.md\`: skip[18,25] made n=18 converge; band-skipping works when skipped-band recompute is bounded and storing that band would create high eviction pressure."
  echo "- \`../notes/handoffs/2026-07-01-queens-nimber-a344227.md\`: nimber heap-sum engine should inherit the same band/context telemetry; h=0 rounds dominate and bk/dense leaves matter."
  echo "- arXiv:2605.10326: line-load/row-column-diagonal energy and four-channel tensor vocabulary support the additive label model, but do not directly imply game strategy."
  echo
  echo "### Implication for solver implementation"
  echo
  echo "Status: heuristic / engineering recommendation."
  echo
  echo "The useful runtime unit is not just a canonical position. It is a context-rich record:"
  echo
  echo "\`\`\`text"
  echo "(pc or ply band, parent/root context, local overlap signature, score or rank)"
  echo "\`\`\`"
  echo
  echo "This combines the old band results with the new border-pair findings:"
  echo
  echo "- Old solver data: storage, re-expansion, getK cost, and skip profitability are strongly popcount-band dependent."
  echo "- New border data: exact local overlap signatures compute \`|combined_asym|\`, but minimizer status needs row context \`(n,x)\`."
  echo "- Killer/refutation data: parent/root-specific context can be decisive where global scalar predictors fail."
  echo "- The statistical-mechanics paper gives line-load vocabulary: row, column, sum-diagonal, and diff-diagonal occupancy/energy."
  echo
  echo "Recommended telemetry fields for future solver-side repair events:"
  echo
  echo "\`\`\`text"
  echo "n"
  echo "ply"
  echo "pc"
  echo "root_move"
  echo "parent_move"
  echo "opponent_move"
  echo "candidate_reply"
  echo "child_pc"
  echo "is_getK_leaf"
  echo "is_recurse_child"
  echo "tau_reply_legal"
  echo "border_state"
  echo "combined_asym"
  echo "asymmetry_rank"
  echo "exact_full_kind_edge_hash"
  echo "row_col_quotient_edge_hash"
  echo "line_load_delta_rows_cols_sums_diffs"
  echo "TT_hit_or_miss"
  echo "cut_rank"
  echo "killer_rank"
  echo "child_value_or_grundy_if_known"
  echo "\`\`\`"
  echo
  echo "Solver policy implication:"
  echo
  echo
  echo "- Use asymmetry minimizers and edge-overlap buckets as candidate generators and move-ordering features."
  echo "- Do not prune on them yet."
  echo "- Index any learned or tabled repair advice by \`(pc/ply band, parent/root context, overlap signature, score rank)\`, not by local move coordinate alone."
  echo "- Keep storage policy band-aware: skip cheap bounded-recompute bands, store bands where misses trigger expensive recursive recomputation."
  echo "- Preserve the ply-window/value-only archive idea as the serious compression route, but gate it on per-ply distinct measurements and explicit membership semantics."
  echo
  echo "### Implication for theory"
  echo
  echo "Status: heuristic proof direction."
  echo
  echo "The older data argues against generic graph-structure compression as a theorem path:"
  echo
  echo "- component decomposition is essentially absent in the tail;"
  echo "- treewidth can be low but still not useful because the searched subtree is already tiny per instance;"
  echo "- canonical/value memoization compresses most where the replaced work is cheap;"
  echo "- scalar move features are too weak to identify strategic replies."
  echo
  echo "The theory path should instead be arithmetic and contextual:"
  echo
  echo "\`\`\`text"
  echo "mirror core"
  echo "+ live-border occupancy <= 2"
  echo "+ exact scar line-label formulas"
  echo "+ overlap-signature candidate set"
  echo "+ row/context-dependent repair oracle"
  echo "+ reservoir / line-load inequalities"
  echo "\`\`\`"
  echo
  echo "B6 should be stated as a candidate-generator observation, not as a universal reply theorem:"
  echo
  echo "\`\`\`text"
  echo "Border-pair asymmetry minimizers form a small structured arithmetic candidate set."
  echo "They are not determined by a simple local coordinate rule; repair selection needs row"
  echo "context and likely residual-state context."
  echo "\`\`\`"
  echo
  echo "### What to do next"
  echo
  echo "Status: recommended next work."
  echo
  echo "1. Low-memory theory note: write theorem-ready lemmas for the score-exact overlap facts now observed:"
  echo "   - row/col transpose quotient preserves \`|combined_asym|\`;"
  echo "   - full-kind edge overlap signature determines the border-pair asymmetry score in the finite data;"
  echo "   - row context is necessary for minimizer status."
  echo "2. Low-memory arithmetic experiment: for each \`(n,x)\`, classify the exact asymmetry minimizer set by size and interval/side structure; output a compact candidate-set table, not a reply formula."
  echo "3. Solver telemetry design: add a gated repair-event log schema matching the fields above, but do not run it while the box is busy."
  echo "4. Storage/search architecture after the box is free: run or revive \`count --by-ply\` to size the widest ply and decide whether ply-windowed value-only layers are feasible for the next large run."
  echo "5. Solver-side validation after the box is free: compare actual solver/killer repair choices against exact asymmetry minimizers and row/col-quotiented edge buckets."
  echo
  echo "Near-term choice: do item 1 next. It is pure proof hygiene, costs no RAM, and turns the useful verified arithmetic into reusable lemmas before more tables accumulate."
  echo
} >> "$NOTES"
