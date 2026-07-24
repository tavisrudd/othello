import Mathlib.Data.Nat.Multiplicity
import RelativeConicArcs.PRSPolarInduction

/-!
# Characteristic-two divided Hessians and Lucas carriers

This module records the modular algebra used by the projective Reed--Solomon polar-induction
argument.  For a divided-power binary cubic it defines the three residual minors, the integral
quartic discriminant, and the divided Hessian.  In characteristic two the quartic is proved to be
the square of the tangent-quadric equation.  The residual-root equation is then converted, on its
separable chart, to an Artin--Schreier equation.

For a pencil of divided-power cubics, the ordered Hessian equation is proved to be homogeneous of
degree two in both the pencil parameter and the ordered root.  Explicit Pluecker coordinates check
the common-quadratic Veronese family, while two Segre parametrizations check the two rulings of the
characteristic-two tangent quadric.  The geometric assertion that these are all reduced degenerate
sections is retained as a structure field, as are root-compatible containment and the coding
interpretation.

The Lucas layer proves the power-of-two binomial vanishing and the resulting consecutive-row
overlap interval.  Each modular carrier is defined through
`PRSPolarInduction.modularContractionKernel`; ordered projective contraction flags retain their
markers and commute with scalar extension.  The degree-nine endpoint is limited to its additive
eight-root subcover.  Its exact witness-count implication is formalized without making a statement
about any other degree-nine carrier stratum.

There are no finite certificates or external oracles in this module.  Algebraic identities and
integer arithmetic are kernel checked.  Geometric integrality, the exhaustive line-section
classification, finite-field root-cover semantics, and the coding dictionary occur only as
explicit hypotheses or structure fields.
-/

namespace RelativeConicArcs.PRSCharacteristicTwoHessianLucas

open PRSPolarInduction

section DividedCubic

variable {R : Type*}

/-- Coefficients `(A,B,C,D)` of a divided-power binary cubic. -/
@[ext] structure DividedCubic (R : Type*) where
  A : R
  B : R
  C : R
  D : R

namespace DividedCubic

variable [CommRing R]

/-- Determinant coefficient of the divided Hessian at `Y²`. -/
def determinant (c : DividedCubic R) : R :=
  c.B * c.D - c.C ^ 2

/-- Mixed coefficient of the divided Hessian. -/
def sumNumerator (c : DividedCubic R) : R :=
  c.A * c.D - c.B * c.C

/-- Determinant coefficient of the divided Hessian at `X²`. -/
def productNumerator (c : DividedCubic R) : R :=
  c.A * c.C - c.B ^ 2

/-- The divided Hessian evaluated at homogeneous root coordinates `(x,y)`. -/
def dividedHessian (c : DividedCubic R) (x y : R) : R :=
  productNumerator c * x ^ 2 + sumNumerator c * x * y + determinant c * y ^ 2

/-- Integral divided-power cubic discriminant.  Multiplying this expression by `-27` gives the
ordinary discriminant of `A X³ + 3 B X²Y + 3 C XY² + D Y³`. -/
def dividedDiscriminant (c : DividedCubic R) : R :=
  c.A ^ 2 * c.D ^ 2 - 6 * c.A * c.B * c.C * c.D -
    3 * c.B ^ 2 * c.C ^ 2 + 4 * c.A * c.C ^ 3 + 4 * c.B ^ 3 * c.D

/-- The discriminant is the residual-quadratic branch expression over every commutative ring. -/
theorem dividedDiscriminant_eq_residualBranch (c : DividedCubic R) :
    dividedDiscriminant c =
      sumNumerator c ^ 2 - 4 * determinant c * productNumerator c := by
  simp only [dividedDiscriminant, sumNumerator, determinant, productNumerator]
  ring

/-- In characteristic two the integral discriminant is the doubled tangent quadric
`(AD+BC)²`. -/
theorem dividedDiscriminant_eq_tangentQuadric_sq [CharP R 2]
    (c : DividedCubic R) :
    dividedDiscriminant c = (c.A * c.D + c.B * c.C) ^ 2 := by
  simp only [dividedDiscriminant]
  have htwo : (2 : R) = 0 := CharP.cast_eq_zero R 2
  have hthree : (3 : R) = 1 := by
    calc
      (3 : R) = (2 : R) + 1 := by norm_num
      _ = 1 := by rw [htwo, zero_add]
  have hfour : (4 : R) = 0 := by
    calc
      (4 : R) = (2 : R) + (2 : R) := by norm_num
      _ = 0 := by rw [htwo, zero_add]
  have hsix : (6 : R) = 0 := by
    calc
      (6 : R) = (2 : R) * (3 : R) := by norm_num
      _ = 0 := by rw [htwo, zero_mul]
  rw [show (6 : R) = 0 from hsix, show (3 : R) = 1 from hthree,
    show (4 : R) = 0 from hfour, add_sq]
  simp only [sub_eq_add_neg, CharTwo.neg_eq, htwo, zero_mul, add_zero]
  ring

