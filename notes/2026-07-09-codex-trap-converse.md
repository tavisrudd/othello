# C41 trap converse report

Date: 2026-07-09.

Task: Lean-certify the missing converse: a trapped residual size-3 grid position implies the
rank-three projective cap game is N.

## Proof kernel

Definitions in Lean:

- `GridGame.OddEscapeStatement`: every residual grid cap `S` with `S.card = 3` has a legal child
  `insert p S` that is `GridGame.IsP`.
- A trap is exactly `not GridGame.OddEscapeStatement`, classically unfolded as
  `exists S, S.card = 3 and GridCap S and forall p in LegalExtensions S, not IsP (insert p S)`.
- `Projective.InitialPStatement`: the empty full projective cap game is `IsP`.

The converse proof is by contradiction from coordinate root-P.

1. Unfold `not OddEscapeStatement` and choose trapped `S`.
2. By `GridGame.isP_iff_all_children_win`, the trap is a grid P-position: every legal child is
   `not IsP`, hence `Win` because `IsP` is definitionally `not Win`.
3. Bridge this arbitrary residual grid position to the full coordinate projective game using
   `FrameGridBridge.Coordinate.isP_fixedDirections_iff_grid`:
   `A = fixedDirections union affineEmbedding '' S` is a projective P-position.
4. `GridCap S` gives `Projective.Cap A`, and `S.card = 3` gives `A.card = 5`.
5. Pick one affine point `y` of `A` and set `F = A.erase y`. Then `F` is a four-point cap by
   `Projective.cap_mono`, so it is a frame in the game-facing sense.
6. Let `T` be the standard coordinate frame
   `fixedDirections union affineEmbedding '' StandardResidualSeed`. It is a four-point cap by the
   existing standard seed lemmas.
7. Use `Projective.capTransitiveStatement_four` to obtain a cap-preserving point equivalence
   `e` with `F.map e = T`.
8. Game values transport under this equivalence by `FiniteBuildGame.isP_map`, so
   `A.map e = insert (e y) T` is a P-valued child of `T`.
9. Therefore `T` is `Win` by `FiniteBuildGame.win_of_move_to_isP`.
10. But coordinate root-P plus `Projective.initialPStatement_iff_isP_frame_of_finrank` says `T`
    is `IsP`, contradiction.

No extra parity or extension-count hypothesis is needed for the formal implication. The positive
count `q^2 - 9q + 21 > 0` remains useful for prose: a trap is not a terminal size-3 position, but
the game-theoretic proof only needs "all legal children are N".

## Lean result

Added:

- `lean/ProjectiveCap/TrapConverse.lean`
- import from `lean/ProjectiveCap.lean`

Main theorem names:

- `ProjectiveCap.GridGame.TrapConverse.oddEscapeStatement_of_coordinateInitialPStatement`
- `ProjectiveCap.GridGame.TrapConverse.oddEscapeStatement_of_initialPStatement_finrank`
- `ProjectiveCap.GridGame.TrapConverse.initialPStatement_iff_oddEscapeStatement_finrank`

The final theorem is:

```lean
theorem initialPStatement_iff_oddEscapeStatement_finrank
    {V : Type*} [AddCommGroup V] [Module K V]
    [Fintype (Projective.Point K V)] [DecidableEq (Projective.Point K V)]
    (hrank : Module.finrank K V = 3) :
    Projective.InitialPStatement (K := K) (V := V) ↔
      OddEscapeStatement (K := K)
```

So D1/falsification phrasing may now state the bidirectional equivalence, modulo the usual Lean
spec-match caveat.

## Validation

Build:

```text
$ nix develop --command lake build ProjectiveCap.TrapConverse ProjectiveCap
warning: Git tree '/home/tavis/src/othello' is dirty
✔ [3019/3020] Built ProjectiveCap (1.3s)
Build completed successfully (3020 jobs).
```

Axiom gate:

```text
$ nix develop --command lake env lean /tmp/c41_axioms.lean
warning: Git tree '/home/tavis/src/othello' is dirty
'ProjectiveCap.GridGame.TrapConverse.oddEscapeStatement_of_coordinateInitialPStatement' depends on axioms: [propext,
 Classical.choice,
 Quot.sound]
'ProjectiveCap.GridGame.TrapConverse.oddEscapeStatement_of_initialPStatement_finrank' depends on axioms: [propext,
 Classical.choice,
 Quot.sound]
'ProjectiveCap.GridGame.TrapConverse.initialPStatement_iff_oddEscapeStatement_finrank' depends on axioms: [propext,
 Classical.choice,
 Quot.sound]
```
