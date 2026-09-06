# C1016 — the character-domain move set, and how wide the shell corpus really is

**Lane**: `ergodis` · **Task**: C1016 · 2026-09-05.

The predecessor (`2026-09-05-c1016-carrier-522-rung.md`) closed the carrier rung
above an exact `q174` hit and named two open moves: widen the shell corpus, and
price a character-domain move set against the position-domain plateau. This is
both, and the character-domain half turns out to be a closed question rather
than an open search.

## The character-domain move set is finite, and now enumerated

The whole condition is a flat spectrum. Summing the carrier law against a
character says that for every nontrivial 522nd root of unity `w`,

```text
sum_b |z_b(w)|^2 = 2092 = 4 * 523,      z_b(w) = sum_p y_b(p) w^p,
```

with `sum_b |z_b(1)|^2 = 4`. By Parseval the squared error over the group and
the squared error over the characters are the same number up to the factor 522,
so moving to the character domain cannot change the *objective*. What it can
change is the move set, and the move set it offers is exactly this.

**A per-block affine relabelling contributes only its multiplier.** Replace one
block by `y'_b(p) = y_b(t p + s)` with `t` coprime to 522. Then

```text
A'_b(g) = sum_p y_b(t p + s) y_b(t p + t g + s) = A_b(t g),
```

so the shift `s` drops out identically: a per-block shift leaves every block
autocorrelation, and therefore the whole objective and every level of the
ladder, exactly where it was. What remains is the multiplier, and on the
character side `t` is the Galois element `w -> w^t`: it relabels one block's
spectrum inside each Galois orbit and leaves the other three blocks alone.

**Only six multipliers are admissible, and only three of those keep the
`q174` rung.** Aggregating `A'_b(g) = A_b(t g)` over the fibre of
`Z/522 -> Z/m` gives `A'^m_b(u) = A^m_b(t u)`, so a twist fixes the `Z/m` level
of every block exactly when `t == 1 (mod m)`. The units congruent to one modulo
twenty-nine are `{1, 59, 175, 233, 349, 407}`, cyclic of order six, and they fix
the `q29` shell the whole campaign is seeded on. The units congruent to one
modulo 174 are `{1, 175, 349}`, and they additionally fix every orbit count,
hence the entire `q174` correlation: those three move the carrier rung and
nothing else. The Python oracle checks this against all 168 units rather than
assuming it.

**The diagonal is a relabelling, not a move.** One multiplier applied to all
four blocks at once permutes the combined correlation and leaves the objective
identically fixed, so the effective move set is the quotient by it: 27 elements
above a fixed `q174` state and 216 above a fixed `q29` shell.

The fibre twist has a concrete shape. Since `175 = 1 + 174`, it sends `p` to
`p + 174 (p mod 3)`, and the three positions of one orbit share their residue
modulo three, so it rotates each orbit of three rigidly by an amount fixed by
that orbit's own index. It is one global element of the fibre group: a jump of
about two thirds of the carrier positions, and a relabelling of one line in the
character domain.

## The census: the move set has no small elements

The twists act on the four blocks independently, so the whole move set is one
finite product group — `3^4 = 81` elements above a fixed `q174` state and
`6^4 = 1296` above a fixed `q29` shell — and every element of it can be scored
exactly. That makes this a census in the sense the two-transfer pass used, not
a search that failed.

Over the 24 retained fibre-arm plateau states and the 12 column-arm states
(`evidence/twist-census-fibre.json`, `evidence/twist-census-shell.json`):

| corpus                  | group   | states | elements each | elements scored | improving |
|-------------------------|---------|-------:|--------------:|----------------:|----------:|
| fibre-arm plateau       | `fibre` |     24 |            81 |           1,944 |         0 |
| fibre-arm plateau       | `shell` |     24 |         1,296 |          31,104 |         0 |
| column-arm plateau      | `shell` |     12 |         1,296 |          15,552 |         0 |
| uniform lifts (control) | `fibre` |    384 |            81 |          31,104 |    16,779 |

