# C910 — the six-label action on the source lattice, and diagonal stability of both primary kernels

**Lane:** `cubic-threefolds` · **Task:** C910 · **Date:** 2026-08-20

This pass removes the last supplied input of the primary-kernel chain built on
2026-08-19 (`2026-08-19-c910-two-primary-lattice-model.md`,
`2026-08-19-c910-two-primary-pairing.md`,
`2026-08-19-c910-two-primary-standard-coordinates.md`,
`2026-08-19-c910-three-primary-analogue.md`).  Both transported primary kernels
were proved self-dual — maximal isotropic at two, maximal isotropic and hence
four-dimensional at three — and reached their packets only *as soon as* they
were stable under the two diagonal generators.  Stability, standing for
`A₅`-equivariance, was supplied.  It is now proved, from an equivariance
hypothesis on the comparison matrix alone.

## What this pass did

Two new modules under
`papers/cubic-stabilization-epilogue/lean/TavisRuddFiniteGeom/Papers/CubicStabilizationEpilogue/GraphLattices/`.

`SixAxisSourcePermutationAction.lean` represents the six-label permutation
group on the source lattice.  A permutation acts on coordinate families by
inverse precomposition; in the five-coordinate chart of the integral quotient
of six labelled coordinates by the constant line its induced map has the
explicit integral matrix

```text
sixPointChartMatrix R σ row column
  = [σ⁻¹(row) = column] - [σ⁻¹(∞) = column]
```

where the labels of the chart are the first five of the six and the subtracted
indicator is the passage to the quotient.  The key lemma is that this matrix
implements inverse precomposition on difference coordinates: it carries the
chart coordinates of a six-label family to the chart coordinates of the
permuted family.  Everything else follows from that one identity together with
surjectivity of the difference-coordinate map.  The matrices carry the identity
to the identity and products to products, so they form a monoid homomorphism
`sixPointChartRepresentation` from the whole six-label permutation group; each
preserves the coefficient matrix `6I₅-J₅`, which is read off from the
permutation invariance of the six-coordinate form `6·Σxᵢyᵢ - (Σx)(Σy)` already
formalized on the integral quotient.  Kronecker multiplication by the identity
on the rank-two elliptic homology coordinate extends the representation to the
source lattice, where it preserves the source polarization.

The contragredient matrix — the transpose of the matrix of the inverse
permutation — is what descends to the discriminant group, because that group is
presented as the cokernel of the polarization rather than as `Λ^#/Λ` directly.
Two identities carry the whole transport: the contragredient action intertwines
the polarization with the action, `Ǎ F = F A`, and it commutes with the
integral cofactor in the same sense, `C Ǎ = A C`.  The first is exactly the
isometry `AᵀFA = F` after cancelling, and the second follows from the first by
cancelling the nondegenerate `6I₅-J₅` on the right.  The first makes the
contragredient action well defined on the cokernel; the second makes it
compatible with the cofactor comparison used to identify the two models of a
primary part.

`SixAxisPrimaryKernelStability.lean` runs the diagram.  For a comparison matrix
`C` pulling a unimodular `T` back to the source polarization and equivariant
for one permutation — meaning `C A = B C` for *some* integral target matrix `B`
— right-cancellation of `C` turns the intertwining identities into
`Ǎ (Cᵀ T) = (Cᵀ T) B`, so the descended action carries the class of `(Cᵀ T) s`
to the class of `(Cᵀ T)(B s)` and preserves the lattice model of the isogeny
kernel; being linear it preserves each torsion part, hence each primary part of
that kernel.  The primary comparison — reduction modulo the prime of the
cofactor image — carries the descended action to the reduced source action, by
the cofactor identity.  The reduced source action moves each elliptic homology
coordinate separately by the reduced chart matrix, and on a chart vector of
vanishing coordinate sum that chart matrix is, in the four heart coordinates,
exactly the heart matrix of the same permutation: such a vector is the
difference presentation of the normalized heart representative of its own first
four coordinates, so the existing lemmas
`sixPointHeartCoordinates_translation` and `sixPointHeartCoordinates_inversion`
apply verbatim, and likewise at three.  Hence both transported primary kernels
are stable under the two diagonal generators, and the packet classifications
apply with no stability hypothesis:

- the transported two-primary kernel is one of the five members of the
  projective-line packet over the field with four elements;
