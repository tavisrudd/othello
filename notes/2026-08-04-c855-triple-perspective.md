# C855 — triple perspectivity from double perspectivity: Lean formalization report

**Date:** 2026-08-04
**Lane:** `clebsch`
**Deliverable:** `lean/RelativeConicArcs/SixArcPerspectivity.lean`, theorem
`RelativeConicArcs.SixArcPerspectivity.triple_perspectivity_of_double_perspectivity`.
This is step 6 of the plan in `notes/2026-08-04-c855-dye-axiom-elimination-plan.md`.

## Statement proved

Over an arbitrary field `K` and a `K`-vector space `V` with `finrank K V = 3` (no characteristic
hypothesis, no finiteness), for projective points `p1 … p6, x, y`:

Hypotheses (all in `ProjectiveCap.Projective.Collinear` vocabulary):

- non-collinearity: `¬Coll p1 p3 p5`, `¬Coll p1 p3 p2`, `¬Coll p1 p3 p4`,
  `¬Coll p1 p3 x`, `¬Coll p1 p5 x`, `¬Coll p3 p5 x`,
  `¬Coll p1 p3 y`, `¬Coll p1 p5 y`, `¬Coll p3 p5 y`;
- first concurrence: `Coll p1 p2 x`, `Coll p3 p4 x`, `Coll p5 p6 x`;
- second concurrence: `Coll p1 p6 y`, `Coll p2 p3 y`, `Coll p4 p5 y`.

Conclusion: `∃ z, Coll p1 p4 z ∧ Coll p2 p5 z ∧ Coll p3 p6 z`.

So the matchings are `{12, 34, 56}` (at `x`), `{16, 23, 45}` (at `y`), and the conclusion matching
`{14, 25, 36}`; equivalently triangles `p1p3p5`, `p2p4p6` perspective under `1↦2, 3↦4, 5↦6` and
`1↦6, 3↦2, 5↦4` are perspective under `1↦4, 3↦6, 5↦2`.

## Why each hypothesis, and what the consumer must supply

- `¬Coll p1 p3 p5` and the three `x` conditions make `{p1, p3, p5, x}` a quadrangle, so
  `quad_normal_form` gives a frame `u` with `p1, p3, p5` on the axes and `x.rep = u0 + u1 + u2`.
- `¬Coll p1 p3 p2` and `¬Coll p1 p3 p4` give nonzero last frame coordinates for `p2` and `p4`;
  these make the exhibited representative of `z` nonzero.
- The three `y` conditions give all three frame coordinates of `y` nonzero; the product
  `d0·d1·d2` is cancelled in the key identity, and this is the only place they are used.

Every non-collinearity follows from "the six points form an arc" plus "`x`, `y` are off the six
points": a concurrence point on a side of the coordinate triangle would be the intersection of
two of its own chords and hence a vertex (e.g. `y` on `p2p3` and on `p1p3` forces `y = p3`,
since `p2p3 ≠ p1p3` by the arc condition). These derivations are NOT formalized here; the
consumer must discharge the nine non-collinearity hypotheses from its `Arc` and off-point facts,
and must also bridge from the incidence-side collinearity to
`ProjectiveCap.Projective.Collinear` (`RelativeConicArcs.ProjectiveBridge`). Notably no condition
on `p6` beyond the two concurrences is needed, and `p2` is never required to avoid `p3p5`.

Only existence of `z` is proved, for this exact labelling. A consumer applying it to two
arbitrary disjoint concurrent one-factors must first relabel the six points into the hexagonal
order in which those one-factors are `{12,34,56}` and `{16,23,45}` (their union is a six-cycle),
and needs a separate (easy, chord-pairing) argument if it wants uniqueness of `z`.

## The determinant computation (re-derived)

Frame: `p1 = (1:0:0)`, `p3 = (0:1:0)`, `p5 = (0:0:1)`, `x = (1:1:1)`. The `x`-concurrences pin
the un-normalized frame coordinates to `p2 = (a2 : s2 : s2)`, `p4 = (m4 : b4 : m4)`,
`p6 = (n6 : n6 : k6)`, with `s2 ≠ 0`, `m4 ≠ 0`; write `y = (d0 : d1 : d2)`, all entries nonzero.
In normalized terms (`a = a2/s2`, `b = b4/m4`, `c = k6/n6`) these are the note's
`(x:1:1), (1:y:1), (1:1:z)`.

