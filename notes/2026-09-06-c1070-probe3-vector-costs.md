# C1070 probe 3 — vector costs and Pareto antichains

**Lane**: `ergodis`
**Task**: C1070 probe 3 (per-level budgets; the vector-cost probe of the compositional-leakage brief
`notes/2026-09-06-c1070-ergodis-compositional-leakage-brief.md`).
**Code**: `~/src/ergodis-private`. `~/src/ergodis` core is read-only for this probe.
**Predecessor**: probe 5, `notes/2026-09-06-c1070-probe5-privacy-interface-tower-case.md`.
**Status**: in progress — written incrementally, updated at each milestone.

## 0. The question

An adversary limited to `a` compromised whole blocks and `b` leaf coordinates does not have a scalar
budget. Its cost is a vector, one component per resource class, and "the minimum-cost coalition"
becomes a Pareto antichain of minimal cost vectors under the componentwise order. This probe asks
what the public core already offers for partially ordered costs, builds the antichain search, and
judges whether the manuscript's finite contextual quotient argument survives the change.

## 1. Part A — what the public core already offers for partially ordered costs

Bounded reads of `~/src/ergodis`; no core file was edited.

### 1.1 The finding: the core already has a partially ordered vector-cost monoid

`src/ordered_resource.rs` is the answer, and the brief did not name it. It defines
`FiniteOrderedMonoid` — a finite commutative monoid with compact elements `0..element_count`, an
`identity`, a `combine`, and a `leq` that is explicitly a **partial** order, not a total one:
`validate_finite_ordered_monoid` exhaustively certifies reflexivity, antisymmetry, transitivity,
monotonicity of the order under `combine`, and extensivity, and nowhere requires comparability. Two
incomparable elements pass validation.

`CappedAdditiveMonoid` is exactly the vector cost this probe needs: a vector of per-component caps,
mixed-radix encoded into one `u32`, with `combine` the componentwise capped sum
(`saturating_add(..).min(cap)`) and `leq` the componentwise `<=`. When every cap is 1 it degenerates
to bitset union and subset, with `combine = left | right` and `leq = left & !right == 0`. It carries
a constant-time `certificate()` rather than paying the cubic audit.

`ParetoFront` is the canonical antichain representing an upward-closed set of feasible costs, and
`WitnessedParetoFront` / `ParetoWitness` / `WitnessedParetoWorkspace::compose` carry a witness
alongside each antichain element through composition. So antichain composition with witnesses is
already a core capability, at a preallocated workspace boundary.

### 1.2 The dominance kernel is there but half-exported

`src/scheduler_dominance.rs` maintains, per layer, an antichain of `(load vector, repair count)`
states, and decides componentwise dominance by SWAR: `DominanceLayout::new(capacities)` packs one
lane per resource with a guard bit, and `dominates_packed` decides lane-wise `left >= right` with a
single borrow-free subtraction, `((left | guard) - right) & guard == guard`. It also carries certified
deletion witnesses replayable by an independent unpacking checker.

That kernel is domain-neutral in substance — it is a packed componentwise comparison over a vector of
bounded nonnegative integers — but its public surface is not. `DominanceLayout::new`, `width`, `lane`,
`lane_limit`, and `capacity` are public; `pack` and `dominates_packed`, the two operations that make
it usable outside the scheduler, are private. A consumer outside the scheduler can build a layout and
read lanes out of a packed word, but cannot pack a vector in or ask whether one dominates another.

`src/scheduler_bound.rs` is about *avoiding* the Pareto frontier, not representing it: it supplies a
certified Lagrangian bound so a branch and bound never materializes the frontier. Its lesson for this
probe is a warning about cost, not a reusable component — it exists because the scheduler's frontier
reached about a hundred thousand states and tens of billions of pairwise dominance comparisons.

`src/defect.rs` is unrelated: projective defect pruning over line-degree profiles, not a cost algebra.

### 1.3 The transfer and composition min-sum is totally ordered

Precisely, and this is the load-bearing answer for probe 3:

- `composition.rs`'s `CostTable` maps a label to a **`u32`**, and `from_entries_field` collapses
  duplicate labels with `(*old).min(cost)`. One scalar per label, no antichain.
- `confinement.rs` composes with `checked_add` for the min–sum step and `.min(..)` to select across
  sectors — the tropical semiring `(ℕ ∪ {∞}, min, +)`, totally ordered.
- `frozen_shortest_path.rs` is Dijkstra-style label setting with `cost: u64` and a sentinel
  `ABSENT_SHORTEST_PATH_COST = u64::MAX`. Label setting is correct only because the order is total
  and costs are nonnegative: a settled class is final. It does import `ordered_resource::FrozenParetoPlan`,
  so the two worlds already touch, but the shortest-path objective itself is a scalar.

