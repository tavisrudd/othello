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

## Second-order extra juice: the Veronese circuit

Let \(G=[g_1\ \cdots\ g_{2m}]\) be an \(m\)-by-\(2m\) generator matrix.
The intrinsic multiplier condition has the matrix form
\[
 G\operatorname{diag}(s)G^{\mathsf T}
   =\sum_{i=1}^{2m}s_i g_i g_i^{\mathsf T}=0.
\]
Thus \(\mathcal D(C,C^\perp)\) is the relation space among the quadratic
Veronese images \(\nu_2(g_i)=g_i g_i^{\mathsf T}\).  The formal
zero-or-one-dimensionality and full-support theorems have a sharp geometric
translation: these \(2m\) Veronese points are either independent or form a
circuit, meaning that their unique projective dependence uses every point.
Diagonal isoduality is exactly the circuit case.

This gives three distinct length regimes.

- For \(m=2\), four Veronese points lie in the three-dimensional space of
  symmetric \(2\)-by-\(2\) matrices.  Dependence is forced, so every exact
  `[4,2,3]` MDS code is diagonally isodual.  Over odd prime fields its
  associated fixed-party encoder is therefore always on the full
  affine-special-linear branch.
- For \(m=3\), both dimensions are six.  The circuit condition is one
  determinant equation.  For a six-arc in the projective plane this is
  exactly the condition that the six points lie on a conic, recovering the
  paper's original phase boundary.
- For \(m\geq4\), \(2m<m(m+1)/2\), so Veronese independence is possible and
  diagonal isoduality is special.  The unconstrained determinantal model
  predicts codimension
  \[
    \frac{m(m+1)}2-2m+1=\frac{(m-1)(m-2)}2,
  \]
  but transversality of the MDS-arc family to that determinantal locus has
  not been proved.  The displayed codimension is therefore a route, not a
  theorem.

The same equation is the classical self-association equation for a
\(2m\)-point configuration in \(\mathbf P^{m-1}\): the unique multiplier is
the Gale self-association scaling.  This identifies the all-length logical
phase with self-association of the projective MDS arc and explains why the
six-party case is governed by conics.

The nullity dichotomy also makes phase detection a single rank test.  The
linear map
\[
  \mathbb F^{2m}\longrightarrow\operatorname{Sym}_m(\mathbb F),
  \qquad s\longmapsto\sum_i s_i g_i g_i^{\mathsf T},
\]
has rank exactly \(2m\) or \(2m-1\); the latter case is precisely diagonal
isoduality.  A full-rank minor certifies the first branch, while a nonzero
kernel vector certifies the second and is automatically an invertible
duality witness.  No separate support or code-equality check is needed.

Once a reference coordinate \(j\) is chosen, the projective multiplier also
produces canonical propagation ratios \(r_{ij}=s_i/s_j\).  They obey
\(r_{ij}r_{jk}=r_{ik}\), so fixed-party propagation has zero holonomy: all
of its relative scalings come from one global projective vector.  Any
remaining projective ambiguity must therefore enter through party-moving
symmetries or lift phases, not through the diagonal witness.