**Not one element of the character-domain move set improves any banked plateau
state.** The reason is not that the plateau is deep but that the move set is
coarse: the best single-block twist of a fibre-arm state scores 86,592 against
a plateau of 14,256 to 15,264 — a factor of 7.06 on average — and the worst
element of the shell group throws a state to 355,776, which is where a fresh
uniform lift starts.

The last row is the control, and it is what makes the first three mean
something. Censusing sixteen uniform carrier lifts of each banked state's own
orbit counts — the same `q174` state, so the same admissible move set, at a
random point of its fibre — 370 of the 384 lifts *do* have an improving twist,
55% of all nonidentity elements improve, and the best element of the group
averages 0.849 of the identity score. **The move set is a randomizer, not a
refiner:** its effect size is set by the state's own randomness, so it helps a
random state about half the time and a settled one never.

One more exact fact falls out of the census. The elements that score exactly
what the state does are, on the plateau corpus, precisely the diagonal — two per
state for the fibre group and five for the shell group, with no accidental ties
in 46,656 elements. Every genuine move of the character domain costs something,
and the least it can cost is a factor of seven.

That is a different kind of negative from the three widenings before it. The
paired transfers, the column scope and the group-scoped search each lost on
cost per step against reach. This one barely pays anything — a twist is priced
in one pass over 262 classes from the maintained block correlations, and the
counter run below measures the whole set at 1.0% of a step for the fibre group
and 2.5% for the shell group. It loses because the Galois action on this
problem has no small elements at all, not because carrying it is expensive.

### The same negative at equal wall clock

The census scores the move set on banked states. The complementary question is
whether a search that *carries* the move set through its own descent lands
anywhere better, and that is a wall-clock question. Four arms, identical engine,
objective, seed, wall clock and worker count, differing only in the
neighbourhood: `none` is the shipped fibre-scope step, `fibre` and `shell` add
the respective twist groups to every neighbourhood, and `restart` spends the
same budget applying a random admissible twist at each reseed instead. Five
interleaved rounds of thirty seconds on twelve workers
(`evidence/carrier-twist-ab.tsv`, best carrier score, lower is better):

| arm       | mean carrier | best  | steps     | geometric ratio to `none` | paired log-ratio t |
|-----------|-------------:|------:|----------:|--------------------------:|-------------------:|
| `none`    |     14,780.8 | 14,320 | 1,952,939 |                     1.0000 |                  — |
| `fibre`   |     14,812.8 | 14,512 | 1,940,602 |                     1.0023 |               0.22 |
| `shell`   |     14,822.4 | 14,512 | 1,920,070 |                     1.0029 |               0.27 |
| `restart` |     14,889.6 | 14,640 | 1,944,315 |                     1.0075 |               0.51 |

**No arm separates from the baseline.** Every twist arm is nominally worse and
none of the differences reaches a t-score of one on five paired rounds, which
is exactly what the census predicts: a move set with no improving element and a
smallest cost factor of seven contributes nothing to a descent, and the small
step deficit it causes is its only measurable effect.

The counter run prices that deficit against the retained control
(`evidence/carrier-twist-counters.tsv`, fifteen-second runs, twelve workers):

| step                | binary            | instructions/step | cycles/step | steps   | best   |
|---------------------|-------------------|------------------:|------------:|--------:|-------:|
| `fibre-none`        | `hadamard`        |       2,499,178.8 |   632,772.1 | 115,552 | 13,744 |
| `fibre-twist-fibre` | `hadamard`        |       2,524,629.5 |   637,826.4 | 114,720 | 15,488 |
| `fibre-twist-shell` | `hadamard`        |       2,562,544.9 |   643,664.5 | 114,848 | 15,488 |
| `column-twist-shell`| `hadamard`        |      20,710,878.6 | 5,047,547.6 |  14,848 | 15,616 |
| `fibre-retained`    | `hadamard-079acc8`|       2,638,176.8 |   656,462.4 | 114,336 | 13,744 |
| `fibre-none-again`  | `hadamard`        |       2,499,185.0 |   633,129.3 | 117,920 | 13,744 |

