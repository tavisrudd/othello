# Mirror-engine unification: conflict-graph + capacity-`c` instances and the method boundary

**Date**: 2026-07-09
**Session**: mirror-unification (Claude)
**Files**: `lean/CapGame/GraphMirror.lean` (new), `lean/ProjectiveCap/CapCMirror.lean` (new),
add-only import lines in `lean/CapGame.lean` and `lean/ProjectiveCap.lean`.

## Framing (read first — do not overclaim)

There is **one** normal-play mirror/copycat engine, `FiniteBuildGame.isP_of_invariant_mirror`
(`CapGame/Mirror.lean`): for any `Valid` family and any involution `σ`, if every legal move
from a `σ`-invariant valid position is answered by a legal `σ`-reply staying valid+invariant,
the empty position is P. The abstract "fixed-point-free involution ⇒ P" fact is **folklore**
(the pairing/copycat strategy; the capacity-1 case is the unnamed argument the queens
P-position proofs use, and the `Nofil = Node-Kayles` collapse is HHS prior art). Per the
handoff Novelty guard, the claimable content is **not** the engine but:

1. the **substantive instances** where verifying the pair-extension (chord) condition is real
   work — projective elliptic collineation, the hyperbolic-quadric similitude, the sum-free
   order-2 / order-3 breakers; and
2. the **sharp method boundary**: exactly where the pairing argument stops (capacity `≥ 3`,
   below).

This session adds the **conflict-graph (capacity-1) instance** and its Cayley specialisation,
and pins the **capacity-`c` boundary**. Wording stays "structured subfamily of known
hypergraph building-avoidance frameworks," not "new general class." The existing
`Sumfree/Game.lean` and `ProjectiveCap/Mirror.lean` proofs are **untouched** (add-only).

## One engine, several instances

| Family                         | Board / involution `σ`                       | Pair-extension (chord) condition                  | Entry theorem                                                                          | Status        |
|--------------------------------|----------------------------------------------|---------------------------------------------------|----------------------------------------------------------------------------------------|---------------|
| Sum-free (negation)            | abelian `G`, `x ↦ -x`                         | no order-2 / order-3 obstruction elements         | `Sumfree.Game.initial_isP_of_negation_no_obstructions`                                 | proven (prior)|
| Sum-free (order-2 translation) | abelian `G`, `x ↦ x + v`, `2v = 0`           | a **spare** order-2 element `v ≠ x` (`z = t+n/2`) | `Sumfree.Game.initial_isP_of_two_nonzero_orderTwo`                                     | proven (prior)|
| Projective cap (elliptic)      | `PG(V)`, elliptic collineation `σ`           | fpf ⇒ chord auto-discharges (`c = 2`)             | `ProjectiveCap.Projective.initialPStatement_of_fixedPointFree_collinearity_preserving_involution` | proven (prior)|
| Hyperbolic quadric `Q⁺`        | sub-board, block-elliptic similitude         | quadric preservation + fpf                        | `ProjectiveCap.Projective.initialSubCapP_blockQuadric_of_odd_card`                     | proven (prior)|
| **Conflict graph (cap-1)**     | graph on `α`, fpf adjacency-preserving `σ`   | **`¬ adj x (σ x)`** (chord is a non-edge)         | `ConflictGraph.initialIndepP_of_fpf_adjPreserving_involution`                          | **proven (new)** |
| **Cayley graph (general)**     | group `G`, `x ↦ g·x`, `g²=1`, `g≠1`          | **`∀x, x⁻¹ g x ∉ S`** (conj. class of `g` avoids `S`) | `ConflictGraph.Cayley.initialIndepP_cayley_of_involution_chord`                    | **proven (new)** |
| **Cayley graph (abelian)**     | comm. group `G`, `x ↦ g·x`, `g²=1`, `g≠1`    | **`g ∉ S`** (single membership test)              | `ConflictGraph.Cayley.initialIndepP_cayley_abelian_of_involution_notMem`               | **proven (new)** |
| **Capacity-`c` (general)**     | abstract `Coll`, fpf collinearity-preserving | explicit `hchord` (only capacity gate)            | `FiniteBuildGame.initialCapCP_of_no_chord`                                             | **proven (new)** |
| Capacity-`c` (projective)      | `PG(V)`, `IsCollinear`                        | explicit `hchord` + set-transport `hCollMap`      | `ProjectiveCap.Projective.initialCapCP_of_setCollinearity_preserving_no_chord`         | **proven (new, chord+transport as hyps)** |

## The pair-extension condition per family (the substantive content)

The engine is a one-liner; the mathematics is the chord/pair condition. Reading down the
"chord" column shows the same order-2-symmetry mechanism reappearing:

