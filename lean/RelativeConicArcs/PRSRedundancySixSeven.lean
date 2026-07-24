import RelativeConicArcs.PRSRedundancySixSevenCertificate

/-!
# Polar-inductive synthesis for redundancies six and seven

This module specializes the coherent contained-versus-transverse interface to the exact numerical
boundaries used for projective Reed--Solomon redundancies six and seven.  Redundancy six uses lower
splitting-cover threshold `29`, transverse-carrier budget `7`, and collision budget `6`.
Redundancy seven uses threshold `37`, transverse-carrier budget `4`, and collision budget `8`.

The conclusions are conditional on named geometric, coding, and finite-certificate inputs.
In particular, the structures do not assert geometric integrality of a splitting cover, classify
contained catalecticant or modular-nucleus components, construct a projective group action, or
validate the external finite enumeration.  The redundancy-seven all-field coding terminal starts
at field order `11`; the public rows at `7`, `8`, and `9` certify split-free syndromes only unless
a separate covering-radius theorem is supplied.
-/

namespace RelativeConicArcs.PRSRedundancySixSeven

/-- Coding and component data that promote a coherent polar exclusion theorem to an exact deep
syndrome classification. -/
structure FixedLevelInput
    (Syndrome Marker Witness : Type*) [Fintype Marker] [DecidableEq Marker]
    (q lowerThreshold transverseBudget collisionBudget : ℕ) where
  /-- Coherent polar geometry and lower witness construction. -/
  polar : PRSPolarInduction.CoherentPolarInput Syndrome Marker Witness
    q lowerThreshold transverseBudget collisionBudget
  /-- Coding-theoretic covering-radius interface. -/
  radius : PRSFoundation.CoveringRadiusInput Syndrome
  /-- The polar and coding interfaces use the same split-free predicate. -/
  splitFreeCompatibility :
    ∀ syndrome, radius.isSplitFree syndrome ↔ polar.isSplitFree syndrome
  /-- Every persistent tangent or conjugate-sigma syndrome is split-free. -/
  persistentSplitFree :
    ∀ {syndrome}, polar.persistent syndrome → polar.isSplitFree syndrome
  /-- Every arithmetically admitted modular-nucleus syndrome is split-free. -/
  modularSplitFree :
    ∀ {syndrome}, polar.modular syndrome → polar.isSplitFree syndrome
  /-- The external covering-radius range holds at the stated lower threshold. -/
  radiusRangeAtThreshold :
    q ≥ lowerThreshold → radius.radiusRange

namespace FixedLevelInput

/-- The coherent polar theorem and the explicit covering-radius input classify deep syndromes by
the persistent and modular contained components. -/
theorem deep_iff_persistent_or_modular
    {Syndrome Marker Witness : Type*} [Fintype Marker] [DecidableEq Marker]
    {q lowerThreshold transverseBudget collisionBudget : ℕ}
    (input : FixedLevelInput Syndrome Marker Witness
      q lowerThreshold transverseBudget collisionBudget)
    (hlower : q ≥ lowerThreshold)
    (hparameters : q + 1 > transverseBudget + collisionBudget)
    (syndrome : Syndrome) :
    input.radius.isDeep syndrome ↔
      input.polar.persistent syndrome ∨ input.polar.modular syndrome := by
  constructor
  · intro hdeep
    have hsplitFree : input.polar.isSplitFree syndrome :=
      (input.splitFreeCompatibility syndrome).1
        (input.radius.deep_implies_splitFree hdeep)
    exact input.polar.splitFree_implies_persistent_or_modular
      hlower hparameters hsplitFree
  · intro hcomponent
    apply input.radius.splitFree_implies_deep
      (input.radiusRangeAtThreshold hlower)
    apply (input.splitFreeCompatibility syndrome).2
    exact hcomponent.elim input.persistentSplitFree input.modularSplitFree

end FixedLevelInput

/-- Redundancy-six high-field classification.  The carrier budget is `3+4=7` and the
pointed-collision budget is `6`, so every `q ≥ 29` has more rational polar parameters than the
combined divisor. -/
theorem redundancySixHighFieldSynthesis
    {Syndrome Marker Witness : Type*} [Fintype Marker] [DecidableEq Marker]
    {q : ℕ} (hq : q ≥ 29)
    (input : FixedLevelInput Syndrome Marker Witness q 29 7 6)
    (syndrome : Syndrome) :
    input.radius.isDeep syndrome ↔
      input.polar.persistent syndrome ∨ input.polar.modular syndrome := by
  apply input.deep_iff_persistent_or_modular hq
  omega