So: **the labelled recovery cost machinery — the part probe 3 would actually want to make
vector-valued — is over a totally ordered monoid throughout, while the core's partially ordered
monoid and Pareto composition live in a separate module that the transfer stack does not use.**

### 1.4 What would have to change (no core edits made)

1. `CostTable` would have to carry, per label, an antichain of incomparable cost vectors instead of
   one `u32`, and its `min` collapse would become an antichain merge. This is the real change; it
   touches the type every transfer and confinement path returns.
2. `confinement.rs`'s `checked_add`/`min` min–sum would become a Minkowski sum of antichains followed
   by a dominance filter.
3. `frozen_shortest_path.rs`'s label setting would have to become label *correcting* over
   `(class, cost vector)` pairs, because with a partial order a class is not settled by its first pop.
4. Two private functions in `scheduler_dominance.rs` — `DominanceLayout::pack` and
   `dominates_packed` — would need exporting for the packed comparison to be reusable. That is the
   smallest useful core change this probe identifies, and it is a visibility change only.

None of this was done. Part B builds the vector-cost search in `ergodis-private` on the direct
method, where the change is contained, and leaves the core alone.

## 2. Part B — the vector-cost interface

New sibling module `~/src/ergodis-private/src/vector_leakage.rs`, plus the tier-2 subcommand
`ergodis-tools leakage-vector`. It reuses `hierarchical_leakage` for everything algebraic — tower
compilation, the observation model, the one-pass reduction that decides recovery and returns the
coefficient witness, the projective-class and subspace enumerations — and replaces only the cost and
the search. The scalar path is untouched; see section 2.5.

### 2.1 The cost model, and why costs are per unit

A cost vector carries up to three nonnegative integer components. **Costs are assigned to units, not
to coalitions**, and a coalition's cost is the componentwise sum. That is forced: the search and the
dominance pruning are only sound if cost is additive over units. A component that counted *distinct
observed coordinates* would not be additive, because a whole-block unit and a leaf unit inside it
share coordinates, so taking both charges less than the sum. The module therefore offers only
per-unit weights and says so in its documentation rather than silently getting overlap wrong.

The cost model is a separate document (`ergodis.leakage-cost-model.v1`) supplied alongside the
encoding, so probe 5's encoding inputs are reused verbatim, byte for byte. Each component is one of:

- `unit-count` — `weight` per matching unit taken;
- `coordinate-count` — `weight` per leaf coordinate the matching unit carries (an acquisition cost,
  additive over units);
- `scalar-cost` — the unit's own declared scalar `cost`, which recovers the probe 5 cost as one
  component.

Each carries a selector matching whole-block units, partial units, or a specific tower level. The
brief's budget — `a` compromised whole blocks and `b` individually read leaf coordinates — is the
two-component model `[unit-count(partial), unit-count(whole-block)]`, committed as
`cost-model-leaves-and-blocks.json`.

### 2.2 The search

Best-first over coalitions ordered by the **sum of components**. That sum is a linear extension of
the componentwise order: if `v ≤ w` componentwise and `v ≠ w` then `sum(v) < sum(w)`, because all
weights are nonnegative and some component is strictly smaller. Each subset is generated exactly
once, by adding units of strictly increasing index, as in probe 5.

Two things differ from the scalar search. First, it does not stop at the first success: it runs to
heap exhaustion, offering every recovering coalition's vector to the antichain and dropping vectors
that a found minimal vector already dominates. Second, the pruning rule is the dominance rule — a
coalition whose vector is at or above a known minimal vector is not expanded, because every superset
has a componentwise larger vector and so cannot contribute a new minimal element. That prune is what
keeps the search from degenerating into the full subset sweep.

Each antichain element keeps its own coalition, observed coordinates, and coefficient witness.

### 2.3 The `t`-symbol profile under a partial order

The scalar profile was a minimum over `t`-dimensional subspaces of `row A`. Its correct
generalization is the **antichain of the union**: pool the per-subspace antichains over all
`t`-dimensional `T ⊆ row A`, then take the minimal elements of that pool. A cost vector is in the
`t`-profile when some `t`-dimensional piece of the secret is recoverable at that cost and no
achievable cost is componentwise smaller. This is not a minimum of scalars dressed up; the profile
entry is genuinely set-valued.

### 2.4 Independent cross-check

For every functional class, a separate routine sweeps all `2^u` coalitions, tests recovery with the
public core's row-space rank arithmetic (`ergodis::Matrix::canonical_row_basis_with`, comparing the
observed rank against the rank of the observed rows stacked with the target — not this crate's
elimination), collects the cost vectors of the recovering ones, and reduces that multiset to its
antichain with a plain minimal-element filter. The reported antichain must equal it as a set of
vectors; the subcommand exits nonzero otherwise. Two independent recovery tests and two independent
antichain computations.

### 2.5 The scalar path is unchanged

