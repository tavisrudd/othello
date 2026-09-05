# C1016 — driving phase two from the banked exact q29 shell corpus

**Lane**: `complete-ports` · **Task**: C1016 · 2026-09-04.

The predecessor (`2026-09-04-c1016-tabu-transfer-bordered-sectors.md`) closed the
bordered order-six `q29` margin shell with a full-neighbourhood tabu step and
banked twelve distinct exact shell states, and named its own successor: consume
that corpus, drive the `q58`/`q87`/`q174` phase-two search from it rather than
from the random lift of whatever phase one happened to reach, measure whether
phase two is itself neighbourhood-limited, and transfer the same delta algebra
to those two views if it is. This is that successor.

Phase two had never actually been driven. The banked walk enters it only after
phase one reaches an exact shell inside the same run, and the stopped
288-billion-mutation campaign never did, so every recorded phase-two mutation
count in this campaign is from a run that started somewhere else. It is now
driven, from all twelve banked shell states, by both engines under a shared
wall-clock budget.

The measurement is unambiguous in both directions. Phase two is strongly
neighbourhood-limited: at equal wall clock the full-neighbourhood step reaches
1,472--1,664 where the banked walk reaches 7,344--9,008, a factor of about five
and a half, and the step puts the `q174` energy exactly on target in every round
while the walk never does. And phase two is not solved: both engines plateau,
the plateau does not move under a two-hundred-fold change of per-lift budget or
any tabu policy tried, and essentially all of the residual sits on one half of
the objective — the `q87` Eisenstein half.

## What phase two is, in the character basis

A phase-one shell state is four integer rows of length twenty-nine. Phase two
lifts one into the 696-cell `q174` state: four blocks of `Z/6 x Z/29` cells
holding a count in `0..=3`, whose signed value `2c - 3` is the sum of an orbit
of three carrier entries. The move is a within-column transfer of one unit from
one class to another, which leaves every column total — and therefore the whole
`q29` view — exactly fixed.

Fix a block and a column. Its six class counts form a `2 x 3` table under the
Chinese remainder isomorphism `Z/6 = Z/2 x Z/3`; write `S_p` for its row sums,
`T_r` for its column sums, and `u = sum S = sum T` for the column total that the
`q29` shell pins. The three views the objective reads are exactly the margins:

```text
q29 value       = 2u - 18,
q58 value (p,j) = 2 S_p - 9,
q87 value (r,j) = 2 T_r - 6.
```

Set the two fluctuation coordinates

```text
e[j]     = S_0 - S_1                            in Z,
delta[j] = (T_0 - T_1) + (T_2 - T_1) omega      in Z[omega],
```

and let `E(c)` and `D(c)` be their combined correlations over all four blocks,
`D` Hermitian. Then, for every shift, the two refined correlations factor
through the `q29` correlation and one fluctuation and nothing else:

```text
A58(a, c) = A29(c)/2 + (-1)^a 2 E(c),
A87(a, c) = [ A29(c) + 8 Re(omega^a D(c)) ] / 3.
```

Both identities are checked numerically on banked states, at every shift, and
they collapse the two registered shells to two statements about the
fluctuations alone. On the `q29` shell, where `A29(0) = 2020` and
`A29(c) = -72`:

```text
q58 shell (2056, -36)  <=>  E(0) = 523 and E(c) = 0 for every c != 0;
q87 shell (2068, -24)  <=>  D(0) = 523 and D(c) = 0 for every c != 0.
```

Two things follow at once. First, the `q58` objective component is exactly
`8 [ (E(0) - 523)^2 + sum_{c=1}^{14} E(c)^2 ]`, and every one of those integers
is even, so its smallest nonzero value is 32 — the same shape of arithmetic
floor the margin shell's step lands on. Second, the two halves of phase two are
independent: `E` is a function of the row margins alone and `D` of the column
margins alone.

The third registered condition is the `q174` energy. Reading the whole column as
a function on `Z/6` and applying Parseval, the fibre's six isotypic energies sum
to six times that energy, and the four registered targets say exactly that the
spectrum is flat off the trivial character:

```text
trivial character            2020,
each of the five others      2092 = 4 * 523 = the order.
```

