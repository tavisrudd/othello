# C1016: wider margin-neighbourhood diagnostics

Native authority: `~/src/ergodis-worktrees/c1016-full-2092/ergodis-private`,
branch `c1016-full-2092-campaign`, checkpoint `dac717e`.
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
grants coverage. All 359,987,561 cross-block pairs remain the next complete
discriminator. The pair objective is nearest-vector cancellation in residual
space, enabling general safe coordinate-envelope and partial-sum bounds.

The existing control gate remains open: recover approximately 14,800 from
random points inside that known-containing fibre. No larger-neighbourhood
descent has yet passed it. The detailed extra-juice/Tao mystery ledger is in
the private census report.
