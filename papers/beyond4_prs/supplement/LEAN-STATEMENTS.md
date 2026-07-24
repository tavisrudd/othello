# Lean declaration and trust map

The paper-facing Lean closure is
`RelativeConicArcs.Gates.PRSBeyondRedundancyFour`.  Its companion
`RelativeConicArcs.Gates.PRSBeyondRedundancyFourAxiomAudit` prints the axiom
dependencies of every declaration on which the manuscript places Lean-level
trust.  The aggregate gate imports only the projective Reed--Solomon
foundation, redundancy-five through redundancy-nine packages, and the
characteristic-two ordered-Hessian/Lucas package.

“Kernel algebra” below means that Lean proves the displayed identity or
arithmetic statement.  “Conditional terminal” means that Lean proves the
conclusion from structure fields or theorem hypotheses whose mathematical
content remains external to the formal development.  “No direct declaration”
means that the manuscript proof, a cited theorem, or a public certificate is
the proof route; Lean may still check downstream arithmetic or logical
composition.  Declaration names in the table are relative to the
`RelativeConicArcs` namespace.

## Manuscript declaration reconciliation

| Manuscript label | Lean boundary | Exact formal status |
|---|---|---|
| `cor:splitfree` | `PRSFoundation.HankelKernelDictionary.not_splitFree_of_kernel_member`; `PRSFoundation.CoveringRadiusInput.deep_iff_splitFree` | Conditional terminal.  The concrete Hankel dictionary and covering-radius premise are inputs. |
| `thm:r5` | `PRSRedundancyFiveCertified.redundancyFiveSynthesisWithCertificate`; family arithmetic under `PRSRedundancyFive.FamilyData`; table arithmetic under `PRSRedundancyFiveCertificate` | Conditional synthesis plus kernel arithmetic.  Covering radius, cubic-cover geometry, group actions, and certificate semantics remain inputs. |
| `thm:spine` | the R6/R7, R8, and R9 terminals listed below | Derived manuscript aggregation; each clause retains its own boundary. |
| `prop:r5-radius` | `PRSFoundation.CoveringRadiusInput.deep_iff_splitFree` | The logical use is checked; the Seroussi--Roth theorem is imported by citation, not proved in Lean. |
| `prop:r5-gcd2` | `PRSRedundancyFive.FamilyData.family_arithmetic` and the three degree-specific `deep_card_*` terminals | Family/count arithmetic is kernel checked; the geometric gcd classification is a manuscript proof. |
| `prop:r5-gcd1` | no direct declaration | Manuscript proof, with the finite `q=7` clause supplied by Certificate R5. |
| `prop:r5-incidence` | no direct declaration | Manuscript proof of the cubic incidence and residual curve geometry. |
| `prop:r5-bridge` | `PRSRedundancyFiveCertificate.certified_comparison_band_has_no_sporadic`; `certified_orbit_summaries_agree_with_sporadic_records`; `CertificateValidation` | Transcription and arithmetic are kernel checked.  Identification and exhaustive-search semantics remain explicit validation fields. |
| `thm:polar-construction` | `PRSPolarInduction.iteratedProjectiveSequenceContraction_map`; `PointedKernelLift.lift_splitSquarefreeKernelMember`; `PRSResidualQuadratic.dividedPowerContraction_comm` | Kernel algebra and a conditional squarefree-lift terminal.  The concrete polynomial/kernel identification is an input. |
| `thm:induction` | `PRSPolarInduction.CoherentPolarInput.splitFree_implies_persistent_or_modular` | Conditional terminal with explicit component, genus, deletion, collision, and witness fields. |
| `prop:contained-rank-two` | no direct declaration | Characteristic-free manuscript rank--nullity proof; degree-specific formal terminals consume its geometric consequence as an input. |
| `prop:r6-persistent` | `PRSRedundancySixSeven.PersistentModularFamilyData.classified_card_doubled`; `PRSPolarInduction.fifthPower_sigmaInversionOrbitCount`; tangent-translation terminals | Cardinality and quotient arithmetic are checked; genuine group actions and the geometric family identification are inputs. |
| `prop:r6-secant` | `PRSPolarInduction.sequenceContraction_agrees_with_finite`; `PRSResidualQuadratic.dividedPowerContraction_twice_apply` | Contraction algebra is checked; the secant-degree assertion is a manuscript proof. |
| `prop:r6-degrees` | no direct declaration | Manuscript component and divisor-degree proof; its bounds enter the polar terminal as hypotheses. |
| `prop:r6-modular` | `PRSPolarInduction.mem_modularContractionKernel_iff`; `PRSCharacteristicTwoHessianLucas.mem_degreeFiveLucasCarrier_iff` | The abstract modular kernel and Lucas instance are checked; the concrete component classification is a manuscript proof. |
| `prop:r6-nucleus` | `PRSCharacteristicTwoHessianLucas.LinearizedRootCoverData.arithmetic_terminal`; `doublingModThree_cycle_table` | Conditional cover arithmetic and cycle table.  Constant-field, splitting, and orbit semantics are inputs. |
| `thm:r6` | `PRSRedundancySixSeven.redundancySixAllFieldSynthesis`; `PRSRedundancySixSevenCertificate.redundancySix_count_exhaustion` | Conditional synthesis plus kernel-checked finite-row arithmetic. |
| `prop:r7-pointed` | `PRSPolarInduction.LowerCoverStratum`; `CoherentPolarInput.splitFree_implies_persistent_or_modular` | The logical use of genus/deletion data is checked; the two-marker cover and degree `24` are manuscript inputs. |
| `prop:r7-gcd1` | no direct declaration | Manuscript proof. |
| `prop:r7-collision` | no direct declaration | Manuscript degree computation, supplied as a collision-budget input to Lean. |
| `prop:r7-central` | `PRSCharacteristicTwoHessianLucas.mem_degreeSixLucasCarrier_iff`; `LinearizedRootCoverData.arithmetic_terminal` | Kernel membership and conditional cover arithmetic; the complete inverse-image calculation is a manuscript proof. |
| `cor:r7-contained` | no direct declaration | Manuscript rank--nullity and component proof; the R7 synthesis structure takes the result as an explicit input. |
| `thm:r7` | `PRSRedundancySixSeven.redundancySevenAllFieldSynthesis`; `PRSRedundancySixSevenCertificate.redundancySeven_count_exhaustion` and `redundancySeven_radius_reporting_boundary` | Conditional synthesis and finite-row arithmetic.  The `q=7,8,9` rows are not promoted through a missing radius premise. |
| `prop:r8-bottom` | `PRSRedundancyEight.exact_deletion_and_polar_budgets`; `threeMarker_genusOne_hasseWeil_bound`; `threeMarker_genusOne_hasseWeil_exact_threshold`; `primePowerOrder_at_least_fortyThree` | Budgets and threshold arithmetic are checked.  Geometric integrality and the lower-cover construction are inputs. |
| `prop:r8-lp61` | no direct declaration | Manuscript recursive lower-package proof; the formal synthesis consumes its package fields. |
| `prop:r8-modular` | `PRSCharacteristicTwoHessianLucas.lucasFlagContraction_map` and the degree-specific Lucas-carrier membership terminals | Contraction and kernel membership are checked; concrete lift exhaustiveness and shallowness are manuscript inputs. |
| `prop:r8-contained` | no direct declaration | Manuscript component theorem, represented by explicit contained/modular fields in `PRSRedundancyEight.RedundancyEightInput`. |
| `thm:r8` | `PRSRedundancyEight.redundancyEightHighFieldSynthesis`; `redundancyEightPrimePowerSynthesis`; `redundancyEightFiniteFieldSynthesis`; `PersistentFamilyData.classified_card`; orbit and tangent terminals | Conditional classification and kernel arithmetic.  Coding, geometry, and group-action semantics remain inputs. |
| `prop:r9-budgets` | no direct declaration | Manuscript four-marker lower-package proof. |
| `prop:r9-residual` | `PRSResidualQuadratic.first_hankel_identity`; `second_hankel_identity`; `residual_discriminant`; `residual_sum_product_solve_hankel` | Kernel algebra.  Fixed-polynomial discriminant/resultant identifications beyond these coordinates are manuscript proof. |
| `prop:r9-slice` | `PRSRedundancyNine.ResidualSliceInput.integralGenusAtMostOneSlice` | The property is an explicit formal input; its geometric proof is in the manuscript. |
| `prop:r9-components` | no direct declaration | Manuscript binary-quartic slice and rational-base proof, supported by Certificate R9. |
| `prop:r9-deletion` | `PRSRedundancyNine.ResidualSliceInput.rationalPointOutsideDeletedDivisors` | The undeleted-point statement is an explicit input; the degree `32` computation and point-bound argument are manuscript proof. |
| `prop:r9-char7` | `PRSRedundancyEight.CharacteristicSevenCarrierBoundary.proved_boundary` | The two displayed boundary facts compose formally from explicit fields; Certificate R9 and Certificate R9-49 supply their semantics. |
| `prop:r9-orbits` | `PRSRedundancyNine.orbit_count_pair`; `PersistentFamilyData.deep_card` | Orbit-count and cardinality arithmetic are checked; construction of the group actions and exhaustion are inputs. |
| `prop:r9-other-modular` | no direct declaration | Manuscript Lucas-support and shallowness proof. |
| `prop:r9-contained` | no direct declaration | Manuscript component theorem; its conclusion is an input to the R9 slice/synthesis package. |
| `thm:r9` | `PRSRedundancyNine.redundancyNineSynthesis` | Conditional synthesis from explicit geometric, witness, coding, cardinality, and orbit fields. |
| `thm:hessian` | `PRSCharacteristicTwoHessianLucas.DividedCubic.dividedDiscriminant_eq_tangentQuadric_sq`; ordered-Hessian scaling, Pluecker, and Segre-ruling terminals; `OrderedHessianCarrierData.carrier_and_complementary_boundary` | Coordinate algebra is checked.  Exhaustive geometric line-section classification is an explicit structure field. |
| `prop:hessian-pullback` | `PRSCharacteristicTwoHessianLucas.splitFree_implies_persistent_or_lucas`; `OrderedHessianCarrierData.carrier_and_complementary_boundary` | Conditional terminal; root-compatible carrier identification is a visible input. |
| `prop:hessian-effective` | `PRSCharacteristicTwoHessianLucas.orderedHessianLowerCoverStratum`; `splitFree_implies_persistent_or_lucas` | Threshold/deletion data and logical synthesis are checked from stated fields; integral-slice geometry and coding identification remain inputs. |
| `prop:lucas-kernel` | `PRSCharacteristicTwoHessianLucas.two_dvd_choose_two_pow`; `consecutiveOverlapIndex_iff`; the three `mem_degree*LucasCarrier_iff` terminals | Lucas arithmetic and modular-kernel instances are kernel checked. |
| `prop:linearized` | `PRSCharacteristicTwoHessianLucas.LinearizedRootCoverData.arithmetic_terminal`; `doublingModThree_cycle_table`; `doublingModSeven_cycle_table` | Conditional arithmetic.  Monodromy, minimal constant field, and splitting semantics are structure fields. |
| `prop:e7-orbit` | no direct declaration | Manuscript stabilizer and kernel-coordinate proof. |
| `prop:e7-as` | `PRSCharacteristicTwoHessianLucas.endpointLastPair_artinSchreier`; `lastPairSum_zero_iff_roots_equal`; `EndpointArtinSchreierLiftingData.rational_lifts_iff_traceZero` | Equation and collision algebra are checked; geometric integrality and finite-field trace semantics are inputs. |
| `prop:e7-additive` | `PRSCharacteristicTwoHessianLucas.DegreeNineEndpointAdditiveData` | Connected-cover and witness construction are explicit fields, not derived in Lean. |
| `thm:e7` | `PRSCharacteristicTwoHessianLucas.DegreeNineEndpointAdditiveData.exact_count_and_endpointOrbit_shallow`; `degreeNineAdditiveWitnessCount_pos` | Conditional orbitwise shallowness plus exact count arithmetic.  The result covers only the distinguished endpoint orbit. |