Carrying the fibre twist group costs 1.0% more instructions per step and the
shell group 2.5%; the column scope's step is 8.3 times heavier for reasons that
predate this pass. Two controls matter. The repeated `none` measurement
reproduces to six significant figures (2,499,178.8 against 2,499,185.0), so the
1.0% is a real cost and not drift. And the current binary is 5.3% cheaper in
instructions and 3.6% cheaper in cycles than the retained
`hadamard-079acc8` while returning the identical best score of 13,744, so
adding the twist machinery to the tree regressed nothing on the arm that does
not use it.

## Where the plateau's energy sits in the character domain

The deviation `E = A522 - target` decomposes over the characters, and the
characters of `Z/522` split by order into the twelve divisor classes. Writing
`T(m)` for the energy carried by the characters of order dividing `m` — which
is `(1/k) sum_u S_m(u)^2` with `k = 522/m` and `S_m` the aggregate of `E` over
the fibre of `Z/522 -> Z/m` — Moebius inversion over the divisor lattice gives
the energy `I(d)` of each order class. The independent oracle
`scripts/carrier_isotypic.py` computes it and checks two identities against the
state itself: `T(174)` must be `q174_full_group / 3`, and the four classes of
order divisible by nine must total `above_q174 / 9`.

Across the 24 banked fibre-arm plateau states:

| character order   |     1 |     2 |     3 |     6 |     9 |    18 |    29 |    58 |    87 |   174 |   261 |   522 |
|-------------------|------:|------:|------:|------:|------:|------:|------:|------:|------:|------:|------:|------:|
| how many          |     1 |     1 |     2 |     2 |     6 |     6 |    28 |    28 |    56 |    56 |   168 |   168 |
| share of energy   | .0000 | .0010 | .0007 | .0006 | .0158 | .0163 | .0000 | .0144 | .0364 | .0319 | .4415 | .4413 |
| share per character| .00000| .00098| .00035| .00030| .00264| .00272| .00000| .00051| .00065| .00057| .00263| .00263 |

The order-29 class is exactly zero, as it must be: the campaign is seeded on
exact `q29` shells, and those are precisely the states whose order-29 and
trivial characters are on target. The check is free and it passes on every
state.

**The plateau is isotropic on the rung.** Every one of the four order classes
divisible by nine — 9, 18, 261 and 522 — carries the same energy per character,
0.00263 to 0.00272, while the classes the `q174` view can see carry about a
fifth of that. There is no concentrated direction in the character domain: the
residual is spread evenly over all 348 characters the rung owns.

The unnormalized form says the same thing about the search rather than about
the state. Mean squared deviation carried by one character of each class, on
the plateau and on eight uniform lifts of each plateau state's own orbit counts:

| character order   |     2 |     3 |     6 |      9 |     18 |    58 |    87 |   174 |    261 |    522 |
|-------------------|------:|------:|------:|-------:|-------:|------:|------:|------:|-------:|-------:|
| uniform lift      |  28.8 |  10.2 |   8.8 | 2055.3 | 2280.1 |  15.2 |  19.2 |  16.8 | 2145.7 | 2069.8 |
| fibre plateau     |  28.8 |  10.2 |   8.8 |   78.0 |   80.4 |  15.2 |  19.2 |  16.8 |   77.6 |   77.5 |
| compression       |  1.00 |  1.00 |  1.00 |  26.3  |  28.4  |  1.00 |  1.00 |  1.00 |  27.7  |  26.7  |

The six classes the fibre scope provably cannot move are identical to the digit
in both rows, which is the invariance the search is built on, arrived at here
by an independent route. On the four classes it can move, **the search
compresses every character by the same factor, about twenty-seven, and then
stops.** No order class is favoured and none is left behind.

That is a direct answer to the question the predecessor left open. A
character-weighted objective — penalize the worst Galois orbit, or weight by
order class — has nothing to grip: the flat spectrum the condition demands is
matched by a flat residual in the part that is still wrong, before the search
starts and after it stops.

