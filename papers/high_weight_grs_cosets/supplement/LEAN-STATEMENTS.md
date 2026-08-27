# Lean declaration and trust map

The paper-facing Lean closure is
`RelativeConicArcs.Gates.PRSBeyondRedundancyFour`. Its companion
`RelativeConicArcs.Gates.PRSBeyondRedundancyFourAxiomAudit` prints the axiom
dependencies of every declaration on which the manuscript places
Lean-level trust. The aggregate
gate imports exactly the foundation, redundancy-five, polar-induction and
redundancy-six/seven, and stable-component gates, together with the
`PRSUniformCoveringRadius` arithmetic and literature adapter.
**Withdrawn.**  The paper draws no quantum consequence from the balanced `q=8`
row.  A split-free direction is not a one-column MDS extension: an extension
needs a syndrome outside the span of every `r-1` parity-check columns, whereas
split-freeness supplies only `r-2`, and Dür's equivalence makes covering radius
`r-1` the same statement as completeness of the normal rational curve's arc, so
no such extension exists at these parameters.  The manuscript states this in the
remark "No one-column MDS extension at this radius" in the redundancy-five
section.  The formal modules below are retained as conditional developments
whose extension hypothesis is unsatisfied here; nothing in the manuscript
depends on them.

The retained balanced-quantum development uses the separate cross-paper closure
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

The following table has one row for each of the 90 numbered lemma,
proposition, theorem, or corollary labels in the TeX include graph.

