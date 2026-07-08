# C27 report: correct residual mirror lemma for cap games (2026-07-08)

## Result

Implemented and checked the generic game-theoretic mirror kernel in Lean:

- file: `lean/CapGame/Mirror.lean`
- umbrella import updated: `lean/CapGame.lean`
- projective wrapper file: `lean/ProjectiveCap/Mirror.lean`
- elliptic mirror coordinate file: `lean/ProjectiveCap/EllipticMirror.lean`
- projective umbrella import updated: `lean/ProjectiveCap.lean`

The proved names are:

```lean
FiniteBuildGame.MirrorInvariant
FiniteBuildGame.MirrorStepGood
FiniteBuildGame.mirrorInvariant_insert_pair
FiniteBuildGame.isP_of_closedMirror
FiniteBuildGame.isP_of_mirrorStep_closed
FiniteBuildGame.isP_of_invariant_mirror
```

The implementation deliberately lives in `CapGame`, not `ProjectiveCap`, because it only uses the
finite building-game recurrence. Geometry-specific files now only need to prove that their proposed
mirror reply is legal and that the two-move follower remains in the closed mirrorable class.

The `ProjectiveCap.Mirror` wrapper specializes the generic theorem to `Projective.Cap`:

```lean
Projective.collinear_swap_left
Projective.collinear_rotate_right
Projective.collinear_swap_right
Projective.cap_insert_of_cap
Projective.rep_mem_span_pair_of_collinear
Projective.collinear_of_collinear_pair
Projective.mirrorStepGood_of_collinearity_preserving_no_chord
Projective.mirrorStepGood_of_collinearity_preserving
Projective.initialPStatement_of_closedMirror
Projective.initialPStatement_of_mirrorStep_closed
Projective.initialPStatement_of_invariant_mirror
Projective.initialPStatement_of_fixedPointFree_collinearity_preserving_involution
Projective.initialPStatement_of_linearEquiv_sq_scalar_nonsquare
Projective.ellipticBlockLinearEquiv
Projective.ellipticBlockLinearEquiv_sq
Projective.initialPStatement_ellipticBlock_of_nonsquare
Projective.initialPStatement_ellipticBlock_of_odd_card
Projective.initialPStatement_of_odd_card_finrank_eq_two_mul
```

The first projective step lemma is intentionally conservative.  It proves the old-old collinearity
obstruction from collinearity preservation, but keeps the mirror-chord obstruction as an explicit
hypothesis:

```lean
∀ {x z}, Move (Cap K V) S x -> z ∈ S -> ¬ Collinear K V (σ x) x z
```

The next geometric tightening is to derive this chord hypothesis from a fixed-point-free projective
collineation plus the standard "two distinct points determine a projective line" fact.

That tightening is now also in Lean as
`Projective.mirrorStepGood_of_collinearity_preserving`.  The supporting line-transfer lemma is:

```lean
Projective.collinear_of_collinear_pair :
  a ≠ b ->
  Collinear K V a b c ->
  Collinear K V a b d ->
  Collinear K V a c d
```

So the fixed-point-free projective mirror step now has only the expected hypotheses:

- `σ` is an involution on projective points;
- `σ` has no fixed projective point;
- `σ` preserves projective collinearity;
- the old position is `σ`-invariant.

The scalar-square linear bridge is also in Lean.  If a linear automorphism `g` satisfies
`g (g v) = δ • v` for a nonsquare scalar `δ`, then the induced projective map is a fixed-point-free
involutive collineation, so the initial projective cap game is P.

The coordinate elliptic block theorem is in Lean for `V = ι -> K × K`:

```lean
Projective.initialPStatement_ellipticBlock_of_odd_card
```

Given `Odd (Fintype.card K)`, it chooses a nonsquare via `FiniteField.exists_nonsquare` and applies
the block map `(a, b) ↦ (δ * b, a)`.  This proves the odd-dimensional theorem in the standard
coordinate model with vector dimension `2 * #ι`.

The arbitrary finite-rank transport is now also in Lean:

```lean
Projective.initialPStatement_of_odd_card_finrank_eq_two_mul
```

It assumes `0 < n` and `Module.finrank K V = 2 * n`, so it is the checked theorem form of
`PG(2n-1,q)` over odd finite fields.

## Theorem Shape