- **Cap-1 conflict graph.** At capacity 1 an obstruction is a single edge, so there is no
  three-point line-closure subtlety (unlike the projective proof): the mirror-chord obstruction
  is exactly the pair `{x, σx}`, killed by `¬ adj x (σx)`; every old-old obstruction `{σx, z}`
  reflects to `{x, σz}` already excluded by `x`'s legality. `mirrorStepGood_of_adjPreserving`.

- **Cayley `g ∉ S` recovers the sum-free `z = t + n/2` breaker.** For a Cayley conflict
  `x ~ y := x⁻¹y ∈ S`, left translation by an order-2 element `g` is the fpf involution; the
  chord `x⁻¹(gx) ∉ S` is the conjugacy class of `g` avoiding `S`, and in an **abelian** group
  it collapses to the single global test `g ∉ S`. This is the exact group-theoretic shadow of
  the sum-free order-2-translation mirror (`TauGood`, `initial_isP_of_two_nonzero_orderTwo`):
  there the second player answers `x` with `x + v` for an order-2 `v`, and the strategy works
  precisely when a **spare** order-2 element (`v = n/2`, the `z = t + n/2` breaker) is available
  and is not itself the played exception. Both are "order-2 translation mirror + a single
  condition on the translation step." (The two are analogues, not literally unified in code —
  the sum-free game's obstruction is the 3-uniform Schur-triple hypergraph, not a capacity-1
  conflict graph.)

## Node-Kayles double-encoding gap (known limitation)

The repo already has a Node-Kayles formalisation, `NodeKayles.Graph.win` (`NodeKayles/Basic.lean`),
using the **vertex-deletion** encoding (a mover deletes `{v} ∪ N(v)`). The new `IndepValid`
game is the **independent-set-building** encoding. They compute the same normal-play value, but
**this session does not prove them equal** — two unlinked Node-Kayles formalisations is a
coherence gap. Bridging them is a separate game-equivalence proof, flagged in the
`GraphMirror.lean` docstring and deferred as follow-up.

## Capacity-`c`: a remark, and where the pairing stops (the boundary)

Capacity-`c` forbids `c+1` collinear points; `Cap` is `c = 2`. The mirror step splits
obstructions in `insert (σx) (insert x S)` into two groups:

- **old-old / reflectable** (a collinear violation through `σx` but not `x`): reflected across
  `σ` to a violation through `x` inside `insert x S`. **This is capacity-blind** and is
  discharged for every `c` in `capCMirrorStep_of_no_chord`.
- **mirror-chord** (a violation containing both `x` and `σx`): isolated as the explicit
  hypothesis `hchord`. **This is the only place capacity enters.**

So the fully-proven general theorem is `initialCapCP_of_no_chord` with the chord explicit.
**The chord discharge is `c = 2`-only**, and the failure at `c ≥ 3` is real, not a proof
artifact:

- At `c = 2` the chord config is a triple `{x, σx, z}` (`z ∈ S`); reflecting puts `z, σz` on
  the line `x—σx`, so `{x, z, σz}` is 3 collinear inside `insert x S`, and `z ≠ σz` (fpf) makes
  it a genuine violation — contradicting `x`'s legality. (This is exactly the existing
  `mirrorStepGood_of_collinearity_preserving`; the `c = 2` game is the maintained instance.)
- At `c ≥ 3` the chord config carries `c−1 ≥ 2` old points `M ⊆ S` on the line; reflecting only
  bounds `{x} ∪ M ∪ σM`, a violation iff `|M ∪ σM| ≥ c`, i.e. iff `σM ⊄ M`. When `M` is a
  union of `σ`-pairs (possible once `|M| ≥ 2`) it is `σ`-invariant and the bound is `c`, not
  `c+1` — no contradiction.

**Concrete counterexample (`c = 3`).** In `PG(2,q)` (`q` odd) take a `σ`-invariant line `ℓ`
and a `σ`-pair `{a, σa} ⊆ ℓ`. Under mirror play `S ⊇ {a, σa}`; the opponent plays a third
point `x ∈ ℓ`. For `c = 3` the set `{a, σa, x}` is only 3 collinear, so `x` is **legal**; but
the forced reply `σx ∈ ℓ` completes `{a, σa, x, σx}` — 4 collinear — so `σx` is **illegal**.
The pairing strategy is stuck. The reason `c = 2` is safe, stated positively: a `σ`-pair
already fills a line to capacity 2, so no legal move can add a third point a mirror reply would
overflow; at `c ≥ 3` a `σ`-pair leaves room and the opponent exploits it.

**Consequence.** The odd-`PG(2m−1,q)` and hyperbolic-quadric `Q⁺(2m−1,q)` P-results do **not**
lift to the capacity-`c` game for `c ≥ 3` via this pairing argument (contrary to the initial
"free lift" expectation). Capacity-`c` for `c ≥ 3` is genuinely open to this method. The
capacity-blind portion (old-old reflection) is what actually lifts for free; the chord is the
gate, and it closes for `c ≥ 3`. This is the sharp boundary the engine framing predicts.