The sign character carries `4 sum e^2`, the two order-three characters carry
`4 sum N(delta)` each, and the two order-six characters carry the interior
Eisenstein residual of the `2 x 3` table — the coordinate that
`order6_crt_residual` already registers, whose total norm the banked Parseval
identity `8 R = 6 q174 - 2 q58 - 3 q87 + q29` forces to 523. So the three
different objects that must each have total 523 are one statement: the three
nontrivial isotypic components of the order-six fibre carry equal energy.

This also says exactly what phase two is *not*. The four registered shells pin
the full correlation of four of the six characters — the trivial one, the sign
one, and the order-three pair — but only the *energy* of the order-six pair.
The off-zero correlations of that last pair are untouched by the phase-two
objective, and they are exactly the carrier-522 work that remains after a
phase-two hit.

## The delta algebra

The objective is a sum of three functions of three separate pieces of the state,
and a transfer changes each piece independently, so its exact score change is
the sum of three independent exact changes.

Both correlation views are ordinary periodic autocorrelations on a product
group, `Z/2 x Z/29` and `Z/3 x Z/29`. Writing `y` for one block's view,
`A(g) = sum_x y_x y_{x+g}`, and replacing `y` by `y + u`,

```text
Delta A(g) = sum_x u_x W_x(g) + sum_x u_x u_{x+g},
```

with `W_x(g) = y_{x+g} + y_{x-g}` the toggle effect of the position `x` read
against the current view — the same object the margin shell's step maintains. A
transfer inside one column has `u = 2(e_k - e_i)` with `i` and `k` in the same
column, so

```text
Delta A(g) = 2 (W_k(g) - W_i(g)) + 8 [g = 0] - 4 ([i + g = k] + [k + g = i]).
```

The self-correlation term is nonzero only at the two shifts whose column part
vanishes: the zero shift, and the shift `(1, 0)`. In the `q58` view the row
difference has order two, so both indicators fire and the term is `-8`; in the
`q87` view exactly one fires and it is `-4`.

Two further facts collapse the scan. A transfer moves the `q58` view only when
its two classes differ modulo two, and the `q87` view only when they differ
modulo three, so the whole `4 * 29 * 30` neighbourhood contains only `4 * 29 * 2`
distinct `q58` changes and `4 * 29 * 6` distinct `q87` changes. Both tables are
compiled once per step from the maintained toggle effects and the maintained
residual, after which one candidate is two table reads and one `O(1)` energy
change. No Gram matrix is needed here: the factorization does the work the Gram
matrix did in the margin shell.

## Correctness gates

- every predicted candidate delta is checked, over the whole neighbourhood after
  the search has already moved, against both a recompilation from the toggle
  effects and a from-scratch rebuild through the registered
  `Order6MarginEvolveState` that shares nothing with the step
  (`every_predicted_transfer_delta_is_the_exact_score_change`);
- the same gate runs again for each scoped stage against the scoped rebuild
  (`every_scoped_delta_is_the_exact_scoped_score_change`);
- the incremental score is checked against that rebuild after every one of six
  hundred steps, together with the count range and — the invariant that matters
  here — the exact `q29` rows the run was seeded on
  (`the_tabu_score_agrees_with_a_direct_rebuild_on_every_step`);
- the maintained values, toggle effects, residuals and energy of both views are
  checked against a full recompilation
  (`the_maintained_views_agree_with_a_full_rebuild`);
- a `q58` stage is checked to leave the `q87` and energy components exactly
  where it found them, which is what makes the two stages compose
  (`a_q58_scoped_search_leaves_the_q87_component_fixed`);
- the baseline walk is the registered state type driven by the campaign's own
  proposal and sawtooth acceptance, and its metric is checked against a direct
  rebuild on every one of twenty thousand mutations
  (`the_walk_metric_agrees_with_a_direct_rebuild_on_every_mutation`);
- the step loop, its reseeds and its kicks allocate nothing
  (`tests/order6_phase_two_allocations.rs`);
- the driver rebuilds every state it reports or banks from that state's own
  counts, refuses a disagreement, and refuses any state whose `q29` projection
  is not the shell state it was lifted from; and
- an independent Python oracle that shares no code with the engine
  (`scripts/phase_two_replay.py`) rebuilds all four components of every banked
  state from the counts alone and agrees on all twelve.

The workspace clippy gate and the serial library suite (617 tests) pass.

## The measurement

Five interleaved rounds, thirty seconds and twelve workers each, both engines
drawing the same lifts of the same twelve banked shell states
(`ergodis-private/evidence/phase-two-ab.tsv`):

