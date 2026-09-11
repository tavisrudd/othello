# C1016: best-state retention through kicks

Private native authority: `~/src/ergodis-worktrees/c1016-full-2092/ergodis-private`.
Correctness commit `633ddfe`; completed evidence checkpoint `15bc0d3`.
The authority's `evidence/margin-kick-retention-report.md` owns exact commands,
hashes, counter samples, replay results and the related-path audit.

Margin-fibre tabu now retains every strictly better intermediate kick state.
The independent regression failed old logic at seed 2: retained 593,568 versus
visited best 561,712. Thirty-two seeds now pass, with a required non-final best;
accepted equal-score moves preserve the prior same-fibre witness. Empty kicks
retain the best and clear tabu state. No actual lost solution is claimed.

Validation: 756 release workspace tests, including the real-loop allocation
counter; 624 independently replayed best/final witnesses; seven artifact mutation
checks. One/twelve-core retained A/B covers disabled, default and frequent kicks.
Observed cycles per step rose 0.2–0.4%; instructions per step changed less than
0.01%. The small shift also appears with kicks disabled. These are four-pair,
CPU-budget comparisons, not a speedup or proof of zero overhead. Correctness
repair is accepted with the measured small cost. No hot layout or communication
changes, and no public core, WASM or live-demo changes.

## Next priority and mystery ledger

The related-path audit is now closed at private checkpoint `96e04d5`: carrier,
phase-two and column-margin retention are repaired, and bounded carrier
arithmetic lowers measured cycles 35.5–35.9%. See
`2026-09-11-c1016-related-kicks-and-carrier-ranges.md` for the 765-test gate,
independent replay, measured limitations and next property-testing frontier.

Profiles put about 95% of sampled cycles in candidate selection and about 5% in
potential refresh. Temporary scoring arrays incur substantial sampled stack
traffic; repeated symmetric Gram evaluations are another candidate. Sampling
skid precludes exact instruction-latency attribution. Neither optimization is
yet implemented or established as a win.

The score-14,800 known-containing-fibre recovery gate, quality effects of corrected
aspiration, and the order-2092 construction remain open. No stored solution or
target coordinates were added to search policy.
