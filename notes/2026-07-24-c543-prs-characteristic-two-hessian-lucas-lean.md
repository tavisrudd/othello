# C543 — characteristic-two Hessian and Lucas formal boundary

**Lane:** `reed-solomon` · **Date:** 2026-07-24 · **Status:** complete

## Result

`RelativeConicArcs.PRSCharacteristicTwoHessianLucas` supplies the characteristic-two modular
formal package used by the beyond-four projective Reed--Solomon manuscript.  It reuses
`RelativeConicArcs.PRSPolarInduction` for contractions, modular kernels, lower-cover strata, and
contained-versus-transverse synthesis.

The kernel-checked algebra includes:

- the integral divided-cubic discriminant and its characteristic-two identity
  \[
  K=(AD+BC)^2;
  \]
- the residual divided Hessian and, on the exact chart
  \(\Delta N_s\ne0\), its Artin--Schreier equation;
- the specialization with Arf representative \(1/A\);
- degree-two homogeneity in both variables of the ordered-Hessian incidence;
- the common-quadratic Veronese Pluecker coordinates and both Segre rulings of the tangent
  quadric;
- the genus-one deletion record using
  `LowerCoverStratum.deletionBelowPointBaseline` and
  `LowerCoverStratum.squaredHasseWeilDeletionBound`;
- power-of-two interior binomial vanishing and the exact consecutive-row overlap interval
  \(2\le i\le d-1\);
- degree-five, degree-six, and degree-nine Lucas carriers defined through
  `modularContractionKernel`;
- scalar transport of ordered projective contraction flags;
- the two length-three doubling cycles modulo seven;
- the order-two doubling cycle modulo three;
- the normalized \(e_7\) last-pair Artin--Schreier equation; and
- the exact identification of the excluded last-pair divisor with root collision; and
- the affine-frame order \(1344\), positivity of
  \(q(q-1)(q-2)(q-4)/1344\), its values \(1\) and \(30\) at \(q=8,16\), and exact
  endpoint-orbit witness-count synthesis.

The geometric and coding trust boundary is explicit.  `OrderedHessianCarrierData` assumes the
exhaustive reduced line-section classification and root-compatible containment theorem.
`LinearizedRootCoverData` assumes the finite-field constant-field and splitting semantics.
`EndpointArtinSchreierLiftingData` assumes the identification of the abstract trace-zero predicate
with the finite-field trace.  `DegreeNineEndpointAdditiveData` assumes construction and transport
of the additive subspace-polynomial witnesses.  The terminal theorem covers only the distinguished
\(e_7\) endpoint orbit and says nothing about the other degree-nine carrier strata.

## Public terminals

- `DividedCubic.dividedDiscriminant_eq_residualBranch`
- `DividedCubic.dividedDiscriminant_eq_tangentQuadric_sq`
- `DividedCubic.arfRepresentative_specialization`
- `DividedCubic.residualQuadratic_eq_zero_iff_artinSchreier`
- `orderedHessianEquation_scale_parameter`
- `orderedHessianEquation_scale_root`
- `commonQuadraticPencil_pluecker`
- `firstSegreRuling_mem_tangentQuadric`
- `secondSegreRuling_mem_tangentQuadric`
- `OrderedHessianCarrierData.carrier_and_complementary_boundary`
- `orderedHessianLowerCoverStratum`
- `splitFree_implies_persistent_or_lucas`
- `two_dvd_choose_two_pow`
- `consecutiveOverlapIndex_iff`
- `mem_degreeFiveLucasCarrier_iff`
- `mem_degreeSixLucasCarrier_iff`
- `mem_degreeNineLucasCarrier_iff`
- `lucasFlagContraction_map`
- `doublingModThree_cycle_table`
- `doublingModSeven_cycle_table`
- `LinearizedRootCoverData.arithmetic_terminal`
- `lastPairSum_zero_iff_roots_equal`
- `endpointLastPair_artinSchreier`
- `EndpointArtinSchreierLiftingData.rational_lifts_iff_traceZero`
- `affineFrameGroupOrderThreeOverTwo`
- `degreeNineAdditiveWitnessCount_small_controls`
- `degreeNineAdditiveWitnessCount_pos`
- `DegreeNineEndpointAdditiveData.exact_count_and_endpointOrbit_shallow`