/-- The residual quadratic attached to the divided Hessian. -/
def residualQuadratic (c : DividedCubic R) (t : R) : R :=
  determinant c * t ^ 2 - sumNumerator c * t + productNumerator c

end DividedCubic

namespace DividedCubic

variable [Field R]

/-- Arf representative of a nonsingular divided Hessian on the chart where its mixed coefficient
is nonzero. -/
def arfRepresentative (c : DividedCubic R) : R :=
  determinant c * productNumerator c / sumNumerator c ^ 2

/-- The specialization `(A,0,1,1)` has Arf representative `1/A`.  This is the algebraic
specialization used to expose a nonconstant Artin--Schreier class; geometric nontriviality of the
class is not inferred here. -/
theorem arfRepresentative_specialization [CharP R 2] (A : R) (hA : A ≠ 0) :
    arfRepresentative ⟨A, 0, 1, 1⟩ = 1 / A := by
  simp only [arfRepresentative, determinant, productNumerator, sumNumerator,
    CharTwo.sub_eq_add]
  norm_num [hA]
  field_simp [hA]

/-- On the chart where the mixed Hessian coefficient is invertible, the residual equation is
equivalent to the Artin--Schreier equation with Arf representative
`determinant * productNumerator / sumNumerator²`. -/
theorem residualQuadratic_eq_zero_iff_artinSchreier
    [CharP R 2] (c : DividedCubic R)
    (hd : determinant c ≠ 0) (hs : sumNumerator c ≠ 0) (t : R) :
    residualQuadratic c t = 0 ↔
      (determinant c * t / sumNumerator c) ^ 2 +
          determinant c * t / sumNumerator c =
        determinant c * productNumerator c / sumNumerator c ^ 2 := by
  have hid :
      sumNumerator c ^ 2 *
          ((determinant c * t / sumNumerator c) ^ 2 +
            determinant c * t / sumNumerator c -
            determinant c * productNumerator c / sumNumerator c ^ 2) =
        determinant c * residualQuadratic c t := by
    field_simp [hs]
    simp only [residualQuadratic, CharTwo.sub_eq_add]
    ring
  constructor
  · intro hroot
    apply sub_eq_zero.mp
    have hproduct :
        sumNumerator c ^ 2 *
            ((determinant c * t / sumNumerator c) ^ 2 +
              determinant c * t / sumNumerator c -
              determinant c * productNumerator c / sumNumerator c ^ 2) = 0 := by
      rw [hid, hroot, mul_zero]
    exact (mul_eq_zero.mp hproduct).resolve_left (pow_ne_zero 2 hs)
  · intro has
    have hdiff :
        (determinant c * t / sumNumerator c) ^ 2 +
            determinant c * t / sumNumerator c -
            determinant c * productNumerator c / sumNumerator c ^ 2 = 0 :=
      sub_eq_zero.mpr has
    have hproduct : determinant c * residualQuadratic c t = 0 := by
      rw [← hid, hdiff, mul_zero]
    exact (mul_eq_zero.mp hproduct).resolve_left hd

end DividedCubic

namespace DividedCubic

variable [CommRing R]

/-- The divided Hessian has degree two in its root coordinates. -/
theorem dividedHessian_scale_root (c : DividedCubic R) (scalar x y : R) :
    dividedHessian c (scalar * x) (scalar * y) =
      scalar ^ 2 * dividedHessian c x y := by
  simp only [dividedHessian]
  ring

end DividedCubic

end DividedCubic

section OrderedHessian

variable {R : Type*} [CommRing R]

/-- Linear combination of the two endpoints of a divided-cubic pencil. -/
def pencilCubic (first second : DividedCubic R) (u v : R) : DividedCubic R where
  A := u * first.A + v * second.A
  B := u * first.B + v * second.B
  C := u * first.C + v * second.C
  D := u * first.D + v * second.D

/-- Ordered divided-Hessian incidence equation for a cubic pencil. -/
def orderedHessianEquation
    (first second : DividedCubic R) (u v x y : R) : R :=
  (pencilCubic first second u v).dividedHessian x y