One number is worth carrying forward. The rung's characters sit at about 78 per
character at the plateau, against 8.8 to 28.8 for the classes the `q174` search
already settled — so the rung is roughly four times less converged per
character than the level below it, which is the same gap the lattice-step
reading gave as 1.86 against 1.54. The compression factor of twenty-seven is
that reading squared and is not a separate fact: five times fewer lattice steps
per class is twenty-five times less squared deviation.

### What the plateau looks like as a spectrum

Since the objective is the same function in either domain, the plateau can be
stated directly in the units the condition is written in. Evaluating
`P(w) = sum_b |z_b(w)|^2` at all 521 nontrivial characters of a banked plateau
state, by direct complex arithmetic that shares nothing with any engine here:

| state                      | rms of `P(w) - 2092` | as a share of 2092 | extremes         |
|----------------------------|---------------------:|-------------------:|------------------|
| uniform lift of its counts |                  908 |              43.4% | `+5666`, `-1662` |
| fibre plateau              |                  174 |               8.3% | `+524`, `-614`   |

**The search flattens every character's power from about forty per cent off
target to about eight, and stops there.** A solution needs zero at every one of
them. That is the plateau in one line, and it is the same object the lattice
reading calls 1.86 steps per class.

## How wide the shell corpus really is

The twelve banked shells are genuinely twelve problems. The symmetries that act
on a shell and leave the carrier objective invariant are an independent cyclic
shift of each block, an independent sign flip of each block, a permutation of
the four blocks, and one *global* multiplier — a per-block multiplier is not a
symmetry, since it is the move set priced above. Canonicalizing under that group
(`scripts/shell_canonical.py`) separates all twelve, and the row-energy profile
already does.

Mining fresh shells exposed a methodology fault worth recording. The margin
tabu step banks a shell in about one worker-run in twenty, so a corpus is a
matter of rounds; but a worker's seed is the round seed exclusive-ored with a
per-worker stride, so incrementing the round seed by one hands the same worker
two nearly identical streams. Ten of the first fifteen mined shells arrived as a
duplicate pair from one worker in two adjacent rounds. With the round seed
strided instead, that disappears. The banked worker states from before the fix
are kept and contribute their distinct shells; the mining loop now strides.

The finished mining run banks 624 worker states, of which 38 are exact `q29`
shells (`scripts/q29_shell_replay.py` replays all 624 from their signs and
agrees on every score). Together with the twelve original hits that is 50 exact
shell rows, and canonicalizing under the invariance group collapses them to
**39 inequivalent shells** — eleven orbits of size two and 28 singletons, with
the row-set, row-energy and canonical-form counts all agreeing at 39
(`scripts/shell_canonical.py`). The corpus the campaign searches is therefore
39 problems wide, up from twelve.

### Width is not a lever when the driver rotates over it

The `q174` driver spreads its lifts across whatever corpus it is given, so a
wider corpus buys reach across shells and pays for it in lifts per shell, and
no measurement had ever separated those. Five interleaved equal-wall-clock
rounds, thirty seconds on twelve workers, identical seeds, differing only in
the corpus file (`evidence/corpus-width-ab.tsv`, best `q174` score, lower is
better):

| corpus            | shells | mean `q174` | steps     | geometric ratio | paired log-ratio t |
|-------------------|-------:|------------:|----------:|----------------:|-------------------:|
| narrow (original) |     12 |     3,654.4 | 1,903,493 |          1.0000 |                  — |
| wide (mined)      |     39 |     3,676.8 | 1,892,256 |          1.0063 |               1.83 |

**Tripling the corpus does not help, and if anything costs 0.6%.** The wide arm
never wins a round: it ties on two seeds and loses on three, at equal step
counts. The lifts-per-shell dilution is real and the extra reach does not pay
for it.

### Shells are not interchangeable, but one run each cannot prove it