## Validation

The source module passes scoped single-file elaboration:

```text
lean/scripts/guarded-lean RelativeConicArcs/PRSCharacteristicTwoHessianLucas.lean
```

The import gate and its axiom-audit gate passed through the shared build queue:

```text
lean/scripts/lean-build-queue.py run \
  RelativeConicArcs.PRSCharacteristicTwoHessianLucas \
  RelativeConicArcs.Gates.PRSCharacteristicTwoHessianLucas \
  RelativeConicArcs.Gates.PRSCharacteristicTwoHessianLucasAxiomAudit \
  --profile single --threads 1 --cores 20-23
```

The queue also completed its trace-only aggregate gate.  The axiom audit prints exactly
`propext`, `Classical.choice`, and `Quot.sound`.  There are no project-local axioms, generated
evaluators, native decisions, external oracles, or finite certificates in this closure.

The manuscript formalization ledger now names the exact characteristic-two and Lucas terminals and
states every remaining geometric, finite-field, and coding hypothesis.

## Extra-juice and Tao closeout

The closeout found six cheap strengthening opportunities and incorporated them:

1. The residual Artin--Schreier equivalence now names both nonvanishing hypotheses
   \(\Delta N_s\ne0\), preventing an invalid equivalence on the determinant divisor.
2. All three degree-specific modular targets instantiate the common contraction-kernel interface;
   the degree-nine module does not introduce a parallel carrier definition.
3. The generic last-pair equation and its trace-lifting boundary are separated from the additive
   subcover.  This prevents the nonconstant Artin--Schreier layer from being confused with the
   additive witnesses that make the \(e_7\) orbit shallow.
4. The \(1/A\) specialization is now checked as an exact Arf-representative identity.
5. Both the order-two \(C_3\) label cycle and the order-three \(C_7\) label cycles are checked,
   making the failure of a stable parity law visible inside one module.
6. The excluded last-pair divisor is proved to be exactly root collision, and the first two
   additive witness counts are checked as arithmetic controls.

The most important limitation remains deliberate: the formal endpoint theorem cannot be read as a
classification of the full six-dimensional degree-nine Lucas carrier.

The post-acceptance review found no further free theorem.  Any stronger result would require the
Grassmannian line classification, finite-field cover semantics, or the separately owned
degree-nine carrier stratification.

## Mystery ledger

Settled:

- **Does characteristic two merely make the ordinary branch test inconvenient?** No.  Lean checks
  the exact doubled-quadric identity.
- **Which chart supports the Artin--Schreier equivalence?** Exactly
  \(\Delta N_s\ne0\).
- **Are ordered projective markers lost in the modular specialization?** No.  The Lucas flag
  terminal is the shared ordered projective contraction map.
- **Does the order-three \(e_7\) cycle imply deepness away from multiples of three?** No.  The
  formal boundary separates that linearized-cover cycle from the larger additive witness family.
- **Is the degree-nine conclusion carrier-wide?** No.  Its predicate is explicitly the
  distinguished endpoint orbit.

Open with exact evidence gaps:

- **Geometric carrier classification.**  The exhaustive Veronese/ruling and root-compatible
  containment arguments remain fields of `OrderedHessianCarrierData`; a future stronger
  formalization would need Grassmannian line geometry and the constrained Hankel pullback.
- **Finite-field cover semantics.**  Minimal constant fields, monodromy groups, and the trace
  interpretation remain structure fields, although their integer and coordinate consequences are
  checked.
- **Other degree-nine strata.**  No formal or mathematical completion is claimed; the intrinsic
  stratification and their root covers remain owned by C531.

No incidental discovery arose outside the selected task.
