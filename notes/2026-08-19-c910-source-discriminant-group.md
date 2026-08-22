# C910 — the discriminant group of the six-axis source polarization

**Lane:** `cubic-threefolds` · **Task:** C910 · **Date:** 2026-08-19

## What this pass did

`lem:relative-six-axis` claims that the `p`-primary part of `ker f` is a
relative maximal isotropic subgroup of the primary discriminant. The
manuscript gets it by counting: `|ker λ_A| = 6⁸`, `|ker f| = deg f = 6⁴`, and
functoriality of the commutator pairing makes `ker f` isotropic, so it has
square-root order and is maximal isotropic. The previous pass made both orders
available as determinants but had no discriminant group and no pairing on it,
so maximal isotropy stayed a supplied proposition.

This pass builds the missing layer and proves the statement, at lattice level,
without counting.

New module
`papers/cubic-stabilization-m1/lean/TavisRuddFiniteGeom/Papers/CubicStabilizationM1/GraphLattices/IntegralDiscriminantGroup.lean`
develops the general theory for an integral square matrix `F` with nonzero
determinant on `Λ = ℤ^ι`:

- `discriminantGroup` is the dual quotient `Λ^#/Λ`, presented as the cokernel
  of `F` on the standard lattice. The presentation is the isomorphism
  `v ↦ F v` from the dual lattice onto `ℤ^ι`, which carries `Λ` onto `F ℤ^ι`;
  the module header states it and the definition records it.
- `discriminantValue` is `(1/det F)·xᵀ adj(F) y` on integral representatives —
  the pairing `E(v,w)` of the corresponding dual vectors — and
  `discriminantPairing` is the `ℤ`-bilinear map it induces into
  `ℚ/ℤ`. Well-definedness is `adj(F) F = det F` in the second variable and, for
  an alternating `F`, `Fᵀ adj(F) = -det F` in the first. It is nondegenerate:
  a class pairing to zero against every class is zero.
- `natCard_integralCokernel`: the discriminant group is finite of order
  `|det F|`, through Mathlib's `Submodule.natAbs_det_equiv`.
- Given an integral `C` and a unimodular `T` with `Cᵀ T C = F`: `C` is
  injective on the lattice, the cokernel of `C` embeds in the discriminant
  group through the matrix `Cᵀ T`, and the image
  (`comparisonKernelSubgroup`) has order `|det C|`, is isotropic, **equals its
  own orthogonal complement**, and is therefore maximal among isotropic
  subgroups. Its order squared is the order of the discriminant group.

The maximal-isotropy proof is matrix algebra, not counting. Isotropy is the
adjugate sandwich `C adj(F) Cᵀ = (det C)² adj(T)`, which makes the discriminant
value of two kernel classes equal to `xᵀ Θᵀ y`, an integer. The reverse
inclusion multiplies the orthogonality condition by `Cᵀ T adj(Tᵀ)` and uses
`F adj(F)ᵀ = -det F` to exhibit the representative in the image of `Cᵀ T`. So
the manuscript's `|ker f|² = |ker λ_A|` is a consequence here rather than a
step, and the orders are recorded separately as determinant facts.

`GraphLattices/SixAxisDiscriminantGroup.lean` specializes: the discriminant
group of `sixAxisSourcePolarization ℤ` has order `6⁸`, its pairing is
nondegenerate, and for any comparison matrix satisfying the pullback identity
against a unimodular form the kernel subgroup has order `6⁴`, equals its own
orthogonal complement, and is maximal isotropic.

`Applications/RelativeSixAxis.lean` carries the per-fibre versions —
`relativeSixAxisKernelSubgroup`, its order, and its maximal isotropy — and
`RelativeSixAxisConclusion` gains a field recording all three, discharged from
the homology realization alone.

Two reviewer terminals were added:
`relativeSixAxis_discriminantGroup_maximalIsotropicKernel`, registered on
`lem:relative-six-axis`, and
`sixAxisSourceDiscriminantPairing_values_and_nondegeneracy`, registered as
machinery because the manuscript states no property of the lattice pairing
separately — it argues with the commutator pairing of the abelian scheme. Both
report `propext, Classical.choice, Quot.sound`.