| Manuscript label | Lean boundary | Exact formal status |
|---|---|---|
| `lem:hankel` | `PRSFoundation.HankelKernelDictionary.not_splitFree_of_kernel_member` | Conditional terminal. The concrete Hankel dictionary and its coding semantics are inputs. |
| `cor:splitfree` | `PRSFoundation.HankelKernelDictionary.not_splitFree_of_kernel_member`; `PRSFoundation.CoveringRadiusInput.deep_iff_splitFree` | Conditional terminal. The concrete dictionary and covering-radius premise are inputs. |
| `thm:r5` | `PRSRedundancyFiveCertified.redundancyFiveSynthesisWithCertificate`; family arithmetic under `PRSRedundancyFive.FamilyData`; table arithmetic under `PRSRedundancyFiveCertificate` | Conditional synthesis plus kernel arithmetic. Covering radius, cubic-cover geometry, group actions, and certificate semantics remain inputs. |
| `thm:spine` | `PRSRedundancySixSeven.redundancySixAllFieldSynthesis`; `redundancySevenAllFieldSynthesis`; `PRSPolarInduction.fifthPower_sigmaInversionOrbitCount` | Derived manuscript aggregation of the R6/R7 clauses and persistent orbit law; each clause retains its own boundary. |
| `prop:r5-radius` | `PRSFoundation.CoveringRadiusInput.deep_iff_splitFree` | The logical use is checked; the Seroussi--Roth theorem is imported by citation. |
| `prop:r5-gcd2` | `PRSRedundancyFive.FamilyData.family_arithmetic` and the three `deep_card_*` terminals | Family/count arithmetic is kernel checked; the geometric gcd classification is a manuscript proof. |
| `prop:r5-gcd1` | no direct declaration | Manuscript proof, with the finite `q=7` clause supplied by Certificate R5. |
| `prop:r5-incidence` | no direct declaration | Manuscript proof of the cubic incidence and residual-curve geometry. |
| `lem:cyclic` | no direct declaration | Manuscript proof of the cyclic stratum. |
| `prop:r5-count` | `PRSRedundancyFive.ExactSplitWitnessCount.countRelation` | The exact split-witness relation is an explicit structure field; Lean checks its arithmetic consequences, and the member-by-member root count is a manuscript proof. |
| `prop:r5-fibre-is-elliptic` | no direct declaration | Manuscript proof identifying the fibre square with the residual-discriminant double cover and hence with the cited incidence curve. |
| `lem:r5-branch` | `PRSRedundancyFive.ExactSplitWitnessCount.branchBudget`; `ExactSplitWitnessCount.fibreSquarePoints_le_twelve`; `nonSplitWeight_le_twelve`; `nonSplitWeight_le_six_of_characteristicTwoBranchBudget`; `fibreSquarePoints_le_six_of_characteristicTwoBranchBudget` | The tame Riemann--Hurwitz budget is a structure field, and the sharper characteristic-two budget is a hypothesis of the last two theorems; the twelve-point and six-point bounds on a split-free fibre square are kernel checked. |
| `cor:r5-equidistribution` | `PRSRedundancyFive.ExactSplitWitnessCount.splitMembers_bounds` | Kernel checked over the reals from the exact count, a bound `B` on the non-split weight, and the two-sided point bound; `B` is instantiated by the two branch-budget theorems and the point bound is imported by citation. |
| `cor:r5-binary-shallow` | `PRSRedundancyFive.splitMembers_pos_of_characteristicTwoBranchBudget`; `fieldOrder_le_twelve_of_characteristicTwoSplitFree` | Kernel checked from the characteristic-two branch budget and the Aubry--Perret range in squared integer form; it removes `q=16` from `requiredBridgeFieldOrders`, and the monodromy geometry is a manuscript proof. |
| `lem:s3` | `PRSRedundancyFive.fieldOrder_le_nineteen_of_splitFree` | The step from the twelve-point bound and the Aubry--Perret range to the field bound is kernel checked; the point bound itself is imported by citation and the monodromy geometry is a manuscript proof. |
| `cor:r5-forced` | `PRSRedundancyFive.ExactSplitWitnessCount.fibreSquareInvariants_of_splitFree` | Kernel checked from the branch budget and the point bound in squared integer form; the Lean statement needs only `17 <= q <= 19`, without the manuscript's oddness hypothesis. |
| `prop:r5-bridge` | `PRSRedundancyFive.requiredBridgeFieldOrders`; `PRSRedundancyFiveCertified.requiredBridgeFieldOrders_subset_certifiedBridgeFieldOrders`; `certifiedBridgeFieldOrders_exceed_required_only_at_sixteen`; `PRSRedundancyFiveCertificate.certified_comparison_band_has_no_sporadic`; `certified_orbit_summaries_agree_with_sporadic_records`; `CertificateValidation` | Transcription and arithmetic are kernel checked, as is the separation of the seven required bridge fields from the certificate's wider sub-threshold domain, which exceeds them only at `q=16`. Identification and exhaustive-search semantics remain explicit validation fields. |
| `thm:polar-construction` | `PRSPolarInduction.iteratedProjectiveSequenceContraction_map`; `sequenceContraction_agrees_with_finite`; `PointedKernelLift.lift_splitSquarefreeKernelMember` | Kernel algebra and a conditional squarefree-lift terminal. The polynomial/kernel identification is an input. |
| `lem:marker-collision` | no direct declaration | Manuscript marker-collision proof. |
| `lem:uniform-collision` | no direct declaration | Manuscript separability and collision-degree proof. |
| `lem:linear-modular-pullback` | `PRSPolarInduction.mem_modularContractionKernel_iff` | The abstract modular-kernel criterion is checked; the degree-specific linear pullback is a manuscript proof. |
| `lem:old-marker-fixed-factor` | no direct declaration | Manuscript evaluation-minor and non-identical-vanishing proof; the degree bound enters the formal package as an explicit field. |
| `lem:exact-linear-gcd-transport` | `PRSUniformCoveringRadius.exactLinearFlagParameterBudget_lt_uniformParameterBudget` and `UniformIteratedPackageInput.packages_fit_uniform_threshold` | The factor-preserving flag’s budget and simultaneous threshold use are kernel checked. Preservation of the concrete gcd under contraction is the displayed manuscript proof and an explicit formal input. |
| `lem:identically-colliding` | no direct declaration | Manuscript reduction to the two inseparable fixed-level calculations. |
| `thm:induction` | `PRSPolarInduction.iteratedProjectiveSequenceContraction_map`; `sequenceContraction_agrees_with_finite`; `CoherentPolarInput.splitFree_implies_persistent_or_modular` | Iterated contraction and lifting algebra are kernel checked. The finite-depth marker choices and terminal point-count argument are the printed manuscript proof; concrete stagewise carrier and lower-package hypotheses remain manuscript or certificate inputs. |
| `prop:contained-rank-two` | no direct declaration | Characteristic-free manuscript rank--nullity proof; degree-specific formal terminals consume its consequence as an input. |
| `prop:r6-persistent` | `PRSRedundancySixSeven.PersistentModularFamilyData.classified_card_doubled`; `PRSPolarInduction.fifthPower_sigmaInversionOrbitCount`; tangent-translation terminals | Cardinality and quotient arithmetic are checked; genuine actions and geometric family identification are inputs. |
| `lem:r6-gcd1` | no direct declaration | Manuscript proof of exact-linear-gcd shallowness. |
| `prop:r6-secant` | `PRSPolarInduction.sequenceContraction_agrees_with_finite` | Contraction algebra is checked; the secant-degree assertion is a manuscript proof. |
| `prop:r6-lower-carrier` | no direct declaration | Manuscript monodromy trichotomy and characteristic-two/three specialization proving exhaustion of the lower trivial-gcd failure loci. |
| `prop:r6-degrees` | no direct declaration | Manuscript component and divisor-degree proof; its bounds enter the polar terminal as hypotheses. |
| `prop:r6-modular` | `PRSPolarInduction.mem_modularContractionKernel_iff` | The abstract modular kernel is checked; the concrete component classification is a manuscript proof. |
| `prop:r6-nucleus` | no direct declaration | Manuscript binary-nucleus arithmetic and splitting proof, supported by Certificate R6. |
| `prop:r6-contained` | no direct declaration | Manuscript exhaustion of contained alternatives. |
| `prop:r6-one-step` | `PRSRedundancySixSeven.redundancySixHighFieldSynthesis` | Conditional specialization of the one-step budgets; the geometric inputs remain hypotheses. |
| `thm:r6` | `PRSRedundancySixSeven.redundancySixAllFieldSynthesis`; `PRSRedundancySixSevenCertificate.redundancySix_count_exhaustion`; `PRSUniformCoveringRadius.SeroussiRothDuerRadiusInput.seroussiRothDimensionRange_six_eight`; `radiusRange_six_eight_of_externalSeroussiRothDuer` | Conditional synthesis plus kernel-checked finite-row arithmetic and the exact \(q=8,r=6\) high-rate endpoint. The concrete coding identifications and cited radius implications remain explicit inputs. |
| `prop:r7-pointed` | `PRSPolarInduction.LowerCoverStratum`; `CoherentPolarInput.splitFree_implies_persistent_or_modular` | The conditional interface and its witness use are checked. The two-marker cover, deletion degree `25`, and point-count derivation are manuscript mathematics, not Lean conclusions. |
| `prop:r7-gcd1` | no direct declaration | Manuscript exact-gcd-one avoidance proof; the exactness hypothesis is explicit. |
| `prop:r7-collision` | no direct declaration | Manuscript degree computation, supplied as a collision-budget input to Lean. |
| `prop:r7-central` | no direct declaration | Manuscript central-lift and inverse-image proof, supported by Certificate R7. |
| `cor:r7-contained` | no direct declaration | Manuscript rank--nullity and component proof; the R7 synthesis structure takes the result as an explicit input. |
| `thm:r7` | `PRSRedundancySixSeven.redundancySevenAllFieldSynthesis`; `PRSRedundancySixSevenCertificate.redundancySeven_count_exhaustion` | Conditional synthesis and finite-row arithmetic. The paper-local `q=7,8,9` rows are not promoted by Lean; at `q=8` the separately imported radius and executable exact-distance extraction (diagonal tangent plus central nucleus) lie outside this formal aggregate. |

