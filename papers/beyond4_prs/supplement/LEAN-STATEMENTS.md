# Lean declaration and trust map

The paper-facing Lean closure is
`RelativeConicArcs.Gates.PRSBeyondRedundancyFour`. Its companion
`RelativeConicArcs.Gates.PRSBeyondRedundancyFourAxiomAudit` prints the axiom
dependencies of every declaration on which the retained redundancy-five
through redundancy-seven manuscript places Lean-level trust. The aggregate
gate imports exactly the foundation, redundancy-five, polar-induction and
redundancy-six/seven, and stable-component gates, together with the
`PRSUniformCoveringRadius` arithmetic and literature adapter.
The balanced quantum corollary uses the separate cross-paper closure
`RelativeConicArcs.Gates.PRSBalancedQuantumExtension` and audit
`RelativeConicArcs.Gates.PRSBalancedQuantumExtensionAxiomAudit`; it is not
folded into the 17-file geometric aggregate.

“Kernel algebra” means that Lean proves the displayed identity or arithmetic
statement. “Conditional terminal” means that Lean proves the conclusion from
structure fields or theorem hypotheses whose mathematical content remains
external to the formal development. “No direct declaration” means that the
manuscript proof, a cited theorem, or a public certificate is the proof route;
Lean may still check downstream arithmetic or logical composition.
Declaration names below are relative to the `RelativeConicArcs` namespace.

## Manuscript declaration reconciliation

The following table has one row for each of the 43 numbered lemma,
proposition, theorem, or corollary labels in the TeX include graph.