The complementary sweep gives each of the 39 shells the same budget *alone* —
fifteen seconds of `q174` from that shell only, then fifteen seconds of the
carrier fibre rung above the state it reached (`evidence/shell-width-sweep.tsv`):

| statistic over the 39 shells | best carrier | median | mean     | worst  | standard deviation |
|------------------------------|-------------:|-------:|---------:|-------:|-------------------:|
| single fifteen-second run    |       13,648 | 14,800 | 14,743.0 | 15,248 |              315.1 |

The best shell of the 39 reaches 13,648, below anything the rotating corpus has
produced in this pass — the twist A/B's best arm bottoms out at 14,320 — and
below the roughly 14,400 the carrier rung plateaued at in the predecessor. The
spread from best to worst is 11.7%.

**That spread is not yet evidence that shells differ.** The five `none` rounds
of the twist A/B, all on the same corpus and differing only in seed, have a
standard deviation of 308 across seeds, against 315 across shells here. One run
per shell cannot separate a good shell from a lucky run, so 13,648 is a lead,
not a measurement. Two things do survive that caveat, because they are
correlations within the same runs rather than comparisons between them: the
shell's `q174` depth predicts its carrier depth only weakly (r = 0.32), and the
count of order-six margin states a shell carries predicts nothing at all
(r = 0.01, over a range from 71,040 to 168,000). **Nothing cheap screens a
shell.** Whatever makes one shell better than another is not visible in the
quantities the campaign already records about it.

That leaves a well-posed successor rather than a conclusion: replicate the
sweep on the tail — the five best shells here are 37, 23, 2, 9 and 10 — with
enough rounds per shell to put the between-shell variance above the
between-seed variance, and if it survives, concentrate the budget on the
survivors instead of rotating all 39.

## Correctness gates

- the two multiplier sets are exactly the units congruent to one modulo
  twenty-nine and modulo 174, each closed under multiplication, and each
  position table is a permutation of the carrier
  (`the_twist_multipliers_are_the_whole_level_fixing_multiplier_group`);
- a twist permutes the twisted block's autocorrelation by its own multiplier
  and changes no other block
  (`a_twist_permutes_the_block_autocorrelation_by_its_multiplier`);
- a fibre twist leaves every orbit count and the whole `q174` correlation fixed;
  a shell twist fixes the `q29` rows, and the three that are not fibre twists
  really do move the `q174` correlation
  (`a_fibre_twist_leaves_every_orbit_count_and_the_q174_correlation_fixed`,
  `a_shell_twist_fixes_the_q29_rows_and_the_wider_ones_move_q174`);
- a per-block shift leaves the objective identically fixed and rotates that
  block's `q29` row, so the multiplier is the whole character-domain move set
  (`a_block_shift_leaves_the_carrier_objective_exactly_fixed`);
- the diagonal leaves the objective and every level it fixes exactly where they
  were (`a_global_twist_leaves_the_objective_and_its_levels_fixed`);
- the fibre twist is the rigid rotation of each orbit by its index modulo three
  (`the_fibre_twist_rotates_each_orbit_rigidly`);
- the census agrees element by element with a direct rebuild of the twisted
  signs, including its best, worst, level and improving counts
  (`the_twist_census_agrees_with_a_direct_rebuild_of_every_element`);
- the block correlations a twist is priced from are maintained across every
  applied transfer, not only rebuilt at reseed
  (`the_maintained_block_correlations_agree_with_a_direct_rebuild`);
- every predicted twist delta is the exact score change
  (`every_predicted_twist_delta_is_the_exact_score_change`);
- a search carrying the fibre twist set never moves the `q174` correlation, and
  one carrying the shell set never leaves the `q29` rows, under either scope
  (`a_fibre_twist_inside_the_search_leaves_the_q174_correlation_fixed`,
  `a_shell_twist_inside_the_search_preserves_the_q29_rows`);
- the twist neighbourhood, its reseeds and its kicks allocate nothing
  (`tests/order6_carrier_allocations.rs`);
