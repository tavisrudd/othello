# C1016 — the paired transfer, and the exact two-transfer census that closes it

**Lane**: `complete-ports` · **Task**: C1016 · 2026-09-05.

The predecessor (`2026-09-05-c1016-q174-congruence-hunt.md`) closed the
arithmetic side of the `q174` plateau — no congruence constrains the deviation
at any modulus whose prime factors are below a million, the floor stays 32, and
the fibre holds about `2^1322` exact solutions — and left one concrete move to
build: a paired transfer between two columns of one `q29` residue group, the
smallest move the fifteen aggregate relations permit beyond a single transfer.

The move is now built, and it is closed by an exhaustive exact census rather
than by a search that came up empty: **every one of the twelve banked plateau
states is an exact local optimum of the whole two-transfer neighbourhood.**
Over 42.4 million paired moves, not one improves the objective, and the best
paired move of a state is typically a *worse* step than its best single
transfer. The engine that scans those pairs is built and measured anyway, and
at matched wall clock it is behind the retained step.

The pass also corrects the motivation the predecessor stated for the move, and
the correction is worth more than the move: the residue groups do not define a
class of moves at all.

## What pairing actually adds

The predecessor described the paired transfer as "a move the fifteen relations
permit but a single transfer cannot make". That is not right. A transfer fixes
every column total and therefore the whole `q29` view, so its delta already
lies in the invariant lattice `H` and already satisfies all fifteen aggregate
relations; this is gated
(`the_invariants_survive_every_phase_two_transfer`). The relations constrain the
net deviation, not the move. What the floor argument really says is that a
*sparse* delta — `+4` and `-4` on two canonical classes of one group — is
valuable, and that a single transfer's delta, `d(g) = 2 (W_b(g) - W_a(g)) + q(g)`
spread over essentially all 88 classes, is nothing like it.

So a pair is not permission. What a pair adds is the **interaction**. Writing
`u1` and `u2` for the two count changes, the combined delta is

```text
d(g) = d1(g) + d2(g) + q12(g),
q12(g) = sum_x (u1_x u2_{x+g} + u2_x u1_{x+g}),
```

and `q12` is supported on the four shifts `b2 - b1`, `a2 - b1`, `b2 - a1`,
`a2 - a1` together with their negatives. Every one of those is congruent to the
two columns' difference modulo 29, so the interaction — and only the
interaction — lies in one `q29` residue group. That is the exact sense in which
a residue group is the natural unit for a paired scan, and it is a much weaker
statement than the one the predecessor made. The two linear parts still spread
across every class; a pair whose *whole* delta sits inside one group would be
an accident of the state rather than a property of pairing. The census measures
that directly: of the twelve states' best pairs, five lie in one block and put
2.0%, 3.2%, 4.2%, 4.3% and 11.7% of their squared delta inside their own group
against 6.7% for an even spread, and the other seven are *cross-block* pairs
with no interaction term at all. The ingredient pairing adds is not even what
produces the best paired move on most states.

Two transfers in different blocks have no interaction at all, since the
combined correlation is a sum over blocks; their delta is exactly separable.

## The exact paired delta

Because the objective is the squared deviation summed over the canonical shift
classes, the paired score change decomposes into the two compiled single
deltas, one inner product, and the sparse interaction:

```text
Delta = Delta1 + Delta2 + 2 <d1, d2>
      + sum_{s in supp q12} (2 r_s q12_s + 2 (d1_s + d2_s) q12_s + q12_s^2).
```

Every term but the inner product is `O(1)` once the single-transfer table is
compiled, so one pair costs one 88-entry dot product. That is what makes an
exhaustive census of about 3.5 million pairs per state a matter of tens of
milliseconds, and it is what makes a paired search step affordable at all.

## The census

For each banked state the census enumerates every admissible single transfer —
about 2,665 of them — and every admissible unordered pair of two of them, and
scores each exactly. It is exhaustive, not sampled.

| state | objective | pairs | improving pairs | best pair | best single |
|------:|----------:|------:|----------------:|----------:|------------:|
| 0     | 3,952     | 3,526,087 | 0 | +960   | +768   |
| 1     | 4,048     | 3,555,384 | 0 | +768   | +464   |
| 2     | 3,728     | 3,533,996 | 0 | +896   | +864   |
| 3     | 3,856     | 3,539,262 | 0 | +1,184 | +736   |
| 4     | 3,984     | 3,534,060 | 0 | +528   | +336   |
| 5     | 3,680     | 3,534,069 | 0 | +832   | +848   |
| 6     | 3,856     | 3,531,088 | 0 | +752   | +272   |
| 7     | 3,728     | 3,536,603 | 0 | +576   | +1,088 |
| 8     | 3,920     | 3,568,504 | 0 | +1,104 | +720   |
| 9     | 3,712     | 3,552,435 | 0 | +928   | +1,056 |
| 10    | 3,680     | 3,576,350 | 0 | +1,248 | +1,024 |
| 11    | 3,952     | 3,544,528 | 0 | +880   | +672   |

