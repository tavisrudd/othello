# C910 — the relative six-axis source over its integral homology realization

**Lane:** `cubic-threefolds` · **Task:** C910 · **Date:** 2026-08-19

## What this pass did

The relative six-axis row of the epilogue companion carried an opaque
organizational signature: `ellipticScheme`, `sourceIsAugmentationTensor`,
`relativeMapIsIsogeny`, `relativeMapFiniteFlat`,
`coefficientFormIsSixAxisAugmentationForm`, `polarizationPullbackIdentity`,
`fiveAxisGramIdentification`, and the symplectic identification
`D₂ ≃ H₂ ⊗ E[2]` were fields of type `Prop` — propositions carried by the
structure, not proofs — so the packaged theorem asserted only that such an input
exists. This pass replaced the elliptic-scheme and isogeny half of that
signature by an explicit integral first-homology layer, and derived from it the
statements those placeholders stood for.

New module
`papers/cubic-stabilization-epilogue/lean/TavisRuddFiniteGeom/Papers/CubicStabilizationEpilogue/GraphLattices/SixAxisSourcePolarization.lean`
builds the polarized source lattice and proves:

- `ellipticWeilPairing` — the standard alternating unimodular pairing on the
  rank-two integral first homology of an elliptic curve — is alternating with
  determinant one;
- `sixAxisSourcePolarization R = sixAxisGram R ⊗ₖ ellipticWeilPairing R`, indexed
  by an axis together with an elliptic homology coordinate, has transpose equal
  to its negative, vanishing diagonal, and integral determinant `6⁸`. The
  determinant runs through `Matrix.det_kronecker` and `(det (6I₅-J₅))² = 6⁸`,
  which itself comes from the committed Smith reduction together with the fact
  that both Smith factors have determinant a square root of one — so no
  five-by-five determinant is ever expanded;
- `sixAxisPolarizationPullback_det_sq`, `_natAbs_det`, `_det_ne_zero`, and
  `_mulVec_injective`: if a comparison matrix pulls a unimodular form back to
  this polarization, its determinant has absolute value `6⁴` and it is injective
  on the integral source lattice. This is the lemma's degree and finiteness
  claim, and it is a determinant identity — the geometry enters nowhere;
- modulo two the polarization reduces to the coordinate-sum map on the elliptic
  homology coordinates, and modulo three to its negative, so
  `sixAxisSourceTwoPrimaryDiscriminantCoordinates` and
  `sixAxisSourceThreePrimaryDiscriminantCoordinates` identify the kernels of the
  two- and three-torsion reductions with four copies of the rank-two module over
  the respective prime field. The three-primary case needed a coordinate-sum-zero
  submodule equivalence valid over any commutative ring, since the existing
  two-primary development uses the characteristic-two identity `x + x = 0`;
- on a six-coordinate lift with vanishing coordinate sum the form
  `6 Σ xᵢyᵢ - (Σx)(Σy)` is six times the dot product, so its half reduces modulo
  two to the dot product and its third reduces modulo three to the negative of
  the dot product, and against such a lift the form is divisible by six — which
  is exactly why neither normalization depends on the chosen lift. This is the
  manuscript's displayed normalized pairing, previously prose only.

In `Applications/RelativeSixAxis.lean` the geometric input now carries a
`RelativeSixAxisHomologyRealization` per fibre — a Jacobian polarization matrix
of determinant one, a comparison matrix, and the pullback identity as an
equation of integral matrices — together with torsion coordinates on the two
discriminants and on the `H₂ ⊗ E[2]` and `H₃ ⊗ E[3]` fibres. The five listed
`Prop` placeholders are gone. The packaged conclusion now records the
determinant `6⁸`, the fibrewise degree `6⁴` with injectivity, and both primary
discriminant identifications, the latter as constructed equivalences that agree
in the supplied coordinates with the computed kernel equivalences.

Three reviewer terminals were added:
`relativeSixAxis_polarizationPullback_degree`,
`relativeSixAxis_primaryDiscriminantCoordinates`, and
`relativeSixAxis_normalizedPrimaryPairings`. All three report
`propext, Classical.choice, Quot.sound`.

## What remains supplied

