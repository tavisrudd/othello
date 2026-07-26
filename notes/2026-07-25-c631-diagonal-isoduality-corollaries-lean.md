# C631: diagonal-isoduality corollaries in Lean

**Lane:** `ame-lu`

**Status:** complete

## Result

`RelativeConicArcs.AMELU.DiagonalIsoduality` formalizes the linear space
\[
 \mathcal D(C,D)=
 \{s\in\mathbb F^{2m}:\operatorname{diag}(s)C\subseteq D\}
\]
for exact `[2m,m,m+1]` MDS codes.  Its main unconditional results are:

- every nonzero member of \(\mathcal D(C,D)\) has full coordinate support;
- its diagonal map \(C\to D\) is bijective;
- \(\dim\mathcal D(C,D)\leq1\);
- the diagonal self-multiplier space \(\mathcal D(C,C)\) is exactly the
  span of the all-ones vector, so every diagonal code automorphism is scalar;
- \(\dim\mathcal D(C,C^\perp)\) is zero or one, and diagonal isoduality is
  equivalent to the nullity-one case;
- any nonzero code-to-dual multiplier reconstructs a
  `GenericDiagonalDuality`;
- two diagonal-duality witnesses are related by a unique nonzero scalar, so
  all coordinate ratios are canonical;
- the witness makes the code totally isotropic for its associated diagonal
  bilinear form; and
- one realized nondiagonal input block forces the full affine
  special-linear carrier through the existing action interface.

The multiplier-space theorem is field-generic.  The paper's odd-prime
restriction belongs to the one-qudit Clifford interpretation, not to this
coding-theoretic lemma.

## Proof mechanism

For a nonzero multiplier \(s\), choose a coordinate \(k\) with \(s_k\ne0\).
To test any coordinate \(i\), extend \(\{i,k\}\) to an \((m+1)\)-set \(S\).
The exact MDS shortening theorem supplies a codeword supported precisely on
\(S\).  Its diagonal image is a nonzero word of the target MDS code, also
supported on \(S\).  Distance \(m+1\) forces every coordinate of this image
to be nonzero, hence \(s_i\ne0\).

Full support makes the diagonal map injective.  Equal code dimensions make it
bijective.  If two independent multipliers existed, a linear combination
could be chosen to vanish at one coordinate, contradicting full support.
Conversely, any nonzero code-to-dual multiplier is bijective and its
coordinatewise inverse supplies both directions required by
`GenericDiagonalDuality`.

## Formal declarations

The public terminal declarations include:

- `diagonalMultiplier_ne_zero_at`;
- `diagonalMultiplierLinearMap_bijective`;
- `diagonalMultiplierSpace_finrank_le_one`;
- `diagonalMultiplierSpace_self_eq_span_one`;
- `diagonalDualityMultiplierSpace_finrank_eq_zero_or_one`;
- `genericDiagonalDualityOfMultiplier`;
- `isDiagonallyIsodual_iff_finrank_eq_one`;
- `not_isDiagonallyIsodual_iff_finrank_eq_zero`;
- `diagonalDualityNullity_fixedPartyProjectiveTransversal_dichotomy`;
- `offDiagonalBlock_fixedPartyProjectiveTransversal_eq_affineSpecialLinear`;
- `diagonalDuality_existsUnique_unit_smul_eq`; and
- `diagonalDuality_multiplier_ratio_eq`.

`RelativeConicArcs.Gates.AMELUAggregate` imports the module, and
`AMELUAggregateAxioms` audits its paper-facing declarations.

## Tao and extra-juice closeout

The decisive reframing was to formalize the whole multiplier space rather
than a chosen unit-valued witness.  This makes the nullity test primary and
turns witness reconstruction and canonical ratios into consequences.

The second-order check asked whether a fixed MDS code could retain hidden
diagonal automorphism freedom.  It cannot:
`diagonalMultiplierSpace_self_eq_span_one` proves that every diagonal
self-multiplier is scalar.  The remaining scalar relating two duality
witnesses is unique, so the witness set, when nonempty, has exactly the
expected \(\mathbb F^\times\)-torsor freedom.

The one-block bootstrap has also been isolated.  Once the existing action
interface identifies a realized nondiagonal block with diagonal isoduality,
Lean immediately gives the full affine special-linear carrier; there is no
intermediate fixed-party phase.