/-- The ordered Hessian equation has degree two in the pencil parameter. -/
theorem orderedHessianEquation_scale_parameter
    (first second : DividedCubic R) (scalar u v x y : R) :
    orderedHessianEquation first second (scalar * u) (scalar * v) x y =
      scalar ^ 2 * orderedHessianEquation first second u v x y := by
  simp only [orderedHessianEquation, pencilCubic, DividedCubic.dividedHessian,
    DividedCubic.productNumerator, DividedCubic.sumNumerator,
    DividedCubic.determinant]
  ring

/-- The ordered Hessian equation has degree two in the ordered-root coordinate. -/
theorem orderedHessianEquation_scale_root
    (first second : DividedCubic R) (scalar u v x y : R) :
    orderedHessianEquation first second u v (scalar * x) (scalar * y) =
      scalar ^ 2 * orderedHessianEquation first second u v x y :=
  DividedCubic.dividedHessian_scale_root _ _ _ _

/-- Pluecker coordinates in the order `(p01,p02,p03,p12,p13,p23)`. -/
def plueckerCoordinates
    (first second : DividedCubic R) : Fin 6 → R
  | 0 => first.A * second.B - first.B * second.A
  | 1 => first.A * second.C - first.C * second.A
  | 2 => first.A * second.D - first.D * second.A
  | 3 => first.B * second.C - first.C * second.B
  | 4 => first.B * second.D - first.D * second.B
  | 5 => first.C * second.D - first.D * second.C

/-- The two cubic generators obtained by multiplying a binary quadratic by the two coordinate
linear forms. -/
def commonQuadraticPencil (a b c : R) : DividedCubic R × DividedCubic R :=
  (⟨a, b, c, 0⟩, ⟨0, a, b, c⟩)

/-- In characteristic two the common-quadratic pencil has the Veronese Pluecker coordinates
`(a²,ab,ac,b²+ac,bc,c²)`. -/
theorem commonQuadraticPencil_pluecker [CharP R 2] (a b c : R) :
    plueckerCoordinates (commonQuadraticPencil a b c).1
        (commonQuadraticPencil a b c).2 =
      ![a ^ 2, a * b, a * c, b ^ 2 + a * c, b * c, c ^ 2] := by
  funext i
  fin_cases i <;>
    simp [plueckerCoordinates, commonQuadraticPencil, pow_two]
  rw [sub_eq_add_neg, CharTwo.neg_eq]
  ring

/-- Equation of the reduced characteristic-two tangent quadric. -/
def tangentQuadricEquation (c : DividedCubic R) : R :=
  c.A * c.D + c.B * c.C

/-- Segre coordinates on the tangent quadric. -/
def segreCubic (r u v w : R) : DividedCubic R :=
  ⟨r * v, r * w, u * v, u * w⟩

/-- Every Segre point lies on the characteristic-two tangent quadric. -/
theorem segreCubic_mem_tangentQuadric [CharP R 2] (r u v w : R) :
    tangentQuadricEquation (segreCubic r u v w) = 0 := by
  simp only [tangentQuadricEquation, segreCubic]
  have htwo : (2 : R) = 0 := CharP.cast_eq_zero R 2
  calc
    r * v * (u * w) + r * w * (u * v) =
        (2 : R) * (r * u * v * w) := by ring
    _ = 0 := by rw [htwo, zero_mul]

/-- A line obtained by fixing the first Segre coordinate lies on one quadric ruling. -/
theorem firstSegreRuling_mem_tangentQuadric [CharP R 2]
    (r u v₀ w₀ v₁ w₁ s t : R) :
    tangentQuadricEquation
      (pencilCubic (segreCubic r u v₀ w₀) (segreCubic r u v₁ w₁) s t) = 0 := by
  simp only [tangentQuadricEquation, pencilCubic, segreCubic]
  have htwo : (2 : R) = 0 := CharP.cast_eq_zero R 2
  calc
    (s * (r * v₀) + t * (r * v₁)) *
          (s * (u * w₀) + t * (u * w₁)) +
        (s * (r * w₀) + t * (r * w₁)) *
          (s * (u * v₀) + t * (u * v₁)) =
        (2 : R) * (r * u *
          (s ^ 2 * v₀ * w₀ + s * t * (v₀ * w₁ + v₁ * w₀) +
            t ^ 2 * v₁ * w₁)) := by ring
    _ = 0 := by rw [htwo, zero_mul]