The row stays a fragment, and deliberately. What the manuscript asserts about
schemes is now concentrated in one dictionary proposition,
`homologyRealizesRelativeGeometry`: that the displayed integral matrices are the
ones induced on first homology by an elliptic scheme, the tensor-product source,
the relative morphism, and the principal polarization of the intermediate
Jacobian. Mathlib has no abelian schemes, so that assertion cannot be given
semantics here; what changed is that it is now a statement about named matrices
rather than an assertion of the whole lemma.

Still supplied besides it: `A₅`-equivariance and the natural `S₆` actions, the
identification of the named kernel type with the two-primary kernel of the
relative map, and `A₅`-stability and maximal isotropy of that kernel. Also not
represented: the Weil pairing of an actual elliptic curve, the geometric
commutator pairing, and hence compatibility of the constructed discriminant
identifications with it — what is proved about pairings concerns the explicit
coefficient and tensor forms already in the package.

## Validation

All gates green, and the manuscript PDF was not rebuilt: the only manuscript
change is the `\lean` list of `lem:relative-six-axis`, whose macros are
typographically empty.

From `papers/cubic-stabilization-epilogue/`:

```text
make lint formal-static
lean/scripts/lean-build-queue.py build CubicStabilizationEpilogue \
  TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.Verification.AxiomAudit \
  --lean-root <repository>/papers/cubic-stabilization-epilogue/lean --cores 20-23
make formal-audit AXIOM_LOG=<run directory>/logs/<audit target>.quiet/<run>/<invocation>/stdout.log
```

The source-only and axiom-log checks both pass over 142 sources and 293 reviewer
terminals, with 62 claims, 47 machinery rows, and unchanged coverage counts
(5 absent, 27 fragmentary, 29 conditional, 1 complete). The claim-map row for
`lem:relative-six-axis` was rewritten — objects, hypotheses, conclusion, and
cautions — and its terminal digest refreshed after that review; the statement
digest is unchanged, since annotations are excluded from it.

## Mystery ledger

- **Settled: why the manuscript's `H_p` is the same shape at two and three.**
  Both reductions of `6I₅-J₅` are rank one over the axis index — the matrix is
  `-J₅` modulo two and modulo three alike, because six vanishes at both primes —
  so each primary kernel is exactly the coordinate-sum-zero submodule, four
  copies of the elliptic torsion. The two primes needed different Lean proofs
  only because the existing two-primary development leans on `x + x = 0`.
- **Settled: the geometric content of the degree claim.** None. Given the
  pullback identity against a unimodular form, `|det f| = 6⁴` is forced by
  multiplicativity of the determinant, and the sign of `det f` is never
  determined — it is orientation data the lemma does not use.
- **Open: maximal isotropy of the isogeny kernel.** The manuscript gets it by
  counting: `|ker λ_A| = 6⁸`, `|ker f| = 6⁴`, and functoriality of the
  commutator pairing makes `ker f` isotropic, so it is maximal isotropic. Both
  orders are now available as determinants, but the argument needs the
  discriminant group `Λ^#/Λ` of an integral symplectic lattice and the index of
  a finite-index sublattice, neither of which the package has. Evidence gap: no
  dual-lattice quotient anywhere in the companion. Owner: the successor step
  named below.
- **Open: symplectic compatibility of the constructed identifications.** The
  identifications `D_p ≃ H_p ⊗ E[p]` are proved as linear equivalences. That
  they carry the discriminant pairing to the tensor product of the normalized
  coefficient form with the Weil pairing is not stated, because the discriminant
  pairing on the kernel — half or a third of `xᵀ λ_A y` on integral lifts — is
  not yet defined in the package. The two ingredients now exist separately: the
  normalized pairing identities proved here, and the alternating nondegenerate
  tensor form already formalized.
- **Open, unchanged: the dictionary proposition.** No route to giving
  `homologyRealizesRelativeGeometry` semantics exists short of abelian schemes in
  Mathlib. It is the honest floor of this row rather than a gap to be closed by
  this lane.

## Next

Define the discriminant group of the integral source polarization as
`Λ^#/Λ` with its `ℚ/ℤ`-valued pairing, prove it has order `6⁸` and that the
preimage lattice of a comparison matrix satisfying the pullback identity is
isotropic of index `6⁴` in it, and conclude maximal isotropy. That removes
`kernelMaximalIsotropic` from the supplied fields and, with the normalized
pairing identities already proved, puts the symplectic compatibility of both
primary identifications within reach in the same layer.
