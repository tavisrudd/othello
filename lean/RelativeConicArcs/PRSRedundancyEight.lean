import RelativeConicArcs.PRSRedundancySixSeven

/-!
# Polar-inductive synthesis for redundancy eight

This module specializes coherent polar induction to projective Reed--Solomon redundancy eight.
Three ordered projective markers lead to a geometrically integral identity-Frobenius ordered-pair
slice of genus one.  Its branch-and-diagonal deletion degree is twelve, and each marker removes at
most six further points, for total deletion degree thirty.  The upper first-polar line has
transverse-carrier budget four and collision budget ten.

The terminal theorem classifies deep syndromes for every field order at least `43` as the
persistent tangent or conjugate-sigma locus.  Geometric integrality, identification of the concrete
Hankel systems, contained-component classification, the projective group actions, and the
covering-radius theorem remain explicit structure fields.  Lean checks the three-marker
contraction interface, the exact Hasse--Weil and parameter arithmetic, the synthesis implication,
the persistent-family cardinality, the seventh-power orbit table, and the tangent cocycle.

The characteristic-seven binary-quartic carrier one redundancy higher is represented only by a
boundary structure: it records the diagonal-field rootless count and a rootless shallow witness
over the quadratic extension.  No statement about rootless sufficiency over larger fields is made.
-/

namespace RelativeConicArcs.PRSRedundancyEight

open PRSPolarInduction

section ThreeMarkerContraction

variable {R A : Type*} [CommRing R] [CommRing A]

/-- Contraction by an ordered triple of projective markers.  A marker equal to `none` is the point
at infinity; a marker `some r` is the affine point with coordinate `r`. -/
def threeMarkerContraction
    (first second third : Option R) (coefficients : ℕ → R) : ℕ → R :=
  iteratedProjectiveSequenceContraction [first, second, third] coefficients

/-- Ordered three-marker contraction commutes with extension of scalars, including markers at
infinity. -/
theorem threeMarkerContraction_map
    (φ : R →+* A) (first second third : Option R) (coefficients : ℕ → R) :
    (fun i => φ (threeMarkerContraction first second third coefficients i)) =
      threeMarkerContraction (first.map φ) (second.map φ) (third.map φ)
        (fun i => φ (coefficients i)) := by
  simpa [threeMarkerContraction] using
    iteratedProjectiveSequenceContraction_map φ
      [first, second, third] coefficients

/-- Two projective sequence contractions commute, including every affine/infinity combination. -/
theorem projectiveSequenceContraction_comm
    (first second : Option R) (coefficients : ℕ → R) :
    projectiveSequenceContraction second
        (projectiveSequenceContraction first coefficients) =
      projectiveSequenceContraction first
        (projectiveSequenceContraction second coefficients) := by
  cases first with
  | none =>
      cases second <;> rfl
  | some first =>
      cases second with
      | none => rfl
      | some second =>
          exact sequenceContraction_comm first second coefficients

/-- Swapping the first two retained markers does not change the contracted coefficient sequence. -/
theorem threeMarkerContraction_swap_first
    (first second third : Option R) (coefficients : ℕ → R) :
    threeMarkerContraction first second third coefficients =
      threeMarkerContraction second first third coefficients := by
  change
    projectiveSequenceContraction third
        (projectiveSequenceContraction second
          (projectiveSequenceContraction first coefficients)) =
      projectiveSequenceContraction third
        (projectiveSequenceContraction first
          (projectiveSequenceContraction second coefficients))
  rw [projectiveSequenceContraction_comm first second coefficients]

/-- Swapping the last two retained markers does not change the contracted coefficient sequence. -/
theorem threeMarkerContraction_swap_last
    (first second third : Option R) (coefficients : ℕ → R) :
    threeMarkerContraction first second third coefficients =
      threeMarkerContraction first third second coefficients := by
  change
    projectiveSequenceContraction third
        (projectiveSequenceContraction second
          (projectiveSequenceContraction first coefficients)) =
      projectiveSequenceContraction second
        (projectiveSequenceContraction third
          (projectiveSequenceContraction first coefficients))
  exact projectiveSequenceContraction_comm second third
    (projectiveSequenceContraction first coefficients)

