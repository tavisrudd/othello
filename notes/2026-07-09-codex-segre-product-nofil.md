# C52 — Segre / product-variety Nofil (mirror harvest #4)

**Claimed + worked by Claude/Opus, 2026-07-09.**
Generator: [`../rust/scripts/segre_product_nofil.py`](../rust/scripts/segre_product_nofil.py)
(deterministic, single-core, tiny memory; reuses the C48 harvest primitives).
Lean: [`../lean/ProjectiveCap/PolarSegreMirror.lean`](../lean/ProjectiveCap/PolarSegreMirror.lean).
Scope was set in [`2026-07-09-mirror-method-boundary.md`](2026-07-09-mirror-method-boundary.md) §#4.

## Summary

`Q⁺(3,q)` **is** the Segre variety `PG(1,q) × PG(1,q) ↪ PG(3,q)` (the `(q+1)×(q+1)`
grid). Generalize the board to `PG(a,q) × PG(b,q)` (Segre embedding): a line meeting
the Segre variety (an intersection of quadrics) in ≥3 points is contained in it, and
the only lines on the Segre are the two **rulings**

  `{P} × (line of PG(b,q))`   and   `(line of PG(a,q)) × {Q}`,

so the cap game is a capacity-2 "rook-lines on a subspace grid" game, which we model
**directly on the grid** `PG(a,q) × PG(b,q)` (no `PG(N,q)` tensor embedding needed).
The result:

> **`PG(a,q) × PG(2m−1,q)` is a P-position for every odd `q`**, via the mirror
> `σ = id × g` where `g` is the C25 elliptic fixed-point-free involution on the
> **odd-dimensional factor** `PG(2m−1,q)`. `σ` is fpf on the product (fpf in one
> coordinate ⇒ fpf overall) and ruling-preserving (a product of collineations sends
> ruling lines to ruling lines), and the C27 pair-extension reduces to the
> single-factor argument.

## Machine gates (verbatim)

```
### PG(1,3) x PG(1,3) Segre: 16 points (even)
    factor A=PG(1,3): 4 pts, 1 lines; factor B=PG(1,3): 4 pts, 1 lines
    ruling hypergraph: 8 lines of sizes {4: 8}
    Q+(3,3) sanity: pts 16 vs 16, lines 8 vs 8  =>  MATCH
    mirror sigma = id_A x (elliptic on B): {'is_perm': True, 'involutive': True, 'fpf': True}
    sigma preserves the ruling hypergraph: True
    C27 pair-extension over ALL 63 sigma-invariant caps: PASS => total mirror strategy => P  (0.0s)
    exhaustive cap-game outcome: P  (0.00s, 953 states)

### PG(2,3) x PG(1,3) Segre: 52 points (even)
    factor A=PG(2,3): 13 pts, 13 lines; factor B=PG(1,3): 4 pts, 1 lines
    ruling hypergraph: 65 lines of sizes {4: 65}
    mirror sigma = id_A x (elliptic on B): {'is_perm': True, 'involutive': True, 'fpf': True}
    sigma preserves the ruling hypergraph: True
    C27 pair-extension over ALL 117963 sigma-invariant caps: PASS => total mirror strategy => P  (23.6s)

### PG(1,3) x PG(3,3) Segre: 160 points (even)
    factor A=PG(1,3): 4 pts, 1 lines; factor B=PG(3,3): 40 pts, 130 lines
    ruling hypergraph: 560 lines of sizes {4: 560}
    mirror sigma = id_A x (elliptic on B): {'is_perm': True, 'involutive': True, 'fpf': True}
    sigma preserves the ruling hypergraph: True
    C27 pair-extension SAMPLED 11182 moves: PASS  (2.1s)  [proof = ruling-preservation + uniform lemma]
```

What each row establishes:

- **`PG(1,3)²` (= `Q⁺(3,3)` sanity):** the grid model reproduces `Q⁺(3,3)` exactly (16
  points, 8 four-point lines — the two rulings of the `4×4` grid). The mirror
  `σ = id × elliptic` is a fpf ruling-preserving involution; the C27 pair-extension
  holds over ALL 63 σ-invariant caps, **and** the independent exhaustive minimax solve
  returns **P** — the two proofs agree.
- **`PG(2,3) × PG(1,3)` (52 pts):** the fpf factor is `B = PG(1,3)` (odd projective dim
  1, `K²`); `σ = id_{PG(2,3)} × elliptic`. C27 pair-extension over ALL 117963
  σ-invariant caps PASS ⇒ P (a complete mirror certificate).