`MirrorStepGood Valid σ S` says:

```lean
∀ x : α, Move Valid S x -> Move Valid (insert x S) (σ x)
```

This is the corrected pair-extension condition: `σ x` must be a legal reply after `x`, not merely
legal from `S`.

`isP_of_closedMirror` proves:

```lean
theorem isP_of_closedMirror
    {Valid : Finset α -> Prop} {Good : Finset α -> Prop} (σ : α ≃ α)
    (hstep : ∀ {S : Finset α}, Good S -> ∀ x : α, Move Valid S x ->
      Move Valid (insert x S) (σ x) ∧ Good (insert (σ x) (insert x S)))
    (S : Finset α) (hgood : Good S) : IsP Valid S
```

It is a direct reduction to the existing `FiniteBuildGame.isP_of_replyStrategy`.

`isP_of_mirrorStep_closed` is the same theorem split into a one-step mirror predicate plus a closure
hypothesis.

`isP_of_invariant_mirror` handles the common case where `Good S` is "S is valid and invariant under
an involutive board equivalence."  The helper `mirrorInvariant_insert_pair` proves that adding a
mirror pair preserves invariance.

## Verification

Commands run from `lean/`:

```text
nix develop --command lake env lean /tmp/projective_mirror_scratch.lean
```

Result:

```text
warning: Git tree '/home/tavis/src/othello' is dirty
```

Then after moving the theorem into the package:

```text
nix develop --command lake env lean CapGame/Mirror.lean
```

Result:

```text
warning: Git tree '/home/tavis/src/othello' is dirty
```

After adding the invariant-position variant:

```text
nix develop --command lake env lean CapGame/Mirror.lean
```

Result:

```text
warning: Git tree '/home/tavis/src/othello' is dirty
```

Targeted rebuild:

```text
nix develop --command lake build CapGame.Mirror ProjectiveCap.Mirror
```

Result:

```text
warning: Git tree '/home/tavis/src/othello' is dirty
✔ [2988/2989] Built CapGame.Mirror (3.2s)
✔ [2989/2989] Built ProjectiveCap.Mirror (3.3s)
Build completed successfully (2989 jobs).
```

The umbrella file needed the new module object, so I built the single target:

```text
nix develop --command lake build CapGame.Mirror
```

Result:

```text
warning: Git tree '/home/tavis/src/othello' is dirty
✔ [2983/2983] Built CapGame.Mirror (1.4s)
Build completed successfully (2983 jobs).
```

Then:

```text
nix develop --command lake env lean CapGame.lean
```

Result:

```text
warning: Git tree '/home/tavis/src/othello' is dirty
```

Then the projective wrapper:

```text
nix develop --command lake env lean ProjectiveCap/Mirror.lean
```

Result:

```text
warning: Git tree '/home/tavis/src/othello' is dirty
```

Build the single projective wrapper target:

```text
nix develop --command lake build ProjectiveCap.Mirror
```

Result:

```text
warning: Git tree '/home/tavis/src/othello' is dirty
✔ [2989/2989] Built ProjectiveCap.Mirror (1.4s)
Build completed successfully (2989 jobs).
```

Then:

```text
nix develop --command lake env lean ProjectiveCap.lean
```

Result:

```text
warning: Git tree '/home/tavis/src/othello' is dirty
```

After adding `Projective.initialPStatement_of_invariant_mirror`:

```text
nix develop --command lake env lean ProjectiveCap/Mirror.lean
nix develop --command lake build ProjectiveCap.Mirror
```

Result:

```text
warning: Git tree '/home/tavis/src/othello' is dirty
warning: Git tree '/home/tavis/src/othello' is dirty
✔ [2989/2989] Built ProjectiveCap.Mirror (1.5s)
Build completed successfully (2989 jobs).
```

After moving the scratch theorem into permanent package files and adding
`Projective.mirrorStepGood_of_collinearity_preserving_no_chord`:

```text
nix develop --command lake env lean ProjectiveCap/Mirror.lean
nix develop --command lake build CapGame.Mirror ProjectiveCap.Mirror
nix develop --command lake env lean ProjectiveCap.lean
```

Result:

```text
warning: Git tree '/home/tavis/src/othello' is dirty
warning: Git tree '/home/tavis/src/othello' is dirty
✔ [2989/2989] Built ProjectiveCap.Mirror (1.7s)
Build completed successfully (2989 jobs).
warning: Git tree '/home/tavis/src/othello' is dirty
```