## Trust statement

The aggregate audit reports only `propext`, `Classical.choice`, and
`Quot.sound`, the standard Lean/mathlib dependencies used by these
declarations; many algebraic and finite-table terminals are axiom-free.  The
aggregate closure contains no declaration introduced with `axiom`, no `sorry`,
no native evaluator, no generated Lean certificate, and no opaque external
oracle.  Externally generated classification records are transcribed into Lean,
where their internal arithmetic is reduced by the kernel.  Their identification
with finite-field syndrome orbits, completeness, representative semantics, and
independent replay remain fields of public validation structures and are not
claimed as Lean proofs.

The source named by the transcribed R5--R7 tables is
`supplement/CLASSIFICATION-RECORDS.json`, SHA-256
`b3441d983798793f211878de7e72b976be9170b580041f460cf981a73dbf66a2`.
The release-level evidence manifest records the same bytes and hash.

## Reproduction

From the repository root, the supported aggregate gate is:

```text
lean/scripts/lean-build-queue.py run \
  RelativeConicArcs.Gates.PRSBeyondRedundancyFourAxiomAudit \
  --profile single --threads 1 --cores 20-23 \
  --aggregate RelativeConicArcs.Gates.PRSBeyondRedundancyFour
```

The queue records per-target source/toolchain traces, build telemetry,
exact-target currentness, and the final trace-only aggregate gate.  The guarded
queue is the supported paper-facing entry point in the shared development
tree.
