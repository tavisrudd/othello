# C51 — Polar-space Nofil: symplectic W(2n−1,q) (mirror harvest #3)

**Claimed + worked by Claude/Opus, 2026-07-09.**
Generator: [`../rust/scripts/polar_space_nofil.py`](../rust/scripts/polar_space_nofil.py)
(deterministic, single-core, tiny memory; reuses the C48 harvest primitives).
Lean: [`../lean/ProjectiveCap/PolarSegreMirror.lean`](../lean/ProjectiveCap/PolarSegreMirror.lean).
Scope was set in [`2026-07-09-mirror-method-boundary.md`](2026-07-09-mirror-method-boundary.md) §#3.

## Summary

Invert the figure/ground of the C48 harvest. Instead of a *variety* being the board
with ambient lines as constraints, take the **whole space `PG(2n−1,q)` as the board**
and let the constraint lines be the **totally-isotropic lines of a polar space**: a
position is legal iff no 3 selected points lie on a common isotropic line. This is a
genuinely weaker-constrained (fewer forbidden triples) capacity-2 game than the full
cap game.

The cleanest first target is **symplectic `W(2n−1,q)`**. For an alternating form `B`
*every* point is isotropic, so the board is all of `PG(2n−1,q)` (odd projective
dimension), and the C25 elliptic block map already lives there. The result:

> **`W(2n−1,q)` is a P-position (second-player win) for every odd `q` and every
> `n ≥ 2`**, via the elliptic block mirror `σ(aᵢ,bᵢ) = (δ·bᵢ, aᵢ)` (`δ` a fixed
> nonsquare), which is a **symplectic similitude** of the standard alternating form
> `B(x,y) = Σᵢ (x₂ᵢ y₂ᵢ₊₁ − x₂ᵢ₊₁ y₂ᵢ)` with factor `−δ`, hence maps isotropic lines
> to isotropic lines while staying fixed-point-free and collinearity-preserving.

The mechanism is uniform in `q` and `n` (the similitude computation and the
"no `λ²=δ`" fpf argument have no size dependence), so the small-`q` machine gates
confirm a proof that holds for the whole family — no per-`q` certificate needed.

## Why the elliptic map is a symplectic similitude (the one new computation)

With `σ(aᵢ,bᵢ) = (δ bᵢ, aᵢ)` and `B(x,y) = Σᵢ (x₂ᵢ y₂ᵢ₊₁ − x₂ᵢ₊₁ y₂ᵢ)`:

```
B(σx, σy) = Σᵢ [ (δ x₂ᵢ₊₁)(y₂ᵢ) − (x₂ᵢ)(δ y₂ᵢ₊₁) ]
          = δ · Σᵢ [ x₂ᵢ₊₁ y₂ᵢ − x₂ᵢ y₂ᵢ₊₁ ]
          = −δ · B(x,y).
```

So `σ` scales `B` by the constant `−δ ≠ 0`; therefore `B(σx,σy)=0 ⇔ B(x,y)=0`, i.e.
`σ` sends every totally-isotropic line to a totally-isotropic line. It is fixed-point-
free on all of `PG(2n−1,q)` because `σ² = δ·I` (projectively the identity) and `λ²=δ`
has no solution for `δ` nonsquare (C25). This is the exact analogue of C48's
observation that the same map is a factor-`δ` *similarity* of the split quadratic
form `Σ aᵢbᵢ`; here it is a factor-`−δ` similitude of the alternating form.

**Note on the machine "factor" print.** The script's `similitude_factor` is computed on
the *raw* block-map images (a linear identity), giving the constant `−δ`; it is
meaningless on *normalized* projective representatives, where per-point rescaling
destroys the constant (an early version printed `NONE` for exactly this reason — the
isotropy-preservation is projectively well-defined, the factor is not).

## Machine gates (verbatim)

```
### W(3,3) symplectic  (board = all of PG(3,3)): 40 points (even)
    elliptic mirror (a,b)->(d b,a), d(nonsquare)=2: {'is_perm': True, 'involutive': True, 'fpf': True, 'collinearity_preserving': True}
    symplectic-similitude factor B(g x,g y)/B(x,y) = 1  (expected -d = 1; constant nonzero => isotropy-preserving)
    isotropic lines: 40 of sizes {4: 40}  (0.1s)
    GQ(3,3) check: points 40 vs 40, lines 40 vs 40, line-size 4  =>  MATCH
    sigma preserves the isotropic-line hypergraph: True
    C27 pair-extension over ALL 22572 sigma-invariant caps: PASS => total mirror strategy => P  (3.0s)

### W(3,5) symplectic  (board = all of PG(3,5)): 156 points (even)
    elliptic mirror (a,b)->(d b,a), d(nonsquare)=2: {'is_perm': True, 'involutive': True, 'fpf': True, 'collinearity_preserving': True}
    symplectic-similitude factor B(g x,g y)/B(x,y) = 3  (expected -d = 3; constant nonzero => isotropy-preserving)
    isotropic lines: 156 of sizes {6: 156}  (1.9s)
    GQ(5,5) check: points 156 vs 156, lines 156 vs 156, line-size 6  =>  MATCH
    sigma preserves the isotropic-line hypergraph: True
    C27 pair-extension SAMPLED 11908 moves: PASS  (1.2s)  [proof = similitude above + uniform lemma]

### W(5,3) symplectic  (board = all of PG(5,3)): 364 points (even)
    elliptic mirror (a,b)->(d b,a), d(nonsquare)=2: {'is_perm': True, 'involutive': True, 'fpf': True, 'collinearity_preserving': True}
    symplectic-similitude factor B(g x,g y)/B(x,y) = 1  (expected -d = 1; constant nonzero => isotropy-preserving)
    [large board] lines/solve skipped; fpf + similitude confirm the uniform mirror hypotheses.
```