Three facts follow, and they are exact.

**The plateau states are two-transfer local optima.** Zero improving pairs over
42,532,366 of them, and zero improving singles as well. The plateau is not a
one-move artefact that a wider neighbourhood walks out of.

**Pairing does not even give a gentler escape, on balance.** On eight of the
twelve states the best pair climbs further than the best single; on four
(states 5, 7, 9 and 10) it climbs less, most sharply on state 7, where the best
pair costs `+576` against the best single's `+1,088`. A tabu step that must
take its least-bad move therefore gains nothing systematic from the wider
neighbourhood.

**No residue group is distinguished.** Every one of the fifteen groups has zero
improving pairs on every state, and on seven of the twelve states the best pair
is a cross-block one, whose delta is exactly the sum of two single deltas.

## The engine, and the A/B that confirms the census

The paired tabu step scans the singles together with one `q29` residue group's
pairs — about 104,000 of them — and advances the group by one on every step, so
fifteen steps cover the whole paired neighbourhood. It is a strict widening of
the retained step: the same singles, plus pairs, all scored exactly.

One worker, fifteen seconds each, non-multiplexed counters
(`evidence/phase-two-paired-counters.tsv`):

| engine   | instructions/step | cycles/step | branch misses/step |
|----------|------------------:|------------:|-------------------:|
| `tabu`   |         2,684,702 |     654,089 |            1,401.2 |
| `paired` |        38,040,569 |   6,831,047 |            6,630.3 |

The paired step costs 14.2 times the instructions and 10.4 times the cycles,
which is the price of one 88-entry dot product for each of about 104,000 pairs
on top of the 3,480 singles. Peak resident memory over twelve workers is
29.1 MB against 10.7 MB, the extra being one delta vector per single transfer
per worker.

That measurement doubles as the regression check on the retained path: the
single-transfer `q174` step is measured here at 2,684,702 instructions and
654,089 cycles against the 2,685,236 and 651,731 banked before this change,
which is 0.02% and 0.36% — unchanged, as expected, since the only edit to it
was to have its shift-class helper call a shared one.

Five interleaved thirty-second rounds, twelve workers, the same seed, the same
per-lift budget, alternating which arm ran first
(`evidence/phase-two-paired-ab.tsv`):

| round | `tabu` | `paired` | ratio |
|------:|-------:|---------:|------:|
| 1     |  3,344 |    3,744 | 1.120 |
| 2     |  3,344 |    4,016 | 1.201 |
| 3     |  3,696 |    4,160 | 1.126 |
| 4     |  3,536 |    3,952 | 1.118 |
| 5     |  3,680 |    4,192 | 1.139 |

The paired step is **1.140 times worse** in geometric mean with a paired
log-ratio `t = 9.79`, and it loses every round. It takes 156,624 steps in the
window against the retained step's 1,795,336, so eleven and a half times fewer
steps buy a neighbourhood thirty times wider, and the trade is a clear loss.
That is exactly what the census predicts: the wider neighbourhood holds no
improving move at the plateau, so all it buys is a more expensive way to pick
the least-bad one.

## Correctness gates

- every compiled single delta is the exact score change, against a rebuild of
  the whole correlation from the moved counts
  (`the_compiled_single_delta_is_the_exact_score_change`);
- every compiled paired delta is the exact score change, over more than five
  hundred pairs on each of three states
  (`every_paired_delta_is_the_exact_score_change`);
- a paired delta across blocks has no interaction term at all, checked against
  the direct rebuild (`a_paired_delta_across_blocks_has_no_interaction`);
- the interaction of two transfers of one block never leaves the `q29` residue
  group of their column difference
  (`the_interaction_lies_in_the_residue_group_of_the_column_difference`);
- a paired move fixes the `q29` shell and keeps the deviation's congruences
  (`a_paired_move_preserves_the_shell_and_the_fifteen_aggregates`);
- the paired step's maintained score agrees with a direct rebuild on every
  step, and never leaves the shell
  (`a_paired_step_stays_on_the_shell_and_agrees_with_a_direct_rebuild`);
- the census's own best move replays: the driver rebuilds the moved state and
  its score from the counts and refuses a state whose best pair does not
  reproduce or leaves the shell;