## Proven vs statement-level

- **Fully proven (no `sorry`/`native_decide`/new axioms):** all conflict-graph and Cayley
  theorems; `capCMirrorStep_of_no_chord`; `initialCapCP_of_no_chord` (the general capacity-`c`
  mirror, chord explicit).
- **Statement-level inputs (taken as hypotheses, standard-shape geometric obligations):** in
  the projective wrapper `initialCapCP_of_setCollinearity_preserving_no_chord`, the set-level
  collinearity transport `hCollMap` (the `IsCollinear`-on-sets analogue of the existing 3-point
  `collinear_mapEquiv`) and the chord `hchord`. The wrapper is otherwise a direct application
  of the proven engine.
- **Not attempted (documented, not sunk effort):** the `c ≥ 3` geometric lift — it is false to
  this method (above); and the `Graph.win` ↔ `IndepValid` encoding bridge.
- **Nice-to-have skipped:** a concrete `ZMod n` circulant instance of the abelian Cayley
  corollary (additive/multiplicative friction with the multiplicative `CommGroup` statement;
  the corollary is clearly non-vacuous as-is).

## `#print axioms` (verbatim)

All new top-level theorems: exactly `[propext, Classical.choice, Quot.sound]`.

```
'ConflictGraph.initialIndepP_of_fpf_adjPreserving_involution' depends on axioms: [propext, Classical.choice, Quot.sound]
'ConflictGraph.Cayley.initialIndepP_cayley_of_involution_chord' depends on axioms: [propext, Classical.choice, Quot.sound]
'ConflictGraph.Cayley.initialIndepP_cayley_abelian_of_involution_notMem' depends on axioms: [propext, Classical.choice, Quot.sound]
'FiniteBuildGame.initialCapCP_of_no_chord' depends on axioms: [propext, Classical.choice, Quot.sound]
'ProjectiveCap.Projective.initialCapCP_of_setCollinearity_preserving_no_chord' depends on axioms: [propext, Classical.choice, Quot.sound]
```

## Build transcript

```
$ nix develop --command lake build CapGame.GraphMirror ProjectiveCap.CapCMirror
✔ [2989/2990] Built ProjectiveCap.CapCMirror (1.3s)
✔ [2990/2990] Built CapGame.GraphMirror (1.4s)
Build completed successfully (2990 jobs).
```

Both targets build green with no warnings (all unused section variables `omit`-ted, no linter
errors). Add-only imports: `CapGame.GraphMirror` in `lean/CapGame.lean`,
`ProjectiveCap.CapCMirror` in `lean/ProjectiveCap.lean`.

## Node-Kayles double-encoding gap — CLOSED

The two repo encodings of the capacity-1 game are now proven to compute the same normal-play
value, in the new file `lean/NodeKayles/ConflictGameEquiv.lean` (add-only import in
`lean/NodeKayles.lean`).

- **`NodeKayles.indepGame_isP_iff`** (Main):
  `FiniteBuildGame.IsP (ConflictGraph.IndepValid (conflictAdj G)) (∅ : Finset (Fin k)) ↔ NodeKayles.IsP G Finset.univ`
  — the independent-set-building game (empty start) is P iff the vertex-deletion Node-Kayles
  game (all vertices live) is P.
- **`NodeKayles.bridge`** (the engine): for every valid built position `S`,
  `FiniteBuildGame.Win (ConflictGraph.IndepValid (conflictAdj G)) S ↔ NodeKayles.win G (liveSet G S)`.

Proof: track the **live set** `liveSet G S = univ \ ⋃_{u∈S} N[u]` of a built independent set;
a move-bijection (`move_iff_liveSet`: legal build moves = live vertices) and a child
correspondence (`liveSet_child`: `liveSet G (insert x S) = liveSet G S \ N[x]`) let a strong
induction on `(liveSet G S).card` match the two `Win`/`win` recursions ply-for-ply. Main is
the `S = ∅` instance via `liveSet G ∅ = univ`.

### `#print axioms` output (verbatim)

```
'NodeKayles.bridge' depends on axioms: [propext, Classical.choice, Quot.sound]
'NodeKayles.indepGame_isP_iff' depends on axioms: [propext, Classical.choice, Quot.sound]
```

### Build transcript

```
$ nix develop --command lake build NodeKayles.ConflictGameEquiv
ℹ [8620/8620] Built NodeKayles.ConflictGameEquiv (22s)
Build completed successfully (8620 jobs).
```

No `sorry` / `native_decide` / new axioms; no linter errors (only `{k : ℕ}` as a section
variable, used in every signature, so no `omit` needed).
