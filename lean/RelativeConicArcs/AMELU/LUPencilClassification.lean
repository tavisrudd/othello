import RelativeConicArcs.AMELU.LURigidity
import RelativeConicArcs.AMELU.PencilClassification

/-!
# Local-unitary classification of the admitted non-GRS pencil

The general LU-to-LC rigidity theorem upgrades the existing
local-Clifford classification of the admitted pencil.  Consequently two
admitted equal-phase pencil states are locally unitarily equivalent
exactly when their scalar pencil invariants agree.

All arguments are symbolic and kernel checked.  The module contains no
generated data, native evaluation, axioms, or admitted declarations.
-/

namespace RelativeConicArcs.AMELU

variable {𝔽 : Type*} [Field 𝔽] [Fintype 𝔽] [DecidableEq 𝔽]

/-- For admitted members of the non-GRS pencil, local-unitary
equivalence of the associated equal-phase states is classified exactly
by the scalar invariant `pencilZ`. -/
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