- the census driver replays every winner from its own signs and refuses one that
  left the `q29` shell, or that moved an orbit count under the fibre group;
- every mined state replays from its own signs to the score the miner recorded,
  and the corpus the sweep and the A/B run on is the canonical-form quotient of
  the mined and banked rows, counted three independent ways — row sets,
  row-energy profiles and canonical forms all give 39
  (`scripts/q29_shell_replay.py`, `scripts/shell_canonical.py`); and
- two independent Python oracles that share no code with the engine:
  `scripts/galois_replay.py`, which recomputes every autocorrelation as
  `522 - 2 popcount(y XOR rot(y, g))` and tests the completeness claim against
  all 168 units, and `scripts/carrier_isotypic.py`, which checks the
  character-order decomposition against `above_q174` and `q174_full_group`.

## Provenance

The multiplier groups, the permutation law, the shift-invariance, the diagonal,
both admissibility statements and the census are exact and gated. The census is
a complete enumeration of a finite group, so its emptiness is a negative with
authority over that move set — but only over that move set, and only on the
banked states it was run on. The 39-shell inequivalence count is exact, being a
canonical-form quotient checked three ways.

The searches remain heuristic, and a miss carries no authority over the sector.
That covers all three wall-clock results here: the twist arms failing to
separate from the baseline, the wide corpus failing to beat the narrow one, and
the per-shell spread. Each is a measured statement about this engine at this
budget, not about the sector.

## What the character domain still offers

The census closes the move set, and the isotropy closes the reweighting. It
does not close the character domain, because one thing there is neither a move
nor a weight: the low-order characters carry *exact low-dimensional
conditions*, and the search does not enforce any of them.

Written out, the condition at a character of order `d` is one equation in
`Z[zeta_d]`, and its rational rank is `phi(d)`. For the trivial character it
reads `sum_b (sum_p y_b(p))^2 = 4`, which the `q29` shell already enforces: one
block sums to `2` and three to `0`. The next one is the order-two character,
`w = -1`, where every `z_b(-1)` is an ordinary even integer and the condition
is the single Diophantine equation

```text
sum_b z_b(-1)^2 = 2092,      z_b(-1) = sum_p (-1)^p y_b(p),
```

that is, `sum_b u_b^2 = 523` in the halved variables. Nothing in the campaign
enforces it, and the plateau does not satisfy it: the order-two class carries
28.8 per character at the plateau, the largest of any class the `q174` search
is free to move, and it is the same 28.8 a uniform lift carries — the search
has not touched it at all.

Together the characters of order 2, 3, 6, 9 and 18 are seventeen of the 521,
and each of their classes is a finite condition on a low-dimensional projection
of the state. That is a constraint-satisfaction handle, not a reweighting, and
it is the part of the character domain this pass leaves open. Solving those
seventeen exactly and searching the remaining 504 subject to them is a
different shape of search from anything the campaign has run.

## Replay