What each row establishes:

- **`W(3,3)` (= GQ(3,3)):** the board is honestly all 40 points of `PG(3,3)`; the
  isotropic-line hypergraph is verified to be exactly `GQ(3,3)` (40 points, 40 lines of
  4 points — the self-dual generalized quadrangle). `σ` is a fpf involution preserving
  the hypergraph. The **C27 pair-extension holds over ALL 22572 σ-invariant reachable
  caps** — this is a *complete* P-certificate: the mirror strategy is total (from every
  σ-invariant position every legal move `x` has `σx` legal as a reply, keeping the
  position σ-invariant and valid), so the second player never gets stuck ⇒ P. (Same
  standard as the C48 mirror-only rows; an exhaustive minimax cross-check at 40 pts is
  infeasible in pure Python — the isotropic game's longer maximal plays give a far
  larger reachable set than the more-constrained `Q(4,3)` variety game.)
- **`W(3,5)` (= GQ(5,5)):** hypergraph verified (156 points/lines of 6), similitude
  factor `−δ = 3`, hypergraph-preserving fpf involution; sampled pair-extension PASS.
- **`W(5,3)`:** 364 points, fpf + similitude confirmed (board too large to enumerate
  lines in pure Python; the uniform argument covers it).

## The general theorem and its proof

The game-theoretic content is a **capacity-2 near-linear-space mirror**: `W(2n−1,q)`'s
isotropic-line game is a capacity-2 line hypergraph in which two distinct points lie on
at most one line (a near-linear / partial linear space, inherited from ambient
projective geometry — two projective points determine a unique projective line, so a
fortiori at most one isotropic line). For such a game, a fixed-point-free
line-preserving involution gives P by the C27 pair-extension argument, whose sole
capacity-dependent step (the mirror chord) discharges from near-linearity at `c = 2`:
if `x, σx, z` share an isotropic line `ℓ`, then `x, σx, σz` share the isotropic line
`σℓ`; `ℓ` and `σℓ` both contain the distinct points `x, σx`, so `ℓ = σℓ`, whence
`x, z, σz` are 3 points on `ℓ` already inside the played `insert x S` — contradicting
`x`'s legality. So `σx` is always a legal reply. This is exactly the C48/C25 chord
discharge, transported from ambient collinearity to isotropic-collinearity.

## Lean

New file [`../lean/ProjectiveCap/PolarSegreMirror.lean`](../lean/ProjectiveCap/PolarSegreMirror.lean)
(imported from `ProjectiveCap.lean`). It factors the reusable engine out of the
projective cap game:

- `FiniteBuildGame.capC2Chord_of_nearLinear` — the capacity-2 chord discharge from a
  near-linearity law `a ≠ b → Coll {a,b,z} → Coll {a,b,w} → Coll {a,z,w}` (the "two
  points determine a line" fact in Finset form) plus downward closure and
  σ-preservation.
- `FiniteBuildGame.initialCapC2P_of_nearLinear_mirror` — **the engine**: a
  fixed-point-free involution preserving a downward-closed near-linear collinearity
  predicate ⇒ `IsP (CapCValid Coll 2) ∅`. Built on the already-proven
  `FiniteBuildGame.initialCapCP_of_no_chord` (`ProjectiveCap/CapCMirror.lean`). This is
  the "conflict-hypergraph mirror lemma" the §#3 scope asked for, at capacity 2; it
  underwrites the projective cap game, the C51 isotropic-line game, and the C52 ruling
  game with one proof.
- `GridRook.gridRook_isP` — a fully-proven concrete instantiation (see the C52 report):
  the capacity-2 rook-lines game on `A × ZMod (2t)`, which is `Q⁺(3,q) = PG(1,q)²`.

The file builds clean (only linter warnings). `#print axioms` on both
`FiniteBuildGame.initialCapC2P_of_nearLinear_mirror` and `GridRook.gridRook_isP`:
`[propext, Classical.choice, Quot.sound]` — no `sorry`, no `native_decide`.

The **symplectic instantiation** (building `Coll = on a common isotropic line` from a
mathlib alternating form and discharging near-linearity from projective line
uniqueness) is left as the remaining geometric obligation; the machine gates above
verify every hypothesis the engine consumes (fpf, isotropic-line-preservation via the
`−δ` similitude, near-linearity from projective geometry).

## Boundary watch (#5 recurs at the group level)

```
### Boundary watch (#5 recurs at the group level)
    orthogonal/parabolic host PG(2,3): a diag(1,1,-1) linear involution has 5 fixed proj pts (odd #vars => rational eigenvector).  Symplectic escapes this because 2m is even AND the nonsplit sqrt(d) makes sigma fpf on the WHOLE space.
```

The #5 boundary theorem is expected to recur at the group level for unitary/orthogonal
polar spaces: the *board* is now the whole space, but the mirror must preserve the
isotropic-line set, i.e. be an isometry/similitude of the form — so the anisotropic-core
obstruction of #5 applies to the acting group. Symplectic escapes it because the
alternating form makes *every* point isotropic (no anisotropic core) and `dim = 2n` is
even, so the nonsplit `√δ` map is fpf on the entire space. The orthogonal/Hermitian
polar-space isotropic-line games are the natural next boundary probes.

## Reproduce

```
cd rust && python3 scripts/polar_space_nofil.py          # ~10s
```
