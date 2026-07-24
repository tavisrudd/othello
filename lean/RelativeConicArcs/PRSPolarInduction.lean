import RelativeConicArcs.PRSFoundation

/-!
# Coherent polar induction for Hankel systems

A divided-power syndrome has consecutive contractions
`aᵢ₊₁ - r aᵢ` at finite marked points `r`.  This module checks their compatibility with ring
maps and packages arbitrary ordered iterations on infinite coefficient sequences.  The list of
markers is retained even though adjacent contractions commute: it records the roots that a lifted
split polynomial must avoid.

The main synthesis theorem is the finite combinatorial core of the contained-versus-transverse
argument.  A coherent polar family either lies in a declared persistent or modular component, or
its bad and collision parameters occupy at most the supplied intersection budgets.  If the
projective marker line has more rational points than that union and the lower splitting-cover
hypotheses supply a witness at every remaining parameter, the original syndrome is not
split-free.

Geometric integrality, genus and deletion estimates, the equations of the lower bad carrier,
contained-component classification, and the passage from a lower rational point to a split
squarefree polynomial remain explicit fields.  No finite census, monodromy theorem, or
rational-point estimate is inferred in this module.
-/

namespace RelativeConicArcs.PRSPolarInduction

section Contraction

variable {R A : Type*} [CommRing R] [CommRing A]

/-- Consecutive divided-power contraction on an unbounded coefficient sequence. -/
def sequenceContraction (r : R) (a : ℕ → R) : ℕ → R :=
  fun i => a (i + 1) - r * a i

/-- Projective contraction on a coefficient sequence.  `none` is the point at infinity and keeps
the leading consecutive row; `some r` is contraction at the finite marker `r`. -/
def projectiveSequenceContraction (marker : Option R) (a : ℕ → R) : ℕ → R :=
  match marker with
  | none => a
  | some r => sequenceContraction r a

/-- Ordered iteration of consecutive contractions.  The marker list remains part of the data
even though the resulting coefficient sequence is symmetric in adjacent markers. -/
def iteratedSequenceContraction (markers : List R) (a : ℕ → R) : ℕ → R :=
  markers.foldl (fun coefficients r => sequenceContraction r coefficients) a

/-- Ordered iteration retaining both finite markers and the point at infinity. -/
def iteratedProjectiveSequenceContraction
    (markers : List (Option R)) (a : ℕ → R) : ℕ → R :=
  markers.foldl
    (fun coefficients marker => projectiveSequenceContraction marker coefficients) a

/-- Projective divided-power contraction on finite coordinate vectors. -/
def projectiveDividedPowerContraction {n : ℕ}
    (marker : Option R) (a : Fin (n + 2) → R) : Fin (n + 1) → R :=
  match marker with
  | none => fun i => a i.castSucc
  | some r => PRSResidualQuadratic.dividedPowerContraction r a

/-- The infinity contraction is the leading consecutive Hankel row. -/
@[simp] theorem projectiveDividedPowerContraction_infinity {n : ℕ}
    (a : Fin (n + 2) → R) :
    projectiveDividedPowerContraction none a = fun i => a i.castSucc :=
  rfl

/-- A finite projective marker recovers ordinary divided-power contraction. -/
@[simp] theorem projectiveDividedPowerContraction_finite {n : ℕ}
    (r : R) (a : Fin (n + 2) → R) :
    projectiveDividedPowerContraction (some r) a =
      PRSResidualQuadratic.dividedPowerContraction r a :=
  rfl

/-- The sequence operation restricts to the finite divided-power contraction used by the
degree-specific Hankel modules. -/
theorem sequenceContraction_agrees_with_finite {n : ℕ} (r : R)
    (a : Fin (n + 2) → R) (i : Fin (n + 1)) :
    sequenceContraction r (fun j => if h : j < n + 2 then a ⟨j, h⟩ else 0) i =
      PRSResidualQuadratic.dividedPowerContraction r a i := by
  have hi : (i : ℕ) + 1 < n + 2 := Nat.succ_lt_succ i.isLt
  have hi0 : (i : ℕ) < n + 2 :=
    Nat.lt_trans i.isLt (Nat.lt_succ_self _)
  simp only [sequenceContraction, PRSResidualQuadratic.dividedPowerContraction]
  rw [dif_pos hi, dif_pos hi0]
  congr 2