Finally, the multiplier line is a monomial covariant.  If a monomial map
\(M\) carries \(C\) to \(C'\), then its projective multiplier transforms as
\[
 [S]\longmapsto[M^{-\mathsf T}SM^{-1}].
\]
For a monomial automorphism this transformed multiplier must be a scalar
multiple of \(S\).  Hence the party-moving automorphism group lies in the
conformal stabilizer of the canonical multiplier line.  For pure coordinate
permutations, the entries of \(s\) must be permuted up to one common scalar.
This supplies a structural pre-filter for future party-extension
classifications without computing a factor set.

## Third-order extra juice: uniform matroids and stability

The circuit statement determines the complete matroid carried by the
Veronese columns.  In the nonisodual branch they represent
\(U_{2m,2m}\); in the isodual branch they represent
\(U_{2m-1,2m}\).  Indeed, any dependence on a proper subset would extend by
zeros to a nonzero multiplier without full support, contradicting the
formal theorem.  Consequently every \(2m-1\) Veronese columns are
independent in the isodual branch, and any deleted column is recovered
uniquely as a linear combination of all the others with no zero
coefficient.

This makes the canonical multiplier determinantal.  Choose coordinates on
the \((2m-1)\)-dimensional Veronese span and let \(A\) be the resulting
\((2m-1)\)-by-\(2m\) column matrix.  If
\(\Delta_i=\det A_{\widehat i}\) is the maximal minor obtained by deleting
column \(i\), then
\[
  s_i=\lambda(-1)^i\Delta_i
\]
for one \(\lambda\ne0\), and every \(\Delta_i\) is nonzero.  Changing the
chosen coordinates rescales the whole projective vector in the expected
way.  Thus the multiplier can be reconstructed from maximal minors without
solving a second linear system.

Over odd characteristic the relation is also the unique weighted identity
\[
  \sum_i s_i\,q(g_i)=0
\]
valid for every quadratic form \(q\).  Combining the cofactor formula with
the manuscript's hyperbolic discriminant condition
\(\prod_i s_i\in(-1)^m(\mathbb F^\times)^2\) gives the basis-independent
Plücker obstruction
\[
  \prod_{i=1}^{2m}\Delta_i\in(\mathbb F^\times)^2.
\]
The signs cancel because
\(\prod_i(-1)^i=(-1)^m\), and every change-of-basis or projective-column
rescaling contributes a square.  This square-class identity is a
paper-level corollary of the discriminant statement; it is not yet a Lean
theorem.

The conformal action on the multiplier line is more rigid than a generic
stabilizer condition.  Pure permutation automorphisms act through a
one-dimensional character \(\chi\):
\[
  P\cdot s=\chi(P)s.
\]
For an element with cycle lengths \(d_1,\ldots,d_r\), nonvanishing of every
entry forces \(\chi(P)^{d_j}=1\) for every \(j\).  Hence a fixed point, or
more generally coprime cycle lengths, forces \(\chi(P)=1\).  If a transitive
permutation subgroup has trivial character, then all \(s_i\) are equal and
\(C=C^\perp\).  These character and cycle constraints are a cheaper
pre-filter than constructing the party-extension factor set.

There is also a free qualitative stability consequence when this result is
combined with the all-length LU-to-LC theorem.  For fixed finite
\((q,m)\), there are finitely many normalized MDS--CSS code states, their
product-unitary orbits are compact, and distinct LC classes are distinct LU
orbits.  The minimum distance between inequivalent orbits is therefore
positive.  Thus some parameter-dependent approximate-rigidity threshold
exists automatically.  This argument supplies neither an effective value
nor a bound uniform in \(q\) or \(m\); C581's substantive target is exactly
that conditioning problem, not qualitative existence.

## Degrees of freedom

| Degree of freedom | Status |
|---|---|
| Choice of a code-to-dual diagonal multiplier | Locked to a zero-dimensional space or one projective point. |
| Scalar normalization of a nonzero witness | Exactly one \(\mathbb F^\times\)-torsor; the scalar between two witnesses is unique. |
| Coordinate propagation ratios \(s_i/s_j\) | Canonical and independent of the witness. |
| Diagonal automorphisms of the code | Only common scalar multiplication survives. |
| Choice of fixed-party linear phase after one nondiagonal block | None: the whole `SL₂` branch follows. |
| Matroid type of the \(2m\) Veronese columns | Exactly \(U_{2m,2m}\) or \(U_{2m-1,2m}\). |
| Pure-permutation action on the multiplier | A one-dimensional character constrained by every cycle length. |
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
| Why is the four-party phase never split-torus? | **Settled:** four quadratic Veronese images in dimension three must be dependent, and the MDS theorem makes the dependence a full-support circuit. | none |
| Why does the six-party phase reduce to a conic? | **Settled structurally:** the square Veronese evaluation matrix is singular exactly on the conic locus. | The matrix-presentation bridge is not yet encoded in Lean. |
| How rare is diagonal isoduality for \(m\geq4\)? | **Open quantitatively:** the ambient determinantal model predicts codimension \((m-1)(m-2)/2\). | Prove transversality, or determine the actual components, inside the MDS-arc moduli space before adopting the count. |
| Does the multiplier line constrain party symmetries before factor-set computation? | **Settled:** every monomial automorphism conformally stabilizes the line; pure permutations preserve its entries projectively. | Turning this into a generated group pre-filter is an optional implementation step. |
| Can a proper subset of the Veronese columns already be dependent? | **Settled negatively:** full support upgrades the two branches to the uniform matroids \(U_{2m,2m}\) and \(U_{2m-1,2m}\). | none |
| Is the multiplier recoverable without a fresh kernel solve? | **Settled:** its projective coordinates are the signed maximal deletion minors. | Encoding this matrix presentation in Lean remains the same optional API bridge. |
| Does exact LU-to-LC rigidity already imply approximate rigidity? | **Settled qualitatively at fixed \((q,m)\)** by finiteness and compactness. | C581 owns an effective, preferably uniform, conditioning bound. |
| Which multiplier characters can party groups realize? | **Constrained but not classified:** cycle lengths bound the character, and a fixed point kills it. | Combine the pre-filter with concrete party-group data if a uniform classification is pursued. |

No genuine mathematical mystery remains in the multiplier-space and witness
uniqueness results.  The open entries are exact formal-interface depth
boundaries.

## Manuscript adoption

The intrinsic result is adopted as
`prop:diagonal-multiplier-line`.  Section 3 proves full support,
bijectivity, one-dimensionality, the scalar self-multiplier theorem, the
code-to-dual nullity test, and projective witness uniqueness, then shortens
the proof of the diagonal-isodual transversal dichotomy by citing the
proposition.  `rem:veronese-phase-test` gives the generator-matrix equation,
the uniform-matroid circuit interpretation, the forced \(m=2\) isodual
branch, and the \(m=3\) conic determinant.  The introduction records the
single rank test.

The speculative \(m\ge4\) codimension, Plücker square-class refinement,
permutation-character filters, and qualitative stability observation remain
outside the manuscript theorem package.

## Validation

- Warning-free direct guarded elaboration of
  `RelativeConicArcs/AMELU/DiagonalIsoduality.lean`: passed.
- The final guarded build queue rebuilt `DiagonalIsoduality`,
  `AMELUAggregate`, and `AMELUAggregateAxioms`; the exact-target no-build
  checks and trace-only aggregate gate passed.
- Every audited declaration reports only `propext`, `Classical.choice`, and
  `Quot.sound`.
- `make -C papers/ame_lu check`: warning-free, 23 pages, 204,734 bytes;
  PDF SHA-256
  `8d618ebe7b4982fa64a14246343c59cd8239c176274947b648ed1827ebc04e1a`.
- The revised introduction and Section 3 pages 2, 8, and 9 were rendered and
  visually inspected.
- The release manifest verifies 37 public artifacts and 80 formal companion
  artifacts, with tree hashes
  `beb5f43430dece10ad18331678b82c60abf1f744c70a9b234bb4cc899faed612`
  and
  `285f596dd0c02f3d3d5b60a519458583eb9f2de82e2eb85e8c7e2d4d299c114a`.
- The entire new module passed the referee-prose and workflow-reference
  review; it contains no generated data, native evaluation, axioms, admitted
  declarations, or private workflow references.
- `git diff --check` passed on the task-owned paths.

**Vibe check:** the formal result has removed the apparent witness choices
rather than merely encoding them; the remaining conditional boundary is now
cleanly at the quantum action bridge, not in the MDS algebra.
