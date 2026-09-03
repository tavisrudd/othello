# C1016 — unrestricted order-2092 campaign launch and first eight chunks

**Lane**: `complete-ports` · **Task**: C1016 · Launched 2026-09-02, running.

## What is running

The unrestricted (multiplier-free) order-2092 search in its best measured
configuration: the order-six margin shell with outer-epoch seeding, eighteen
workers, an exact cold scope reseed every 1,000,000 mutations, and 1,000,000,000
mutations per worker per chunk. That is exactly the campaign shape recorded in
`2026-08-30-c1016-ergodis-hadamard-quotient-synthesis.md` as the run that
visited 18,000 fresh outer profiles in 942 seconds and improved the best q29
residual from 192 to 96. The campaign now repeats that shape indefinitely with a
fresh coordinator seed per chunk, stopping early only on an exact q29 shell hit
or an exact phase-two hit.

Launch command, from the run directory:

    choom -n 1000 -- ./hadamard-c1016 order6 margin-evolve 18 1000000000 outer-epochs 1000000 0 progress.jsonl

## Provenance

Two sibling git worktrees, both detached at the committed HEAD of their
repository, so the search kernel is exactly the committed code:

- `~/src/ergodis-worktrees/c1016-full-2092/ergodis` at `b7cb98a`
- `~/src/ergodis-worktrees/c1016-full-2092/ergodis-private` at `48c75d7`

Run artifacts live in `~/src/ergodis-worktrees/c1016-full-2092/run/`
(`progress.jsonl`, `final.json`, `run.err`, `launch.sh`, the retained binary
`hadamard-c1016`), outside both worktrees and off the tmpfs.

One driver change was required and is confined to the tier-2 subcommand
`tasks/hadamard-2092/src/order6/margin_evolve.rs`; no library or kernel code was
touched. The committed driver runs a single campaign from a fixed seed and
prints only when it finishes, so repeated invocations would reproduce the same
trajectory and a multi-day run would emit nothing until the end. The change adds
two optional positionals, `chunks` and `progress`: chunk zero uses the original
seed and reproduces the recorded control exactly, later chunks derive a fresh
coordinator seed, and each finished chunk appends one JSON line. It is committed
on the branch `c1016-full-2092-campaign` in the private worktree.

## Final result: sixteen chunks, stopped deliberately

The campaign ran 4h04m and was stopped on request after sixteen chunks:
288,000,000,000 mutations, 288 independent worker runs, eight seed families
reaching 96 and eight reaching 128, no q29 shell hit and no exact hit. The
campaign best q29 residual is 96, the same value the earlier recorded
18,000-profile campaign reached, and it never improved.

| Worker best q29 residual | Runs |
|--------------------------|------|
| 96                       | 12   |
| 128                      | 53   |
| 160                      | 104  |
| 192                      | 91   |
| 224                      | 27   |
| 256                      | 1    |

Retained evidence is committed on the branch `c1016-full-2092-campaign` of
`ergodis-private` at `f7aba58`, under
`evidence/c1016-unrestricted-2092-campaign/` with `SHA256SUMS` covering the
campaign log, the launcher, the watcher, and the executed binary.

## Why the residuals are quantized, and what the floor is

The phase-one score is the squared error of the combined q29 PAF against 2020
at shift zero and -72 at each of the fourteen off-zero shifts. Three exact facts
pin its arithmetic, and together they explain the observed value set completely.

The shell fixes the zero shift, so all error lives off zero. The global
autocorrelation sum law gives the already-banked all-ones relation: summing the
combined PAF over all twenty-nine shifts equals the sum of squared row sums,
which is 4 for row sums `(2,0,0,0)`, so `2020 + 2 sum_{s=1..14} P(s) = 4` and
the fourteen off-zero deviations `d(s) = P(s) + 72` sum to zero. Because every
q29 coefficient is even, each block PAF is divisible by four and every `d(s)` is
too, so `d = 4e` where `e` is the residual of the halved system against
`(505,-18,...,-18)`.

Hence `score = 16 sum e(s)^2`, and `sum e(s) = 0` forces `sum e(s)^2` to be
even. Every attainable score is therefore a multiple of 32 — which is exactly
what 288 worker runs show, with no exception. The campaign floor of 96 is the
statement `sum e(s)^2 >= 6`, and every residual-96 state examined has `e` in
`{-1,0,1}` with exactly three coordinates at `+1` and three at `-1`.

The sharp open question is now arithmetic rather than computational: the linear
constraints admit `sum e^2 = 2` (one coordinate `+1`, one `-1`) and `4`, yet
neither ever occurs. Either a further exact obstruction excludes small-support
deviations, in which case the floor is a theorem and the search family is
provably shell-free, or they are reachable and every annealer so far has been
trapped. The residual-floor census now running harvests every worker's own best
state, not just the chunk winner, to give the relation miner the whole left tail
of this distribution to work on.