/-- Consecutive contraction commutes with a base-ring homomorphism. -/
theorem sequenceContraction_map (φ : R →+* A) (r : R) (a : ℕ → R) :
    (fun i => φ (sequenceContraction r a i)) =
      sequenceContraction (φ r) (fun i => φ (a i)) := by
  funext i
  simp [sequenceContraction]

/-- Projective contraction, including the infinity marker, commutes with base change. -/
theorem projectiveSequenceContraction_map
    (φ : R →+* A) (marker : Option R) (a : ℕ → R) :
    (fun i => φ (projectiveSequenceContraction marker a i)) =
      projectiveSequenceContraction (marker.map φ) (fun i => φ (a i)) := by
  cases marker with
  | none => rfl
  | some r => exact sequenceContraction_map φ r a

/-- Every ordered iterated contraction commutes with a base-ring homomorphism. -/
theorem iteratedSequenceContraction_map (φ : R →+* A) (markers : List R)
    (a : ℕ → R) :
    (fun i => φ (iteratedSequenceContraction markers a i)) =
      iteratedSequenceContraction (markers.map φ) (fun i => φ (a i)) := by
  induction markers generalizing a with
  | nil => rfl
  | cons r markers ih =>
      simp only [iteratedSequenceContraction, List.foldl_cons, List.map_cons]
      rw [← sequenceContraction_map φ r a]
      exact ih (sequenceContraction r a)

/-- Every ordered projective contraction flag, including infinity markers, commutes with base
change. -/
theorem iteratedProjectiveSequenceContraction_map
    (φ : R →+* A) (markers : List (Option R)) (a : ℕ → R) :
    (fun i => φ (iteratedProjectiveSequenceContraction markers a i)) =
      iteratedProjectiveSequenceContraction (markers.map (Option.map φ))
        (fun i => φ (a i)) := by
  induction markers generalizing a with
  | nil => rfl
  | cons marker markers ih =>
      simp only [iteratedProjectiveSequenceContraction, List.foldl_cons, List.map_cons]
      rw [← projectiveSequenceContraction_map φ marker a]
      exact ih (projectiveSequenceContraction marker a)

/-- Two adjacent sequence contractions commute. -/
theorem sequenceContraction_comm (r s : R) (a : ℕ → R) :
    sequenceContraction s (sequenceContraction r a) =
      sequenceContraction r (sequenceContraction s a) := by
  funext i
  simp [sequenceContraction]
  ring

end Contraction

section Markers

variable {Marker Polynomial : Type*}

/-- A polynomial avoids an ordered marker list when it does not vanish at any retained marker. -/
def AvoidsMarkers (vanishesAt : Marker → Polynomial → Prop)
    (markers : List Marker) (polynomial : Polynomial) : Prop :=
  ∀ marker ∈ markers, ¬ vanishesAt marker polynomial

/-- Avoidance of a nonempty marker list separates its first marker from the remaining markers. -/
theorem avoidsMarkers_cons (vanishesAt : Marker → Polynomial → Prop)
    (marker : Marker) (markers : List Marker) (polynomial : Polynomial) :
    AvoidsMarkers vanishesAt (marker :: markers) polynomial ↔
      ¬ vanishesAt marker polynomial ∧
        AvoidsMarkers vanishesAt markers polynomial := by
  simp [AvoidsMarkers]

/-- The forbidden diagonal for an ordered marker list. -/
def HasRepeatedMarker [DecidableEq Marker] (markers : List Marker) : Prop :=
  ¬ markers.Nodup

/-- Adding a marker stays off the forbidden diagonal exactly when it is new and the old list was
already off the diagonal. -/
theorem not_hasRepeatedMarker_cons [DecidableEq Marker]
    (marker : Marker) (markers : List Marker) :
    ¬ HasRepeatedMarker (marker :: markers) ↔
      marker ∉ markers ∧ ¬ HasRepeatedMarker markers := by
  simp [HasRepeatedMarker]

end Markers