/-- Redundancy-seven high-field classification.  The carrier budget is `3+1=4` and the
marked self-collision budget is `8`, so every `q ≥ 37` has an admissible polar parameter. -/
theorem redundancySevenHighFieldSynthesis
    {Syndrome Marker Witness : Type*} [Fintype Marker] [DecidableEq Marker]
    {q : ℕ} (hq : q ≥ 37)
    (input : FixedLevelInput Syndrome Marker Witness q 37 4 8)
    (syndrome : Syndrome) :
    input.radius.isDeep syndrome ↔
      input.polar.persistent syndrome ∨ input.polar.modular syndrome := by
  apply input.deep_iff_persistent_or_modular hq
  omega

/-- Tangent/sigma families together with an arithmetically admitted modular component.  The
modular subset is not assumed nonempty: degree-specific arithmetic decides whether a nucleus
component contributes deep syndromes over the chosen field. -/
structure PersistentModularFamilyData
    (Syndrome : Type*) [DecidableEq Syndrome] (q : ℕ) where
  /-- Persistent rational-tangent syndromes. -/
  tangent : Finset Syndrome
  /-- Persistent conjugate-sigma syndromes. -/
  sigma : Finset Syndrome
  /-- Arithmetically admitted modular-nucleus syndromes. -/
  modular : Finset Syndrome
  /-- Complete declared classified locus. -/
  classified : Finset Syndrome
  /-- Tangent and sigma families are disjoint. -/
  tangentSigmaDisjoint : Disjoint tangent sigma
  /-- The modular family is disjoint from the persistent union. -/
  persistentModularDisjoint : Disjoint (tangent ∪ sigma) modular
  /-- The classified set is exactly the union of all three families. -/
  classified_eq : classified = (tangent ∪ sigma) ∪ modular
  /-- A finite field has positive order. -/
  fieldOrderPositive : 0 < q
  /-- The tangent family has `q(q+1)` points. -/
  tangent_card : tangent.card = q * (q + 1)
  /-- Twice the sigma-family cardinality is `q(q²-1)`. -/
  sigma_card_doubled : 2 * sigma.card = q * (q ^ 2 - 1)

namespace PersistentModularFamilyData

/-- The exact cardinality identity, written without division so it is uniform in every
characteristic. -/
theorem classified_card_doubled
    {Syndrome : Type*} [DecidableEq Syndrome] {q : ℕ}
    (data : PersistentModularFamilyData Syndrome q) :
    2 * data.classified.card =
      q * (q + 1) ^ 2 + 2 * data.modular.card := by
  rw [data.classified_eq,
    Finset.card_union_of_disjoint data.persistentModularDisjoint,
    Finset.card_union_of_disjoint data.tangentSigmaDisjoint,
    Nat.mul_add, Nat.mul_add, data.tangent_card, data.sigma_card_doubled]
  obtain ⟨k, rfl⟩ :=
    Nat.exists_eq_succ_of_ne_zero (Nat.ne_of_gt data.fieldOrderPositive)
  simp only [Nat.succ_eq_add_one]
  have hsquare : (k + 1) ^ 2 - 1 = k ^ 2 + 2 * k := by
    have hexpand : (k + 1) ^ 2 = k ^ 2 + 2 * k + 1 := by ring
    omega
  rw [hsquare]
  ring

end PersistentModularFamilyData

namespace RedundancySixOrbitArithmetic

/-- Arithmetic cases for the fifth-power norm-one-torus quotient and the characteristic-five
tangent split. -/
inductive Case
  | sigmaOrderOne
  | characteristicFive
  | sigmaOrderFiveFrobeniusFixed
  | sigmaOrderFiveFrobeniusFused
  deriving DecidableEq

/-- Number of projective-linear orbits in the redundancy-six persistent locus. -/
def projectiveOrbitCount : Case → ℕ
  | .sigmaOrderOne => 2
  | .characteristicFive => 3
  | .sigmaOrderFiveFrobeniusFixed => 4
  | .sigmaOrderFiveFrobeniusFused => 4

