# Formalization ledger

The shared definitions are fixed in
`RelativeConicArcs.AMELU.Definitions`, with import-only terminal
`RelativeConicArcs.Gates.AMELUDefinitions`.  The dictionary is proved
unconditionally.  The admitted-pencil classification now has a
hypothesis-explicit Lean interface; it is not adopted as an unconditional
formal proof of its geometric and holonomy inputs.

| Manuscript result | Formal status | Unformalized boundary | Action |
|---|---|---|---|
| `thm:dictionary` | complete in `RelativeConicArcs.AMELU.Dictionary` and `RelativeConicArcs.AMELU.StabilizerDictionary`: arc-to-`[6,3,4]`, AME equivalence for equal-phase states, projective-to-monomial-to-LC, tensor Weyl stabilizers, CSS Lagrangian/support, and minimum computational support | none at statement level | unconditional formal coverage adopted |
| `thm:lc-pencil` | algebraic quotient complete in `RelativeConicArcs.AMELU.PencilClassification`; `admitted_nonGRS_pencil_classified_by_z` proves the field-linear projective/monomial/LC interface from `PencilClassificationInputs` | six-arc verification, explicit projectivity construction, complementary-bracket invariance, and LC holonomy recovery are four named hypotheses; the manuscript identifies this with the full quantum Clifford group only over prime fields | cite only as a conditional formal interface; do not infer extension-field full-Clifford classification |
| `cor:lu-lc-pencil` | `locallyUnitaryEquivalent_admitted_nonGRS_pencil_iff_pencilZ_eq` completes the six-party LU composition from `PencilClassificationInputs` | the same four geometric and LC-holonomy fields used by the conditional LC classification; identification with the full quantum Clifford group remains prime-field only | cite as a conditional formal interface, with the prime-field manuscript scope explicit |
| `thm:lu-h3-grs` | conditional interface complete in `RelativeConicArcs.AMELU.MarginalMoment`: concrete CSS supported-space rank, exact 455/60/15 graph counts, `60+b` reduction, rank-four trace specialization, and `70>66` LU-separation implication | density-matrix trace expansion, chord-concurrency/rank equivalence, H3 determinant ten-count, GRS involution six-bound, and LU covariance are explicit hypotheses | cite the finite graph core and conditional separator separately |
| `thm:logical-phase`; `cor:six-arc-fixed-party-group` | `fixedPartyKernel_eq_specialLinear_or_splitTorus` proves the conditional exact `SL₂`/split-torus linear dichotomy; `fixedPartyProjectiveTransversal_eq_affineSpecialLinear_or_splitTorus` proves the corresponding exact affine carriers | the geometric propagation facts remain fields of `LogicalPhaseInputs`; `FixedPartyProjectiveTransversalInputs.transversal_iff_linear_mem` is the explicit complete-translation-fiber hypothesis; extension-field full Clifford blocks and uniform party-moving groups are not formalized | cite the conditional Lean interfaces for the exact fixed-party linear and affine carriers only over prime fields |
| `thm:q13-lu` | conditional interface complete in `RelativeConicArcs.AMELU.FourCopyContraction`: concrete matching map/rank, exact q=13 generators and four-copy pattern, proved common-bra normalization to `σ₁=id`, rational orbit-sum formula, proved party-relabel invariance, and `q13_zFour_not_locallyUnitaryEquivalent_zTwelve` | solution-counting contraction/rank bridge, LU covariance, and the `720/3024` finite rank evaluations are explicit certificate inputs | cite the concrete definitions and conditional terminal implication |
| `thm:transport-divisor` | conditional interface complete in `RelativeConicArcs.AMELU.TransportDivisor`: parametric `9 × 9` block operator, all three cycle-polynomial factorizations, exact homogeneous and `(z-2)(9z-4)` divisors, rank-excess arithmetic, characteristic-seven doubled scheme and zero-set merger, and `96+192=288` support count | the fixed quotient-action matrices are not instantiated; the three determinant expansions, systematic rank bridge, generic one-dimensional kernel, and double-coset support construction/cardinalities/disjointness are explicit fields of `TransportCycleCoverInputs`, `TransportRankBridgeInputs`, and `TransportOrbitGeometryInputs` | cite the unconditional algebra and conditional transport inputs separately |
| `prop:full-weyl-marginal`; `cor:full-weyl-cover`; `thm:lu-lc-rigidity`; `cor:transversal-clifford` | `all_isClifford_of_fullWeylDiagonal_intertwining` formalizes the full-Weyl local criterion; the diagonal-axis theorem and unconditional arbitrary-\(m\) rigidity remain in `GenericMarginal`, `GenericMarginalCovariance`, `GenericTensorRigidity`, and `GenericLURigidity`, together with `EncoderTransversal`'s exact Choi and Clifford-closure terminals | the abstract state-cover corollary is not a separate Lean terminal; Lean checks the full-Weyl local criterion and its MDS cover specialization. `EncoderConversionInputs.choi_conversion` states the forward normalized Choi equation; no encoder matrix API is introduced | cite Lean for the local criterion, diagonal-axis core, full all-prime-power/all-\(m\geq2\) MDS LU-to-LC theorem, and factorwise transversal no-go; keep only the abstract cover packaging manuscript-level |
| `cor:discrete-lu-symmetry`; `prop:diagonal-multiplier-line`; `rem:veronese-phase-test`; `cor:diagonal-isodual-transversal-group` | `AutomorphismExactSequence` proves the continuous closed scalar-torus exact sequences, closed Hausdorff discrete intrinsic Clifford quotient, finite scalar-torus component covers, finite discrete fixed-party and party-permuted quotients, intrinsic signature identifications, and exact realized party-permutation extension.  `NonabelianExtensionInvariant` constructs the canonical outer action by descent, the normalized factor set, its ordered nonabelian associativity and change-of-section laws, and the equivalence between factor-set trivializability and a homomorphic splitting.  `EncoderTransversal` defines diagonal isoduality without an evaluation-code presentation and proves the conditional exact affine-special-linear/split-torus carrier dichotomy and the order-16464 specialization.  `DiagonalIsoduality` proves the arbitrary-length MDS diagonal-multiplier full-support and bijectivity lemmas, the zero-or-one-dimensional multiplier space, the exact nullity test, reconstruction and projective uniqueness of the witness, canonical coordinate ratios, and the one-nondiagonal-block bootstrap through the carrier interface. | `DiagonalIsodualityTransversalInputs` still leaves special-linearity, torus propagation, diagonal-isodual propagation, the block-action-to-multiplier converse, and the complete affine translation fiber as explicit fields.  The multiplier-space proposition is unconditional in Lean, while its generator-matrix/Veronese presentation is a manuscript proof.  The remaining action bridge and Pauli quotient are manuscript proofs.  The odd-field Weil lift on the isodual branch's linear `SL_2(q)` factor and the Weyl-commutator obstruction for the full affine scalar extension are not formalized.  Neither claim supplies a cochain for the separate realized party-permutation factor set. | cite Lean unconditionally for `cor:discrete-lu-symmetry`, the intrinsic multiplier-space/nullity theorem, and witness uniqueness; cite the Veronese presentation as paper proof and the exact carrier dichotomy as a conditional formal interface; cite the action bridge and scalar lift boundary as manuscript proofs and do not transfer them to the party-permutation extension |
| `cor:computed-party-splitting` | `PartyExtensionSplitting` constructs the trivializing cochain from a homomorphic complement and proves its ordered coboundary identity, the semidirect-product equivalence, unique kernel--quotient coordinates, cardinality product, and the inverting-involution witness; the corresponding `genericPartyPermutation*` declarations specialize these consequences to the realized AME--LU extension | the twelve C624 complement witnesses, their preservation of the CSS Lagrangians, completeness of the party images, and the parity action on each concrete fixed kernel are external exact certificate data | cite Lean for every abstract consequence after a complement is supplied; cite the paper-local C624 certificate, not Lean, for existence of the twelve complements |