- **`PG(1,3) × PG(3,3)` (160 pts):** the fpf factor is `B = PG(3,3)` (odd projective dim
  3); ruling-preserving fpf involution; sampled pair-extension PASS. The uniform
  argument covers the full solve, which is out of exhaustive reach.

## The general theorem and its proof

Same engine as C51 (§Lean below): the Segre ruling game is a **capacity-2 near-linear
line hypergraph** (two distinct grid points lie on at most one ruling line — a ruling
line fixes one coordinate, so two points with both coordinates differing share no
ruling line, and two points sharing one coordinate lie on the single ruling line for
that coordinate). The mirror `σ = id × g`:

- **fpf:** `σ(P,Q) = (P, g Q)`; since `g` is fpf on the second factor, `g Q ≠ Q`, so
  `σ(P,Q) ≠ (P,Q)`. (More generally `σ_a × σ_b` is fpf iff `Fix(σ_a) × Fix(σ_b) = ∅`,
  i.e. iff *some* factor's involution is fpf.)
- **ruling-preserving:** `{P} × ℓ_b ↦ {P} × g(ℓ_b)` (a line of `PG(b,q)` since `g` is a
  collineation) and `ℓ_a × {Q} ↦ ℓ_a × {g Q}` — both rulings map to rulings.

so the C27 pair-extension (mirror chord) discharges from near-linearity exactly as in
C51. Uniform in `q` and the factor dimensions.

## Boundary (#5): a product of two even-dim factors admits no `id × (fpf)` mirror

```
### Boundary: PG(2,3) x PG(2,3) (both factors even proj dim)
    every diag(+-1) involution on a K^3 factor has >= 5 fixed proj pts (odd #coords => rational eigenvector).  So sigma_a x sigma_b is fpf iff SOME factor's involution is fpf; two even-dim factors give none.  Matches the #5 boundary.
```

Because `σ_a × σ_b` is fpf iff at least one factor's involution is fpf, and a linear
involution on an even-projective-dim factor (odd number of coordinates, e.g. `K³` for
`PG(2,q)`) always keeps a rational fixed point, **the product of two even-dimensional
factors has no `σ = σ_a × σ_b` mirror**. This is the #5 boundary recurring at the
product level: one **odd-dimensional factor** is required. (As with the C48 negatives,
this is a *method* boundary — the outcome may still be P by some other mechanism.)

## Grassmannians (next step up)

`Gr(2,4)` under Plücker is the Klein quadric `Q⁺(5,q)` — already covered by the C48
hyperbolic-quadric family. Higher `Gr(k,n)` needs the fpf-on-`k`-subspaces check for
the induced elliptic map (a `√δ`-eigenspace-free condition on `k`-subspaces); a
"Grassmannian Nofil" family is plausible but the fpf condition is the crux and is not
resolved here.

## Lean

The C52 base family is **Lean-proven** in
[`../lean/ProjectiveCap/PolarSegreMirror.lean`](../lean/ProjectiveCap/PolarSegreMirror.lean).
The file factors out the shared engine (see the C51 report) and instantiates it:

- `FiniteBuildGame.initialCapC2P_of_nearLinear_mirror` — the capacity-2 near-linear
  mirror engine (fpf involution + downward-closed near-linear `Coll` ⇒ P), built on the
  proven `initialCapCP_of_no_chord`.
- `GridRook.gridRook_isP` — **the capacity-2 rook-lines game on `A × ZMod (2t)` is P**,
  via the column-shift mirror `(i,j) ↦ (i, j+t)` (fpf, rook-collinearity-preserving,
  near-linear — all proven: `shift_fixed`, `shift_involutive`, `rookColl_map`,
  `rookColl_down`, `rookColl_linear`). Taking `A = ZMod (q+1)`, `2t = q+1` (odd `q`
  makes `q+1` even) this **is** `Q⁺(3,q) = PG(1,q) × PG(1,q)`, so C52's base family is
  unconditional in Lean. The rook-grid formulation is exactly the C48 "capacity-2
  rook-lines / E1 line-capacity" model.

The file builds clean (only linter warnings). `#print axioms GridRook.gridRook_isP`:
`[propext, Classical.choice, Quot.sound]` — no `sorry`, no `native_decide`.

The **general higher-factor Segre** (`PG(a,q) × PG(2m−1,q)`, `b ≥ 3`) reduces to the
same engine once the product ruling `Coll` predicate over abstract factor line
predicates is built; the machine gates above verify every engine hypothesis (fpf,
ruling-preservation, near-linearity). This is the remaining Lean obligation, at
statement level.

## Reproduce

```
cd rust && python3 scripts/segre_product_nofil.py        # ~30s (52-pt full BFS dominates)
```
