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
