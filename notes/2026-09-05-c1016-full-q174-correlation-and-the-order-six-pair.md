# C1016 — scoring the order-six character pair: phase two on the full q174 correlation

**Lane**: `complete-ports` · **Task**: C1016 · 2026-09-05.

The predecessor (`2026-09-04-c1016-phase-two-from-shell-corpus.md`) drove phase
two from the banked exact `q29` shell corpus, measured that it is strongly
neighbourhood-limited, and named the rung it never touches: the registered
objective pins the full correlation of four of the order-six fibre's six
characters and only the *energy* of the order-six pair, so a phase-two hit
leaves that pair's off-zero correlations entirely unconstrained. This is that
successor. The pair is now scored, and the number is large.

Two results, and they are the same result read twice. Measured on the twelve
banked phase-two states, the part of the deviation the registered objective
never saw is between 99.2% and 99.8% of the whole: those states sit at a
registered residual near 1,700 while their full `q174` correlation error is
108,832 to 401,456. And a search that scores the whole correlation reaches
3,344 to 3,712 at equal wall clock — thirty to seventy times closer to the
carrier condition — at the price of a registered residual about three times
worse. The registered objective was not solving a smaller version of the
problem; it was solving a different one.

## The full `q174` correlation, and why it is one object

The whole ladder is quotients of one carrier correlation: four blocks of length
522, `2088` at the zero shift and `-4` at every other one. A shift class of
`Z/m` aggregates the `522 / m` carrier shifts above it, so every registered
target is that one law evaluated at a different level:

| view   | subgroup | zero shift | off zero |
|--------|---------:|-----------:|---------:|
| `q29`  |       18 |      2,020 |      -72 |
| `q58`  |        9 |      2,056 |      -36 |
| `q87`  |        6 |      2,068 |      -24 |
| `q174` |        3 |      2,080 |      -12 |

`quotient_targets` computes the row from the carrier constants, and a
compile-time assertion checks it against all four registered numbers. The
`q174` row is the new objective, and the three registered conditions are its
aggregates: summing `A174` over the order-three subgroup `{0, 58, 116}` gives
`A58`, over the order-two subgroup `{0, 87}` gives `A87`, and its zero shift is
the `q174` energy. A gate checks all three aggregations on states rather than
asserting them, and the driver refuses a claimed `q174` hit that leaves any
registered component nonzero. So the new objective strictly dominates the old
one: a zero of it is a zero of everything the campaign had registered.

What it adds is the order-six character pair. Cut out by inclusion and
exclusion over the three quotients, the order-six isotypic part of the
deviation `D = A174 - target` is `S6 / 6`, with

```text
S6(g) = 6 D(g) - 2 d58(g mod 58) - 3 d87(g mod 87) + d29(g mod 29),
```

and because the four isotypic projections are orthogonal its norm obeys the
exact integer identity

```text
sum_g S6(g)^2 = 36 sum_g D(g)^2 - 12 sum_v d58(v)^2 - 18 sum_w d87(w)^2
                                                   + 6 sum_u d29(u)^2.
```

That is the number reported below as the order-six pair residual, and it is
checked on every state that any tool in this report prints. The same
arithmetic splits the whole deviation into four parts — trivial, sign,
order-three pair, order-six pair — each scaled by thirty-six to stay an
integer, and they sum to `36 sum_g D(g)^2`.

## What the banked plateau states look like

Every one of the twelve banked phase-two states, scored by
`order6 phase-two-spectrum` and rebuilt from its own 696 counts:

| state | registered | `q174` correlation | order-six share of the deviation |
|------:|-----------:|-------------------:|---------------------------------:|
|     0 |      1,856 |            164,384 |                           99.5%   |
|     1 |      1,760 |            132,032 |                           99.4%   |
|     2 |      1,744 |            125,488 |                           99.4%   |
|     3 |      1,840 |            142,544 |                           99.4%   |
|     4 |      1,728 |            172,704 |                           99.5%   |
|     5 |      1,728 |            108,832 |                           99.3%   |
|     6 |      1,520 |            183,632 |                           99.6%   |
|     7 |      1,728 |            212,256 |                           99.6%   |
|     8 |      1,776 |            304,752 |                           99.7%   |
|     9 |      1,648 |            401,456 |                           99.8%   |
|    10 |      1,792 |            110,080 |                           99.2%   |
|    11 |      1,792 |            166,656 |                           99.6%   |