## Blind congruence search on the residual: a clean negative

Thirty-four independently obtained best states — sixteen chunk winners from the
stopped campaign and eighteen per-worker states from the first census chunk —
were reduced to their fourteen-coordinate residual vectors. Two checks ran on
that corpus.

First, `score = 16 sum e^2` holds exactly on all thirty-four states, and every
residual-96 state has exactly three coordinates at `+1` and three at `-1`. A
coordinate of absolute value two first appears at score 128, never at 96.

Second, a blind search for further linear congruences: the null space of the
thirty-four-by-fourteen residual matrix was computed over the prime fields 2, 3,
5, 7, 11, 13, and 29. In every one of them the null space has dimension exactly
one, which is the already-banked all-ones relation and nothing else. The
observed residual vectors therefore span the entire thirteen-dimensional
hyperplane `sum e = 0`.

That is a useful negative. No linear or congruence invariant beyond the
autocorrelation sum law constrains the deviation, so nothing of that kind
forbids `sum e^2 = 2` or `4`. Any obstruction would have to come from
realizability by actual integer rows, not from the residual arithmetic. The
weight of evidence therefore shifts toward the floor being a property of the
move geometry — the annealer reaches `sum e^2 = 6` and would have to pass
through worse states to go lower — rather than a theorem waiting to be proved.

The productive consequence is that the eight residual-96 states are now the
right targets for an exact bounded neighbourhood census, in the way the earlier
residual-576 state was proved empty in its complete three-transfer
neighbourhood. Those censuses were run around older, worse states; these eight
come from independent seed families and are three times closer to the shell.

## Scope learning: balanced inventories are the wrong place to search

The library already computes a cold per-reseed observation for every outer
epoch — the four magnitude-inventory counts, the four row energies, the four odd
supports, the sampling policy, and the best q29 score that epoch reached — and
the driver was discarding it. It now writes those rows out, giving 5,400 labelled
scope-to-outcome rows per chunk.

On the first 10,800 rows, with an epoch counted as productive when its million
mutations reach a q29 residual of 224 or less (a 0.50% base rate), the row-energy
profile of the scope predicts the outcome strongly and monotonically.

| Smallest row energy | Rows  | Productive | Lift |
|---------------------|-------|------------|------|
| under 20            | 1,506 | 1.26%      | 2.52 |
| 20 to 30            | 1,581 | 1.14%      | 2.28 |
| 30 to 45            | 2,354 | 0.64%      | 1.27 |
| 45 to 70            | 2,943 | 0.07%      | 0.14 |
| 70 and above        | 2,416 | 0.00%      | 0.00 |

| Energy spread (max minus min) | Rows  | Productive | Lift |
|-------------------------------|-------|------------|------|
| under 150                     | 3,716 | 0.05%      | 0.11 |
| 150 to 200                    | 2,746 | 0.58%      | 1.17 |
| 200 to 260                    | 2,489 | 0.68%      | 1.37 |
| 260 and above                 | 1,849 | 1.03%      | 2.06 |

Not one of the 2,416 sampled scopes with smallest row energy at or above 70 was
productive, and scopes with energy spread under 150 were productive twice in
3,716 draws. Every one of the four epochs that reached residual 128 from a cold
start has two light rows and two heavy ones: sorted energies
`(14,19,164,308)`, `(32,56,200,217)`, `(24,28,169,284)`, and `(21,50,206,228)`.

This bears directly on the retained hand-selected inventory. Its row energies are
`(123,128,128,126)`: smallest energy 123, spread 5. That is the deadest stratum
in the table on both axes, which is consistent with the earlier fixed-inventory
control stalling at residual 576 while the scope-sampling campaign reaches 96.
The lesson is that the productive region is strongly unbalanced inventories — one
nearly empty row against two heavy ones — and the search has been spending most
of its budget on balanced ones.

The joint stratum, smallest energy under 30 together with spread at least 200,
holds 23.3% of draws at 2.38 times the base rate. A sampler restricted to it
should see roughly two to three times as many productive starts per unit compute.

A fresh chunk of 5,400 rows, held out and scored only after the rule was fixed,
confirms the effect and slightly strengthens it: base rate 0.39%, stratum rate
1.18%, lift 3.03. One claim from the training rows does not survive. Zero of
2,416 training draws with smallest row energy at or above 70 were productive, but
the holdout has three productive draws out of 1,211 there. That region is
depleted by roughly a factor of five, not empty, and the rule should be stated as
a strong bias rather than a hard exclusion. The second-smallest energy also shows
a sharp optimum in the 40-to-60 band, but that rests on twenty events and is not
yet separable from noise.

## Results after eight chunks