/-- Number of projective-semilinear orbits after coefficient Frobenius. -/
def semilinearOrbitCount : Case → ℕ
  | .sigmaOrderOne => 2
  | .characteristicFive => 3
  | .sigmaOrderFiveFrobeniusFixed => 4
  | .sigmaOrderFiveFrobeniusFused => 3

/-- Exact persistent orbit-count table for redundancy six. -/
theorem orbit_count_pairs :
    (projectiveOrbitCount .sigmaOrderOne,
        semilinearOrbitCount .sigmaOrderOne) = (2, 2) ∧
      (projectiveOrbitCount .characteristicFive,
        semilinearOrbitCount .characteristicFive) = (3, 3) ∧
      (projectiveOrbitCount .sigmaOrderFiveFrobeniusFixed,
        semilinearOrbitCount .sigmaOrderFiveFrobeniusFixed) = (4, 4) ∧
      (projectiveOrbitCount .sigmaOrderFiveFrobeniusFused,
        semilinearOrbitCount .sigmaOrderFiveFrobeniusFused) = (4, 3) := by
  decide

end RedundancySixOrbitArithmetic

namespace RedundancySevenOrbitArithmetic

/-- Arithmetic cases for the sixth-power norm-one-torus quotient and the characteristic-two or
characteristic-three tangent split.  The central nucleus point is counted separately. -/
inductive Case
  | sigmaOrderOne
  | sigmaOrderOneCharacteristicTwo
  | sigmaOrderTwo
  | sigmaOrderTwoCharacteristicThree
  | sigmaOrderThreeCharacteristicTwo
  | sigmaOrderSix
  deriving DecidableEq

/-- Projective-linear persistent orbit count, excluding the optional central nucleus point. -/
def persistentProjectiveOrbitCount : Case → ℕ
  | .sigmaOrderOne => 2
  | .sigmaOrderOneCharacteristicTwo => 3
  | .sigmaOrderTwo => 3
  | .sigmaOrderTwoCharacteristicThree => 4
  | .sigmaOrderThreeCharacteristicTwo => 4
  | .sigmaOrderSix => 5

/-- Projective-semilinear persistent orbit count.  Frobenius acts through inversion on every
cyclic quotient of order dividing six, so these counts equal the projective counts. -/
def persistentSemilinearOrbitCount : Case → ℕ
  | .sigmaOrderOne => 2
  | .sigmaOrderOneCharacteristicTwo => 3
  | .sigmaOrderTwo => 3
  | .sigmaOrderTwoCharacteristicThree => 4
  | .sigmaOrderThreeCharacteristicTwo => 4
  | .sigmaOrderSix => 5

/-- Adding the central nucleus point, when it is deep, adds one fixed orbit to both actions. -/
def orbitCountPair (c : Case) (centralDeep : Bool) : ℕ × ℕ :=
  (persistentProjectiveOrbitCount c + centralDeep.toNat,
    persistentSemilinearOrbitCount c + centralDeep.toNat)

/-- The central point changes both orbit counts by exactly one. -/
theorem central_point_orbit_increment (c : Case) :
    orbitCountPair c true =
      (persistentProjectiveOrbitCount c + 1,
        persistentSemilinearOrbitCount c + 1) := by
  rfl

end RedundancySevenOrbitArithmetic

/-- All-field bridge for redundancy six.  The target predicate may include the certified
small-field sporadic families; above the geometric threshold it must reduce to the persistent and
arithmetically admitted modular components. -/
structure RedundancySixAllFieldInput
    (Syndrome Marker Witness : Type*) [Fintype Marker] [DecidableEq Marker]
    (q : ℕ) where
  /-- High-field polar and coding inputs. -/
  highField : FixedLevelInput Syndrome Marker Witness q 29 7 6
  /-- Semantic validation of the public finite records. -/
  certificate :
    PRSRedundancySixSevenCertificate.RedundancySixCertificateValidation
  /-- Complete field-dependent classification predicate. -/
  classified : Syndrome → Prop
  /-- In the high-field branch, the classified predicate is the contained union. -/
  highFieldClassified :
    ∀ syndrome,
      classified syndrome ↔
        highField.polar.persistent syndrome ∨ highField.polar.modular syndrome
  /-- Every lower field order is represented by the public finite record.  For an actual finite
  field, this is proved from its prime-power order. -/
  finiteRow :
    q < 29 →
      ∃ record ∈
        PRSRedundancySixSevenCertificate.redundancySixFieldRecords,
          record.fieldOrder = q
  /-- Semantic certificate validation identifies the formal deep predicate with the declared
  classification on the represented finite row. -/
  finiteClassification :
    ∀ record ∈
      PRSRedundancySixSevenCertificate.redundancySixFieldRecords,
      record.fieldOrder = q →
      ∀ syndrome, highField.radius.isDeep syndrome ↔ classified syndrome