The registered residual and the true one are not even correlated across the
corpus: state 9 has the second-best registered score and the worst `q174`
correlation of the twelve. Whatever the registered plateau at roughly 1,500
was measuring, it was not distance from a solution.

One exact detail falls out of the same table: the full-group deviation is
exactly twice the canonical one on every banked state, which says `D(0)` and
`D(87)` both vanish. They do so for a reason — `A87(0) = A174(0) + A174(87)`,
so a state with the energy and the `q87` zero shift both on target has the
self-inverse shift on target as well, and the banked search always landed the
energy.

## The delta algebra, and what it costs

The `q174` view is the whole fibre as one cyclic group, `Z/174`, with a cell
index its own group element, so a shift is addition modulo 174 and the
canonical class of `g` is `min(g, 174 - g)` — exactly 88 of them. The same
incremental algebra as the two quotient views carries it: with
`W_x(g) = y_{x+g} + y_{x-g}` maintained per position and class,

```text
Delta A(g) = 2 (W_k(g) - W_i(g)) + 8 [g = 0] - 4 ([g = k-i] + [g = i-k]),
```

where the self-correlation term lands in the single class of the transfer's own
shift and both indicators fire only when that shift is the self-inverse one,
87, making the term `-8` there and `-4` elsewhere.

What does not carry over is the collapse. In the `q58` view a transfer is
determined by which parity loses the unit and in the `q87` view by an ordered
residue pair, so the `4 * 29 * 30` neighbourhood has only `4 * 29 * 2` and
`4 * 29 * 6` distinct changes; the `q174` view has no quotient to collapse and
every ordered class pair of every column is its own change. The step therefore
compiles the whole `4 * 29 * 30` table each iteration, each entry one
correlation delta over 88 classes, after which a candidate is still a single
table read.

Measured against the retained pre-change executable, one worker, fifteen
seconds each, `evidence/phase-two-q174-counters.tsv`:

| binary                        | objective | instructions/step | cycles/step | branch misses/step |
|-------------------------------|-----------|------------------:|------------:|-------------------:|
| `hadamard-a5c345b-pre-q174`   | `full`    |           533,411 |     107,803 |               61.7 |
| `hadamard-a5c345b-q174-final` | `full`    |           506,175 |     107,204 |               41.9 |
| `hadamard-a5c345b-q174-final` | `q174`    |         2,685,236 |     651,731 |            1,403.3 |

The `q174` step costs 5.3 times the instructions and 6.1 times the cycles of
the registered step, which is the price of scoring 88 classes for 3,480
transfers instead of 30 and 44 classes for 232 and 696 collapsed ones. The
registered path is 5.1% *cheaper* in instructions than before this change and
reaches the identical best score on the same seed: the first version of the
extension put the scope test inside the candidate scan, which cost 12,000
instructions a step, and hoisting it out of the scan paid for itself and for
the pre-existing energy-scope test as well. Peak resident memory is 12.5 MB
for either objective on twelve workers.

## The A/B

Five interleaved rounds, thirty seconds and twelve workers each, the same seeds
and the same shell corpus, both objectives driven by the same
full-neighbourhood step (`evidence/phase-two-q174-ab.tsv`). Every column is
rebuilt from the winning state's own counts, so the two objectives are compared
on the same scales regardless of which one steered the run.

| round | objective | registered | `q174` correlation | order-six pair | steps      |
|-------|-----------|-----------:|-------------------:|---------------:|-----------:|
| 1     | `full`    |      1,504 |            108,064 |      7,737,216 | 11,112,512 |
| 1     | `q174`    |      5,456 |              3,344 |         82,368 |  1,784,040 |
| 2     | `q174`    |      5,344 |              3,712 |        127,104 |  1,707,368 |
| 2     | `full`    |      1,504 |            165,344 |     11,858,304 | 11,769,376 |
| 3     | `full`    |      1,616 |            189,424 |     13,586,496 |  9,410,912 |
| 3     | `q174`    |      5,456 |              3,344 |         82,368 |  1,625,328 |
| 4     | `q174`    |      5,360 |              3,472 |         81,216 |  1,651,496 |
| 4     | `full`    |      1,504 |            256,640 |     18,431,616 | 10,792,456 |
| 5     | `full`    |      1,664 |            121,472 |      8,694,528 | 10,860,472 |
| 5     | `q174`    |      5,280 |              3,680 |        109,824 |  1,720,392 |

