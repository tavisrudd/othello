# C664 Paper III symbolic Lean mechanisms

**Lane:** `clebsch`

**Date:** 2026-07-26

## Result

The two required symbolic mechanisms are implemented in:

- `RelativeConicArcs.InvolutiveOddUnit`;
- `RelativeConicArcs.KneserPairEigenspace`.

The implementation is human-mechanism-first.  It contains no generated data,
certificate array, `native_decide`, project-specific axiom, or admitted
declaration.

The import-only axiom gate is
`RelativeConicArcs.Gates.ClebschOrientationMechanisms`.  Its shared-tree build
and exact-current confirmation remain blocked by the foreign build owner for
`RelativeConicArcs.Gates.ArcsCompleteOutsideConic`; the two leaves elaborate
individually through `lean/scripts/guarded-lean`.

## Involutive odd-unit mechanism

`RelativeConicArcs.InvolutiveOddUnit.map_evenPart`,
`map_oddPart`, and `evenPart_add_oddPart` prove the two averaging projections
and their decomposition.  `invariant_eq_zero_of_antiInvariant` proves that
their intersection is zero.

`oddMulEquiv` proves that multiplication by an anti-invariant unit identifies
the invariant and anti-invariant parts.
`existsUnique_invariant_add_mul_invariant` then gives the unique expression
\(a+cb\) with \(a,b\) invariant whenever \(c^2\) is a unit.
`localized_existsUnique_invariant_add_mul_invariant` applies the same theorem
after localization away from \(c^2\), assuming the localized involution and
its compatibility with the algebra map.

This is the exact algebraic mechanism behind the generic orientation-forgetting
clause: localization makes the odd generator invertible, after which the
two summands are forced.  It does not formalize the invariant-ring
classification or identify the geometric incidence cover.

## Kneser pair-sum mechanism

`RelativeConicArcs.KneserPairEigenspace.Pair` is the subtype of two-element
subsets of `Fin n`.  The adjacency operator is the finite sum over disjoint
pairs, with no enumerated matrix.

The proof counts:

- \(n-1\) pairs through one vertex;
- one pair through two distinct vertices;
- \(\binom{n-2}{2}\) pairs disjoint from a fixed pair; and
- the common endpoints of two pairs.

These counts yield the incidence identity and
`adjacency_pairSum_of_sum_eq_zero`:
\[
 A(Ey)=-(n-3)Ey\qquad\text{when}\qquad \sum_i y_i=0.
\]
`pairSum_injective_on_sumZero` proves injectivity on the standard module when
the scalar \(n-2\) is a unit.

For \(n=5\), `totalPairSum_eq_zero_of_petersenEigen` kills the total pair
weight using \(5T=0\).  Incidence sums divided by three then reconstruct the
unique sum-zero vertex weighting in
`existsUnique_pairSum_of_petersenEigen`.
`standardEquivPetersenNegTwo` packages this as a linear equivalence with the
full Petersen \((-2)\)-eigenspace, and
`finrank_petersenNegTwoEigenspace` proves that eigenspace has dimension four.
The characteristic-three and characteristic-five hypotheses remain separate:
three is used for reconstruction, while five kills the total pair sum.

## Paper correspondence and exclusions

The odd-unit terminals support only the localized algebraic splitting used to
explain why an invertible odd observable recovers orientation.  The Kneser
terminals support only the pair-module statement that the Clebsch four-space
is the full Petersen \((-2)\)-eigenspace.

They do not support Hitchin's incidence variety or branch theorem, the
\(5J_0\) square class, the \(A_5\)-invariant-ring classification, the
spinor or \(T_{11}\) identifications, the Mathieu carriers, spherical
integration, Wigner-symbol identities, the Gaunt--Steinhardt scalar, or any
materials claim.  Paper III's release gate remains independent of Lean until
a separate statement-correspondence decision.

The optional golden-exchanger leaf was omitted.  The two required modules
already expose the reusable mechanisms, while adding projective and reflection
interfaces would enlarge the formal surface without strengthening the
acceptance crown.

## Validation

- `lean/scripts/guarded-lean RelativeConicArcs/InvolutiveOddUnit.lean`:
  green, warning-free;
- `lean/scripts/guarded-lean RelativeConicArcs/KneserPairEigenspace.lean`:
  green, warning-free;
- import-only gate and exact-target freshness: waiting for the foreign
  shared-tree build owner to release the build lock.

## Mystery ledger

- **Settled:** the Petersen eigenvalue is the \(n=5\) value of
  \(-(n-3)\), proved without a matrix.
- **Settled:** characteristic three controls incidence reconstruction and
  characteristic five controls total-weight vanishing; the proof keeps the
  two exclusions independent.
- **Settled:** injectivity from the unit \(n-2\) is correctly a theorem on the
  sum-zero standard module.  Without that domain restriction, characteristic
  two supplies constant kernel vectors for odd \(n\).
- **Settled:** the localization corollary is short and retains an explicit
  equivariant localized involution as a hypothesis.
- **No new mathematical mystery remains inside the bounded formal surface.**
  The arithmetic-cover and harmonic-integral questions remain outside this
  task by design.

## Vibe check

Strong mathematical result with a clean trust boundary.  The formalization
replaces both coordinate-level claims by reusable structural theorems; only
shared-tree build ownership prevents administrative completion.