| `thm:main` | no direct declaration | Manuscript synthesis of the pointed simultaneous-marker theorem, reduced carrier, rank-two arithmetic, and imported radius/extension gate. Lean does not formalize the point-deleted-support shell classification or its counts. |
| `prop:reduced-terminal-carrier` | no direct declaration | Manuscript prime-decomposition proof plus the stable-component elimination certificates. Lean does not prove the concrete primary ideals or exceptional-fibre equations. |
| `prop:maximal-lucas-union` | no direct declaration | Manuscript Lucas/Pascal proof. The degree-one pullback enters the formal recursive interface as an explicit geometric input. |
| `prop:persistent-count-orbits` | no direct declaration | Elementary uniform rank-two count and stabilizer calculation. The established full-support family/count boundary is cited in the proof; no Lean declaration carries the orbit classification. |
| `prop:recursive-component-selection` | 'PRSSquarefreeMarkerDensity.eq_zero_of_splitCoefficientPullback_eval_eq_zero_on_injective'; 'PRSStableComponents.RecursiveContainedGeometryInput.bad_implies_persistent_or_modular' | Polynomial density, closure transport, finite-component selection, and recursive logical composition are kernel checked. The marker-to-rowspace identification and concrete component classification are manuscript inputs. |
| `thm:recursive-carrier` | no direct declaration | Manuscript consequence of the reduced recursive carrier and simultaneous-marker theorem. The prior stagewise conditional Lean synthesis is strictly weaker and is not cited as coverage. |
| `thm:composite-contraction` | no direct declaration | Manuscript proof from the divided-power pairing. Existing Lean contraction fragments do not state the composite theorem at this generality. |
| `lem:vandermonde-grid` | no direct declaration | Elementary manuscript polynomial-evaluation proof. |
| `lem:terminal-selector` | no direct declaration | Manuscript separator proof from the certified reduced terminal decomposition and irreducibility of the catalecticant row space; it also proves the exact separate-degree and field-of-definition bounds. |
| `thm:simultaneous-marker-escape` | no direct declaration | Manuscript proof from the concrete reduced-carrier converse, the degree-six selector, the Vandermonde grid lemma, and the exact R5 count. No computation or Lean theorem supplies the arbitrary-redundancy escape. |
| `cor:split-witness-abundance` | no direct declaration | Manuscript Schwartz--Zippel, deletion, and decomposition-multiplicity count. |
| `cor:one-column-extensions` | no direct declaration | Manuscript circuit proof and dual-distance argument; the MDS deep-shell input is imported separately in the surrounding theorem. |
| `thm:family-aggregate-nmds` | no direct declaration | Manuscript family-wise incidence double count followed by the cited standard NMDS recurrence. |
| `prop:upper-radius` | radius bridge terminals | The manuscript applies the cited Seroussi--Roth and Dür theorems; Lean keeps those coding inputs explicit. |

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

In the separate public Lean repository, from its repository root, the
aggregate gate is:

```text
nix develop --command lake build \
  RelativeConicArcs.Gates.PRSBeyondRedundancyFourAxiomAudit \
  RelativeConicArcs.Gates.PRSBeyondRedundancyFour
```

The paper-local verifier independently checks that the statement table has
exactly the current TeX label set and that the aggregate and audit source
have exactly the declared target sets.  The balanced quantum bridge has its
own formal gate in the development repository; it is not part of this
17-source-file paper export and no replay command for it is advertised here.
