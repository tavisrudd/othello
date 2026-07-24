# Lean arc--MDS--AME dictionary bridges

## Result

The shared Lean foundation now contains the CSS stabilizer-label interface and
the three coherence bridges exposed by the post-foundation expert audit.

`RelativeConicArcs.AMELU.CSS` defines:

- `PauliLabel 𝔽 = (Fin 6 → 𝔽) × (Fin 6 → 𝔽)`;
- `cssLabelSpace C = C × FiniteGeom.dualCode C`;
- `pauliSupport` and `PauliSupportedOn`; and
- `cssSupportedLabelSpace C S`, the formal `L_C(S)`.

`RelativeConicArcs.AMELU.Dictionary` proves:

| Mathematical bridge | Terminal declaration |
|---|---|
| determinant six-arc → exact `[6,3,4]` kernel | `RelativeConicArcs.AMELU.isMDSCode634_arcKernel` |
| exact `[6,3,4]` code → AME equal-phase state | `RelativeConicArcs.AMELU.isAME_equalPhaseState` |
| six-arc → AME kernel state | `RelativeConicArcs.AMELU.isAME_equalPhaseState_arcKernel` |
| convention dictionary → AME selected state | `RelativeConicArcs.AMELU.ConventionDictionary.state_isAME` |
| projective column equivalence → monomial kernel equivalence | `RelativeConicArcs.AMELU.projectivelyEquivalent_arcKernel_monomiallyEquivalent` |
| monomial code equivalence → LC state equivalence | `RelativeConicArcs.AMELU.monomiallyEquivalent_equalPhaseState_locallyCliffordEquivalent` |
| projective equivalence → LC kernel-state equivalence | `RelativeConicArcs.AMELU.projectivelyEquivalent_equalPhaseState_locallyCliffordEquivalent` |

## Proof mechanisms

The determinant condition gives linear independence of every selected triple.
The existing transparent rank-three parity-check package then supplies
dimension three, distance at least four, and a word of weight four.  A proved
matrix-kernel/linear-combination bridge identifies that package with the shared
`arcKernel`.

For AME, projection of the code onto any three parties is injective by distance
four and bijective by equal dimension.  Every smaller projection is
surjective.  Its fibers are translates of the projection kernel and therefore
have exactly `|𝔽|^(3-|S|)` elements.  The marginal sum consequently has zero
off-diagonal entries and diagonal entries `|𝔽|^(-|S|)`; a separate finite
cardinality calculation proves normalization.

For projective coherence, the proof transports the parity-check sum through
the displayed linear equivalence, reindexes it by the party permutation, and
tracks the inverse column multiplier explicitly.  Multiplication by a nonzero
field element is then realized as a computational-basis permutation matrix.
Lean proves that this matrix is unitary and conjugates
`W(a,b)=X(a)Z(b)` to `W(ra,r⁻¹b)`.  The tensor product of these matrices
implements the monomial state equivalence with the exact party-action
direction fixed by the shared interface.

## Verification and trust

The final definitions and theorem module passed direct guarded elaboration with
Lean `v4.32.0-rc1`.  The import-only terminal
`RelativeConicArcs.Gates.AMELUDictionary` passed the measured `single` profile
in 18.43 seconds with 1,881,492 KiB peak RSS, followed by the runner's exact
trace-only aggregate gate.

`RelativeConicArcs.Gates.AMELUDictionaryAxioms` records the actual
`#print axioms` audit.  Every manuscript-facing terminal reports exactly the
standard Mathlib axioms `propext`, `Classical.choice`, and `Quot.sound`.
There is no `sorry`, native evaluation, generated source, external
certificate, or project-specific axiom.

## Scope boundary

The CSS label and support subspaces are now fixed, but this task does not yet
prove that every label in `C × Cᵖ` acts as a stabilizer of the amplitude
function, that this subspace is Lagrangian, or that support `|C|=|𝔽|³` is
minimal among AME states.  The formal AME and equivalence bridges themselves
are complete.  The remaining stabilizer-action/Lagrangian statements must be
closed before the full manuscript proposition `thm:dictionary` is marked
formally adopted.

## Mystery ledger

- **Permutation and multiplier directions:** settled.  The projective,
  monomial, state, and Clifford actions compose in one proved direction.
- **Marginal normalization:** settled without a computational oracle.  Fiber
  cardinality and the square-root normalization are both proved symbolically.
- **Character dependence:** the multiplier-Clifford theorem holds for every
  nontrivial additive-character convention, hence in particular for the exact
  trace convention.  No hidden trace-specific hypothesis remains.
- **Full stabilizer proposition:** open only at the stabilizer-action,
  Lagrangian, and minimum-support clauses described above.  This is a precise
  statement-coverage gap for the aggregate reconciliation gate, not an
  ambiguity in the definitions or in the theorems proved here.
