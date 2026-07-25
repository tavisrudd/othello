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
| `thm:logical-phase` | fixed-party conditional field-linear interface complete in `RelativeConicArcs.AMELU.LogicalPhase`: `fixedPartyKernel_eq_specialLinear_or_splitTorus` proves the exact `SL₂`-block dichotomy | special-linearity, torus propagation, conic propagation of all `SL₂` blocks, and the off-diagonal-to-conic implication are four named hypotheses; extension-field full Clifford blocks and the party-moving isoduality/normalizer clause are not formalized | identify the interface with the full quantum kernel only over prime fields |
| `thm:q13-lu` | conditional interface complete in `RelativeConicArcs.AMELU.FourCopyContraction`: concrete matching map/rank, exact q=13 generators and four-copy pattern, proved common-bra normalization to `σ₁=id`, rational orbit-sum formula, proved party-relabel invariance, and `q13_zFour_not_locallyUnitaryEquivalent_zTwelve` | solution-counting contraction/rank bridge, LU covariance, and the `720/3024` finite rank evaluations are explicit certificate inputs | cite the concrete definitions and conditional terminal implication |
| `thm:transport-divisor` | conditional interface complete in `RelativeConicArcs.AMELU.TransportDivisor`: parametric `9 × 9` block operator, all three cycle-polynomial factorizations, exact homogeneous and `(z-2)(9z-4)` divisors, rank-excess arithmetic, characteristic-seven doubled scheme and zero-set merger, and `96+192=288` support count | the fixed quotient-action matrices are not instantiated; the three determinant expansions, systematic rank bridge, generic one-dimensional kernel, and double-coset support construction/cardinalities/disjointness are explicit fields of `TransportCycleCoverInputs`, `TransportRankBridgeInputs`, and `TransportOrbitGeometryInputs` | cite the unconditional algebra and conditional transport inputs separately |
| `thm:lu-lc-rigidity`; `cor:transversal-clifford` | unconditional arbitrary-\(m\) rigidity in `GenericMarginal`, `GenericMarginalCovariance`, `GenericTensorRigidity`, and `GenericLURigidity`, together with `EncoderTransversal`'s exact inverse-transpose Choi orientation, canonical inverse-transpose witness for every logical unitary, Clifford adjoint/conjugation/transpose closure, and `encoderConversion_logical_and_physical_isClifford` | `EncoderConversionInputs.choi_conversion` states the forward normalized Choi equation; no encoder matrix API is introduced | cite Lean for the full all-prime-power, all-\(m\geq2\) LU-to-LC theorem and the factorwise transversal no-go from the displayed Choi conversion data |
| `cor:discrete-lu-symmetry`; `cor:grs-transversal-group` | `AutomorphismExactSequence` proves the continuous closed scalar-torus exact sequences, closed Hausdorff discrete intrinsic Clifford quotient, finite scalar-torus component covers, finite discrete fixed-party and party-permuted quotients, intrinsic signature identifications, and exact realized party-permutation extension.  `NonabelianExtensionInvariant` constructs the canonical outer action by descent, the normalized factor set, its ordered nonabelian associativity and change-of-section laws, and the equivalence between factor-set trivializability and a homomorphic splitting.  `EncoderTransversal` checks the exact affine-special-linear carrier interface and order-16464 specialization. | `GRSTransversalInputs` leaves the generalized/extended GRS code construction, phase-corrected Clifford lifts, logical Pauli representatives, elementary generation, and no-go converse as explicit fields.  Its generator representatives do not give the normalized cochain that trivializes the realized party-permutation factor set. | cite Lean unconditionally for `cor:discrete-lu-symmetry`; cite the exact GRS equality as a conditional formal interface and do not infer factor-set triviality from generator-by-generator lifts |

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
