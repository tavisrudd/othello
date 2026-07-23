# Proof of the `Y_NK` guard — `capOK ⟹ (value = P ⟺ full-graph Node-Kayles Grundy 0)`

**Lane:** `cap`. Companion to [C523](2026-07-23-c523-ynk-full-graph-guard.md) (which certified this
computationally: 54,930 `capOK` grandchildren at q=13/17/19, 0 disagreements). This note is the
written proof, pending Lean formalization. Intended for adversarial review before it is relied on.

## Game

The residual grid game (cap handoff, § Residual Grid Game). Fix the frame points `a = (1:0:0)` and
`b = (0:1:0)` in `PG(2,q)`. A **state** is a finite set `S` of affine points (a cell `(r,c)` is the
point `(r:c:1)`) such that `{a,b} ∪ S` is a **cap** (no three of its points collinear). The **legal
moves** from `S` are

```
L(S) = { x affine point : {a,b} ∪ S ∪ {x} is a cap }.
```

Players alternately play a point of `L(current state)`; **normal play** — a player with no legal move
loses. `value(S) = P` means the player to move from `S` loses (equivalently the previous player wins).

The residual game's "at most one point per burned row / column" constraints are exactly "no point
collinear with `a`" (rows through the row-direction frame point) and "no point collinear with `b`"
(columns), so they are already part of the single cap condition on `{a,b} ∪ S`. There is no separate
constraint to track.

## Objects

For a state `S`:

- **Conflict graph `G_S`.** Vertex set `L(S)`; distinct `y, z ∈ L(S)` are adjacent (`y ~ z`) iff
  `{a,b} ∪ S ∪ {y,z}` is **not** a cap. Because `{a,b} ∪ S` is a cap and `y, z ∈ L(S)` (so
  `{a,b} ∪ S ∪ {y}` and `{a,b} ∪ S ∪ {z}` are caps), the only way to break the cap is a collinear
  triple `{y, z, w}` with `w ∈ {a,b} ∪ S`. **So `y ~ z` iff `y, z` are collinear with some point of
  `{a,b} ∪ S`.**
- **Capacity-two line.** A projective line `ℓ` with `ℓ ∩ ({a,b} ∪ S) = ∅` (it carries no frame point
  and no selected point, hence could still receive two cap points).
- **`capOK(S)`.** Every capacity-two line contains at most two points of `L(S)`.
- **Node-Kayles on `G_S`.** The impartial normal-play game: players alternately pick a vertex not
  equal or adjacent to any previously picked vertex; equivalently, picking `x` deletes `x` and its
  neighborhood `N(x)` and play continues on the induced subgraph. Mover-with-no-vertex loses.

## Lemma 1 (a move is vertex deletion — unconditional)

For every legal `x ∈ L(S)`, `L(S ∪ {x}) = L(S) \ ({x} ∪ N_{G_S}(x))`.

*Proof.* `y ∈ L(S ∪ {x})` iff `{a,b} ∪ S ∪ {x, y}` is a cap. This requires `y ∈ L(S)` (take the
subset `{a,b} ∪ S ∪ {y}`), `y ≠ x`, and that no collinear triple uses both `x` and `y`; a triple
`{x, y, w}` with `w ∈ {a,b} ∪ S` is exactly a `G_S`-edge `x ~ y`. Triples `{x, w, w'}` are ruled out
because `x ∈ L(S)`, and triples inside `{a,b} ∪ S ∪ {y}` because `y ∈ L(S)`. Hence
`y ∈ L(S ∪ {x}) ⟺ y ∈ L(S), y ≠ x, y ≁ x`. ∎

Lemma 1 needs no hypothesis: the reachable move sets always shrink by exactly a closed neighborhood.
What can differ from Node-Kayles is the **edge set** among the survivors.

## Lemma 2 (edge preservation — needs `capOK`)

If `capOK(S)` then for every legal `x`, `G_{S ∪ {x}} = G_S[L(S ∪ {x})]` (the induced subgraph on the
survivors).

*Proof.* Write `T = S ∪ {x}` and let `y, z ∈ L(T)` (so, by Lemma 1, `y, z ∈ L(S)` and `y, z ≁ x`).

“⊇”: if `y ~ z` in `G_S`, the witnessing collinear triple uses `w ∈ {a,b} ∪ S ⊆ {a,b} ∪ T`, so
`y ~ z` in `G_T`.

“⊆”: suppose `y ~ z` in `G_T` but not in `G_S`. Then `{a,b} ∪ T ∪ {y,z} = {a,b} ∪ S ∪ {x, y, z}`
contains a collinear triple absent from `{a,b} ∪ S ∪ {y,z}`, so the new triple uses `x`. It cannot be
`{x, y, w}` or `{x, z, w}` with `w ∈ {a,b} ∪ S` (those would make `x ~ y` or `x ~ z` in `G_S`,
contradicting `y, z ≁ x`), nor `{x, w, w'}` (as `x ∈ L(S)`). So the triple is `{x, y, z}` collinear;
let `ℓ` be its line. Now split on whether `ℓ` meets `{a,b} ∪ S`:
- if `ℓ ∩ ({a,b} ∪ S) = ∅`, then `ℓ` is a capacity-two line of `S` carrying the three legal points
  `x, y, z ∈ L(S)` — contradicting `capOK(S)`;