The declaration-level comparison with the manuscript is recorded in
`formal-statement-adequacy.md`.  The aggregate import is
`RelativeConicArcs.Gates.AMELUAggregate`, its audit is
`RelativeConicArcs.Gates.AMELUAggregateAxioms`, and the checked toolchain is
Lean `v4.32.0-rc1`.

The aggregate audit reports only `propext`, `Classical.choice`, and
`Quot.sound` outside the marginal graph census.  The exhaustive
`native_decide` proofs of the 455 marginal triples, 60 stars, and 15 perfect
matchings additionally expose their three declaration-local native axioms;
no other audited terminal depends on native evaluation.

The stabilizer dictionary exits through
`RelativeConicArcs.Gates.AMELUStabilizerDictionary` and
`RelativeConicArcs.Gates.AMELUStabilizerDictionaryAxioms`.  Its paper-facing
terminals depend only on `propext`, `Classical.choice`, and `Quot.sound`;
there is no native evaluation, generated source, external certificate,
project-specific axiom, or admitted declaration.

The transport divisor exits through
`RelativeConicArcs.Gates.AMELUTransportDivisor` and
`RelativeConicArcs.Gates.AMELUTransportDivisorAxioms`.  Its paper-facing
terminals depend only on `propext`, `Classical.choice`, and `Quot.sound`;
there is no native evaluation, generated source, external certificate
declaration, project-specific axiom, or admitted declaration.

The admitted-pencil package exits through
`RelativeConicArcs.Gates.AMELUPencilClassification` and
`RelativeConicArcs.Gates.AMELUPencilClassificationAxioms`.  Its audited
terminals depend only on `propext`, `Classical.choice`, and `Quot.sound`;
there is no native evaluation, generated source, external certificate,
project-specific axiom, or admitted declaration.

The logical-phase and four-copy package exits through
`RelativeConicArcs.Gates.AMELULogicalPhaseFourCopy` and
`RelativeConicArcs.Gates.AMELULogicalPhaseFourCopyAxioms`.  Its audited
terminals depend only on `propext`, `Classical.choice`, and `Quot.sound`.
The two finite contraction evaluations remain fields of
`FourCopySeparatorInputs`; they are not hidden as native evaluation,
generated declarations, project-specific axioms, or admitted declarations.