/-- A line obtained by fixing the second Segre coordinate lies on the complementary ruling. -/
theorem secondSegreRuling_mem_tangentQuadric [CharP R 2]
    (r₀ u₀ r₁ u₁ v w s t : R) :
    tangentQuadricEquation
      (pencilCubic (segreCubic r₀ u₀ v w) (segreCubic r₁ u₁ v w) s t) = 0 := by
  simp only [tangentQuadricEquation, pencilCubic, segreCubic]
  have htwo : (2 : R) = 0 := CharP.cast_eq_zero R 2
  calc
    (s * (r₀ * v) + t * (r₁ * v)) *
          (s * (u₀ * w) + t * (u₁ * w)) +
        (s * (r₀ * w) + t * (r₁ * w)) *
          (s * (u₀ * v) + t * (u₁ * v)) =
        (2 : R) * (v * w *
          (s ^ 2 * r₀ * u₀ + s * t * (r₀ * u₁ + r₁ * u₀) +
            t ^ 2 * r₁ * u₁)) := by ring
    _ = 0 := by rw [htwo, zero_mul]

/-- Explicit geometric and root-compatible classification boundary for reduced ordered-Hessian
line sections.  All fields are propositions so downstream theorems expose, rather than conceal,
the algebraic-geometry input. -/
structure OrderedHessianCarrierData (Line Syndrome : Type*) where
  /-- The reduced moving `(2,2)` section is geometrically degenerate. -/
  reducedDegenerate : Line → Prop
  /-- The line belongs to the common-quadratic Veronese family. -/
  veronese : Line → Prop
  /-- The line belongs to the tangent ruling of the doubled discriminant quadric. -/
  tangentRuling : Line → Prop
  /-- The line belongs to the complementary ruling. -/
  complementaryRuling : Line → Prop
  /-- The line is a rank-at-most-one root-compatible contraction. -/
  rootCompatibleRankAtMostOne : Line → Prop
  /-- The syndrome pullback is contained in the reduced degenerate locus. -/
  containedPullback : Syndrome → Prop
  /-- Persistent catalecticant rank-two syndrome predicate. -/
  persistent : Syndrome → Prop
  /-- Lucas-nucleus modular carrier predicate. -/
  lucas : Syndrome → Prop
  /-- After forced vertical factors are removed, the three displayed families exhaust geometric
  degeneracy. -/
  reducedDegenerate_iff :
    ∀ line, reducedDegenerate line ↔
      veronese line ∨ tangentRuling line ∨ complementaryRuling line
  /-- A complementary-ruling root-compatible line has rank at most one. -/
  complementary_rootCompatible_rankAtMostOne :
    ∀ line, complementaryRuling line → rootCompatibleRankAtMostOne line
  /-- Nontrivial root-compatible containment is exactly the persistent or Lucas carrier union. -/
  containedPullback_iff :
    ∀ syndrome, containedPullback syndrome ↔ persistent syndrome ∨ lucas syndrome

namespace OrderedHessianCarrierData

/-- The recorded root-compatible classification exposes exactly the persistent/Lucas containment
conclusion and the rank-one boundary of the complementary ruling. -/
theorem carrier_and_complementary_boundary
    {Line Syndrome : Type*} (data : OrderedHessianCarrierData Line Syndrome)
    (syndrome : Syndrome) (line : Line) :
    (data.containedPullback syndrome ↔
      data.persistent syndrome ∨ data.lucas syndrome) ∧
      (data.complementaryRuling line → data.rootCompatibleRankAtMostOne line) :=
  ⟨data.containedPullback_iff syndrome,
    data.complementary_rootCompatible_rankAtMostOne line⟩

end OrderedHessianCarrierData

end OrderedHessian

section EffectiveBounds

/-- Effective field-order threshold for selecting a good characteristic-two root-compatible
ordered-Hessian slice in syndrome degree `n`. -/
def orderedHessianBaseThreshold (n : ℕ) : ℕ :=
  min (((n - 4) * (n + 11)) / 2 + 1) (9 * (n - 4))

/-- Total branch, diagonal, collision, and retained-root deletion budget in syndrome degree `n`. -/
def orderedHessianDeletionBudget (n : ℕ) : ℕ :=
  3 * n - 4

/-- A genus-one ordered-Hessian stratum uses exactly the integer-safe squared Hasse--Weil fields
from `LowerCoverStratum`; no floor-rounded square root is used. -/
def orderedHessianLowerCoverStratum
    (q n : ℕ) (geometricallyIntegral : Prop)
    (hbaseline : orderedHessianDeletionBudget n < q + 1)
    (hsquared :
      4 * 1 ^ 2 * q <
        (q + 1 - orderedHessianDeletionBudget n) ^ 2) :
    LowerCoverStratum q where
  genusBound := 1
  deletionDegree := orderedHessianDeletionBudget n
  geometricallyIntegralIdentityTwist := geometricallyIntegral
  deletionBelowPointBaseline := hbaseline
  squaredHasseWeilDeletionBound := hsquared