Everything lives in the private campaign branch `c1016-full-2092-campaign` of
`ergodis-private`, checked out at
`~/src/ergodis-worktrees/c1016-full-2092/ergodis-private`.

    cargo test --release -p ergodis-private --lib order6_galois
    cargo test --release -p ergodis-private --lib order6_carrier
    cargo test --release -p ergodis-private --test order6_carrier_allocations
    cargo test --release --workspace --all-targets -- --test-threads=1

    hadamard order6 twist-census --corpus evidence/carrier-fibre-corpus.jsonl \
        --group fibre --per-state
    hadamard order6 twist-census --corpus evidence/carrier-fibre-corpus.jsonl \
        --group shell --per-state
    hadamard order6 twist-census --corpus evidence/carrier-column-corpus.jsonl \
        --group shell --per-state
    hadamard order6 twist-census --corpus evidence/carrier-fibre-corpus.jsonl \
        --group fibre --lifts 16 --seed 20260905

    bash scripts/shell_mine.sh evidence/q29-shell-mine.jsonl 25 45 12 990001
    bash scripts/corpus_width_ab.sh evidence/corpus-width-ab.tsv \
        evidence/q29-margin-tabu-shell-hits.json evidence/q29-shell-corpus-wide.json 30 12 5
    bash scripts/carrier_twist_ab.sh evidence/carrier-twist-ab.tsv \
        evidence/phase-two-q174-corpus.jsonl 30 12 5 fibre
    bash scripts/carrier_twist_counters.sh evidence/carrier-twist-counters.tsv \
        evidence/phase-two-q174-corpus.jsonl 15 \
        ~/.cache/ergodis/target/ergodis-private/release/hadamard \
        ~/.cache/ergodis/bin/hadamard-079acc8
    bash scripts/shell_width_sweep.sh evidence/shell-width-sweep.tsv \
        evidence/q29-shell-corpus-wide.json 15 12

    python3 scripts/q29_shell_replay.py evidence/q29-shell-mine.jsonl
    python3 scripts/shell_canonical.py evidence/q29-shell-mine.jsonl \
        evidence/q29-margin-tabu-shell-hits.json
    python3 scripts/galois_replay.py evidence/carrier-fibre-corpus.jsonl \
        evidence/carrier-column-corpus.jsonl
    python3 scripts/carrier_isotypic.py evidence/carrier-fibre-corpus.jsonl
    python3 scripts/carrier_isotypic.py --lifts=8 evidence/carrier-fibre-corpus.jsonl

Evidence hashes are in that repository's `evidence/SHA256SUMS`. The retained
executables and their digests are in `~/.cache/ergodis/bin/MANIFEST.tsv`.

## Mystery ledger

- **The character domain offers no small moves, and that is now proved rather
  than suspected.** The affine relabellings of one block contribute exactly the
  multipliers, the admissible multipliers form a group of order six, and the
  smallest nonidentity element multiplies the plateau objective by about seven.
  Settled by this pass, by exact census and confirmed at equal wall clock.
- **The plateau is isotropic on the rung.** All four character-order classes
  above the `q174` view carry the same energy per character. Nothing in the
  character domain distinguishes a direction, which is why a reweighted
  objective is not the next thing to try. Settled by this pass.
- **The search compresses the four movable order classes by the same factor of
  about twenty-seven, and no other.** That the factor is uniform is explained —
  it is the lattice-step reading squared. That it is twenty-seven, rather than
  running until the classes separate, is not. Open: no evidence gap is named
  because no experiment here distinguishes "the search stops where its move set
  runs out" from "the classes are jointly obstructed at that depth". The
  order-two Diophantine handle below is the cheapest probe of it.
- **Corpus width is not a lever, but shell identity might be, and one run each
  cannot tell.** Tripling the corpus from twelve shells to 39 costs 0.6% at
  equal wall clock, while a single fifteen-second run per shell spreads 11.7%
  from best to worst — and that spread is the same size as the run-to-run
  spread on a fixed corpus (315 against 308). Open, with an exact gate: a
  replicated sweep on shells 37, 23, 2, 9 and 10 with enough rounds to lift the
  between-shell variance above the between-seed variance. Until that runs, the
  13,648 the best shell reached is a lead, not a better plateau.
- **Nothing the campaign records about a shell predicts how deep the search
  gets from it.** The shell's own order-six margin count is uncorrelated with
  the carrier depth reached from it (r = 0.01) and its `q174` depth is only
  weakly correlated (r = 0.32). Open; owned by the same replicated sweep, which
  is the only thing that can say whether there is a shell property to predict.
- **The order-two character carries a low-dimensional Diophantine condition the
  search has never touched.** `sum_b u_b^2 = 523` in the halved variables, and
  the order-two class sits at the same 28.8 per character on the plateau as on
  a fresh uniform lift. Open by construction: this pass identifies it and
  prices nothing about it. It is the largest single unexploited structure the
  character-domain reading exposes, and enforcing the seventeen characters of
  order 2, 3, 6, 9 and 18 exactly while searching the remaining 504 subject to
  them is a different search shape from anything the campaign has run.