144,000,000,000 mutations in 7,333 seconds, 916.6 seconds per chunk, eight
independent seed families, 144 worker runs. No q29 shell hit and no exact hit.

| Statistic                     | Value                                  |
|-------------------------------|----------------------------------------|
| Campaign best q29 residual    | 96                                     |
| Chunk best residuals           | 96, 96, 96, 96, 128, 96, 128, 96       |
| Worker best residual 96        | 10 runs                                |
| Worker best residual 128       | 29 runs                                |
| Worker best residual 160       | 52 runs                                |
| Worker best residual 192       | 40 runs                                |
| Worker best residual 224       | 13 runs                                |

Every worker best is a multiple of 32, and the distribution has a sharp left
edge: 96 is attained by ten runs and nothing below it is ever attained. The
descent of the tail is roughly a factor of two to three per 32-step (52, 29, 10),
so a smooth continuation would predict about four runs at 64 among 144; observing
none has probability near two percent under that model. That is evidence for a
genuine floor of this move geometry rather than a compute shortfall, but it is
discovery evidence only and carries no negative authority.

## What this means for the next move

Reaching 96 no longer requires a long campaign — six of the first eight chunks
hit it within about fifteen minutes each. Additional hours of the same kernel buy
resampling of the same left edge, not depth. The next real reduction has to change
the move geometry or the state, not the budget: the outstanding candidates remain
an algebraic sufficient-state theorem linking the cyclic and negacyclic q18
boundary tables to the eighteen-by-twenty-nine binary lifts, and a measured
mixed-CRT reconstruction search. The standing launch gate is unchanged — a pair
side near 10^8 states with a checkpointed positive reconstruction path — and this
campaign does not meet it.

A secondary measurement: worker finish times for an identical billion-mutation
budget spread from roughly 600 to 900 seconds because cold unranking cost is
scope-dependent, so each chunk ends with most workers idle and the campaign wastes
on the order of twenty percent of the machine. Pulling epochs from a shared
counter instead of a fixed per-worker budget would recover it; that was not done
here because it changes the driver while the floor result argues against buying
more of the same compute.

## Stratified rerun: the sampler now spends its budget where the outcomes are

The scope-learning result above was acted on. The outer scope sampler draws each
reseed as an exact conditional sample of four `(energy, odd support)` row scopes
whose energies sum to 505, under one of three rotating policies. It now accepts
an optional stratum, and rejects a drawn quartet that misses it before any of the
expensive work — the inventory unranking and the sign reconstruction — happens.
The default stratum is the one the census measured: smallest row energy at most
30 together with an energy spread of at least 200.

Three properties matter for what the rerun can be used to claim.

1. Rejection acts only on the scope selection, never on the drawn coefficients,
   and the retained draw still passes the unchanged canonical replay boundary.
   An accepted quartet is an exact conditional draw of the same policy,
   conditioned on the stratum.
2. One reseed in five is drawn with the bias switched off, and the attempt budget
   is bounded at 64 with the last draw kept. The holdout showed the heavy-balanced
   region is depleted by about a factor of five, not empty, so nothing is
   excluded — every scope the unbiased sampler could reach is still reachable.
3. Only an accepted draw increments the novelty visit counts, so a rejected
   quartet leaves no trace in the policy state, and with the bias disabled the
   sampler is bit-identical to the control, seed for seed.

This is search policy. It changes where the discovery budget is spent and grants
no coverage, exclusion, or negative authority over the scopes it under-samples.

All of it is private: the sampler is `ergodis-private/src/q29_inventory_scope.rs`
and the campaign driver is the tier-2 subcommand, so no public-core change was
involved. The stratum is configurable from the command line
(`--stratum`, `--stratum-max-min-energy`, `--stratum-min-spread`,
`--stratum-attempts`, `--stratum-unbiased-permille`), off by default, and the
per-reseed census now also records the rejection attempts and whether the
retained draw is in the stratum. Library and workspace tests pass, including new
ones for the replay boundary under bias, the unconditioned share, the
control-path identity, and allocation freedom after workspace setup.

### Measured effect

The rerun is the same campaign shape — eighteen workers, one billion mutations
per worker per chunk, cold reseed every million mutations — with the bias on.
Comparing its per-reseed census against the banked unbiased census of 16,200
rows, with an epoch counted productive when it reaches a q29 residual of 224 or
less:

| Run                  | Rows   | Productive | Rate  | In stratum |
|----------------------|--------|------------|-------|------------|
| unbiased control     | 16,200 |         75 | 0.46% |      24.9% |
| stratified rerun     | 18,000 |        196 | 1.09% |      82.5% |

The productive rate rises by a factor of 2.35, with a one-sided Fisher exact
p-value of 2.2e-11. The bias costs nothing: the mean draw takes 7.3 attempts,
and the first chunk finished in 876 seconds against the control's 916.6, so the
rejection loop is far cheaper than the reseed it feeds. The stratum share of
82.5% is what the configuration predicts — four fifths conditioned plus the
natural quarter of the unconditioned fifth.