/-- The characteristic-two ordered-Hessian synthesis is the shared coherent-polar theorem with
the effective base threshold and deletion arithmetic kept visible. -/
theorem splitFree_implies_persistent_or_lucas
    {Syndrome Marker Witness : Type*} [Fintype Marker] [DecidableEq Marker]
    {q n transverseBudget collisionBudget : ℕ}
    (input : CoherentPolarInput Syndrome Marker Witness
      q (orderedHessianBaseThreshold n) transverseBudget collisionBudget)
    (hbase : q ≥ orderedHessianBaseThreshold n)
    (hparameters : q + 1 > transverseBudget + collisionBudget)
    {syndrome : Syndrome} (hsplitFree : input.isSplitFree syndrome) :
    input.persistent syndrome ∨ input.modular syndrome :=
  input.splitFree_implies_persistent_or_modular hbase hparameters hsplitFree

end EffectiveBounds

section LucasArithmetic

/-- Interior binomial coefficients in a power-of-two row are even. -/
theorem two_dvd_choose_two_pow {s i : ℕ}
    (hi0 : i ≠ 0) (hitop : i ≠ 2 ^ s) :
    2 ∣ (2 ^ s).choose i :=
  Nat.prime_two.dvd_choose_pow hi0 hitop

/-- Coordinate predicate for the top nucleus of the degree-`d` normal rational curve. -/
def topNucleusIndex (d i : ℕ) : Prop :=
  0 < i ∧ i < d

/-- Consecutive-row overlap predicate for lifting a lower nucleus from degree `d` to degree
`d+1`. -/
def consecutiveOverlapIndex (d i : ℕ) : Prop :=
  (i = d + 1 ∨ topNucleusIndex d i) ∧
    (i = 0 ∨ topNucleusIndex d (i - 1))

/-- For `d ≥ 2`, the top-nucleus consecutive overlap is exactly the interval
`2 ≤ i ≤ d-1`, corresponding to the coordinate span `e₂,…,e_{d-1}`. -/
theorem consecutiveOverlapIndex_iff {d i : ℕ} (hd : 2 ≤ d) :
    consecutiveOverlapIndex d i ↔ 2 ≤ i ∧ i ≤ d - 1 := by
  simp only [consecutiveOverlapIndex, topNucleusIndex]
  omega

/-- Degree-five Lucas carrier instantiated through the shared modular contraction kernel. -/
def degreeFiveLucasCarrier
    {R Syndrome Marker Lower : Type*}
    [CommRing R] [AddCommGroup Syndrome] [Module R Syndrome]
    [AddCommGroup Marker] [Module R Marker]
    [AddCommGroup Lower] [Module R Lower]
    (contractionFamily : Syndrome →ₗ[R] Marker →ₗ[R] Lower)
    (degreeFourTopNucleus : Submodule R Lower) : Submodule R Syndrome :=
  modularContractionKernel contractionFamily degreeFourTopNucleus

/-- Degree-six Lucas carrier instantiated through the shared modular contraction kernel. -/
def degreeSixLucasCarrier
    {R Syndrome Marker Lower : Type*}
    [CommRing R] [AddCommGroup Syndrome] [Module R Syndrome]
    [AddCommGroup Marker] [Module R Marker]
    [AddCommGroup Lower] [Module R Lower]
    (contractionFamily : Syndrome →ₗ[R] Marker →ₗ[R] Lower)
    (degreeFiveNucleus : Submodule R Lower) : Submodule R Syndrome :=
  modularContractionKernel contractionFamily degreeFiveNucleus

/-- Degree-nine Lucas carrier instantiated through the shared modular contraction kernel. -/
def degreeNineLucasCarrier
    {R Syndrome Marker Lower : Type*}
    [CommRing R] [AddCommGroup Syndrome] [Module R Syndrome]
    [AddCommGroup Marker] [Module R Marker]
    [AddCommGroup Lower] [Module R Lower]
    (contractionFamily : Syndrome →ₗ[R] Marker →ₗ[R] Lower)
    (degreeEightTopNucleus : Submodule R Lower) : Submodule R Syndrome :=
  modularContractionKernel contractionFamily degreeEightTopNucleus

