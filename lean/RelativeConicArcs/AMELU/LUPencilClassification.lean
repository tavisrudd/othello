import RelativeConicArcs.AMELU.LURigidity
import RelativeConicArcs.AMELU.PencilClassification

/-!
# Local-unitary classification of the admitted non-GRS pencil

Assuming `PencilClassificationInputs`, LU-to-LC rigidity upgrades the
field-linear local-Clifford classification of the admitted pencil to an LU
classification by `pencilZ`.  The input structure is an explicit hypothesis:
this module does not derive the LC-to-`pencilZ` implication for the full
additive Clifford relation over extension fields.

All arguments are symbolic and kernel checked.  The module contains no
generated data, native evaluation, axioms, or admitted declarations.
-/

namespace RelativeConicArcs.AMELU

variable {𝔽 : Type*} [Field 𝔽] [Fintype 𝔽] [DecidableEq 𝔽]

/-- Under `PencilClassificationInputs`, admitted pencil states are locally
unitarily equivalent exactly when their `pencilZ` invariants agree. -/
theorem locallyUnitaryEquivalent_admitted_nonGRS_pencil_iff_pencilZ_eq
    (w : WeylConvention 𝔽) (inputs : PencilClassificationInputs 𝔽 w)
    {t u : 𝔽} (ht : IsAdmittedNonGRSParameter t)
    (hu : IsAdmittedNonGRSParameter u) :
    LocallyUnitaryEquivalent
        (equalPhaseState (arcKernel (nonGRSPencil t)))
        (equalPhaseState (arcKernel (nonGRSPencil u))) ↔
      pencilZ t = pencilZ u := by
  have hCt : IsMDSCode634 (arcKernel (nonGRSPencil t)) :=
    isMDSCode634_arcKernel (inputs.admitted_isSixArc t ht)
  have hCu : IsMDSCode634 (arcKernel (nonGRSPencil u)) :=
    isMDSCode634_arcKernel (inputs.admitted_isSixArc u hu)
  have hlc_iff :
      LocallyCliffordEquivalent w
          (equalPhaseState (arcKernel (nonGRSPencil t)))
          (equalPhaseState (arcKernel (nonGRSPencil u))) ↔
        pencilZ t = pencilZ u :=
    (admitted_nonGRS_pencil_classified_by_z w inputs ht hu).2.2
  constructor
  · intro hLU
    exact hlc_iff.mp
      (locallyUnitaryEquivalent_equalPhaseState_implies_locallyCliffordEquivalent
        w hCt hCu hLU)
  · intro hz
    exact locallyCliffordEquivalent_implies_locallyUnitaryEquivalent w
      (hlc_iff.mpr hz)

end RelativeConicArcs.AMELU