Two edits touched `hierarchical_leakage.rs`, both visibility only: `core_recovers` and
`mask_coordinates` became `pub` so the vector module can reuse the core-routed recovery test and the
coordinate resolution. No logic changed. Re-running the complete probe 5 replay regenerates all
twelve outputs, `sha256sum -c` verifies all eighteen entries of
`notes/data/2026-09-06-c1070-probe5/SHA256SUMS`, and `git status` reports no change to that
directory. The outputs are byte-identical.

### 2.6 Results

The `leaves-and-blocks` two-component model against probe 5's six encodings and one new input.
"max classwise" is the largest antichain over the projective classes of the secret.

| input | max classwise | `t`-profile antichains | sweep agrees |
|---|---|---|---|
| `single-level-f3-plain`   | 1 | `t=1: {(1,0)}` | yes |
| `single-level-f3-twisted` | 1 | `t=1: {(2,0)}` | yes |
| `single-level-f5-plain`   | 1 | `t=1: {(1,0)}` | yes |
| `single-level-f5-twisted` | 1 | `t=1: {(2,0)}` | yes |
| `tower-two-level-f3`      | 3 | `t=1: {(0,1),(1,0)}` · `t=2: {(0,1),(2,0)}` · `t=3: {(0,2),(1,1),(3,0)}` | yes |
| `tower-two-level-gf4`     | 2 | `t=1: {(0,1),(1,0)}` · `t=2: {(0,1),(2,0)}` | yes |
| `tradeoff-block-against-leaves-f3` | 2 | `t=1: {(0,1),(3,0)}` | yes |

Reading of these:

- The four single-level inputs have no whole-block units, so the second component is identically zero,
  the order is total on the reachable vectors, and the antichain collapses to exactly the probe 5
  scalar answer — 1 for `(x,y,x+y)` and 2 for `(x,y,x+2y)`, over both `F_3` and `F_5`. The vector
  path degenerates correctly.
- In the two-level `F_3` tower **every one of the thirteen projective classes** has at least two
  incomparable minima, and one class (`m1 + m2`) has three, `{(0,2),(1,1),(2,0)}`. Under probe 5's
  scalar cost each of these classes had a single number. The scalar summary was not merely coarser;
  it selected one point of an antichain and discarded the rest.
- The whole-block units, which never won anything under probe 5's scalar cost, win a component
  everywhere here. That is the point: probe 5's model priced a three-leaf block at 2 against three
  leaves at 3, and the search preferred leaves on ties; separating the resources makes the block
  incomparable rather than losing.
- `tower-two-level-f3` at `t = 2` is `{(0,1),(2,0)}`: **one compromised whole block already leaks two
  symbols** of the three-dimensional secret, since the block's three leaves span a rank-two space of
  message functionals. That is a per-level-budget statement no scalar cost expresses.
- The new `tradeoff-block-against-leaves-f3` input is the requested clean case. Only leaves 0, 1 and
  3 are individually readable, so the secret `m0+m1+m2` is either three leaves, `(3,0)`, or the single
  whole block that contains it, `(0,1)`. The block dominates in the leaf component and loses in the
  block component, and the antichain has exactly those two elements.

### 2.7 Tests

Six tests in `src/vector_leakage.rs`, all passing:

- the four single-level inputs give a one-point antichain equal to the probe 5 scalar cost;
- the two-level tower's antichains are genuine antichains (no element dominates another), at least
  one class has two incomparable minima, and the `t = 3` profile has at least two elements;
- the trade-off input's antichain is exactly `{(0,1),(3,0)}`;
- the search antichain matches the independent sweep on all six inputs plus the trade-off input;
- a three-component model (leaves, blocks, coordinates) also matches the sweep, exercising the
  maximum vector dimension; and
- the minimal-element filter keeps exactly the incomparable elements of a hand-written multiset.

### 2.8 Validation gate

`rustfmt --check` clean on the new files. `cargo test -p ergodis-private --release --lib` passes the
whole private library. `cargo clippy --all-targets --all-features -- -D warnings` exits 0 across the
whole workspace with these files in it — the pre-existing `tasks/tools` findings noted in the probe 5
report were fixed separately, and the one finding these files raised (`should_implement_trait`, for
an inherent `add` on the cost vector) was resolved by implementing `std::ops::Add` rather than
renaming, so `+` is the composition operator on cost vectors.

The cost vector's `+` is where the vector analogue of the min–sum lives, which is the reason to make
it the real operator: `CostVector + CostVector` is exactly the `combine` a `FiniteOrderedMonoid`
would supply, and `dominates_or_equals` is its `leq`. If this ever moves onto the core's
`CappedAdditiveMonoid`, those two functions are the seam.

## 3. Replay

