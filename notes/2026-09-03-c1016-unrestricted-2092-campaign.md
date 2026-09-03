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