The chunk-level result so far is the interesting part and is reported below as it
accumulates.

## Method transfer from the high-weight GRS coset paper

The user pointed at `papers/high_weight_grs_cosets`, which classifies every coset
of weight at least `r-1` of a point-deleted generalized Reed--Solomon code. That
paper is foreign to this lane and nothing here edits it, but three of its moves
transfer directly to the residual-floor question, and one of them was checked
numerically here.

### The shift-multiplier group acts, and it collapses the exclusion problem

The paper's classification works by acting with the projective group on syndrome
directions and classifying orbits rather than individual cosets. The unrestricted
q29 problem has exactly such a group and the search has not been using it.

Relabelling every column by `j -> c j` for `c` invertible modulo 29 preserves
each row's energy and row sum, hence the canonical scope, and transforms the
combined periodic autocorrelation by `A(s) -> A(c s)`. The target is constant off
zero, so it is fixed. Therefore the deviation vector transforms by
`e(s) -> e(c s)`, and the group `(Z/29)^* / {+-1}`, cyclic of order 14, acts on
the fourteen shift classes simply transitively. This was verified directly on the
retained residual-96 state: relabelling by `c = 2, 3, 5, 12` leaves the shell
value 2020 and the residual `sum e^2 = 6` unchanged while permuting the deviation
support.

Two consequences follow immediately.

1. **The small-support exclusion becomes a finite, small case list.** Up to the
   action, the residual-32 shapes (`sum e^2 = 2`, one class at `+1` and one at
   `-1`) form exactly `14 * 13 / 14 = 13` orbits, and the residual-64 shapes
   (`sum e^2 = 4`, two classes at `+1` and two at `-1`) form
   `91 * 66 / 14 = 429` orbits. Deciding 442 exactly pinned feasibility
   instances settles whether the campaign floor of 96 is a theorem. Each
   instance is far more constrained than the search that has been run: all
   fourteen off-zero correlation values are fixed exactly, not minimized.
2. **The action is a free score-preserving macro-move.** Every state has
   thirteen relabelled twins with the same score and a different deviation
   support. The move set currently reaches none of them, so the annealer's basin
   structure is much finer than the problem's. Applying a random multiplier as an
   occasional macro-move, or canonicalizing states under the action to
   deduplicate, changes the move geometry at zero cost — which is exactly what
   the previous section argued is needed, and unlike more compute it is free.

An orbit classification of the eight banked residual-96 states puts them in eight
distinct orbits, so the floor is not concentrated on one distinguished deviation
shape; the six-support `+-1` shell is broadly realizable in a way the two- and
four-support shells so far are not.

### The contraction ladder, applied to the difference operator

The paper reduces arbitrary redundancy to a terminal pencil of binary cubics by a
coherent polar contraction, then decides the terminal case exactly by a genus-one
count. The analogous contraction here already exists in one step and has not been
iterated. For a shift `s` write `d_r = y_r - shift_s(y_r)`. Then
`sum_{r,j} d_r(j)^2 = 2 D_s = 2(523 - e(s))`, and the whole correlation of the
derived system is pinned by the original one,
`A_d(t) = 2 A(t) - A(t+s) - A(t-s)`. So assuming a deviation pattern determines
the derived system's energy and its complete correlation, and the derived system
is smaller. Iterating gives a ladder of exactly pinned systems whose terminal
level is small enough for an exact tablebase, with an exclusion or a witness
propagating back up. This is the closest structural analogue of the paper's
recursive carrier theorem, and it is the route that turns the floor from a search
observation into a proof or a witness.

### Spectral pre-filter before any expensive join

At a nontrivial character the target spectrum is exactly `2092`, the order — the
combined spectrum is `sum_r |Y_r(chi)|^2 = 523 + e-hat(chi)` in halved units.
Assuming a deviation pattern therefore requires a totally positive algebraic
integer of `Z[zeta_29]^+` to be a sum of four Hermitian norms, coherently across
one Galois orbit. That is the same fixed-field norm-equation mechanism that
closed the `g=91` order-29 sector by a binomial and three-square argument, and it
is cheap to evaluate per pattern. It belongs in front of the 442 feasibility
instances as a filter, not behind them.

### What was not adopted

The paper's rank-two and catalecticant stratification does not transfer: the
correlation circulant here is positive definite of full rank, so there is no
degenerate locus of the same kind to land in. Its abundance-bound style
construction remains a possible positive route — counting quadruples with a
prescribed correlation by character sums would say whether residual-32 states
should be expected to exist at all — but it is weaker evidence than the exact
ladder and is not proposed as the next step.