| round | engine | best  | q58   | q87   | q174 | lifts |
|-------|--------|-------|-------|-------|------|-------|
| 1     | walk   | 8,576 | 2,464 | 5,856 | 256  | 92    |
| 1     | tabu   | 1,504 | 768   | 736   | 0    | 173   |
| 2     | tabu   | 1,504 | 512   | 992   | 0    | 230   |
| 2     | walk   | 7,344 | 992   | 6,096 | 256  | 93    |
| 3     | walk   | 9,008 | 3,296 | 5,136 | 576  | 60    |
| 3     | tabu   | 1,472 | 480   | 992   | 0    | 232   |
| 4     | tabu   | 1,504 | 512   | 992   | 0    | 232   |
| 4     | walk   | 8,528 | 2,592 | 5,360 | 576  | 60    |
| 5     | walk   | 8,288 | 3,776 | 4,256 | 256  | 92    |
| 5     | tabu   | 1,664 | 576   | 1,088 | 0    | 230   |

The step wins every round by about five and a half times, and the two engines
separate qualitatively as well as quantitatively: the step ends every round with
the `q174` energy exactly on target and the walk ends every round off it. Unlike
the `g41` fine-orbit sector, where the same algebra was a wash, this sector is
strongly neighbourhood-limited.

It is also not solved. The plateau is insensitive to the per-lift budget across
a two-hundred-fold range — 500, 3,000, 20,000 and 100,000 steps per lift give
1,760, 1,504, 1,568 and 1,488 — and to the tabu policy: stall, tenure, jitter
and kick settings from `(100, 3, 3, 4)` to `(2000, 12, 12, 12)` all land between
1,616 and 2,176, with the default as good as any. The walk plateaus in the same
way at its own level, 8,288--9,248 across the same budget range.

The residual is one-sided. On the banked corpus the `q58` half is solved or
nearly so — the best state has `sum e^2 = 523` exactly, with only four of the
fourteen off-zero `E(c)` nonzero and each of those `+/-2` or `-4` — and the
energy is exactly on target, while `D(0) = 520` against 523 and every off-zero
`D(c)` is nonzero. Scoped stages confirm that this is a property of the `q87`
half itself and not interference between the two: a `q58`-only stage reaches
160, an eighth of the joint run's `q58` residual, while a `q87`-only stage
reaches 880 against the joint run's roughly 1,000. Solving the hard half in
isolation buys almost nothing.

One measurement trap is worth recording. A `q87`-scoped stage given the whole
neighbourhood instead of its own half does *worse* — 1,536 against 880 — because
every transfer inside the other half scores an exact zero under the scoped
objective, and a best-improvement step spends its picks on those ties. The
restriction that makes the two stages compose is also what makes each one work.

## Closed doors

Three cheap exclusions were tested and are empty; none of them filters the
corpus.

- **Capacity.** `|e|` is bounded by `min(u, 18 - u)` per column, so a shell
  state with too little room cannot carry `sum e^2 = 523`. All twelve banked
  states have capacity 6,787--7,579, more than thirteen times what is needed,
  and their Eisenstein capacity is 12,388--13,180 against 2,092.
- **Parity.** `e` has the parity of `u`, which the shell fixes, so every `E(c)`
  has a parity the shell fixes too. It is the right one automatically: the `q29`
  shell forces `sum_{b,j} u_b[j] u_b[j+c] = 9396` at every off-zero shift, which
  is even, and `sum_{b,j} u_b[j] = 1045`, which is odd — exactly the parities
  `E(c) = 0` and `E(0) = 523` need.
- **The Eisenstein prime.** `delta` is congruent to `u` modulo `1 - omega`, again
  fixed by the shell, and the induced congruences on `D(c)` are `0` off zero and
  `1` at zero, which is what `D(c) = 0` and `D(0) = 523` need.

## Provenance

The character decomposition, both factorization identities, the delta algebra
and every gate are exact. Both searches are heuristic: only the direct replay of
the defining equations certifies a positive, and every miss in this report is a
heuristic miss with no negative authority over the sector.

## Mystery ledger

- **The three 523s are one 523, and that is now proved rather than observed.**
  The `q58` fluctuation energy, the `q87` Eisenstein fluctuation norm and the
  interior residual norm that `order6_crt_residual` registers all had to total
  523, by three separate-looking arguments. They are the three nontrivial
  isotypic components of the order-six fibre, and the four registered zero-shell
  targets are exactly the statement that the fibre's character spectrum is flat
  at `2092 = 4 * 523` off the trivial character. Nothing here is open any more;
  it is recorded because it replaces three coincidences with one identity.
