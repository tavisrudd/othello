# C438 — q=9/q=11 decorated-transform seam

**Lane:** `crowns`

**Date:** 2026-07-20

**Verdict:** `SHARP OBSTRUCTION; THE OUTER FUSIONS LIVE ON DIFFERENT FIBRES`

**Literature depth:** zero sources were read at full text for this post-C435 review.  One cached
primary source was reread at the partial depth stated below.  This report makes no novelty or
priority claim.

## Result

C435 does not turn C405's q=9 construction and C379's q=11 construction into two specializations
of one decorated obstruction transform.  It instead exposes the precise categorical mismatch.

Both examples do share a coarse terminating deepest-locus pattern.  Using the respective
codimension-four and codimension-three deepest-locus operators of C405 and C379, one has

```text
q=9:   A (7 points in PG(3,9))  -> X (8-point Cayley octad) -> empty,
q=11:  X (6 points in PG(2,11)) -> Q (12-point conic)       -> empty.
```

Both first arrows become injective on their frozen finite source fibres after adding a decoration.
The decorations, however, are not produced by the same obstruction construction, and C435's two
seven-suborbits do not repair that failure.

### The q=9 fibre

For the fixed octad `X`, the eight C405 parents form one transitive `PSL_2(7)`-set

```text
P9 = PSL_2(7)/(7:3),                 |P9|=8.
```

C435 gives an equivariant bijection `P9 -> X`: a parent is recovered by marking one octad point.
Classical Cayley-octad theory indexes the 28 bitangents by *all* unordered pairs of octad points,
namely the complete edge set `binom(X,2)`.  C405 separately finds 28 singular quadrics in the net
and explicitly leaves their incidence dictionary with the bitangents to a later test.  Either
unmarked 28-set is preserved by the full order-168 child stabilizer, so neither can select one of
the eight parents whose stabilizer has order 21.

Marking `p in X` does select the seven-edge star at `p`, but this does not strengthen the recovery:
the star and the marked point determine each other.  Across the eight bitangent stars there are 56
vertex--edge incidences, and every one of the 28 unoriented octad-pair labels occurs in two stars.
C405/C435 establish neither a corresponding seven-subset of singular net quadrics nor a
parent-specific singularity, degeneration, or root type.  Thus the bitangent labels supply a
classical ambient incidence space, not the parent-recovering obstruction invariant required by
C438.

The semilinear action does not split `P9` into two sheets.  Its orders remain

```text
projective:  168/21 = 8,             semilinear: 336/42 = 8.
```

C435's fusion `1,7,7,21 -> 1,14,21` occurs on a different `PGU(3,3)`-set: the 36 symmetric
determinantal/even-theta classes, based at one class with stabilizer `PSL_2(7)`.  It is not a fusion
of the eight-parent fibre over `X`.

### The q=11 fibre

For the fixed conic child `Q`, C379's 22 parents form

```text
P11 = PGL_2(11)/A5,                  |P11|=22.
```

Here the decoration is intrinsically obstruction-bearing.  The six deletion conics of a parent
cut `Q` into a perfect matching `M_X`; the same six edges are exactly the pairs whose effective
roots intersect in `-1`, rather than `0`.  The matching stabilizer is the parent `A5`, so `(Q,M_X)`
recovers the parent.  Moreover `PSL_2(11)` splits `P11` into two eleven-parent one-factorizations,
and the outer element `J` exchanges those two components.  The sheet structure therefore lives on
the parent/matching fibre itself.

## Failure of the required commuting square

The proposed square would have to identify, functorially, all three of the following levels:

```text
source parent  ->  child  ->  parent-recovering obstruction decoration.
```

At q=11 the outer involution and the root-intersection decoration both act on `P11`.  At q=9 the
parent decoration is a point of `X`, while Frobenius's `7+7 -> 14` fusion acts on the separate
36-class determinantal fibre.  Moving the q=9 fusion into the square therefore changes objects;
moving the unmarked 28-sets into it forgets the parent; and replacing the bitangents by a seven-edge
star merely re-encodes the already supplied octad-point mark.  No shared discriminant/root
invariant survives these forgetful maps.