The trade is the same in every round and it is not close: scoring the whole
correlation improves it by a factor of 32 to 74 and improves the order-six pair
by a factor of about a hundred, while the registered residual worsens by a
factor of about three and a half. The registered residual is the aggregate the
old objective was minimizing, so it is not surprising that giving it up costs
something there; what matters is that the aggregate was 0.5% of the real error.

A hundred and twenty seconds and twelve workers reaches 3,680 with every worker
between 3,680 and 4,048 (`evidence/phase-two-q174-corpus.jsonl`), and the
plateau does not move with the per-lift budget: 500, 5,000 and 50,000 steps per
lift give 3,808, 3,840 and 3,840. It is the same kind of plateau the registered
objective has, at its own level.

The residual at that plateau is spread, not concentrated. On the best banked
`q174` state the deviation splits by character order as 2,197 on the sign
character, 2,272 on the order-three pair and 2,891 on the order-six pair — a
near-even three-way split of 7,360, against the 99.5% concentration the
registered plateau shows. The new objective does not merely push the old
residual around; it produces qualitatively different states.

## The arithmetic floor

Two exact invariants of the neutral fibre bound the objective from below, and
both are gated. Every within-column transfer changes a correlation by a
multiple of four, so each deviation keeps its residue modulo four and the score
is a multiple of sixteen. And the correlation sums over the group to the
squared block sums, which the `q29` shell already fixes at 4 — exactly what the
target sums to — so on the shell the deviation is mean-zero. The cheapest
nonzero configuration those two permit is two classes off by four, a score of
32, the same floor the `q58` half has. The plateau at 3,344 is a hundred times
above it.

## Closed doors

- **Staging is a wash.** Starting the full-correlation search from the twelve
  banked states that already solve the registered conditions, instead of from
  fresh uniform lifts of the same shells, gives 3,536, 3,536 and 3,728 against
  3,568, 3,552 and 3,888 over three matched rounds
  (`evidence/phase-two-q174-staged.tsv`). The edge is about one percent, inside
  the plateau's own spread, so solving the registered conditions first buys
  essentially nothing. The plateau is a property of the fibre and the search,
  not of where the search starts.
- **Carrying the `q174` view in every scope costs nothing measurable.** The
  view is 245 KB per worker state and its pages are touched at construction
  even when unscored, but peak resident memory is 12.5 MB either way and the
  registered step is faster than before the change.

## Correctness gates

Everything below is in the library suite unless noted.

- the three registered conditions are checked to be exact aggregates of the
  `q174` correlation, shift class by shift class, on sampled states
  (`the_registered_conditions_are_aggregates_of_the_q174_correlation`);
- the order-six residual is checked against its orthogonal identity, and the
  four character-order parts against their partition of the whole deviation
  (`the_order_six_pair_residual_satisfies_the_orthogonal_identity`); both are
  re-checked on every state the spectrum tool and the Python oracle print;
- every predicted candidate delta is checked, over the whole neighbourhood
  after the search has already moved, against both a recompilation from the
  toggle effects and a from-scratch rebuild from the counts
  (`every_predicted_q174_delta_is_the_exact_score_change`);
- the incremental score is checked against a rebuild after every one of six
  hundred steps, together with the count range and the exact `q29` rows the run
  was seeded on (`the_q174_score_agrees_with_a_direct_rebuild_on_every_step`);
- the maintained values, toggle effects and residuals of the `q174` view are
  checked against a full recompilation
  (`the_maintained_q174_view_agrees_with_a_full_rebuild`);
- the two fibre invariants above are gated
  (`the_q174_deviation_is_a_multiple_of_four_and_sums_to_zero`);
- a staged drive is checked to start on its banked states and to refuse any
  state that does not project onto a shell of its corpus
  (`a_staged_drive_starts_on_its_banked_states_and_refuses_foreign_ones`);
- the step loop, its reseeds and its kicks allocate nothing under the `q174`
  scope (`tests/order6_phase_two_allocations.rs`);
- the driver rebuilds every state it reports from that state's own counts,
  refuses a disagreement, refuses any state off the shell it was lifted from,
  and refuses a claimed `q174` hit that leaves a registered component nonzero;
  and
