import RelativeConicArcs.PRSRedundancyFiveCertificate
import RelativeConicArcs.AMELU.GenericLURigidity
import RelativeConicArcs.AMELU.EncoderTransversal

/-!
# Balanced quantum consequence of the redundancy-five extension table

The redundancy-five projective Reed--Solomon certificate has one row whose
one-column extension is balanced: at field order eight, a `[9,4,6]` MDS code
extends to a `[10,5,6]` MDS code.  This module checks the exact certificate
row, its `1116 = 360 + 756` decomposition, and the fact that this is the
unique balanced prime-power parameter among redundancies five through seven.

The standard MDS-to-AME and AME-to-quantum-code correspondences are exposed
through an explicit proposition-valued interface; their mathematical
semantics remain cited inputs rather than definitions reconstructed here.
The local-unitary and transversal-Clifford conclusions are genuine
specializations of the kernel-checked length-generic MDS--CSS theorems.

No generated data, native evaluation, project-local axiom, or admitted
declaration is used.
-/

namespace RelativeConicArcs.PRSBalancedQuantumExtension

open PRSRedundancyFiveCertificate
open AMELU

/-- The exact field-eight row transcribed from the public redundancy-five
certificate. -/
def fieldEightRecord : CertifiedFieldRecord where
  fieldOrder := 8
  classifiedSplitFreeCount := 1116
  nonsporadicOrbitCount := 4
  projectiveOrbitCount := 7
  semilinearOrbitCount := 5
  sporadicPoints := 756
  exhaustive := true
  radiusFour := true

/-- The field-eight summary is one of the certified finite-field rows. -/
theorem fieldEightRecord_mem_certifiedFieldRecords :
    fieldEightRecord ∈ certifiedFieldRecords := by
  decide

/-- The certified field-eight projective directions split into the exact
nonsporadic and sporadic totals printed in the classification table. -/
theorem fieldEight_projectiveDirectionCount :
    fieldEightRecord.classifiedSplitFreeCount = 1116 ∧
      1116 = 360 + fieldEightRecord.sporadicPoints ∧
      fieldEightRecord.sporadicPoints = 756 := by
  norm_num [fieldEightRecord]

/-- The field-eight redundancy-five extension has classical parameters
`[9,4,6] → [10,5,6]`, and the extended length is twice its dimension. -/
theorem fieldEight_balancedExtensionParameters :
    9 - 4 = 5 ∧ 9 - 4 + 1 = 6 ∧
      10 - 5 = 5 ∧ 10 - 5 + 1 = 6 ∧
      10 = 2 * 5 := by
  norm_num

/-- Among redundancies five, six, and seven, the balance equation
`q + 2 = 2r` with prime-power field order forces `(r,q)=(5,8)`. -/
theorem fieldEight_uniqueBalancedPrimePowerRow
    {r q : ℕ}
    (hr : r = 5 ∨ r = 6 ∨ r = 7)
    (hbalance : q + 2 = 2 * r)
    (hq : IsPrimePow q) :
    r = 5 ∧ q = 8 := by
  rcases hr with rfl | rfl | rfl
  · omega
  · have hq10 : q = 10 := by omega
    subst q
    exact False.elim ((by decide : ¬ IsPrimePow 10) hq)
  · have hq12 : q = 12 := by omega
    subst q
    exact False.elim ((by decide : ¬ IsPrimePow 12) hq)

/-- Proposition-valued trust interface for the standard quantum dictionaries
used by the balanced extension corollary.  `isMDS` describes the classical
`[10,5,6]` extension, while the other fields state exactly the two imported
quantum consequences. -/
structure QuantumDictionary (Extension : Type*) where
  isMDS : Extension → Prop
  isMinimumSupportAME10 : Extension → Prop
  isQuantumMDS915 : Extension → Prop
  mds_to_ame : ∀ D, isMDS D → isMinimumSupportAME10 D
  ame_to_quantumMDS : ∀ D, isMinimumSupportAME10 D → isQuantumMDS915 D

/-- A certified family of `1116` balanced MDS extensions inherits the AME and
`[[9,1,5]]` conclusions from an explicit quantum-dictionary interface. -/
theorem certifiedBalancedExtensions_haveQuantumConsequences
    {Extension : Type*} [Fintype Extension]
    (dictionary : QuantumDictionary Extension)
    (hcount : Fintype.card Extension = 1116)
    (hMDS : ∀ D, dictionary.isMDS D) :
    Fintype.card Extension = 360 + 756 ∧
      ∀ D, dictionary.isMinimumSupportAME10 D ∧
        dictionary.isQuantumMDS915 D := by
  constructor
  · omega
  · intro D
    have hAME := dictionary.mds_to_ame D (hMDS D)
    exact ⟨hAME, dictionary.ame_to_quantumMDS D hAME⟩

/-- For length ten exact MDS equal-phase states, local-unitary equivalence is
local-Clifford equivalence over every finite field. -/
theorem lengthTen_locallyUnitaryEquivalent_implies_locallyCliffordEquivalent
    {𝔽 : Type*} [Field 𝔽] [Fintype 𝔽] [DecidableEq 𝔽]
    (w : WeylConvention 𝔽)
    {C D : Submodule 𝔽 (GenericBasisLabel 5 𝔽)}
    (hC : IsMDSCode2m C) (hD : IsMDSCode2m D)
    (hLU :
      GenericLocallyUnitaryEquivalent
        (genericEqualPhaseState C) (genericEqualPhaseState D)) :
    GenericLocallyCliffordEquivalent w
      (genericEqualPhaseState C) (genericEqualPhaseState D) :=
  genericLocallyUnitaryEquivalent_equalPhaseState_implies_genericLocallyCliffordEquivalent
    (m := 5) (by norm_num) w hC hD hLU

/-- A transversal conversion between length-ten exact MDS encoders is
Clifford on the logical qudit and on every physical qudit. -/
theorem lengthTen_encoderConversion_logical_and_physical_isClifford
    {𝔽 : Type*} [Field 𝔽] [Fintype 𝔽] [DecidableEq 𝔽]
    (w : WeylConvention 𝔽)
    (input : GenericParty 5)
    {C D : Submodule 𝔽 (GenericBasisLabel 5 𝔽)}
    (L : LocalMatrix 𝔽)
    (U : {i : GenericParty 5 // i ≠ input} → LocalMatrix 𝔽)
    (inputs : EncoderConversionInputs input C D L U) :
    IsCliffordMatrix w L ∧
      ∀ i, IsCliffordMatrix w (U i) :=
  encoderConversion_logical_and_physical_isClifford
    (m := 5) (by norm_num) w input L U inputs

end RelativeConicArcs.PRSBalancedQuantumExtension