The common statements “the second bare transform is empty” and “a finite decoration makes the
first arrow injective” are true, but they are formal packaging broad enough to fit unrelated
terminating transforms.  Counts, subgroup inclusions, and separate incidence tables were
explicitly excluded as a pass.  C438
therefore stops at its incompatible-marking/invariant gate.  G4 and G11 receive no promotion from
this spike.

## Post-C435 review of the octad-picture advice

The earlier advice to “consume existing Cayley-octad obstruction pictures” is too strong for this
finite-field seam.  Van Bommel--Docking--Dokchitser--Lercier--Lorenzo García define octad pictures
from valuation/degeneration data for Cayley octads over non-archimedean local fields.  Their picture
is invariant under projective coordinate change; its map to stable-reduction type is proved
compatible with changing Cayley octad for a single building block, while the general compatibility
is conjectural.  The paper also explicitly warns that the picture itself depends on the chosen
Cayley octad even when its stable-reduction image does not.

C405/C435 provide a smooth Hermitian quartic and 36 rational determinantal classes over `F_9`, but
no local-field lift, valuation data, degeneration, or stable-reduction type.  Hence the paper is a
valuable prior-art template and novelty boundary for any future *degeneration* version of the q=9
construction; it does not provide an obstruction object that C438 can import into the present
finite-field transform.  C435 strengthens this conclusion by separating the transitive 36-class
marking action from the eight-parent fibre.

**Source read at partial depth:** Raymond van Bommel, Jordan Docking, Vladimir Dokchitser, Reynald
Lercier, and Elisa Lorenzo García, *Reduction of Plane Quartics and Cayley Octads*,
arXiv:2309.17381v2.  Reread the Introduction's statement of the octad-picture-to-stable-reduction
map and Section 1.2, including the coordinate-invariance theorem, the `Sp(6,2)` action, the
single-building-block theorem, and the general compatibility conjecture.  Cached as
`arXiv:2309.17381`, SHA-256
`1ca4b91e0e9daf15527ee922f90a2754d9a7a087f4873a35fc62826f6b12d925`.

No claim-specific absence search or forward-citation closure was run, because the seam fails on
the internal category test before novelty becomes load-bearing.

## Evidence boundary

This obstruction is a conceptual comparison of already certified finite actions, not a new finite
enumeration.  Its load-bearing inputs are:

- C435's exact `21 < 168 < 6048` stabilizer tower, eight-parent/octad-point bijection, 36-class
  action, and semilinear fusion;
- C405's 28 singular net quadrics, classical octad-pair/bitangent indexing, explicitly open
  incidence dictionary between them, and `U(X)=empty`; and
- C379's 22 matching-decorated parents, `11+11` split, root-intersection characterization, and
  `D(Q)=empty`.

The distinction between the q=9 parent fibre and determinantal fibre can be checked directly in
the tracked C435 certificate: `parent_decoration_recovery` has orbit sizes `8/8`, whereas
`determinantal_class_action` and `semilinear_fusion` carry the `1,7,7,21` and `1,14,21` data.
No new script or certificate is needed, and no statement is made for arbitrary Cayley octads,
arbitrary deep-hole transforms, or chosen local-field lifts of the Hermitian quartic.

## Postmortem continuation

A subsequent bounded attack-vector search preserves this obstruction but finds a better category:
marked Cayley-octad points are exactly the classical 288 Aronhold systems, while q=11 matchings are
maximal isotropic kernels in the 2-torsion of the genus-five hyperelliptic curve branched at the
twelve conic points.  This suggests a theta/Richelot bridge rather than the failed direct fibre
square.  It also certifies that no q=9 parent stabilizer fixes one of the 63 Steiner complexes, so
the most tempting direct six-pair shortcut is unavailable.  See
`notes/2026-07-20-c438-postmortem-bridge-attack-vectors.md` and its exact evidence bundle.

## C414 consumption boundary

C414's later twisted-Fourier synthesis consumes this report only as a category stop: its
q=7/q=11 factorization-sector statement lives on conic parent/matching fibres and must not be
advertised as a q=9 decorated-transform specialization.  The corrected scalar-weight versus sheet-
parity distinction and the exact B3/H3 exceptional blocks are recorded in
`notes/2026-07-20-c414-tautological-fourier-preflight.md`; they do not weaken the different-fibre
obstruction proved here.