Working directory `/home/tavis/src/othello/notes/data`. Build from `/home/tavis/src/ergodis-private`
with `cargo build -p ergodis-tools --release`, then for each of probe 5's six stems:

```text
~/.cache/ergodis/target/ergodis-private/release/ergodis-tools leakage-vector \
  --input 2026-09-06-c1070-probe5/<stem>.json \
  --cost-model 2026-09-06-c1070-probe3/cost-model-leaves-and-blocks.json \
  --json-out 2026-09-06-c1070-probe3/<stem>.vector.json \
  --summary-out 2026-09-06-c1070-probe3/<stem>.vector.txt
```

and for the new input, with `--input 2026-09-06-c1070-probe3/tradeoff-block-against-leaves-f3.json`
and the matching output stem. The subcommand exits nonzero if the sweep disagrees with any reported
antichain. Verify with `sha256sum -c SHA256SUMS` inside `2026-09-06-c1070-probe3`, and confirm the
scalar path with `sha256sum -c SHA256SUMS` inside `2026-09-06-c1070-probe5` after re-running the
probe 5 replay. Tests: `cargo test -p ergodis-private --lib vector_leakage`.

Generator sources in `ergodis-private`:

| file | SHA-256 |
|---|---|
| `src/vector_leakage.rs`             | `023337e807335cc9072d1997848453f620fe0e4fe7cda4c14f7a270b3c2b68ef` |
| `src/hierarchical_leakage.rs`       | `ab21c4c1feff2881d5f4eb3ad4e72f0beb193d4282091de94a8a6f7ef0cac901` |
| `tasks/tools/src/leakage_vector.rs` | `814815e007af60b5c4ac78a04e31efc701fd47e1d049beccdc29ad09216ab418` |

Inputs, cost model, reports, and summaries: `notes/data/2026-09-06-c1070-probe3/SHA256SUMS`.

**What this certifies and does not.** The antichains are exact minimal cost vectors for the stated
observation model and the stated per-unit cost model, and nothing else. They say nothing about an
adversary with a different unit vocabulary, and nothing about non-additive costs, which the model
deliberately cannot express. The sweep confirms minimality within the enumerated coalition lattice;
it shares the encoding matrix with the search, and does not re-derive it.

## 4. Part C — does the finite contextual quotient survive vector costs?

**This is reasoning, not a proof, and it is not evidence of either answer.**

My reading is that it does not obviously survive, and that a separate argument is needed, for one
specific reason: the quotient's finiteness argument and its exactness argument fail differently, and
only the finiteness one transfers cheaply.

Exactness looks safe. The manuscript's quotient is a congruence — states that agree on all
completions of bounded size are identified — and that definition never mentions the cost order. If
two contexts agree on which coalitions recover which labels, they agree under any cost assignment,
scalar or vector, because the cost is a function of the coalition and not of the state. So the
congruence property is order-agnostic and I would expect it to carry over verbatim.

Finiteness is where I expect the argument to need rebuilding. In the scalar case the state that has
to be retained per label is a single number, and the bound on the number of states leans on
costs being drawn from a totally ordered set with a bounded range — a label's retained cost is
one value in `0..r`, so the state space is a bounded-height function into a chain. Under a
componentwise order the retained object per label is an **antichain** in `(0..r)^d`, and the number of
antichains in a `d`-dimensional grid is the Dedekind-style count, which is enormous but still finite
for fixed `d` and `r`. So I expect finiteness to survive in the weak sense — the state space is
still finite at bounded radius — while the *bound* becomes wildly worse and any argument that quoted
a polynomial or small-constant state count is simply void. Concretely, the empirical evidence here
already pushes that way: the `t = 3` profile of a six-leaf tower has three incomparable minima where
the scalar had one, and `scheduler_bound.rs` exists in the core precisely because a Pareto frontier
elsewhere in this codebase blew up to about a hundred thousand states.

The third piece, and the one I would attack first, is the min–sum itself. Associativity of the
composition needs `combine` to distribute over the antichain merge — that a Minkowski sum of
antichains followed by a dominance filter equals the filter of the Minkowski sum of the unfiltered
sets. That is true when the order is monotone under addition, which `CappedAdditiveMonoid` in the
core explicitly certifies (`OrderedResourceError::Monotone`), so I would expect the min–sum step to
go through with the antichain merge in place of `min`. If that holds, what is left to prove is
exactly the finiteness bound, not the algebra.

One caveat I would not wave away: label *setting* becomes label *correcting*. `frozen_shortest_path`'s
correctness rests on a settled class being final, which is a total-order fact. Any quotient argument
that borrowed "settled" from the shortest-path formulation, rather than from the congruence, has to
be redone. My recommendation is that probe 2, which is already about reading the profile off the
quotient, be settled in the scalar case first, and vector costs be layered on afterwards, since the
scalar quotient is a special case of the vector one at `d = 1` and a scalar negative would kill both.