## Degrees of freedom

| Degree of freedom | Status |
|---|---|
| Choice of a code-to-dual diagonal multiplier | Locked to a zero-dimensional space or one projective point. |
| Scalar normalization of a nonzero witness | Exactly one \(\mathbb F^\times\)-torsor; the scalar between two witnesses is unique. |
| Coordinate propagation ratios \(s_i/s_j\) | Canonical and independent of the witness. |
| Diagonal automorphisms of the code | Only common scalar multiplication survives. |
| Choice of fixed-party linear phase after one nondiagonal block | None: the whole `SL₂` branch follows. |
| Phases of unitary Clifford lifts | Not controlled by the multiplier space; owned by the separate Weil/Heisenberg scalar-extension analysis. |
| Party permutations | Not controlled by fixed-coordinate diagonal isoduality; owned by the realized party-permutation extension. |

## Mystery ledger

| Feature | Closeout status | Exact remaining gap or owner |
|---|---|---|
| Can the multiplier nullity exceed one? | **Settled negatively** for every exact `[2m,m,m+1]` MDS pair. | none |
| Can a nonzero multiplier be singular? | **Settled negatively** by shortening and distance. | none |
| Is a nonzero code-to-dual multiplier merely an inclusion? | **Settled negatively:** its restricted diagonal map is bijective and reconstructs a duality witness. | none |
| Can diagonal code automorphisms change propagation ratios? | **Settled negatively:** the self-multiplier space is the scalar line. | none |
| Is the scalar relating two witnesses itself ambiguous? | **Settled negatively:** it is unique. | none |
| Does the theorem depend on a finite or prime base field? | **Settled boundary:** the multiplier proofs use the exact MDS hypotheses and coordinate finiteness; the odd-prime restriction enters only at the Clifford-action layer. | none |
| Is the report's matrix test \(G\operatorname{diag}(s)G^{\mathsf T}=0\) formalized as a kernel computation? | **Open only as an API bridge.** | A generator-matrix presentation of the existing submodule-valued multiplier space would be required; the intrinsic nullity theorem does not depend on it. |
| Is the hyperbolic determinant square-class corollary formalized? | **Partially:** Lean proves total isotropy for the diagonal form. | An adapted-basis determinant theorem would be needed to derive \(\det S\in(-1)^m(\mathbb F^\times)^2\); no such result is claimed by the formal artifact. |
| Are the five action-level carrier inputs unconditional? | **No:** the coding multiplier lemma is now unconditional, but special-linearity, propagation, the block-action bridge, and the complete translation fiber remain fields of `DiagonalIsodualityTransversalInputs`. | The manuscript proof remains the authority for those action-level steps. |

No genuine mathematical mystery remains in the multiplier-space and witness
uniqueness results.  The open entries are exact formal-interface depth
boundaries.

## Validation

- Warning-free direct guarded elaboration of
  `RelativeConicArcs/AMELU/DiagonalIsoduality.lean`: passed.
- The final guarded build queue rebuilt `DiagonalIsoduality`,
  `AMELUAggregate`, and `AMELUAggregateAxioms`; the exact-target no-build
  checks and trace-only aggregate gate passed.
- Every audited declaration reports only `propext`, `Classical.choice`, and
  `Quot.sound`.
- `make -C papers/ame_lu check`: warning-free, 21 pages, 195,549 bytes;
  PDF SHA-256
  `7a81b9703f24a36516f82f12af088f67e0787daa43e681b9228e6b8fa7fe344c`.
- The revised verification-boundary page was rendered and visually inspected.
- The release manifest verifies 35 public artifacts and 78 formal companion
  artifacts, with tree hashes
  `35f4dac109b353fef65e42fcd18b4d2aef0b5cfecbfa983df1350c453ee1b208`
  and
  `91a8bb7870059f59e58ae403d073512f7544d034e1291a412f85cb10c6ba089d`.
- The entire new module passed the referee-prose and workflow-reference
  review; it contains no generated data, native evaluation, axioms, admitted
  declarations, or private workflow references.
- `git diff --check` passed on the task-owned paths.

**Vibe check:** the formal result has removed the apparent witness choices
rather than merely encoding them; the remaining conditional boundary is now
cleanly at the quantum action bridge, not in the MDS algebra.
