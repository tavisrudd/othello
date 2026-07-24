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

/-- Exact genus-one Hasse--Weil deletion inequality for every integer field order at least `43`.
The first prime-power interpretation is supplied by the finite-field instance using this lemma. -/
theorem threeMarker_genusOne_hasseWeil_bound
    {q : ℕ} (hq : 43 ≤ q) :
    q + 1 > 2 * Nat.sqrt q + threeMarkerDeletionDegree := by
  have hsquare : Nat.sqrt q * Nat.sqrt q ≤ q := Nat.sqrt_le q
  rw [show threeMarkerDeletionDegree = 30 by
    exact exact_deletion_and_polar_budgets.1]
  by_cases hsqrt : Nat.sqrt q ≤ 6
  · omega
  · have hsqrtLower : 7 ≤ Nat.sqrt q := by omega
    nlinarith

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