/-- Membership in the degree-nine Lucas carrier is exactly containment of every contraction in
the degree-eight top nucleus. -/
theorem mem_degreeNineLucasCarrier_iff
    {R Syndrome Marker Lower : Type*}
    [CommRing R] [AddCommGroup Syndrome] [Module R Syndrome]
    [AddCommGroup Marker] [Module R Marker]
    [AddCommGroup Lower] [Module R Lower]
    (contractionFamily : Syndrome →ₗ[R] Marker →ₗ[R] Lower)
    (degreeEightTopNucleus : Submodule R Lower) (syndrome : Syndrome) :
    syndrome ∈ degreeNineLucasCarrier contractionFamily degreeEightTopNucleus ↔
      ∀ marker, contractionFamily syndrome marker ∈ degreeEightTopNucleus :=
  Iff.rfl

/-- Membership in the degree-five Lucas carrier is exactly containment of every contraction in
the degree-four top nucleus. -/
theorem mem_degreeFiveLucasCarrier_iff
    {R Syndrome Marker Lower : Type*}
    [CommRing R] [AddCommGroup Syndrome] [Module R Syndrome]
    [AddCommGroup Marker] [Module R Marker]
    [AddCommGroup Lower] [Module R Lower]
    (contractionFamily : Syndrome →ₗ[R] Marker →ₗ[R] Lower)
    (degreeFourTopNucleus : Submodule R Lower) (syndrome : Syndrome) :
    syndrome ∈ degreeFiveLucasCarrier contractionFamily degreeFourTopNucleus ↔
      ∀ marker, contractionFamily syndrome marker ∈ degreeFourTopNucleus :=
  Iff.rfl

/-- Membership in the degree-six Lucas carrier is exactly containment of every contraction in
the degree-five nucleus. -/
theorem mem_degreeSixLucasCarrier_iff
    {R Syndrome Marker Lower : Type*}
    [CommRing R] [AddCommGroup Syndrome] [Module R Syndrome]
    [AddCommGroup Marker] [Module R Marker]
    [AddCommGroup Lower] [Module R Lower]
    (contractionFamily : Syndrome →ₗ[R] Marker →ₗ[R] Lower)
    (degreeFiveNucleus : Submodule R Lower) (syndrome : Syndrome) :
    syndrome ∈ degreeSixLucasCarrier contractionFamily degreeFiveNucleus ↔
      ∀ marker, contractionFamily syndrome marker ∈ degreeFiveNucleus :=
  Iff.rfl

/-- Ordered Lucas contraction flags retain projective markers and commute with base change. -/
theorem lucasFlagContraction_map
    {R A : Type*} [CommRing R] [CommRing A]
    (φ : R →+* A) (markers : List (Option R)) (coefficients : ℕ → R) :
    (fun i => φ (iteratedProjectiveSequenceContraction markers coefficients i)) =
      iteratedProjectiveSequenceContraction (markers.map (Option.map φ))
        (fun i => φ (coefficients i)) :=
  iteratedProjectiveSequenceContraction_map φ markers coefficients

/-- The exact Frobenius permutation on the seven nonzero labels of the degree-eight linearized
root space. -/
def doublingModSeven (i : Fin 7) : Fin 7 :=
  ⟨(2 * i) % 7, Nat.mod_lt _ (by decide)⟩

/-- Frobenius doubling on the three labels of the degree-four linearized root space. -/
def doublingModThree (i : Fin 3) : Fin 3 :=
  ⟨(2 * i) % 3, Nat.mod_lt _ (by decide)⟩

/-- Doubling modulo three fixes zero and exchanges the two nonzero labels. -/
theorem doublingModThree_cycle_table :
    (doublingModThree 0, doublingModThree 1, doublingModThree 2) =
      (0, 2, 1) := by
  decide

/-- Doubling modulo seven fixes zero and has the two three-cycles
`1→2→4→1` and `3→6→5→3`. -/
theorem doublingModSeven_cycle_table :
    (doublingModSeven 0, doublingModSeven 1, doublingModSeven 2,
      doublingModSeven 3, doublingModSeven 4, doublingModSeven 5,
      doublingModSeven 6) =
      (0, 2, 4, 6, 1, 3, 5) := by
  decide

/-- Arithmetic boundary for the normalized power-of-two linearized root cover.  The splitting
criterion and constant-field assertions are fields because their proof uses finite-field and
geometric-monodromy semantics not developed in this module. -/
structure LinearizedRootCoverData (s : ℕ) where
  /-- The power-of-two root-space dimension is positive. -/
  two_le_s : 2 ≤ s
  /-- Minimal constant-field degree of the normalized cover. -/
  minimalConstantFieldDegree : ℕ
  /-- Order of the based residual scaling group. -/
  basedDeckGroupOrder : ℕ
  /-- Exact constant-field degree. -/
  minimalConstantFieldDegree_eq : minimalConstantFieldDegree = s
  /-- Exact based deck-group order. -/
  basedDeckGroupOrder_eq : basedDeckGroupOrder = 2 ^ s - 1
  /-- A split squarefree linearized member over extension degree `m`. -/
  hasSplitSquarefreeMember : ℕ → Prop
  /-- The member exists exactly when the constant field embeds. -/
  split_iff_dvd : ∀ m, hasSplitSquarefreeMember m ↔ s ∣ m