- the paired loop, its reseeds and its kicks allocate nothing
  (`the_paired_loop_its_reseeds_and_its_kicks_allocate_nothing`); and
- the independent Python oracle, sharing no code with the engine, rebuilds the
  correlation, every single delta, every paired delta and the whole census of
  all twelve states, and agrees on every field
  (`scripts/phase_two_paired_census_replay.py`, 0 failures over 12 states).
  Its treatment of repeated interaction classes is deliberately different from
  the engine's — the engine merges duplicate classes before scoring, the oracle
  sums the four raw terms and repairs the square over ordered pairs — so a
  collision bug in either would show as a disagreement.

`cargo fmt --check`, the workspace clippy gate with warnings denied, and the
serial workspace suite pass. The Lanczos coefficient in the congruence driver
was truncated to the same `f64` value to clear a new `excessive_precision`
finding from the current toolchain; no number changes.

## Provenance

The delta algebra, the interaction's residue-group confinement, and the census
are exact. The census is an exhaustive enumeration of the two-transfer
neighbourhood of the twelve banked states, so "no improving pair" is a proved
statement about those states and carries no authority over states the search
has not reached. The A/B is a heuristic comparison at matched wall clock.

## Mystery ledger

- **The paired move is closed, and the census is why.** The predecessor's first
  named next step is answered exactly: the plateau states are two-transfer
  local optima, no residue group is distinguished, and the wider neighbourhood
  loses at matched wall clock. Settled by this pass.
- **The motivation was wrong in a way worth keeping in view.** The fifteen
  relations constrain the net deviation and every single transfer already
  respects them; only the interaction of a pair is confined to a residue group.
  Any future move designed "because the relations permit it" should be checked
  against that distinction first.
- **What stalls the descent is still unexplained, and the neighbourhood is no
  longer a candidate.** Single and paired moves are both exhausted at the
  plateau; the remaining structural candidates are a genuinely different move
  set (a multiplier-symmetric shard, or a move that changes the `q29` shell and
  repairs it) and the possibility that the objective itself is the wrong rung.
- **The largest unscored rung is above, not below.** The carrier `Z/522` sits
  above an exact `q174` hit with 174 free correlation classes of its own and
  nothing scoring them, and the campaign's language for it — "the last factor of
  three", "the carrier-522 replay" — understates it. A `q174` hit is not
  obviously liftable. Scoring that rung is now the highest-value open move on
  the bordered ladder, and it is unbuilt.
- **The plateau's depth in bits stays model-dependent.** The predecessor's "130
  bits into a 400-bit descent" rests on a two-moment gamma tail fit; an
  independent Gaussian-ball count of the same plateau gives about 195 bits, so
  the figure carries roughly ±60 bits and should not be quoted as a progress
  measure. The 400-bit total is the robust half.

## Replay

Everything lives in the private campaign branch `c1016-full-2092-campaign` of
`ergodis-private`, checked out at
`~/src/ergodis-worktrees/c1016-full-2092/ergodis-private`.

    cargo test --release -p ergodis-private --lib order6_paired_transfer
    cargo test --release --workspace --all-targets -- --test-threads=1

    hadamard order6 paired-census \
        --corpus evidence/phase-two-q174-corpus.jsonl \
        --workers 12 --per-state \
        > evidence/phase-two-paired-census.json

    uv run --with numpy python3 scripts/phase_two_paired_census_replay.py \
        evidence/phase-two-q174-corpus.jsonl evidence/phase-two-paired-census.json

    scripts/phase_two_paired_ab.sh evidence/phase-two-paired-ab.tsv \
        evidence/q29-margin-tabu-shell-hits.json 30 12 5

    scripts/phase_two_paired_counters.sh evidence/phase-two-paired-counters.tsv \
        evidence/q29-margin-tabu-shell-hits.json 15

The census takes 0.12 seconds on twelve workers and its independent replay 16
seconds. Evidence hashes are in that repository's `evidence/SHA256SUMS`; the
one pre-existing mismatch there, `c1028-chain-ring-instrument-test.json`, is
from a different task and is untouched.

## Next

The `q174` neighbourhood is exhausted in both directions the predecessor named:
single transfers were already exact and full, and pairs are now exact, full and
empty. Group-scoped search is the remaining item from that list and the census
removes its premise — no group holds an improving pair, so scoping to one can
only see fewer of the same moves.

The productive move is up the ladder rather than sideways in it: score the
carrier `Z/522` rung above an exact `q174` hit, which nothing scores yet and
which is the larger of the two remaining rungs. The alternative worth pricing
against it is a return to the plain `Z/523` spin shard, which is one rung
rather than two.
