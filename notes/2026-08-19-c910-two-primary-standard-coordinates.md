# C910 — the two-primary kernel in the standard coordinates, and the packet

**Lane:** `cubic-threefolds` · **Task:** C910 · **Date:** 2026-08-19

Third pass of the day on the two-primary side of `lem:relative-six-axis`,
after `2026-08-19-c910-two-primary-lattice-model.md` (identification of the two
models) and `2026-08-19-c910-two-primary-pairing.md` (the discriminant pairing
across that identification).

## What this pass did

New module
`papers/cubic-stabilization-m1/lean/TavisRuddFiniteGeom/Papers/CubicStabilizationM1/GraphLattices/SixAxisTwoPrimaryStandardCoordinates.lean`
closes the last gap between the lattice statement and the packet
classification.

The normalized two-primary form lives on `F₂`-valued source vectors; the
rank-eight tensor form of the coefficient heart lives on the standard
coordinates `Fin 4 → Fin 2 → F₂`. The coordinate equivalence between them
discards the fifth axis coordinate. It is an isometry, and the reason is the
augmentation normalization: a kernel vector has vanishing axis coordinate sum
along each elliptic homology coordinate, so in characteristic two its fifth
coordinate is the sum of the other four — which is exactly the fifth entry of
the normalized heart representative, whose sixth entry is zero. So the
five-term dot product of two kernel slices is the six-term dot product of the
corresponding heart representatives, which is the coefficient form of the
heart. That identity is checked exhaustively over the two slices with their
augmentation conditions, and the tensor structure then matches term by term,
the reduced elliptic pairing supplying exactly the two cross terms of the
standard form.

Carrying the two-primary part of the lattice model of the isogeny kernel across
that isometry gives a subspace of the standard coordinates. It is exactly its
own orthogonal complement for the rank-eight bilinear form, hence maximal
isotropic — with no dimension count anywhere in the chain — and therefore, by
the classification already formalized, it belongs to the five-member
`P¹(F₄)` packet as soon as it is stable under the two diagonal generators.

`Applications/RelativeSixAxis.lean` carries the per-fibre version and
`RelativeSixAxisConclusion` gains the field
`twoPrimaryKernelStandardCoordinates`. One reviewer terminal was added,
`relativeSixAxis_twoPrimaryKernelStandardCoordinates`, registered on
`lem:relative-six-axis`; it reports `propext, Classical.choice, Quot.sound`.

## What this changes about the supplied inputs

Before these three passes the route to the packet ran through
`RelativeSixAxisKernelCoordinateInput`, which supplies both diagonal stability
and maximal isotropy of a coordinate subspace attached to the geometric kernel
by a supplied coordinate equivalence. For the lattice model of the kernel,
maximal isotropy is now proved rather than supplied, and stability is the only
remaining input. That supplied structure is unchanged and still needed for the
geometric kernel, because its coordinate equivalence is arbitrary and is tied
to no form; the lattice statement does not reach it.

Stability itself stands for the `A₅`-equivariance of the kernel, which this
package does not represent at all — no group action on either discriminant
model is constructed. It is therefore the natural single frontier of the
two-primary half of the lemma.

## Validation

From `papers/cubic-stabilization-m1/`, `make lint formal-static` and
`make formal-audit` against the captured audit log of the guarded build of
`Verification.AxiomAudit` both pass, over 149 sources and 299 reviewer
terminals, with 62 claims, 48 machinery rows, and unchanged coverage counts
(5 absent, 27 fragmentary, 29 conditional, 1 complete). The claim-map row for
`lem:relative-six-axis` was extended across objects, conclusion, and cautions,
and its terminal digest refreshed after that review. The manuscript PDF was not
rebuilt: the only manuscript change is the `\lean` list of that lemma, whose
macros are typographically empty.

## Mystery ledger

- **Settled: why the isometry is a one-line computation.** Both normalizations
  choose the same representative. The five-axis chart records the first four
  heart coordinates and their sum; the six-point heart representative records
  the same five entries and a zero. Nothing else had to match.
- **Settled: the whole two-primary chain avoids cardinality.** The package
  contains a maximal-isotropy criterion by half dimension, and it is not used
  anywhere here: self-duality comes from the pullback identity through the
  adjugate, transports to the primary part by Bezout, and transports again
  along an isometry.
- **Open: stability, that is `A₅`-equivariance.** Now the single remaining
  input for packet membership of the lattice two-primary kernel. It needs an
  integral action on the source lattice commuting with the polarization and an
  equivariance hypothesis on the comparison matrix; the homology realization
  has neither.
- **Open: the three-primary analogue.** The same route should work verbatim at
  three — cofactor identity, primary part as the kernel of the reduced
  polarization, pairing as minus the dot product tensored with the reduced
  elliptic pairing — and the three-primary packet machinery already exists. It
  is the obvious next pass.
- **Open, unchanged: the orders of the primary parts, the commutator pairing,
  and the dictionary proposition.** The orders would follow from packet
  membership, since every packet member is four-dimensional, so they are now
  gated on stability rather than on new cardinality machinery.