namespace LinearizedRootCoverData

/-- The normalized linearized cover packages the exact divisibility law and deck-group order. -/
theorem arithmetic_terminal {s : ℕ} (data : LinearizedRootCoverData s) (m : ℕ) :
    data.hasSplitSquarefreeMember m ↔ s ∣ m :=
  data.split_iff_dvd m

end LinearizedRootCoverData

end LucasArithmetic

section DegreeNineAdditiveSubcover

variable {K : Type*}

/-- Sum of the four free framed roots in the normalized degree-eight endpoint incidence. -/
def endpointFreeRootSum [Add K] (a b c d : K) : K :=
  a + b + c + d

/-- Pairwise-product sum of the four free framed roots. -/
def endpointFreeRootPairSum [CommSemiring K] (a b c d : K) : K :=
  a * b + a * c + a * d + b * c + b * d + c * d

/-- Sum of the last two roots after the roots `0` and `1` have been framed. -/
def endpointLastPairSum [AddMonoidWithOne K] (a b c d : K) : K :=
  1 + endpointFreeRootSum a b c d

/-- Product of the last two roots after the degree-seven and degree-six coefficients vanish. -/
def endpointLastPairProduct [CommSemiring K] (a b c d : K) : K :=
  1 + endpointFreeRootPairSum a b c d + endpointFreeRootSum a b c d +
    endpointFreeRootSum a b c d ^ 2

/-- In characteristic two, vanishing of the sum of the last two roots is exactly their collision.
Thus the divisor removed from the normalized Artin--Schreier chart has its squarefree semantics
without an additional hypothesis. -/
theorem lastPairSum_zero_iff_roots_equal
    [Ring K] [CharP K 2] (u v : K) :
    u + v = 0 ↔ u = v := by
  constructor
  · intro h
    apply sub_eq_zero.mp
    simpa only [CharTwo.sub_eq_add] using h
  · intro h
    subst v
    exact CharTwo.add_self_eq_zero u

/-- On the squarefree chart where the last-pair sum is nonzero, the last-pair quadratic becomes
the normalized Artin--Schreier equation `y²+y=p/h²`. -/
theorem endpointLastPair_artinSchreier
    [Field K] [CharP K 2] (a b c d u : K)
    (hh : endpointLastPairSum a b c d ≠ 0) :
    u ^ 2 + endpointLastPairSum a b c d * u +
          endpointLastPairProduct a b c d = 0 ↔
      (u / endpointLastPairSum a b c d) ^ 2 +
          u / endpointLastPairSum a b c d =
        endpointLastPairProduct a b c d /
          endpointLastPairSum a b c d ^ 2 := by
  rw [show
    u ^ 2 + endpointLastPairSum a b c d * u +
          endpointLastPairProduct a b c d = 0 ↔
        u ^ 2 + endpointLastPairSum a b c d * u =
          endpointLastPairProduct a b c d by
      constructor
      · intro h
        apply sub_eq_zero.mp
        simpa only [CharTwo.sub_eq_add] using h
      · intro h
        have hzero := sub_eq_zero.mpr h
        simpa only [CharTwo.sub_eq_add] using hzero]
  field_simp [hh]

/-- Rational lifting boundary for the normalized last-pair Artin--Schreier cover.  The trace
predicate is explicit because the finite-field trace API and the identification with the framed
root incidence are not developed here. -/
structure EndpointArtinSchreierLiftingData (BasePoint : Type*) where
  /-- The normalized Arf representative at a rational framed base point. -/
  arfRepresentative : BasePoint → K
  /-- The representative has absolute trace zero. -/
  traceZero : BasePoint → Prop
  /-- The last ordered pair has two rational lifts. -/
  hasTwoRationalLifts : BasePoint → Prop
  /-- Exact finite-field Artin--Schreier lifting criterion. -/
  hasTwoRationalLifts_iff_traceZero :
    ∀ point, hasTwoRationalLifts point ↔ traceZero point

namespace EndpointArtinSchreierLiftingData