/-- Data that connect one pointed contraction to multiplication by its retained linear factor.
The equivalence is the abstract Hankel lifting identity.  The final field is the squarefreeness
condition that makes the forbidden-root exclusion indispensable. -/
structure PointedKernelLift (Syndrome Lower Polynomial Marker : Type*) where
  /-- Contraction of a syndrome at a marked projective point. -/
  contract : Syndrome → Marker → Lower
  /-- Multiplication of a lower polynomial by the marked linear factor. -/
  multiplyMarker : Marker → Polynomial → Polynomial
  /-- Hankel-kernel incidence before contraction. -/
  upperKernel : Syndrome → Polynomial → Prop
  /-- Hankel-kernel incidence after contraction. -/
  lowerKernel : Lower → Polynomial → Prop
  /-- Vanishing of a polynomial at the marked point. -/
  vanishesAt : Marker → Polynomial → Prop
  /-- Completely split squarefree polynomial predicate. -/
  isSplitSquarefree : Polynomial → Prop
  /-- A lower member lies in the contracted kernel exactly when its marked product lies in the
  original kernel. -/
  kernel_lift_iff :
    ∀ syndrome marker polynomial,
      lowerKernel (contract syndrome marker) polynomial ↔
        upperKernel syndrome (multiplyMarker marker polynomial)
  /-- A split squarefree lower member remains split and squarefree after multiplication precisely
  when it avoids the new marked root. -/
  squarefree_lift :
    ∀ {marker polynomial}, isSplitSquarefree polynomial →
      ¬ vanishesAt marker polynomial →
      isSplitSquarefree (multiplyMarker marker polynomial)

namespace PointedKernelLift

/-- A lower split squarefree kernel member avoiding the marker lifts to an upper split squarefree
kernel member. -/
theorem lift_splitSquarefreeKernelMember
    {Syndrome Lower Polynomial Marker : Type*}
    (lift : PointedKernelLift Syndrome Lower Polynomial Marker)
    {syndrome marker polynomial}
    (hkernel : lift.lowerKernel (lift.contract syndrome marker) polynomial)
    (hsplit : lift.isSplitSquarefree polynomial)
    (havoid : ¬ lift.vanishesAt marker polynomial) :
    lift.upperKernel syndrome (lift.multiplyMarker marker polynomial) ∧
      lift.isSplitSquarefree (lift.multiplyMarker marker polynomial) :=
  ⟨(lift.kernel_lift_iff syndrome marker polynomial).1 hkernel,
    lift.squarefree_lift hsplit havoid⟩

end PointedKernelLift

section ModularKernel

variable {R Syndrome Marker Lower : Type*}
  [CommRing R]
  [AddCommGroup Syndrome] [Module R Syndrome]
  [AddCommGroup Marker] [Module R Marker]
  [AddCommGroup Lower] [Module R Lower]

/-- Syndromes whose entire linear contraction family lands in a declared lower nucleus.
This is the linear-kernel form of the modular contained-component test: it is the kernel of the
contraction family after quotienting the lower syndrome space by the nucleus. -/
def modularContractionKernel
    (contractionFamily : Syndrome →ₗ[R] Marker →ₗ[R] Lower)
    (nucleus : Submodule R Lower) : Submodule R Syndrome where
  carrier := {syndrome | ∀ marker, contractionFamily syndrome marker ∈ nucleus}
  zero_mem' := by
    intro marker
    simp
  add_mem' := by
    intro first second hfirst hsecond marker
    simpa using nucleus.add_mem (hfirst marker) (hsecond marker)
  smul_mem' := by
    intro scalar syndrome hsyndrome marker
    simpa using nucleus.smul_mem scalar (hsyndrome marker)

/-- Membership in the modular contraction kernel is exactly containment of every contraction in
the lower nucleus. -/
theorem mem_modularContractionKernel_iff
    (contractionFamily : Syndrome →ₗ[R] Marker →ₗ[R] Lower)
    (nucleus : Submodule R Lower) (syndrome : Syndrome) :
    syndrome ∈ modularContractionKernel contractionFamily nucleus ↔
      ∀ marker, contractionFamily syndrome marker ∈ nucleus :=
  Iff.rfl

/-- A modular contraction kernel is preserved when the lower nucleus is enlarged. -/
theorem modularContractionKernel_mono
    (contractionFamily : Syndrome →ₗ[R] Marker →ₗ[R] Lower)
    {first second : Submodule R Lower} (hsub : first ≤ second) :
    modularContractionKernel contractionFamily first ≤
      modularContractionKernel contractionFamily second := by
  intro syndrome hsyndrome marker
  exact hsub (hsyndrome marker)