/-- Exact redundancy-six all-field synthesis from the high-field polar theorem and the validated
finite bridge. -/
theorem redundancySixAllFieldSynthesis
    {Syndrome Marker Witness : Type*} [Fintype Marker] [DecidableEq Marker]
    {q : ℕ} (input : RedundancySixAllFieldInput Syndrome Marker Witness q)
    (syndrome : Syndrome) :
    input.highField.radius.isDeep syndrome ↔ input.classified syndrome := by
  by_cases hq : q ≥ 29
  · exact (redundancySixHighFieldSynthesis hq input.highField syndrome).trans
      (input.highFieldClassified syndrome).symm
  · obtain ⟨record, hrecord, hfield⟩ := input.finiteRow (by omega)
    exact input.finiteClassification record hrecord hfield syndrome

/-- All-field bridge for the redundancy-seven coding classification.  Its intended domain starts
at field order `11`; the lower split-free-only records remain available in the certificate module
without being promoted here. -/
structure RedundancySevenAllFieldInput
    (Syndrome Marker Witness : Type*) [Fintype Marker] [DecidableEq Marker]
    (q : ℕ) where
  /-- High-field polar and coding inputs. -/
  highField : FixedLevelInput Syndrome Marker Witness q 37 4 8
  /-- Semantic validation of the public finite records. -/
  certificate :
    PRSRedundancySixSevenCertificate.RedundancySevenCertificateValidation
  /-- Complete field-dependent classification predicate. -/
  classified : Syndrome → Prop
  /-- In the high-field branch, the classified predicate is the contained union. -/
  highFieldClassified :
    ∀ syndrome,
      classified syndrome ↔
        highField.polar.persistent syndrome ∨ highField.polar.modular syndrome
  /-- Every field order in the bounded coding range is represented by a radius-certified public
  row. -/
  finiteRadiusRow :
    11 ≤ q → q < 37 →
      ∃ record ∈
        PRSRedundancySixSevenCertificate.redundancySevenFieldRecords,
          record.fieldOrder = q ∧ record.radiusSixReported = true
  /-- Semantic certificate validation identifies the formal coding predicate on a
  radius-certified row. -/
  finiteClassification :
    ∀ record ∈
      PRSRedundancySixSevenCertificate.redundancySevenFieldRecords,
      record.fieldOrder = q →
      record.radiusSixReported = true →
      ∀ syndrome, highField.radius.isDeep syndrome ↔ classified syndrome

/-- Exact redundancy-seven coding synthesis for field orders at least `11`.  No conclusion is
drawn from the split-free-only rows at `7`, `8`, or `9`. -/
theorem redundancySevenAllFieldSynthesis
    {Syndrome Marker Witness : Type*} [Fintype Marker] [DecidableEq Marker]
    {q : ℕ} (input : RedundancySevenAllFieldInput Syndrome Marker Witness q)
    (hqMinimum : 11 ≤ q) (syndrome : Syndrome) :
    input.highField.radius.isDeep syndrome ↔ input.classified syndrome := by
  by_cases hq : q ≥ 37
  · exact (redundancySevenHighFieldSynthesis hq input.highField syndrome).trans
      (input.highFieldClassified syndrome).symm
  · obtain ⟨record, hrecord, hfield, hradius⟩ :=
      input.finiteRadiusRow hqMinimum (by omega)
    exact input.finiteClassification record hrecord hfield hradius syndrome

end RelativeConicArcs.PRSRedundancySixSeven