- the independent Python oracle, which shares no code with the engine, rebuilds
  the full `q174` correlation, the four quotient deviations and the character
  split of all twelve banked `q174` states and agrees on every field
  (`scripts/phase_two_replay.py`, 0 failures).

`cargo fmt --check`, the workspace clippy gate and the serial workspace suite —
every library, binary and integration target — pass.

## Provenance

The character decomposition, the aggregation law, the delta algebra, the
orthogonal identity and both fibre invariants are exact. The search is
heuristic: only the direct replay of the defining equations certifies a
positive, and every miss in this report is a heuristic miss with no negative
authority over the sector.

## Mystery ledger

- **The registered plateau was measuring almost nothing.** The banked states
  sit at 0.5% of their own total deviation, and their registered scores do not
  order them by true error at all — the second-best registered state is the
  worst by the full correlation. This retires the predecessor's open question
  about a congruence explaining a floor near 1,500: the number 1,500 is not a
  floor of the problem, it is the size of a fragment of it. Settled by this
  pass.
- **The new plateau near 3,500 is unexplained and is a hundred times the
  floor.** Budget insensitivity across a hundredfold range, staged starts, and
  a fourfold longer run all leave it where it is, and the residual is spread
  evenly across the three nontrivial character blocks rather than trapped in
  one. No congruence beyond the mod-four and mean-zero invariants has been
  looked for at this level, and that is now the first thing to look for.
- **Twelve shells is still the whole corpus.** Every measurement here rotates
  the same twelve shell states, and nothing distinguishes one from another for
  either objective. The margin step produces new shells in seconds, so a much
  larger corpus remains cheap and untested — the predecessor said the same and
  it is still true, now with a scale on which to test it.
- **The order-six pair is the largest block of the three at the new plateau,
  but only just.** 2,891 against 2,272 and 2,197 in squared-norm units. Before
  this pass it carried 99.5% of the deviation; the search equalizes it to 39%.
  Whether that is the search finding the easiest available balance or a real
  structural symmetry among the three blocks is unexamined.
- **A `q174` hit is still not a carrier solution.** The `q174` correlation is
  the last quotient before the carrier itself: `Z/522 -> Z/174` has fibre three,
  so a hit fixes every correlation of the order-six fibre and leaves the
  remaining factor of three to the carrier-522 replay. That rung has never been
  scored either, and it is now the only one left above the target.

## Replay

Everything lives in the private campaign branch `c1016-full-2092-campaign` of
`ergodis-private`, checked out at
`~/src/ergodis-worktrees/c1016-full-2092/ergodis-private`.

    cargo test --release -p ergodis-private --lib order6_phase_two
    cargo test --release -p ergodis-private --test order6_phase_two_allocations

    hadamard order6 phase-two-spectrum --corpus evidence/phase-two-corpus.jsonl --per-state
    hadamard order6 phase-two --corpus evidence/q29-margin-tabu-shell-hits.json \
        --engine tabu --objective q174 --workers 12 --seconds 120 --budget 5000 \
        --seed 20260905 --output evidence/phase-two-q174-corpus.jsonl
    hadamard order6 phase-two --corpus evidence/q29-margin-tabu-shell-hits.json \
        --engine tabu --objective q174 --workers 12 --seconds 30 --budget 5000 \
        --seed 31337 --start-states evidence/phase-two-corpus.jsonl

    bash scripts/phase_two_q174_ab.sh evidence/phase-two-q174-ab.tsv \
        evidence/q29-margin-tabu-shell-hits.json 30 12 5
    python3 scripts/phase_two_replay.py evidence/phase-two-q174-corpus.jsonl

Evidence hashes are in that repository's `evidence/SHA256SUMS`; the retained
executables and their digests are in `~/.cache/ergodis/bin/MANIFEST.tsv` and in
`evidence/phase-two-q174-counters.tsv`. The one pre-existing mismatch there,
`c1028-chain-ring-instrument-test.json`, is from a different task and is
untouched.

## Next

The `q174` plateau near 3,500 is the whole of what is now measurable, and it
sits a hundred times above the only floor anyone has derived. Look for a
congruence on the deviation beyond the mod-four and mean-zero invariants that
would explain it, and test a much larger shell corpus now that there is a scale
that actually orders states by distance from a solution. The rung above is the
carrier itself: `Z/522 -> Z/174` has fibre three, so even an exact `q174` hit
leaves one factor of three to the carrier replay, and nothing scores that yet.