- if `ℓ` meets `{a,b} ∪ S` at some `w`, then `{y, z, w}` is collinear, so `y ~ z` in `G_S` —
  contradicting the assumption.

Either way a contradiction, so no such extra edge exists. ∎

## Lemma 3 (`capOK` persists)

If `capOK(S)` then `capOK(S ∪ {x})` for every legal `x`.

*Proof.* Let `ℓ` be a capacity-two line of `S ∪ {x}`, i.e. `ℓ ∩ ({a,b} ∪ S ∪ {x}) = ∅`. Then
`ℓ ∩ ({a,b} ∪ S) = ∅`, so `ℓ` is capacity-two for `S`, whence `|ℓ ∩ L(S)| ≤ 2` by `capOK(S)`. Since
`L(S ∪ {x}) ⊆ L(S)` (Lemma 1), `|ℓ ∩ L(S ∪ {x})| ≤ 2`. Adding `x` creates no new capacity-two line
(a capacity-two line of `S ∪ {x}` avoids `x`, so was already capacity-two for `S`). Hence
`capOK(S ∪ {x})`. ∎

## Theorem (`Y_NK`)

If `capOK(S)`, the residual game from `S` is isomorphic, as an impartial normal-play game, to
Node-Kayles on `G_S`. Consequently `value(S) = P ⟺ Grundy(G_S) = 0`.

*Proof.* Induction invariant: every state `T` reachable from `S` satisfies (i) `capOK(T)` and
(ii) `G_T = G_S[L(T)]`. (i) holds by Lemma 3 along the path; (ii) holds because each step restricts to
an induced subgraph (Lemma 2), and a composition of induced-subgraph restrictions is an induced
subgraph, so `G_T` depends only on `L(T)`, not on the path taken. Given the invariant, from any
reachable `T` the legal moves are the vertices of `G_T` (Lemma 1) and playing `x` deletes `x ∪ N(x)`
and continues on the induced subgraph — one Node-Kayles move. Hence the game tree from `S` coincides
with Node-Kayles on `G_S`, the empty state `L = ∅` being a loss for the mover in both. For a single
impartial normal-play game, a position is a P-position iff its Grundy value (defined by the mex
recursion) is `0`; therefore `value(S) = P ⟺ Grundy(G_S) = 0`. (This is the mex/P-position fact, not
the Sprague–Grundy sum theorem — the object here is one game, not a disjunctive sum; a Lean
formalization should target the mex fact.) ∎

**Corollary (`Y_NK0`).** When `L(S)` contains no live conic point (the "empty conic" case), `G_S` is
the zone graph, and the theorem specializes to the original empty-conic guard.

## What this proof does and does not give

- **Does:** a self-contained reduction of any `capOK` state to a *static* Node-Kayles position. It is
  `q`-uniform — no arithmetic input. In fact **`q`-oddness is never used**: the proof needs only that
  `{a,b} ∪ S` is a cap and `capOK(S)`, so the guard holds for even `q` as well (oddness enters the
  broader program only through the conic structure). The three lemmas are elementary finite projective
  geometry plus the mex/P-position fact for a single impartial game.
- **Does not:** decide `Grundy(G_S)` in closed form. `Y_NK` (= `capOK` + `Grundy 0`) is checked by
  computing the Node-Kayles Grundy value of `G_S`; this proof says that value **is** the game value,
  not that it is cheap or has a uniform formula. A uniform `q`-independent Grundy criterion for the
  arising graph class is a separate (open) question.
- **Does not:** bear on the depth-2 routing conjecture (C524), which concerns states that are **not**
  `capOK` (`capOVER`) and is unproven.

## Review checklist (for the adversarial pass)

1. Lemma 2 “⊆” enumeration of new triples — is `{x,y,z}` truly the only possibility given
   `y, z ≁ x` and `x,y,z ∈ L(S)`? (Triples with two frame points are impossible in a cap; triples
   `{x, y, w}` excluded by non-adjacency; check no case is missed with repeated/degenerate points.)
2. The claim “`y ~ z` iff collinear with a point of `{a,b} ∪ S`” — verify the cap-breaking triple must
   contain both `y` and `z` (it cannot be an all-old triple since `{a,b} ∪ S` is a cap, nor a
   single-new triple since `y, z ∈ L(S)`).
3. Normal-play convention match: the engine returns `value = False` (P) on an empty move set; confirm
   this equals “mover with no Node-Kayles vertex loses,” i.e. Grundy `0`.
4. Definition alignment: the code's `node_kayles_exact` uses lines with `fixed_load + |selected ∩ ℓ| = 0`
   and `max legal points ≤ 2`; confirm this is exactly “every capacity-two line has `≤ 2` legal
   points” as used here.
5. Any hidden dependence on the conic / on `S` being reachable from a real opening — the proof should
   hold for an arbitrary `capOK` state, independent of provenance.