end ModularKernel

/-- Arithmetic data for one identity-Frobenius splitting-cover stratum.  The two numerical fields
give an integer-safe squared form of the Hasse--Weil deletion inequality: the post-deletion
baseline is positive, and its square exceeds `4g²q`. -/
structure LowerCoverStratum (q : ℕ) where
  /-- Genus bound for the normalization of the identity-Frobenius twist. -/
  genusBound : ℕ
  /-- Total degree removed by branch, diagonal, collision, and retained-marker divisors. -/
  deletionDegree : ℕ
  /-- The identity-Frobenius twist is geometrically integral. -/
  geometricallyIntegralIdentityTwist : Prop
  /-- At least one point remains in the `q+1` baseline before the genus correction. -/
  deletionBelowPointBaseline : deletionDegree < q + 1
  /-- Squared integer form of the strict Hasse--Weil inequality after all declared deletions. -/
  squaredHasseWeilDeletionBound :
    4 * genusBound ^ 2 * q < (q + 1 - deletionDegree) ^ 2

/-- Explicit contained-versus-transverse inputs for one coherent polar family.  The finite marker
type models the rational points of the projective line.  Its cardinality, the lower-cover
threshold, and both intersection budgets are stated independently so that degree-specific modules
cannot hide them in a finite table. -/
structure CoherentPolarInput
    (Syndrome Marker Witness : Type*) [Fintype Marker] [DecidableEq Marker]
    (q lowerThreshold transverseBudget collisionBudget : ℕ) where
  /-- Split-free syndrome predicate at the upper level. -/
  isSplitFree : Syndrome → Prop
  /-- Persistent tangent or conjugate-sigma component. -/
  persistent : Syndrome → Prop
  /-- Modular-nucleus contained component. -/
  modular : Syndrome → Prop
  /-- Scheme-theoretic containment of the coherent pointed polar graph in a lower bad carrier. -/
  contained : Syndrome → Prop
  /-- Parameters where a noncontained polar family meets the lower bad carrier. -/
  lowerBadParameters : Syndrome → Finset Marker
  /-- Retained-marker repetitions and self-collision parameters. -/
  collisionParameters : Syndrome → Finset Marker
  /-- A rational lower-cover point outside all deletions, packaged as a liftable witness. -/
  witnessAt : Syndrome → Marker → Witness → Prop
  /-- Identity-Frobenius cover strata with their explicit genus and deletion data. -/
  lowerCoverStrata : List (LowerCoverStratum q)
  /-- The marker line has exactly `q+1` rational points. -/
  markerCardinality : Fintype.card Marker = q + 1
  /-- Every contained polar graph is one of the two classified components. -/
  containedClassification :
    ∀ {syndrome}, contained syndrome → persistent syndrome ∨ modular syndrome
  /-- A noncontained graph meets the lower bad carrier within the declared degree. -/
  lowerBadCard :
    ∀ {syndrome}, ¬ contained syndrome →
      (lowerBadParameters syndrome).card ≤ transverseBudget
  /-- The marked collision divisor has the declared degree bound off the contained locus. -/
  collisionCard :
    ∀ {syndrome}, ¬ contained syndrome →
      (collisionParameters syndrome).card ≤ collisionBudget
  /-- The lower splitting package supplies a witness at every parameter outside both divisors. -/
  lowerWitness :
    q ≥ lowerThreshold →
      ∀ {syndrome marker}, ¬ contained syndrome →
        marker ∉ lowerBadParameters syndrome →
        marker ∉ collisionParameters syndrome →
        ∃ stratum ∈ lowerCoverStrata,
          stratum.geometricallyIntegralIdentityTwist ∧
            ∃ witness, witnessAt syndrome marker witness
  /-- Every lifted witness contradicts upper split-freeness. -/
  witnessContradictsSplitFree :
    ∀ {syndrome marker witness}, witnessAt syndrome marker witness →
      ¬ isSplitFree syndrome

namespace CoherentPolarInput

