# C1016: wider margin-neighbourhood diagnostics

Native authority: `~/src/ergodis-worktrees/c1016-full-2092/ergodis-private`,
branch `c1016-full-2092-campaign`, checkpoint `f81b4ba`.
The scheduled native phase runs until 2026-09-11 13:33 UTC.

The banked score-14,800 state has no improving or neutral six-cycle preserving
both margins. Complete census: 71,559,936 edge sets, 2,247,171 admissible,
minimum delta +2,928. Independent direct arithmetic agrees exactly. A new
immutable pricing snapshot prevents stale-potential use; the old descent
kernel is unchanged. Full workspace gate: 739 tests passed; both direct and
Gram census loops allocate zero after setup, with exact parallel agreement.

The Gram diagnostic takes median 1.148 s versus 4.220 s direct on one worker,
0.192 s versus 0.684 s on twelve distinct physical cores, from twelve rotated
A/B pairs. This is a diagnostic-kernel comparison, not a solve speedup.
Source, exact census, counter samples, replay commands and scope are in
`evidence/margin-six-cycle-census.md` in the authoritative worktree.

Earlier diagnostic commits `e5826b5` and `aa4f267` sampled 4/6/8-cycles and
cross-block pairs of retained four-cycles. Neither sample improved; neither
grants coverage. The complete 359,987,561 cross-block pair census now also excludes improving
or neutral moves: minimum 18,784. Its generic grouped residual-vector kernel
uses exact partial squared-norm rejection, measuring 1.86x single-core and
1.66x twelve-core speedups against its full-coordinate reference. Full source
replay and 743 release tests pass. The best of twelve fresh randomized controls
(score 23,152) also has no improving pair (minimum 24,720). All twelve frozen controls now have complete two-neighbourhood strict-descent
closure: only three improve, by small amounts; the best remains 23,152.
Sixteen complete censuses suffice; none reaches its round cap. A cold-calibrated
threshold-acceptance experiment is frozen before measurement in the private
`evidence/margin-threshold-walk-design.md`. `evidence/margin-pair-census.md` owns
precise scopes, counter evidence, replay commands and the mystery ledger. The pair objective is nearest-vector cancellation in residual
space, enabling general safe coordinate-envelope and partial-sum bounds.

The existing control gate remains open: recover approximately 14,800 from
random points inside that known-containing fibre. No larger-neighbourhood
descent has yet passed it. The detailed extra-juice/Tao mystery ledger is in
the private census report.

## Pricing and acceptance-policy result

Private checkpoint `f45ed58` validates contiguous-stream exact pricing with
749 release tests and zero-allocation checks. Against the retained previous
halo implementation, solve-time ratios are 0.644 on one worker and 0.636 on
twelve. Explicit inlining restores the rejection-only path: no measured
regression remains. Counters and matching fixed-work outputs substantiate the
pricing gain; these are independent trajectories, not one-root parallel speedup.

The four-policy quality experiment is negative. Record travel, local threshold
and neutral greedy each improve zero of 48 repeated worker-runs; unchanged tabu
improves 30 and reaches 22,736. These are repetitions of twelve development
source/seed pairs, not 48 independent initial states. No externally desired
score enters the new policy. The randomized 14,800 recovery gate remains open.
Full evidence, including the caught rejection-path regression, is in private
`evidence/margin-walk-streams-report.md`.

## Current experiment

Checkpoint `f81b4ba` freezes a replicated shell-selection experiment: the five
previous leaders against five fixed control shells, four fresh seeds each,
with equal two-stage wall budgets and CPU counters. Existing q174 and carrier
kernels are unchanged. Ten short smoke cases and a separate witness replay pass.
The full 40-case run is active; no quality result is claimed yet. Protocol and
runner are private `evidence/shell-replication-design.md` and
`scripts/shell_replicated_sweep.py`. This measures the specified two-stage
pipeline, not intrinsic shell difficulty or a ranking of all 39 shells.