| Manuscript label | Lean boundary | Exact formal status |
|---|---|---|
| `lem:hankel` | `PRSFoundation.HankelKernelDictionary.not_splitFree_of_kernel_member` | Conditional terminal. The concrete Hankel dictionary and its coding semantics are inputs. |
| `cor:splitfree` | `PRSFoundation.HankelKernelDictionary.not_splitFree_of_kernel_member`; `PRSFoundation.CoveringRadiusInput.deep_iff_splitFree` | Conditional terminal. The concrete dictionary and covering-radius premise are inputs. |
| `thm:r5` | `PRSRedundancyFiveCertified.redundancyFiveSynthesisWithCertificate`; family arithmetic under `PRSRedundancyFive.FamilyData`; table arithmetic under `PRSRedundancyFiveCertificate` | Conditional synthesis plus kernel arithmetic. Covering radius, cubic-cover geometry, group actions, and certificate semantics remain inputs. |
| `cor:q8-quantum-extension` | `PRSBalancedQuantumExtension.fieldEightRecord_mem_certifiedFieldRecords`; `fieldEight_projectiveDirectionCount`; `fieldEight_balancedExtensionParameters`; `fieldEight_uniqueBalancedPrimePowerRow`; `certifiedBalancedExtensions_haveQuantumConsequences`; `lengthTen_locallyUnitaryEquivalent_implies_locallyCliffordEquivalent`; `lengthTen_encoderConversion_logical_and_physical_isClifford` | Exact certificate arithmetic and balanced-row uniqueness are kernel checked. The MDS--AME and Choi semantics are explicit interface fields; the LU and transversal conclusions are kernel-checked specializations of the generic MDS--CSS theorems. No complete LU/LC orbit classification is asserted. |
| `thm:spine` | `PRSRedundancySixSeven.redundancySixAllFieldSynthesis`; `redundancySevenAllFieldSynthesis`; `PRSPolarInduction.fifthPower_sigmaInversionOrbitCount` | Derived manuscript aggregation of the R6/R7 clauses and persistent orbit law; each clause retains its own boundary. |
| `thm:stable-component-headline` | `PRSSquarefreeMarkerDensity.eq_zero_of_splitCoefficientPullback_eval_eq_zero_on_injective`; `PRSStableComponents.ContainedRowSpaceData.rowSpace_subset_badCarrier`; `ContainedRowSpaceData.exists_component_containing_rowSpace`; `RecursiveContainedGeometryInput.bad_implies_persistent_or_modular`; the `PRSStableComponents` factor, coherent-Fano, modular-kernel, and cyclic-plane terminals; `PRSUniformCoveringRadius.UniformIteratedPackageInput.packages_fit_uniform_threshold`; `seroussiRothDimensionRange_of_uniformTransverseThreshold`; `deep_iff_splitFree_of_externalSeroussiRothDuer_uniformTransverseThreshold` | Polynomial density of monic split-squarefree coefficient tuples over an infinite field, density-to-closure transport, finite irreducible-component selection, recursive descent, coordinate algebra, characteristic-two block-coverage termination, simultaneous stagewise budget arithmetic, and composition of the external radius implications are kernel checked. The infinite-field theorem is used after passage to an algebraic closure. Identification of the retained-marker coefficient map with the catalecticant row-space closure, the exact primary-decomposition ledger, saturation, concrete scheme properness and integrality, the dual-GRS identification, and the cited coding theorems remain manuscript, certificate, or external inputs. |
| `prop:r5-radius` | `PRSFoundation.CoveringRadiusInput.deep_iff_splitFree` | The logical use is checked; the Seroussi--Roth theorem is imported by citation. |
| `prop:r5-gcd2` | `PRSRedundancyFive.FamilyData.family_arithmetic` and the three `deep_card_*` terminals | Family/count arithmetic is kernel checked; the geometric gcd classification is a manuscript proof. |
| `prop:r5-gcd1` | no direct declaration | Manuscript proof, with the finite `q=7` clause supplied by Certificate R5. |
| `prop:r5-incidence` | no direct declaration | Manuscript proof of the cubic incidence and residual-curve geometry. |
| `lem:cyclic` | no direct declaration | Manuscript proof of the cyclic stratum. |
| `lem:s3` | no direct declaration | Manuscript proof using the cited rational-point bound. |
| `prop:r5-bridge` | `PRSRedundancyFiveCertificate.certified_comparison_band_has_no_sporadic`; `certified_orbit_summaries_agree_with_sporadic_records`; `CertificateValidation` | Transcription and arithmetic are kernel checked. Identification and exhaustive-search semantics remain explicit validation fields. |
| `thm:polar-construction` | `PRSPolarInduction.iteratedProjectiveSequenceContraction_map`; `sequenceContraction_agrees_with_finite`; `PointedKernelLift.lift_splitSquarefreeKernelMember` | Kernel algebra and a conditional squarefree-lift terminal. The polynomial/kernel identification is an input. |
| `lem:marker-collision` | no direct declaration | Manuscript marker-collision proof. |
| `lem:uniform-collision` | no direct declaration | Manuscript separability and collision-degree proof. |
| `lem:linear-modular-pullback` | `PRSPolarInduction.mem_modularContractionKernel_iff` | The abstract modular-kernel criterion is checked; the degree-specific linear pullback is a manuscript proof. |
| `lem:old-marker-fixed-factor` | no direct declaration | Manuscript evaluation-minor and non-identical-vanishing proof; the degree bound enters the formal package as an explicit field. |
| `lem:exact-linear-gcd-transport` | `PRSUniformCoveringRadius.exactLinearFlagParameterBudget_lt_uniformParameterBudget` and `UniformIteratedPackageInput.packages_fit_uniform_threshold` | The factor-preserving flag’s budget and simultaneous threshold use are kernel checked. Preservation of the concrete gcd under contraction is the displayed manuscript proof and an explicit formal input. |
| `lem:identically-colliding` | no direct declaration | Manuscript reduction to the two inseparable fixed-level calculations. |
| `prop:exact-bottom-ledger` | the `PRSStableComponents` factor, coherent-Fano, modular-kernel, and cyclic-plane terminals | Coordinate identities are kernel checked. The gcd trichotomy, exact component identification, primary decomposition, and match to the reduced terminal carrier are manuscript and Certificate SC mathematics. |
| `lem:recursive-bottom-transport` | `PRSSquarefreeMarkerDensity.eq_zero_of_splitCoefficientPullback_eval_eq_zero_on_injective`; `PRSStableComponents.ContainedRowSpaceData.rowSpace_subset_badCarrier`; `ContainedRowSpaceData.exists_component_containing_rowSpace`; `RecursiveContainedGeometryInput.bad_implies_persistent_or_modular` | Polynomial density of split-squarefree coefficient tuples over an infinite field, closure transport, finite closed-component selection by irreducibility, and the recursive implication are kernel checked. The density theorem is used over an algebraic closure. Identification of the marker coefficient map with the catalecticant row-space closure and identification and classification of the listed components are supplied geometric inputs. |
| `thm:induction` | `PRSPolarInduction.CoherentPolarInput.splitFree_implies_persistent_or_modular` | Conditional terminal. `lowerWitness` directly supplies rational witnesses; genus, deletion, and Hasse--Weil data are carried in the interface but do not derive that field. |
| `prop:uniform-iterated-packages` | `PRSUniformCoveringRadius.bottomCurveDeletionBudget_eq`; `exactLinearGraphDeletionBudget_eq`; `intermediateParameterBudget_lt_uniformParameterBudget`; the two `*DeletionBudget_lt_fieldOrder_add_one` terminals; `UniformIteratedPackageInput.packages_fit_uniform_threshold` | The genus-one, exact-linear-gcd graph, and stagewise degree formulas and their simultaneous use above the threshold are kernel checked. Properness, geometric integrality, rational graph cardinality, and concrete degree bounds are explicit inputs proved in the manuscript. |
| `thm:uniform-transverse` | `PRSPolarInduction.CoherentPolarInput.splitFree_implies_persistent_or_modular`; `PRSStableComponents.RecursiveContainedGeometryInput.bad_implies_persistent_or_modular`; `PRSUniformCoveringRadius.UniformIteratedPackageInput.packages_fit_uniform_threshold`; `PRSStableComponents` coordinate and component-selection terminals | Conditional one-step logic, polynomial density of split-squarefree coefficient tuples over an infinite field, density-to-closure transport, finite irreducible-component selection, recursive composition, coordinate identities, and uniform arithmetic are checked. The density theorem is used after passage to an algebraic closure. The retained-marker-to-catalecticant identification, integrality, point counts, primary decomposition, and scheme identification remain manuscript or certificate inputs. |
| `prop:contained-rank-two` | no direct declaration | Characteristic-free manuscript rank--nullity proof; degree-specific formal terminals consume its consequence as an input. |
| `prop:higher-lucas-endpoint` | no direct declaration | Manuscript proof using Lucas support, linearized-polynomial root differences, and binary subspace polynomials.  It classifies the canonical endpoint section and proves shallowness of the first fresh endpoint orbit, not of every higher modular-carrier stratum. |
| `prop:r6-persistent` | `PRSRedundancySixSeven.PersistentModularFamilyData.classified_card_doubled`; `PRSPolarInduction.fifthPower_sigmaInversionOrbitCount`; tangent-translation terminals | Cardinality and quotient arithmetic are checked; genuine actions and geometric family identification are inputs. |
| `lem:r6-gcd1` | no direct declaration | Manuscript proof of exact-linear-gcd shallowness. |
| `prop:r6-secant` | `PRSPolarInduction.sequenceContraction_agrees_with_finite` | Contraction algebra is checked; the secant-degree assertion is a manuscript proof. |
| `prop:r6-degrees` | no direct declaration | Manuscript component and divisor-degree proof; its bounds enter the polar terminal as hypotheses. |
| `prop:r6-modular` | `PRSPolarInduction.mem_modularContractionKernel_iff` | The abstract modular kernel is checked; the concrete component classification is a manuscript proof. |
| `prop:r6-nucleus` | no direct declaration | Manuscript binary-nucleus arithmetic and splitting proof, supported by Certificate R6. |
| `prop:r6-contained` | no direct declaration | Manuscript exhaustion of contained alternatives. |
| `prop:r6-one-step` | `PRSRedundancySixSeven.redundancySixHighFieldSynthesis` | Conditional specialization of the one-step budgets; the geometric inputs remain hypotheses. |
| `thm:r6` | `PRSRedundancySixSeven.redundancySixAllFieldSynthesis`; `PRSRedundancySixSevenCertificate.redundancySix_count_exhaustion`; `PRSUniformCoveringRadius.SeroussiRothDuerRadiusInput.seroussiRothDimensionRange_six_eight`; `radiusRange_six_eight_of_externalSeroussiRothDuer` | Conditional synthesis plus kernel-checked finite-row arithmetic and the exact \(q=8,r=6\) high-rate endpoint. The concrete coding identifications and cited radius implications remain explicit inputs. |
| `prop:r7-pointed` | `PRSPolarInduction.LowerCoverStratum`; `CoherentPolarInput.splitFree_implies_persistent_or_modular` | The conditional interface and its witness use are checked. The two-marker cover, deletion degree `25`, and point-count derivation are manuscript mathematics, not Lean conclusions. |
| `prop:r7-gcd1` | no direct declaration | Manuscript proof. |
| `prop:r7-collision` | no direct declaration | Manuscript degree computation, supplied as a collision-budget input to Lean. |
| `prop:r7-central` | no direct declaration | Manuscript central-lift and inverse-image proof, supported by Certificate R7. |
| `cor:r7-contained` | no direct declaration | Manuscript rank--nullity and component proof; the R7 synthesis structure takes the result as an explicit input. |
| `thm:r7` | `PRSRedundancySixSeven.redundancySevenAllFieldSynthesis`; `PRSRedundancySixSevenCertificate.redundancySeven_count_exhaustion` | Conditional synthesis and finite-row arithmetic. The `q=7,8,9` rows are not promoted through the missing radius premise. |
| `cor:large-characteristic-stable` | `PRSStableComponents` coordinate terminals; `PRSPolarInduction.CoherentPolarInput.splitFree_implies_persistent_or_modular` | The formal closure checks coordinate identities and the conditional one-step implication. The all-level stable-component theorem, Lucas exclusion, and iteration are manuscript proofs. |