After proving the projective line-transfer lemma and the stronger fixed-point-free mirror-step
lemma:

```text
nix develop --command lake env lean ProjectiveCap/PlaneTransitivity.lean
nix develop --command lake build ProjectiveCap.PlaneTransitivity
nix develop --command lake env lean ProjectiveCap/Mirror.lean
nix develop --command lake build ProjectiveCap.PlaneTransitivity ProjectiveCap.Mirror
nix develop --command lake env lean ProjectiveCap.lean
```

Result:

```text
warning: Git tree '/home/tavis/src/othello' is dirty
warning: Git tree '/home/tavis/src/othello' is dirty
✔ [2988/2988] Built ProjectiveCap.PlaneTransitivity (16s)
Build completed successfully (2988 jobs).
warning: Git tree '/home/tavis/src/othello' is dirty
warning: Git tree '/home/tavis/src/othello' is dirty
✔ [2990/2990] Built ProjectiveCap.Mirror (1.6s)
Build completed successfully (2990 jobs).
warning: Git tree '/home/tavis/src/othello' is dirty
```

After adding the whole-board fixed-point-free wrapper:

```text
nix develop --command lake env lean ProjectiveCap/Mirror.lean
nix develop --command lake build ProjectiveCap.Mirror
```

Result:

```text
warning: Git tree '/home/tavis/src/othello' is dirty
warning: Git tree '/home/tavis/src/othello' is dirty
✔ [2990/2990] Built ProjectiveCap.Mirror (1.8s)
Build completed successfully (2990 jobs).
```

After adding the scalar-square linear-equivalence bridge:

```text
nix develop --command lake env lean ProjectiveCap/Mirror.lean
nix develop --command lake build ProjectiveCap.Mirror
```

Result:

```text
warning: Git tree '/home/tavis/src/othello' is dirty
warning: Git tree '/home/tavis/src/othello' is dirty
✔ [2990/2990] Built ProjectiveCap.Mirror (1.9s)
Build completed successfully (2990 jobs).
```

After adding the coordinate elliptic block theorem and odd-cardinality corollary:

```text
nix develop --command lake env lean ProjectiveCap/EllipticMirror.lean
nix develop --command lake build ProjectiveCap.EllipticMirror
nix develop --command lake env lean ProjectiveCap.lean
```

Result:

```text
warning: Git tree '/home/tavis/src/othello' is dirty
warning: Git tree '/home/tavis/src/othello' is dirty
✔ [2991/2991] Built ProjectiveCap.EllipticMirror (1.7s)
Build completed successfully (2991 jobs).
warning: Git tree '/home/tavis/src/othello' is dirty
```

After adding arbitrary finite-rank transport:

```text
nix develop --command lake env lean ProjectiveCap/EllipticMirror.lean
nix develop --command lake build ProjectiveCap.EllipticMirror
nix develop --command lake env lean ProjectiveCap.lean
```

Result:

```text
warning: Git tree '/home/tavis/src/othello' is dirty
warning: Git tree '/home/tavis/src/othello' is dirty
✔ [2991/2991] Built ProjectiveCap.EllipticMirror (1.8s)
Build completed successfully (2991 jobs).
warning: Git tree '/home/tavis/src/othello' is dirty
```

Final narrow build over all new mirror modules:

```text
nix develop --command lake build CapGame.Mirror ProjectiveCap.Mirror ProjectiveCap.EllipticMirror
```

Result:

```text
warning: Git tree '/home/tavis/src/othello' is dirty
Build completed successfully (2991 jobs).
```

No full `lake build` was run.

## Follow-Up

Projective-specific proof work can now use:

1. `isP_of_closedMirror` for fixed-point-free projective collineations.
2. `isP_of_mirrorStep_closed` for residual/endgame mirrors where `Good` encodes the fixed-locus and
   mirror-chord hypotheses.
3. C28 to test how often computed certificate subtrees close by `MirrorClosed` leaves.

The whole-board, scalar-square, coordinate elliptic-block, and arbitrary finite-rank transport
wrappers are now in Lean.  The remaining polish is naming/aliasing convenience if we want a theorem
whose parameter is projective dimension instead of vector-space finrank.