/-- The normalized endpoint cover has rational sheets exactly on the declared trace-zero locus. -/
theorem rational_lifts_iff_traceZero
    {BasePoint : Type*} (data : EndpointArtinSchreierLiftingData (K := K) BasePoint)
    (point : BasePoint) :
    data.hasTwoRationalLifts point ↔ data.traceZero point :=
  data.hasTwoRationalLifts_iff_traceZero point

end EndpointArtinSchreierLiftingData

/-- Exact additive-affine witness count
`q(q-1)(q-2)(q-4)/|AGL₃(F₂)|`, where `|AGL₃(F₂)|=1344`. -/
def degreeNineAdditiveWitnessCount (q : ℕ) : ℕ :=
  q * (q - 1) * (q - 2) * (q - 4) / 1344

/-- The order of the affine frame group of a three-dimensional vector space over `F₂`. -/
theorem affineFrameGroupOrderThreeOverTwo :
    8 * ((8 - 1) * (8 - 2) * (8 - 4)) = 1344 := by
  norm_num

/-- The additive-affine family has one monic witness at order eight and thirty at order sixteen. -/
theorem degreeNineAdditiveWitnessCount_small_controls :
    degreeNineAdditiveWitnessCount 8 = 1 ∧
      degreeNineAdditiveWitnessCount 16 = 30 := by
  norm_num [degreeNineAdditiveWitnessCount]

/-- The exact additive witness count is positive for every field order at least eight. -/
theorem degreeNineAdditiveWitnessCount_pos {q : ℕ} (hq : 8 ≤ q) :
    0 < degreeNineAdditiveWitnessCount q := by
  apply Nat.div_pos
  ·
    have h1 : 7 ≤ q - 1 := by omega
    have h2 : 6 ≤ q - 2 := by omega
    have h4 : 4 ≤ q - 4 := by omega
    calc
      1344 = 8 * 7 * 6 * 4 := by norm_num
      _ ≤ q * (q - 1) * (q - 2) * (q - 4) :=
        Nat.mul_le_mul (Nat.mul_le_mul (Nat.mul_le_mul hq h1) h2) h4
  · norm_num

/-- Finite-field and coding semantics for the additive eight-root subcover at the distinguished
degree-nine endpoint.  The type `CarrierPoint` may contain other strata; only `endpointOrbit` is
covered by this record. -/
structure DegreeNineEndpointAdditiveData
    (Witness CarrierPoint : Type*) [DecidableEq Witness] (q : ℕ) where
  /-- Monic additive-affine split squarefree polynomials in the endpoint Hankel kernel. -/
  witnesses : Finset Witness
  /-- Distinguished endpoint orbit, excluding all other degree-nine carrier strata. -/
  endpointOrbit : CarrierPoint → Prop
  /-- Coding predicate that a carrier point is shallow. -/
  shallow : CarrierPoint → Prop
  /-- Exact number of additive-affine witnesses. -/
  witness_card :
    witnesses.card = degreeNineAdditiveWitnessCount q
  /-- Every additive witness transports to a shallowness witness on the endpoint orbit. -/
  witness_makes_endpointOrbit_shallow :
    witnesses.Nonempty → ∀ point, endpointOrbit point → shallow point

namespace DegreeNineEndpointAdditiveData

/-- For `q ≥ 8`, the additive witness count is nonzero and every point of the distinguished
endpoint orbit is shallow.  No conclusion is made about another degree-nine carrier stratum. -/
theorem endpointOrbit_shallow
    {Witness CarrierPoint : Type*} [DecidableEq Witness] {q : ℕ}
    (data : DegreeNineEndpointAdditiveData Witness CarrierPoint q)
    (hq : 8 ≤ q) {point : CarrierPoint} (hpoint : data.endpointOrbit point) :
    data.shallow point := by
  apply data.witness_makes_endpointOrbit_shallow
  · exact Finset.card_pos.mp (by
      rw [data.witness_card]
      exact degreeNineAdditiveWitnessCount_pos hq)
  · exact hpoint

/-- The exact count and the orbitwise shallowness conclusion are available together. -/
theorem exact_count_and_endpointOrbit_shallow
    {Witness CarrierPoint : Type*} [DecidableEq Witness] {q : ℕ}
    (data : DegreeNineEndpointAdditiveData Witness CarrierPoint q)
    (hq : 8 ≤ q) :
    data.witnesses.card = degreeNineAdditiveWitnessCount q ∧
      ∀ point, data.endpointOrbit point → data.shallow point :=
  ⟨data.witness_card, fun _ hpoint => data.endpointOrbit_shallow hq hpoint⟩

end DegreeNineEndpointAdditiveData

end DegreeNineAdditiveSubcover

end RelativeConicArcs.PRSCharacteristicTwoHessianLucas
