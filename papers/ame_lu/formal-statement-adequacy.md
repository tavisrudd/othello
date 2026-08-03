# Formal statement adequacy

This ledger compares Paper I's manuscript claims with the exact declarations
currently available under `RelativeConicArcs.AMELU`. The current import
surface is the pre-split `RelativeConicArcs.Gates.AMELUAggregate`; it is not a
Paper I release gate.

| Manuscript result | Exact Lean surface | Adequacy verdict | Visible boundary |
|---|---|---|---|
| `prop:stabilizer-ame-support`; `prop:full-weyl-marginal`; `cor:full-weyl-cover`; `thm:lu-lc-rigidity` | `stabilizerCoordinateRestriction_eq_zero_iff`, `stabilizerKernelLocalProjection_injective_of_supportAtMost`, `stabilizerAME_halfParty_kernelToLocal_bijective_of_finrank`, `stabilizerKernelLocalProjection_existsUnique`; `AdditiveStabilizerProjector.supportedLocalProjection_bijective`, both `reindexedMarginalArray_eq_diagonal` declarations, `additiveStabilizer_reindexedMarginalArray_intertwining`, `additiveStabilizer_all_isClifford_of_localAction`, its party-relabeled form, and `additiveStabilizer_locallyUnitaryEquivalent_implies_locallyCliffordEquivalent` | arbitrary-additive support profile, phased marginal, covariance, axis recovery, and fixed/relabeled LU-to-LC implications are kernel checked above the explicit stabilizer-projector realization | the manuscript identifies its concrete state notation and party relabelling with that interface; no paper-specific gate has yet frozen the recursive closure |
| `thm:atlas-classification` | `AMESupportedSubspaceProfile.erase_sup_erase_eq`, `space_eq_minimumSupportSpan`, `minimumSupportSpan_univ_eq_top`, `minimumSupportTransition_apply_supportedLabel`, the `MinimumSupportAtlasEquivalent` relation, `HolonomyAtlas.compatibleGaugeEquivHolonomyCentralizer`, `compatibleGaugesInSubgroupEquiv`, and `compatibleGaugesInNormalSubgroupEquiv` | support generation, atlas transitions/equivalence, and abstract holonomy reduction are kernel checked | the manuscript proves that atlas equivalence matches the global label spaces and packages the symmetry-group exact sequence |
| `lem:pauli-phase-correction` | `pauliSymplecticToDual_injective`, `exists_pauliLabel_pairing_eq_dual` | stabilizer-character correction algebra is kernel checked | the corrected state-ray conclusion is a manuscript step |
| `cor:transversal-clifford` | `encoderConversion_inverseTranspose_chosenLeg`, the `IsCliffordMatrix` closure declarations, and `encoderConversion_logical_and_physical_isClifford` | Choi orientation and Clifford closure are kernel checked | `EncoderTransversal` also contains Paper II carrier material; the Paper I gate must review its import closure rather than import by filename glob |
| `lem:local-generator-isometry` and the continuous-symmetry core | `Multipartite` generator splitting, single-exponential identity, polarized second-moment identity, product-map algebra, and nonscalar-generator exclusion | named exact cores are unconditional | topological finiteness, every quantitative stability estimate, and inverse threshold are manuscript only |
| `lem:quantitative-cleaning-commutator`; `lem:nested-weyl-rounding`; `thm:cleaning-global-rounding`; `prop:robust-linear-atlas` | none | not formalized | entire cleaning, Fourier, overlap-gap composition, robust compatibility, constants, and affine obstruction are manuscript proofs |
| Appendix A partial-Weyl recognition | none | not formalized | complete manuscript proof only |
| Appendix B alternative quantitative routes | no declarations beyond the multipartite core above | quantitative axes, single-marginal and aggregate rounding, budget-free residual theorem, overlap quantization, and 2-unitary gauge corollary are not formalized | no numerical or certificate evidence is claimed |

## Trust summary

Under Lean `v4.32.0-rc1`, the named audited declarations report only
`propext`, `Classical.choice`, and `Quot.sound`. Conditional structures are
mathematical hypotheses, not Lean axioms; statement adequacy and axiom trust
therefore answer different questions.

The planned Paper I roots are
`RelativeConicArcs.Gates.AMEStabilizerRigidity` and
`RelativeConicArcs.Gates.AMEStabilizerRigidityAxioms`. Until those roots and
their recursive contract are created and validated, the pre-split aggregate
must not be presented as Paper I's content-addressed formal closure.