/-- Outside the classified contained components, a split-free syndrome can exist only when the
lower threshold or the rational-parameter budget fails. -/
theorem splitFree_implies_persistent_or_modular
    {Syndrome Marker Witness : Type*} [Fintype Marker] [DecidableEq Marker]
    {q lowerThreshold transverseBudget collisionBudget : ℕ}
    (input : CoherentPolarInput Syndrome Marker Witness
      q lowerThreshold transverseBudget collisionBudget)
    (hlower : q ≥ lowerThreshold)
    (hparameters : q + 1 > transverseBudget + collisionBudget)
    {syndrome : Syndrome} (hsplitFree : input.isSplitFree syndrome) :
    input.persistent syndrome ∨ input.modular syndrome := by
  by_cases hcontained : input.contained syndrome
  · exact input.containedClassification hcontained
  · have hunionCard :
        (input.lowerBadParameters syndrome ∪
          input.collisionParameters syndrome).card <
            Fintype.card Marker := by
      calc
        (input.lowerBadParameters syndrome ∪
            input.collisionParameters syndrome).card
            ≤ (input.lowerBadParameters syndrome).card +
                (input.collisionParameters syndrome).card :=
          Finset.card_union_le _ _
        _ ≤ transverseBudget + collisionBudget :=
          Nat.add_le_add (input.lowerBadCard hcontained)
            (input.collisionCard hcontained)
        _ < q + 1 := hparameters
        _ = Fintype.card Marker := input.markerCardinality.symm
    have hmarker :
        ∃ marker : Marker,
          marker ∉ input.lowerBadParameters syndrome ∧
            marker ∉ input.collisionParameters syndrome := by
      classical
      have hnsubset :
          ¬(Finset.univ : Finset Marker) ⊆
            input.lowerBadParameters syndrome ∪
              input.collisionParameters syndrome := by
        intro hsubset
        have hcard := Finset.card_le_card hsubset
        rw [Finset.card_univ] at hcard
        omega
      rw [Finset.not_subset] at hnsubset
      obtain ⟨marker, -, hnotmem⟩ := hnsubset
      exact ⟨marker, by
        simpa [Finset.mem_union, not_or] using hnotmem⟩
    obtain ⟨marker, hbad, hcollision⟩ := hmarker
    obtain ⟨-, -, -, witness, hwitness⟩ :=
      input.lowerWitness hlower hcontained hbad hcollision
    exact False.elim ((input.witnessContradictsSplitFree hwitness) hsplitFree)

end CoherentPolarInput

/-- Scalar tangent-fibre cocycle `z ↦ z + n u`. -/
def tangentTranslate {K : Type*} [Semiring K] (n : ℕ) (u z : K) : K :=
  z + (n : K) * u

/-- When the degree scalar vanishes, every additive translation fixes the tangent coordinate. -/
theorem tangentTranslate_of_cast_eq_zero {K : Type*} [Semiring K]
    {n : ℕ} (hn : (n : K) = 0) (u z : K) :
    tangentTranslate n u z = z := by
  simp [tangentTranslate, hn]

/-- Over a field, a nonzero degree scalar makes the tangent translations transitive. -/
theorem tangentTranslate_surjective {K : Type*} [Field K]
    {n : ℕ} (hn : (n : K) ≠ 0) (z w : K) :
    ∃ u, tangentTranslate n u z = w := by
  refine ⟨(w - z) / (n : K), ?_⟩
  rw [tangentTranslate,
    mul_comm (n : K) ((w - z) / (n : K)), div_mul_cancel₀ _ hn]
  ring

/-- Number of inversion-orbits in a cyclic quotient of order `d`.  Degree-specific modules still
must identify the actual norm-one torus quotient and Frobenius action. -/
def sigmaInversionOrbitCount (d : ℕ) : ℕ :=
  d / 2 + 1

/-- The only quotient orders occurring for the fifth-power sigma law have one or three
inversion-orbits. -/
theorem fifthPower_sigmaInversionOrbitCount :
    sigmaInversionOrbitCount 1 = 1 ∧
      sigmaInversionOrbitCount 5 = 3 := by
  decide

/-- The quotient orders occurring for the sixth-power sigma law have the stated
inversion-orbit counts. -/
theorem sixthPower_sigmaInversionOrbitCount :
    sigmaInversionOrbitCount 1 = 1 ∧
      sigmaInversionOrbitCount 2 = 2 ∧
      sigmaInversionOrbitCount 3 = 2 ∧
      sigmaInversionOrbitCount 6 = 4 := by
  decide

end RelativeConicArcs.PRSPolarInduction