- the transported three-primary kernel is the vertical copy or one of the three
  scalar graphs.

`Applications/RelativeSixAxis.lean` carries both per fibre.  The geometric
input structure gains one field, `homologyComparisonEquivariant`, the
first-homology form of the equivariance the structure already named as an
opaque proposition, and the packaged conclusion gains two fields: the
source-lattice permutation action with its isometry and composition laws, and
the unconditional packet membership of both primary kernels.  Two reviewer
terminals were added, `relativeSixAxis_sourceLatticePermutationAction` and
`relativeSixAxis_primaryKernelEquivariantPackets`; both report
`propext, Classical.choice, Quot.sound`.

## What the hypothesis is, and what it is not

Equivariance here is a matrix statement: on each fibre the comparison matrix
carries the source action of each of the two displayed generators to *some*
integral endomorphism of the target lattice.  Nothing more is needed — in
particular the target action is not required to preserve the target
polarization, and no relation between the two generators' target actions is
used.  What remains supplied is the identification of that matrix statement
with equivariance of an actual relative isogeny under the manuscript's
alternating group, together with the identification of the six labels with the
manuscript's six dihedral axes.  No abelian scheme, relative isogeny, torsion
group scheme, Weil pairing, or geometric group action is constructed anywhere
in this pass.

## Validation

From `papers/cubic-stabilization-epilogue/`:

```text
lean/scripts/lean-build-queue.py build CubicStabilizationEpilogue \
  TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.Verification.AxiomAudit \
  --lean-root <repository>/papers/cubic-stabilization-epilogue/lean --cores 20-23
make lint formal-static
make formal-audit AXIOM_LOG=<run directory>/logs/<audit target>.quiet/<run>/<invocation>/stdout.log
```

Both the source-only and the axiom-log check pass over 154 sources and 304
reviewer terminals, with 62 claims, 48 machinery rows, and unchanged coverage
counts (5 absent, 27 fragmentary, 29 conditional, 1 complete).  The claim-map
row for `lem:relative-six-axis` was reviewed across objects, hypotheses,
conclusion, and cautions before its digests were refreshed: the cautions no
longer say that stability is a hypothesis or that equivariance is unrepresented,
and say instead which matrix-level hypothesis replaced them.  The manuscript
PDF was not rebuilt: the only manuscript change is the `\lean` list of that
lemma, whose macros are typographically empty.

## Mystery ledger

- **Settled: stability at both primes.**  It was the one remaining supplied
  input of the primary chain and is now a consequence of matrix-level
  equivariance.  Nothing in the argument is prime-specific beyond the two
  displayed heart matrices.
- **Settled: how weak the equivariance hypothesis can be.**  No isometry on the
  target side, no compatibility between the two generators, and no invertibility
  of the target action is used; right-cancellation of the comparison matrix,
  which is nondegenerate by the pullback identity, does all the work.
- **Settled: why the contragredient and not the action itself descends.**  The
  discriminant group is presented as the cokernel of the polarization, which is
  `Λ^#/Λ` transported by the polarization; that transport turns the action into
  its contragredient.  The cofactor identity is the same statement one step
  further along.
- **Open, and now sharper: equivariance cannot select a packet member.**  The
  packet at two is exactly the set of diagonally stable maximal-isotropic
  subspaces, and at three exactly the diagonally stable four-dimensional ones.
  So every member is stable, and no strengthening of the group hypothesis can
  distinguish them.  Identifying the actual gluing kernel — the exotic member at
  two — needs an input outside the six-label action, of the kind the marked
  quadratic extension and its Frobenius orbit supply in
  `FrobeniusPacket.lean` and `ConnectedPacketPersistence.lean`.  That is the
  next real gate on this chain, not more equivariance.
- **Open: the orders `2⁴` and `3⁴` of the primary parts of the kernel.**  Still
  unstated, and the route no longer needs stability: the kernel has order `6⁴`
  and splits as the direct sum of its two primary parts, each annihilated by its
  prime and therefore of prime-power order, so unique factorization forces the
  two orders.  The Lean cost is relativizing complementation to the kernel
  subgroup, not new mathematics.
- **Open, unchanged: the geometric commutator pairing and the dictionary
  proposition.**  No elliptic torsion group scheme, Weil pairing, or geometric
  discriminant is constructed at either prime, and the identification of the six
  labels with the manuscript's dihedral axes remains supplied.
