# C1016: wider margin-neighbourhood diagnostics

Native authority: `~/src/ergodis-worktrees/c1016-full-2092/ergodis-private`,
branch `c1016-full-2092-campaign`, checkpoint `04cdadb`.
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