## Exact project-owned closure

Recursive import resolution from the axiom-audit gate gives 17
project-owned Lean files:

- six gates: `PRSFoundation`, `PRSRedundancyFive`,
  `PRSPolarInductionRedundancySixSeven`, `PRSStableComponents`,
  `PRSBeyondRedundancyFour`, and
  `PRSBeyondRedundancyFourAxiomAudit`;
- eleven mathematical modules: `PRSContraction`, `PRSFoundation`,
  `PRSRedundancyFive`, `PRSRedundancyFiveCertificate`,
  `PRSRedundancyFiveCertified`, `PRSPolarInduction`,
  `PRSRedundancySixSeven`, `PRSRedundancySixSevenCertificate`, and
  `PRSSquarefreeMarkerDensity`, `PRSStableComponents`, and
  `PRSUniformCoveringRadius`.

`PRSContraction` contains only the finite-coordinate contraction API.
The residual-quadratic, R8, R9, ordered-Hessian, Lucas-carrier, and
degree-nine endpoint modules are not in this closure.

The balanced quantum bridge adds its mathematical module, import-only gate,
and axiom-audit gate on top of the separately released AME--LU dependency
closure.  Its arithmetic and length-ten specializations are kernel checked;
the MDS--AME and one-party Choi semantics remain explicit cited inputs.

## Trust statement

The aggregate audit reports only `propext`, `Classical.choice`, and
`Quot.sound`, the standard Lean/mathlib dependencies used by these
declarations; many algebraic and finite-table terminals are axiom-free. The
aggregate closure contains no declaration introduced with `axiom`, no `sorry`,
no native evaluator, no generated Lean certificate, and no opaque external
oracle. Externally generated classification records are transcribed into Lean,
where their internal arithmetic is reduced by the kernel. Their identification
with finite-field syndrome orbits, completeness, representative semantics, and
independent replay remain fields of public validation structures.

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
exact-target currentness, and the final trace-only aggregate gate. The
paper-local verifier independently checks that this table has exactly the
current TeX label set and that the aggregate and audit source have exactly the
declared R5--R7 target sets.

The balanced quantum bridge is checked separately by:

```text
lean/scripts/lean-build-queue.py run \
  RelativeConicArcs.PRSBalancedQuantumExtension \
  RelativeConicArcs.Gates.PRSBalancedQuantumExtension \
  RelativeConicArcs.Gates.PRSBalancedQuantumExtensionAxiomAudit \
  --profile single --threads 1 --cores 20-23
```