## What remains supplied

The row stays a fragment. Three things are unchanged.

The geometry is still supplied through `homologyRealizesRelativeGeometry`: that
the displayed matrices are the ones induced on first homology. Nothing here
constructs an abelian scheme.

The commutator pairing of a polarized abelian scheme is still absent, so the
identification of the lattice discriminant pairing with `e_{λ_A}` is supplied,
as is the identification of the lattice kernel with `ker f`.

The primary decomposition is not represented. Maximal isotropy is proved for
the whole kernel inside the whole discriminant group; the manuscript states it
for each `𝒦_p` inside `𝒟_p`. The supplied field `kernelMaximalIsotropic`
therefore stays, now carrying only the primary refinement rather than the whole
assertion. Closing it needs `D = D₂ ⊕ D₃`, which is within reach: the group is
killed by six, because the committed Smith reduction gives an integral matrix
`M` with `(6I₅-J₅) M = 6`, and distinct primary parts are automatically
orthogonal because a value killed by two and by three vanishes in `ℚ/ℤ`. Then
`𝒦_p^⊥ ∩ D_p = 𝒦 ∩ D_p = 𝒦_p` transports the statement.

## Validation

All gates green; the manuscript PDF was not rebuilt, since the only manuscript
change is the `\lean` list of `lem:relative-six-axis`, whose macros are
typographically empty.

From `papers/cubic-stabilization-m1/`:

```text
make lint formal-static
lean/scripts/lean-build-queue.py build CubicStabilizationM1 \
  TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Verification.AxiomAudit \
  --lean-root <repository>/papers/cubic-stabilization-m1/lean --cores 20-23
make formal-audit AXIOM_LOG=<run directory>/logs/<audit target>.quiet/<run>/<invocation>/stdout.log
```

Source-only and axiom-log checks both pass over 144 sources and 295 reviewer
terminals, with 62 claims, 48 machinery rows, and unchanged coverage counts
(5 absent, 27 fragmentary, 29 conditional, 1 complete). The claim-map row for
`lem:relative-six-axis` was rewritten across objects, hypotheses, conclusion,
and cautions, and its terminal digest refreshed after that review; the statement
digest is unchanged, since annotations are excluded from it.

## Mystery ledger

- **Settled: what the counting argument is really using.** Nothing about
  cardinality. Given `Cᵀ T C = F` with `T` unimodular, the preimage lattice
  `C⁻¹ℤ^ι` is unimodular for `E`, so it is its own dual and its class group is
  its own orthogonal complement. The orders `6⁸` and `6⁴` are true and are
  recorded, but the maximal-isotropy statement does not pass through them, and
  the Lean proof does not.
- **Settled: why the two orders are forced to be square and square-root.**
  `det F = (det C)²·det T`, so with `T` unimodular the discriminant order is a
  perfect square and the kernel order is its square root by construction. There
  is no freedom here to check against.
- **Open: the primary decomposition.** Stated above with its route; nothing
  blocks it except work. Owner: the successor step named below.
- **Open, unchanged: the commutator pairing.** The lattice pairing built here
  is the discriminant pairing of an integral symplectic lattice. That it is the
  commutator pairing of the source polarization is exactly the assertion
  Mathlib's absence of abelian schemes puts out of reach, and it is the last
  supplied link in the isotropy half of the row.
- **Open, unchanged: the dictionary proposition.** As before, no route to
  giving `homologyRealizesRelativeGeometry` semantics exists in this package.

## Next

Split the discriminant group into its two- and three-primary parts, prove that
distinct primary parts are orthogonal for the discriminant pairing, and
transport maximal isotropy to each part. That removes `kernelMaximalIsotropic`
from the supplied fields and puts the symplectic compatibility of both primary
identifications — the remaining half of the same manuscript sentence — in the
same layer as the normalized pairing identities already proved.