- The `y`-concurrence, expanded through `collinear_iff_det_eq_zero` on each of its three chords,
  gives `n6·d2 = k6·d1` (from `p1p6`), `a2·d2 = s2·d0` (from `p2p3`), `b4·d0 = m4·d1`
  (from `p4p5`). Multiplying the three and cancelling `d0·d1·d2 ≠ 0` yields the key identity
  `k6·a2·b4 = n6·m4·s2`, i.e. `abc = 1` after normalization. In line coordinates the
  `y`-concurrence is the vanishing of `det[(0,-c,1); (-1,0,a); (b,-1,0)] = 1 - abc`.
- The conclusion point is written down explicitly: `z = (a2·b4 : b4·s2 : m4·s2)`
  (normalized `(ab : b : 1)`), the meet of `p1p4` and `p2p5`. Incidence of `z` with `p1p4` and
  `p2p5` is an identical polynomial vanishing (using only `c2 1 = c2 2`); incidence with `p3p6`
  is exactly the key identity. In line coordinates the third-matching concurrence is
  `det[(0,-1,b); (1,-a,0); (c,0,-1)] = abc - 1`.

So the two concurrence determinants are negatives of each other, `1 - abc` versus `abc - 1`,
which is why either concurrence implies the other. This confirms the sign relation claimed in
the source note.

## Labelling inconsistency found in the source note

In `notes/2026-08-03-c855-structural-exclusions.md`, Lemma B, the prose defines the second
perspectivity as `1↦6, 3↦2, 5↦4` and the conclusion as `1↦4, 3↦6, 5↦2`, but the displayed line
triples are swapped between the two. With `A = (P1, P3, P5)`, `B = (P2, P4, P6)`:

- The note's "lines of the second perspectivity" `A₁B₂, A₂B₃, A₃B₁` are the joins
  `P1P4, P3P6, P5P2` — the CONCLUSION matching `{14, 25, 36}`, not `{16, 23, 45}`.
- The note's "lines of the third" `A₁B₃, A₂B₁, A₃B₂` are `P1P6, P3P2, P5P4` — the HYPOTHESIS
  matching `{16, 23, 45}`.

The displayed determinant values (`xyz - 1` and `1 - xyz`) are correct for the line triples as
displayed; only the attachment of the triples to "second" and "third" perspectivity is
exchanged. Since the two determinants are negatives, the lemma's truth is unaffected, and the
Lean development derives both matchings directly from the statement rather than from the note.

## Verification status

- Verified in scratch form only: the new material was elaborated in a temporary file whose
  content was the `FrameCoordinates.lean` source pasted verbatim (imports
  `Mathlib.LinearAlgebra.Determinant` and `ProjectiveCap.PlaneTransitivity` only) followed by the
  new declarations, byte-identical to the deliverable's new material. `guarded-lean` on that
  scratch file exited 0 with no errors, and `#print axioms` on the main theorem reported exactly
  `[propext, Classical.choice, Quot.sound]`.
- NOT verified: elaboration of `SixArcPerspectivity.lean` itself against a compiled
  `RelativeConicArcs.FrameCoordinates` artifact (none exists yet); this compile is owed to the
  build window that lands the module. The only differences from the verified scratch are the
  `import RelativeConicArcs.FrameCoordinates` line and the module header prose.
- The scratch file was deleted after the split, as required.

## Proof-engineering notes

The proof works entirely through `FrameCoordinates.collinear_iff_det_eq_zero`, expanding each
collinearity as a `Matrix.det_fin_three` polynomial in frame-coordinate entries and reducing
with `linear_combination`. Three private helpers supply what `FrameCoordinates` lacks and are
candidates for promotion into it later under its owner: entrywise `coordOf` of a scalar multiple
and of a sum, `coordOf` of the frame vectors themselves, and a determinant criterion
(`collinear_mk_of_det_eq_zero`) whose third row is the `coordOf` of an explicit representative
vector rather than of the chosen representative of its class — this is what lets the exhibited
point `z` be checked without renormalizing `Projectivization.rep`.