/-- On the affine chart, three-marker contraction depends only on the elementary symmetric
functions of the retained markers. -/
theorem threeMarkerContraction_affine_apply
    (first second third : R) (coefficients : ℕ → R) (i : ℕ) :
    threeMarkerContraction (some first) (some second) (some third) coefficients i =
      coefficients (i + 3) -
        (first + second + third) * coefficients (i + 2) +
        (first * second + first * third + second * third) * coefficients (i + 1) -
        first * second * third * coefficients i := by
  simp [threeMarkerContraction, iteratedProjectiveSequenceContraction,
    projectiveSequenceContraction, sequenceContraction, Nat.add_assoc]
  ring

/-- Affine marker triples with the same three elementary symmetric functions induce the same
contracted coefficient sequence.  Equivalently, the contraction factors through the monic cubic
having the retained markers as roots. -/
theorem threeMarkerContraction_affine_eq_of_elementarySymmetric
    {first second third first' second' third' : R}
    (hsum : first + second + third = first' + second' + third')
    (hpairs :
      first * second + first * third + second * third =
        first' * second' + first' * third' + second' * third')
    (hproduct : first * second * third = first' * second' * third')
    (coefficients : ℕ → R) :
    threeMarkerContraction (some first) (some second) (some third) coefficients =
      threeMarkerContraction (some first') (some second') (some third') coefficients := by
  funext i
  rw [threeMarkerContraction_affine_apply, threeMarkerContraction_affine_apply,
    hsum, hpairs, hproduct]

end ThreeMarkerContraction

/-- Number of retained markers on the redundancy-eight lower splitting slice. -/
def retainedMarkerCount : ℕ := 3

/-- Branch and diagonal deletion degree on the normalized ordered-pair cubic cover. -/
def branchAndDiagonalDeletionDegree : ℕ := 12

/-- Maximum deletion degree contributed by one retained marker. -/
def deletionDegreePerMarker : ℕ := 6

/-- Total deletion degree on the three-marker geometric-`S3` identity twist. -/
def threeMarkerDeletionDegree : ℕ :=
  branchAndDiagonalDeletionDegree + retainedMarkerCount * deletionDegreePerMarker

/-- Degree with which a noncontained first-polar line meets the lower carrier. -/
def transverseCarrierBudget : ℕ := 4

/-- Ramification degree of the marked self-collision divisor. -/
def markedCollisionBudget : ℕ := 10

/-- The displayed lower-cover and first-polar budgets are exactly `30` and `14`. -/
theorem exact_deletion_and_polar_budgets :
    threeMarkerDeletionDegree = 30 ∧
      transverseCarrierBudget + markedCollisionBudget = 14 := by
  norm_num [threeMarkerDeletionDegree, branchAndDiagonalDeletionDegree,
    retainedMarkerCount, deletionDegreePerMarker, transverseCarrierBudget,
    markedCollisionBudget]

/-- Integer-safe squared form of the genus-one Hasse--Weil deletion inequality for every integer
at least `42`.  Redundancy eight uses the first prime-power field order in this range, namely
`43`. -/
theorem threeMarker_genusOne_hasseWeil_bound
    {q : ℕ} (hq : 42 ≤ q) :
    threeMarkerDeletionDegree < q + 1 ∧
      4 * 1 ^ 2 * q < (q + 1 - threeMarkerDeletionDegree) ^ 2 := by
  rw [show threeMarkerDeletionDegree = 30 by
    exact exact_deletion_and_polar_budgets.1]
  constructor
  · omega
  · have hsub : q + 1 - 30 = q - 29 := by omega
    rw [hsub]
    have hqsub : q - 29 + 29 = q := by omega
    nlinarith

/-- The squared integer Hasse--Weil deletion threshold is exact: it holds at `42` and fails at
`41`. -/
theorem threeMarker_genusOne_hasseWeil_exact_threshold :
    (threeMarkerDeletionDegree < 42 + 1 ∧
      4 * 1 ^ 2 * 42 < (42 + 1 - threeMarkerDeletionDegree) ^ 2) ∧
    ¬(threeMarkerDeletionDegree < 41 + 1 ∧
      4 * 1 ^ 2 * 41 < (41 + 1 - threeMarkerDeletionDegree) ^ 2) := by
  norm_num [threeMarkerDeletionDegree, branchAndDiagonalDeletionDegree,
    retainedMarkerCount, deletionDegreePerMarker]

/-- A prime-power field order satisfying the exact integer Hasse--Weil threshold is at least `43`,
because `42` is not a prime power. -/
theorem primePowerOrder_at_least_fortyThree
    {q : ℕ} (hprimePower : IsPrimePow q) (hq : 42 ≤ q) :
    43 ≤ q := by
  by_cases hq42 : q = 42
  · subst q
    exact False.elim ((by decide : ¬ IsPrimePow 42) hprimePower)
  · omega

/-- A finite field whose order satisfies the exact integer Hasse--Weil threshold has at least
forty-three elements. -/
theorem finiteFieldOrder_at_least_fortyThree
    {K : Type*} [Field K] [Fintype K]
    (hq : 42 ≤ Fintype.card K) :
    43 ≤ Fintype.card K :=
  primePowerOrder_at_least_fortyThree
    Fintype.isPrimePow_card_of_field hq

/-- A normalized geometric-`S3` lower slice has three ordered distinct markers and identifies its
identity-Frobenius component with the genus-one, degree-thirty stratum used by synthesis.
Geometric integrality is a field of `stratum`, rather than a conclusion of the numerical proof. -/
structure ThreeMarkerGeometricS3Slice
    (Marker : Type*) [DecidableEq Marker] (q : ℕ) where
  /-- Ordered retained markers. -/
  markers : Fin 3 → Marker
  /-- The normalized slice lies off every marker diagonal. -/
  markersInjective : Function.Injective markers
  /-- The geometric monodromy of the normalized ordered-root cover is `S₃`. -/
  geometricMonodromyIsS3 : Prop
  /-- The declared geometric monodromy statement is available to the lower splitting argument. -/
  geometricMonodromyIsS3_proof : geometricMonodromyIsS3
  /-- Identity-Frobenius ordered-pair cover with its geometric and Hasse--Weil inputs. -/
  stratum : LowerCoverStratum q
  /-- `S₃`-transitivity makes the identity-Frobenius ordered-pair twist geometrically integral. -/
  stratumGeometricallyIntegral : stratum.geometricallyIntegralIdentityTwist
  /-- The normalization has genus at most one. -/
  genusBound_eq : stratum.genusBound = 1
  /-- Branch, diagonal, and marker fibers give total deletion degree thirty. -/
  deletionDegree_eq : stratum.deletionDegree = threeMarkerDeletionDegree

/-- Exact redundancy-eight input.  The lower-cover slice is visibly among the strata used by the
polar theorem, and every modular-nucleus lift is excluded in the stated high-field range. -/
structure RedundancyEightInput
    (Syndrome Marker Witness : Type*) [Fintype Marker] [DecidableEq Marker]
    (q : ℕ) where
  /-- Coherent polar and coding data with threshold `43` and budgets `4+10`. -/
  fixedLevel :
    PRSRedundancySixSeven.FixedLevelInput Syndrome Marker Witness q 43 4 10
  /-- Normalized three-marker identity-Frobenius slice. -/
  threeMarkerSlice : ThreeMarkerGeometricS3Slice Marker q
  /-- The polar lower-cover list contains the declared geometric-`S3` slice. -/
  slice_mem_lowerCoverStrata :
    threeMarkerSlice.stratum ∈ fixedLevel.polar.lowerCoverStrata
  /-- Every candidate modular-nucleus lift is shallow in this range. -/
  modularEmpty :
    ∀ syndrome, ¬ fixedLevel.polar.modular syndrome

/-- For every field order at least `43`, the exact redundancy-eight classification contains only
the persistent tangent and conjugate-sigma components. -/
theorem redundancyEightHighFieldSynthesis
    {Syndrome Marker Witness : Type*} [Fintype Marker] [DecidableEq Marker]
    {q : ℕ} (hq : 43 ≤ q)
    (input : RedundancyEightInput Syndrome Marker Witness q)
    (syndrome : Syndrome) :
    input.fixedLevel.radius.isDeep syndrome ↔
      input.fixedLevel.polar.persistent syndrome := by
  rw [input.fixedLevel.deep_iff_persistent_or_modular hq (by omega)]
  exact or_iff_left (input.modularEmpty syndrome)

/-- Prime-power form of redundancy-eight synthesis.  The geometric inequality may be stated at
its exact integer threshold `42`; prime-power arithmetic supplies the coding threshold `43`. -/
theorem redundancyEightPrimePowerSynthesis
    {Syndrome Marker Witness : Type*} [Fintype Marker] [DecidableEq Marker]
    {q : ℕ} (hprimePower : IsPrimePow q) (hq : 42 ≤ q)
    (input : RedundancyEightInput Syndrome Marker Witness q)
    (syndrome : Syndrome) :
    input.fixedLevel.radius.isDeep syndrome ↔
      input.fixedLevel.polar.persistent syndrome :=
  redundancyEightHighFieldSynthesis
    (primePowerOrder_at_least_fortyThree hprimePower hq) input syndrome

/-- Finite-field form of redundancy-eight synthesis, with the prime-power premise discharged from
the field structure. -/
theorem redundancyEightFiniteFieldSynthesis
    {K Syndrome Marker Witness : Type*} [Field K] [Fintype K]
    [Fintype Marker] [DecidableEq Marker]
    (hq : 42 ≤ Fintype.card K)
    (input :
      RedundancyEightInput Syndrome Marker Witness (Fintype.card K))
    (syndrome : Syndrome) :
    input.fixedLevel.radius.isDeep syndrome ↔
      input.fixedLevel.polar.persistent syndrome :=
  redundancyEightHighFieldSynthesis
    (finiteFieldOrder_at_least_fortyThree hq) input syndrome

/-- Persistent tangent and conjugate-sigma family data with no modular contribution. -/
structure PersistentFamilyData
    (Syndrome : Type*) [DecidableEq Syndrome] (q : ℕ)
    extends PRSRedundancySixSeven.PersistentModularFamilyData Syndrome q where
  /-- Redundancy eight has no arithmetically admitted modular family in the theorem range. -/
  modular_eq_empty : modular = ∅

namespace PersistentFamilyData

/-- Exact persistent-family cardinality in quotient form. -/
theorem classified_card
    {Syndrome : Type*} [DecidableEq Syndrome] {q : ℕ}
    (data : PersistentFamilyData Syndrome q) :
    data.classified.card = q * (q + 1) ^ 2 / 2 := by
  have hdoubled :
      2 * data.classified.card = q * (q + 1) ^ 2 := by
    simpa [data.modular_eq_empty] using
      data.toPersistentModularFamilyData.classified_card_doubled
  omega

end PersistentFamilyData

namespace OrbitArithmetic

/-- Arithmetic cases for the seventh-power norm-one-torus quotient and the characteristic-seven
tangent split. -/
inductive Case
  | sigmaOrderOne
  | characteristicSeven
  | sigmaOrderSevenFrobeniusFixed
  | sigmaOrderSevenFrobeniusFused
  deriving DecidableEq

/-- Number of projective-linear orbits in the persistent redundancy-eight locus. -/
def projectiveOrbitCount : Case → ℕ
  | .sigmaOrderOne => 2
  | .characteristicSeven => 3
  | .sigmaOrderSevenFrobeniusFixed => 5
  | .sigmaOrderSevenFrobeniusFused => 5

/-- Number of projective-semilinear orbits after coefficient Frobenius. -/
def semilinearOrbitCount : Case → ℕ
  | .sigmaOrderOne => 2
  | .characteristicSeven => 3
  | .sigmaOrderSevenFrobeniusFixed => 5
  | .sigmaOrderSevenFrobeniusFused => 3

/-- Exact four-case `PGL₂/PΓL₂` orbit-count table. -/
theorem orbit_count_pairs :
    (projectiveOrbitCount .sigmaOrderOne,
        semilinearOrbitCount .sigmaOrderOne) = (2, 2) ∧
      (projectiveOrbitCount .characteristicSeven,
        semilinearOrbitCount .characteristicSeven) = (3, 3) ∧
      (projectiveOrbitCount .sigmaOrderSevenFrobeniusFixed,
        semilinearOrbitCount .sigmaOrderSevenFrobeniusFixed) = (5, 5) ∧
      (projectiveOrbitCount .sigmaOrderSevenFrobeniusFused,
        semilinearOrbitCount .sigmaOrderSevenFrobeniusFused) = (5, 3) := by
  decide

/-- The seventh-power sigma quotient has one inversion orbit at order one and four at order
seven. -/
theorem seventhPower_sigmaInversionOrbitCount :
    sigmaInversionOrbitCount 1 = 1 ∧
      sigmaInversionOrbitCount 7 = 4 := by
  decide

end OrbitArithmetic

/-- In characteristic seven, the normalized tangent cocycle `z ↦ z + 7u` is fixed. -/
theorem tangentTranslateSeven_of_cast_eq_zero
    {K : Type*} [Semiring K] (hseven : (7 : K) = 0) (u z : K) :
    tangentTranslate 7 u z = z :=
  tangentTranslate_of_cast_eq_zero hseven u z

/-- Away from characteristic seven, the normalized tangent cocycle is transitive. -/
theorem tangentTranslateSeven_surjective
    {K : Type*} [Field K] (hseven : (7 : K) ≠ 0) (z w : K) :
    ∃ u, tangentTranslate 7 u z = w :=
  tangentTranslate_surjective hseven z w

/-- Exact proved boundary for the characteristic-seven binary-quartic carrier one redundancy
higher.  The structure records only the diagonal-field equivalence and count, together with one
rootless shallow witness over the quadratic extension. -/
structure CharacteristicSevenCarrierBoundary
    (Quartic Septic : Type*) [DecidableEq Quartic]
    (rootlessAtSeven deepAtSeven rootlessAtFortyNine : Quartic → Prop)
    (splitSquarefreeKernelWitnessAtFortyNine : Quartic → Septic → Prop) where
  /-- Projective quartics in the diagonal-field carrier. -/
  carrierAtSeven : Finset Quartic
  /-- Rootless projective quartics in that carrier. -/
  rootlessCarrierAtSeven : Finset Quartic
  /-- Membership in the rootless subfamily agrees with the declared rootless predicate. -/
  rootlessCarrierAtSeven_spec :
    ∀ quartic ∈ carrierAtSeven,
      quartic ∈ rootlessCarrierAtSeven ↔ rootlessAtSeven quartic
  /-- On the diagonal field, deepness is exactly rootlessness. -/
  deep_iff_rootless_atSeven :
    ∀ quartic ∈ carrierAtSeven,
      deepAtSeven quartic ↔ rootlessAtSeven quartic
  /-- Exact diagonal-field rootless count. -/
  rootlessCarrierAtSeven_card : rootlessCarrierAtSeven.card = 819
  /-- A rootless quartic over the quadratic extension. -/
  rootlessShallowAtFortyNine : Quartic
  /-- The displayed quadratic-extension quartic is rootless. -/
  rootlessShallowAtFortyNine_isRootless :
    rootlessAtFortyNine rootlessShallowAtFortyNine
  /-- A split squarefree septic in its Hankel kernel. -/
  shallowWitnessAtFortyNine : Septic
  /-- The displayed septic witnesses shallowness. -/
  shallowWitnessAtFortyNine_spec :
    splitSquarefreeKernelWitnessAtFortyNine
      rootlessShallowAtFortyNine shallowWitnessAtFortyNine

namespace CharacteristicSevenCarrierBoundary

/-- The recorded boundary gives exactly `819` diagonal-field deep rootless quartics and exhibits a
rootless shallow quartic over the quadratic extension. -/
theorem proved_boundary
    {Quartic Septic : Type*} [DecidableEq Quartic]
    {rootlessAtSeven deepAtSeven rootlessAtFortyNine : Quartic → Prop}
    {splitSquarefreeKernelWitnessAtFortyNine : Quartic → Septic → Prop}
    (data : CharacteristicSevenCarrierBoundary Quartic Septic
      rootlessAtSeven deepAtSeven rootlessAtFortyNine
      splitSquarefreeKernelWitnessAtFortyNine) :
    data.rootlessCarrierAtSeven.card = 819 ∧
      (∀ quartic ∈ data.carrierAtSeven,
        deepAtSeven quartic ↔ quartic ∈ data.rootlessCarrierAtSeven) ∧
      rootlessAtFortyNine data.rootlessShallowAtFortyNine ∧
      ∃ witness,
        splitSquarefreeKernelWitnessAtFortyNine
          data.rootlessShallowAtFortyNine witness := by
  refine ⟨data.rootlessCarrierAtSeven_card, ?_, ?_,
    data.shallowWitnessAtFortyNine, data.shallowWitnessAtFortyNine_spec⟩
  · intro quartic hquartic
    exact (data.deep_iff_rootless_atSeven quartic hquartic).trans
      (data.rootlessCarrierAtSeven_spec quartic hquartic).symm
  · exact data.rootlessShallowAtFortyNine_isRootless

end CharacteristicSevenCarrierBoundary

end RelativeConicArcs.PRSRedundancyEight
