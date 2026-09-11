# C1016: wider margin-neighbourhood diagnostics

Native authority: `~/src/ergodis-worktrees/c1016-full-2092/ergodis-private`,
branch `c1016-full-2092-campaign`, checkpoint `49cc0df`.
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

## Replicated shell selection

The complete forty-case replication is committed at `27e2f4b`: five prior
leaders and five fixed control shells, four fresh seeds each, equal two-stage
wall budgets and CPU counters. All 960 stage-worker states independently replay.
Prior leaders have mean carrier score 72.8 worse than controls; no concentration
on those leaders is justified. Best fresh score is 14,176 on control shell 24.
This is a different set of fibres and does not pass the 14,800 recovery gate.
The sample is too small to prove shell equivalence. The observed correlation
between selected q174 and later carrier minima is −0.000499; it does not
validate q174 score as a downstream predictor or compare alternative states
within a case. Protocol, exact data and
scope are in private `evidence/shell-replication-report.md`.

## Sampled selection and current gate

Checkpoint `0c2e445` adds an explicit private sampled-tabu experiment with
753 passing release tests and five evidence-integrity mutation controls.
Independent completed-artifact replay checks all 192 best/final witnesses.
Contiguous/modulo pricing time ratios are 0.373 single-worker and 0.375 with
12 workers. The ordinary common-apply refactor and rejection-only control show
no material observed regression. Ordinary/default selection remains unchanged.

Quality is negative: sampled tabu improves 0/48 repeated worker runs, versus
30/48 for unchanged full-neighbourhood tabu. Best remains 23,152 versus 22,736;
sampled median final score is 47,336. Its 54,211 median accepted moves show a
higher-travel regime than record acceptance, with no improvement. The sampled
prototype has no restart/kick policy, so this does not isolate sampling from
escape behavior. Private authority: `evidence/margin-sampled-tabu-report.md`.

## ej / tt and remaining frontier

The reusable progress is exact residual-vector arithmetic and cheaper pricing,
not a successful new heuristic or a solved 2092 matrix. Faster random proposals,
record travel and sampled best-selection all fail the known-containing fibre.
A matched escape-policy comparison or an exact residual-candidate index is the
next useful discriminator; never guide it with stored target signs. Retain the
plain-prime route as an alternative. The kernel representation, policy quality
and evidence-coverage questions remain separate. A concrete unimplemented
exact box-bound index proposal and its stale-source/interaction/performance
gates are in private `evidence/residual-candidate-index-plan.md`.

Order 2092 and the approximately 14,800 randomized-fibre recovery gate are open.
No heuristic miss grants infeasibility. Public core, WASM and live demo were not
changed during this native phase. Umbrella C1016 remains active.