- **Phase two does not see the order-six characters at all, and that is the real
  size of the remaining problem.** The registered objective pins the full
  correlation of four of the six characters and only the energy of the order-six
  pair. A phase-two hit therefore leaves twenty-eight complex equations — the
  order-six pair's off-zero correlations — entirely unconstrained, and those are
  what the carrier-522 replay checks. The ladder's remaining rung is larger than
  the rung just measured, and it has never been scored by anything.
- **The `q87` half is hard on its own, and the reason is not neighbourhood
  coverage.** Scoping the search to that half alone, with its own move set,
  improves it by about a tenth. The half has fifty-six real off-zero equations
  against the `q58` half's fourteen, and its values are quantized four times as
  coarsely, so a plausible explanation is simply that it is four times the
  problem at four times the granularity — but that is a hypothesis, not a
  measurement, and no floor for the `q87` component has been derived the way the
  `q58` floor of 32 has.
- **The step lands on the energy target every time and the walk never does.**
  The energy is a single scalar with an `O(1)` exact delta, so a
  best-improvement step over the whole neighbourhood can always find a transfer
  that moves it the right way; the walk, proposing one uniformly random
  transfer, evidently cannot hold it. This is the clearest single illustration
  of what the full neighbourhood buys, and it was not anticipated.
- **The plateau is at roughly 1,500 while the arithmetic floor of the `q58` half
  alone is 32.** Unlike the margin shell, where the step walked straight to the
  last rung above the shell and then needed luck, this step stops far above any
  floor that has been derived. Whether there is a much higher genuine floor here
  — some further congruence on `D(c)` beyond the prime `1 - omega` — is
  unexamined, and it is the first thing to look for before more compute is spent
  on the search.
- **The corpus is twelve states and the plateau barely moves between them.**
  Every round above draws from all twelve in rotation, and the best states come
  from different shells, so nothing yet distinguishes a good shell state from a
  bad one for phase two. If the plateau is a property of the shell rather than
  of the search, a much larger shell corpus is cheap to make — the margin step
  produces one in seconds — and selecting on it would be the lever. That is
  untested.

## Replay

Everything lives in the private campaign branch `c1016-full-2092-campaign` of
`ergodis-private`, checked out at
`~/src/ergodis-worktrees/c1016-full-2092/ergodis-private`.

    cargo test --release -p ergodis-private --lib order6_phase_two
    cargo test --release -p ergodis-private --test order6_phase_two_allocations

    hadamard order6 phase-two --corpus evidence/q29-margin-tabu-shell-hits.json \
        --engine tabu --workers 12 --seconds 45 --budget 5000 --seed 777 \
        --output evidence/phase-two-corpus.jsonl
    hadamard order6 phase-two --corpus evidence/q29-margin-tabu-shell-hits.json \
        --engine walk --workers 12 --seconds 45 --budget 300000 --seed 777
    hadamard order6 phase-two --corpus evidence/q29-margin-tabu-shell-hits.json \
        --engine tabu --objective q87 --workers 12 --seconds 45 --budget 5000

    bash scripts/phase_two_ab.sh evidence/phase-two-ab.tsv \
        evidence/q29-margin-tabu-shell-hits.json 30 12 5
    python3 scripts/phase_two_replay.py evidence/phase-two-corpus.jsonl

Evidence hashes are recorded in that repository's `evidence/SHA256SUMS`. One
entry there, `c1028-chain-ring-instrument-test.json`, has disagreed with its
recorded hash since commit `80963f5` of a different task; it is untouched here.

## Next

The `q87` half is the whole of the remaining phase-two residual, and a stronger
local step is not what it is short of. Before more search compute, look for a
congruence on `D(c)` beyond the Eisenstein prime that would explain a floor near
1,500 — the way the autocorrelation sum law explained the margin shell's 32 —
and test whether a much larger shell corpus contains states that phase two finds
easier, since producing one now costs seconds. If neither bites, the next lever
is the order-six character pair: it is the largest untouched rung of the ladder,
nothing in the current objective scores it, and scoring it would at least make
the true difficulty of a carrier-522 solution visible instead of deferred.
