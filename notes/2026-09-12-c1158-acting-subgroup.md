# C1158 — acting subgroups of constrained enumerations

**Lane**: `ergodis`
**Date**: 2026-09-12
**Status**: COMPLETE.

Task branch `task/c1158-acting-subgroup`, commit `3d52f12`, starts from C1153
`b0b0648`; its paired core is pinned at `b7cb98a`. Worktrees are under
`~/.cache/ergodis/worktrees/c1158/`. Live campaign and main branches are untouched.
The existing shared build target is retained. No hot solver change, performance
claim, public export or canonical-augmentation implementation was made.

## Scope correction and result

The task wording conflated the old multiplier-41 q18 source-interface census,
q29 shells and the actual two-transfer census. The implemented twelve-state
`order6 paired-census` operates on q174 counts. This pass separates all three
and measures the relevant actions within C1153's declared affine/inversion/
value-sign/block-permutation group, not an unproved full symmetry classification.

| Object | Setwise group order at its level | Kernel on that domain | Effective action |
|---|---:|---:|---:|
| Multiplier-41 canonical q18 interfaces | 36,864 | 48 | 768 |
| Each q29 shell projecting a banked paired-census seed | 1 | 1 | 1 |
| Each of the twelve q174 paired output sets | 1 | 1 | 1 |

Carrier projection kernels are 19,803,868 at q18, 629,856 at q29 and 243 at
q174. They act identically on projected rows and provide no reduction.
For the q18 interface domain the carrier setwise preimage is 730,049,789,952,
with domain-action kernel 950,585,664. These are induced q18 actions, not claims
about preservation of every fine multiplier-41 lift.

## Exact q174 negative

Every single/pair output shares its seed's q29 projection and lies within count
L1 radius four of that seed. Each q29 shell has trivial stabilizer, independently
computed by Python matching and the existing Rust canonicalizer. Its complete
q174 preimage has 2,592 elements: multipliers 1 and 59, four shifts in 29·{0,…,5}.

An admitted single transfer excludes every nonidentity candidate: its image is
at least 124 from the seed, outside the output radius. More strongly, every
nonidentity transformed seed is at least 122 from its seed, exceeding twice the
radius. Since the group is an L1 isometry, no nonidentity ambient element can
map any output state to another output state. Therefore there are no orbit
merges beyond ordinary equality, not merely no nontrivial setwise group.

All 31,104 candidates across twelve seeds are checked. Independent Rust replay
uses the existing `apply` action and agrees on complete candidate-stream hashes
and distance minima. It enumerates pair admission through the actual production
predicate, reproducing 32,039 singles and 42,532,366 cell-disjoint pairs; Python
uses a separate incidence-count formula. These are move counts, not distinct
state counts. Scores and search exclusions are not recomputed or expanded.

## Exact q18 group, with its actual limits

The canonical source domain has six U(18)-constant count slots, radices
8,8,15,15,15,15, row weights 260,261,261,261, and exact quotient PAF. Six anchors
come from the existing sealed-cache test witness with the last three blocks
permuted. The production cache writer/reader replays every anchor's equations.

Exhaustive local affine matching on all six anchors bounds the setwise group
by 36,864. Half-period shifts, complements of the three equal-weight blocks,
their permutations, common units and independent inversions preserve the entire
packing/weight/PAF domain, giving the matching lower bound. The report proves
that domain closure algebraically. The scripts check 152 scalar packing cases,
114 anchor/generator cases and 252 full quadratic coefficient identities. Rust
independently evaluates all 14 generators on a complete 2,628-vector quadratic
basis in 72 variables. This is not a sample-only lower-bound claim.

Units and inversions act identically on every canonical word, giving kernel 48;
pointwise checking of the six anchors supplies the matching upper bound. The
effective action is 768. That is not a measured speedup or orbit-count reduction:
individual interfaces have nontrivial stabilizers. The earlier complement/
translation quotient is acknowledged, and the full 1,984,512-record cache is
not regenerated or recounted. Its defining mathematical domain, rather than a
new claim to have replayed every cached record, is the subject of this proof.

## Validation and durable bundle

Task-branch evidence authority:
`evidence/2026-09-12-acting-subgroups.md`, both dated JSON certificates and
`evidence/2026-09-12-acting-subgroups.sha256`. The manifest binds both Python
scripts, Rust replay, banked inputs and existing action/admission sources.
Exact commands and mathematical scope are in that report. Four Rust release
tests pass, both Python `--check` replays pass, formatting and all hashes pass.
Owned Clippy diagnostics are zero. The inherited strict library gate still
fails on `g53_mod14_reduction.rs:58` (`unnecessary_cast`) and
`order6_carrier.rs:388` (`useless_conversion`); those foreign files are untouched.
Cache GC refuses from a worktree inside its cache root by design; the canonical
main-root dry run is used instead, without deleting anything.

## Mystery ledger — ej + tt

- Settled: carrier group order includes large projection kernels; effective
  actions, not those kernels, govern any reduction.
- Settled: a trivial setwise subgroup alone does not exclude ambient-orbit
  collisions inside a constrained set. The stronger 122>8 center separation
  settles that question for the actual paired output sets.
- Settled: the q18 and q174 measurements concern different sets. The old q18
  multiplier-assumed shard already has a structural exclusion; the live paired
  neighborhood has no orbit merges. Neither justifies core augmentation now.
- Scope limit: 768 is an effective group order, not the number of orbits or a
  uniform reduction factor. Any future augmentation needs exact orbit coverage
  and counts on its actual live domain; no new C-ID is allocated here.
- No genuine unresolved mystery remains within the stated acted-set questions.
  No incidental discovery entry: these are task-owned corrections and checks.

Decision: close the measurement. Do not promote a generic action trait or
canonical augmentation from a closed positive example and a live negative one.
Next programme frontier remains the concrete workload/IR-obligation gate for
join-engine and external benchmark allocation; no concrete successor ID exists.
