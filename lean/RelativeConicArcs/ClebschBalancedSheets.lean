import RelativeConicArcs.ClebschMomentTrade
import Mathlib.LinearAlgebra.Dimension.Finite

/-!
# Balanced two-sheet evaluation spaces and cubic orientation

This module develops the symbolic algebra used to recover two equal sheets from an affine
evaluation space.  A sheet pair is represented by two functions on `Fin q`.  If the evaluation
space contains a function with two distinct constant sheet values, restricts onto every zero-sum
function on either sheet, has equal sheet sums on all coordinatewise products, and has one product
with nonzero sheet sum, then its coordinatewise-product square is exactly the equal-sheet-sum
hyperplane.

The remaining results are independent of the finite configurations.  They identify the sign line
as the annihilator of the equal-sheet-sum hyperplane, give an abstract index-two relative-invariant
stabilizer theorem, and derive the first three polynomial identities obtained by expanding
`P = P₀ + QΦ`.
-/

namespace RelativeConicArcs
namespace ClebschBalancedSheets

open scoped BigOperators
open Matrix

/-- A pair of `q`-point sheets with values in `K`. -/
abbrev SheetPair (q : ℕ) (K : Type*) := (Fin q → K) × (Fin q → K)

section SheetAlgebra

variable {q : ℕ} {K : Type*} [Field K]

/-- Coordinatewise multiplication on a pair of sheets. -/
def hadamard (x y : SheetPair q K) : SheetPair q K :=
  (⟨fun i ↦ x.1 i * y.1 i, fun i ↦ x.2 i * y.2 i⟩)

/-- The indicator of the left sheet. -/
def leftIndicator : SheetPair q K := (⟨fun _ ↦ 1, fun _ ↦ 0⟩)

/-- The indicator of the right sheet. -/
def rightIndicator : SheetPair q K := (⟨fun _ ↦ 0, fun _ ↦ 1⟩)

/-- The signed difference of the two sheet indicators. -/
def sheetSign : SheetPair q K := (⟨fun _ ↦ 1, fun _ ↦ -1⟩)

/-- Embed a function as a vector supported on the left sheet. -/
def leftSupported (u : Fin q → K) : SheetPair q K := ⟨u, 0⟩

/-- Embed a function as a vector supported on the right sheet. -/
def rightSupported (u : Fin q → K) : SheetPair q K := ⟨0, u⟩

/-- Sum the values on the left sheet. -/
def leftSum (x : SheetPair q K) : K := ∑ i, x.1 i

/-- Sum the values on the right sheet. -/
def rightSum (x : SheetPair q K) : K := ∑ i, x.2 i

/-- Sheet pairs whose two coordinate sums agree. -/
def equalSheetSum : Submodule K (SheetPair q K) where
  carrier := {x | leftSum x = rightSum x}
  zero_mem' := by simp [leftSum, rightSum]
  add_mem' := by
    intro x y hx hy
    change leftSum x = rightSum x at hx
    change leftSum y = rightSum y at hy
    simp only [leftSum, rightSum] at hx hy ⊢
    simp [Finset.sum_add_distrib, hx, hy]
  smul_mem' := by
    intro c x hx
    change leftSum x = rightSum x at hx
    change leftSum (c • x) = rightSum (c • x)
    calc
      leftSum (c • x) = c * leftSum x := by simp [leftSum, ← Finset.mul_sum]
      _ = c * rightSum x := congrArg (c * ·) hx
      _ = rightSum (c • x) := by simp [rightSum, ← Finset.mul_sum]

@[simp] theorem mem_equalSheetSum_iff (x : SheetPair q K) :
    x ∈ equalSheetSum ↔ leftSum x = rightSum x := Iff.rfl

/-- The submodule spanned by coordinatewise products of pairs from `L`. -/
def hadamardSquare (L : Submodule K (SheetPair q K)) : Submodule K (SheetPair q K) :=
  Submodule.span K {z | ∃ x ∈ L, ∃ y ∈ L, z = hadamard x y}

/-- The coordinatewise product of two members of `L` belongs to its Hadamard square. -/
theorem hadamard_mem_hadamardSquare {L : Submodule K (SheetPair q K)}
    {x y : SheetPair q K} (hx : x ∈ L) (hy : y ∈ L) :
    hadamard x y ∈ hadamardSquare L := by
  apply Submodule.subset_span
  exact ⟨x, hx, y, hy, rfl⟩

/-- A two-level function in `L`, together with the constant function, recovers both sheet
indicators. -/
theorem indicators_mem_of_separating_level (L : Submodule K (SheetPair q K))
    (hone : (⟨(1 : Fin q → K), (1 : Fin q → K)⟩ : SheetPair q K) ∈ L)
    {r : SheetPair q K} (hr : r ∈ L) {a b : K} (hab : a ≠ b)
    (hleft : ∀ i, r.1 i = a) (hright : ∀ i, r.2 i = b) :
    leftIndicator ∈ L ∧ rightIndicator ∈ L := by
  have hne : a - b ≠ 0 := sub_ne_zero.mpr hab
  have hleft_eq : leftIndicator = (a - b)⁻¹ •
      (r - b • (⟨(1 : Fin q → K), (1 : Fin q → K)⟩ : SheetPair q K)) := by
    ext i <;> simp [leftIndicator, hleft, hright, hne]
  have hli : leftIndicator ∈ L := by
    rw [hleft_eq]
    exact L.smul_mem _ (L.sub_mem hr (L.smul_mem _ hone))
  have hright_eq : rightIndicator =
      (⟨(1 : Fin q → K), (1 : Fin q → K)⟩ : SheetPair q K) - leftIndicator := by
    ext i <;> simp [leftIndicator, rightIndicator]
  refine ⟨hli, ?_⟩
  rw [hright_eq]
  exact L.sub_mem hone hli

/-- Surjectivity of the two restriction maps onto the zero-sum hyperplanes. -/
def RestrictsOntoZeroSum (L : Submodule K (SheetPair q K)) : Prop :=
  (∀ u : Fin q → K, (∑ i, u i) = 0 → ∃ x ∈ L, x.1 = u) ∧
    (∀ u : Fin q → K, (∑ i, u i) = 0 → ∃ x ∈ L, x.2 = u)

/-- Every product of two evaluation functions has the same sum on the two sheets. -/
def ProductsHaveEqualSheetSums (L : Submodule K (SheetPair q K)) : Prop :=
  ∀ x ∈ L, ∀ y ∈ L, leftSum (hadamard x y) = rightSum (hadamard x y)

/-- Some product has a nonzero (hence common) sheet sum. -/
def HasNonzeroSheetProduct (L : Submodule K (SheetPair q K)) : Prop :=
  ∃ x ∈ L, ∃ y ∈ L, leftSum (hadamard x y) ≠ 0

private theorem leftSupported_mem_square (L : Submodule K (SheetPair q K))
    (hli : leftIndicator ∈ L) (hres : RestrictsOntoZeroSum L)
    (u : Fin q → K) (hu : (∑ i, u i) = 0) :
    leftSupported u ∈ hadamardSquare L := by
  obtain ⟨x, hx, hxu⟩ := hres.1 u hu
  have hp := hadamard_mem_hadamardSquare hx hli
  convert hp using 1
  ext i <;> simp [hadamard, leftIndicator, leftSupported, hxu]

private theorem rightSupported_mem_square (L : Submodule K (SheetPair q K))
    (hri : rightIndicator ∈ L) (hres : RestrictsOntoZeroSum L)
    (u : Fin q → K) (hu : (∑ i, u i) = 0) :
    rightSupported u ∈ hadamardSquare L := by
  obtain ⟨x, hx, hxu⟩ := hres.2 u hu
  have hp := hadamard_mem_hadamardSquare hx hri
  convert hp using 1
  ext i <;> simp [hadamard, rightIndicator, rightSupported, hxu]

/-- Radical separation, restriction surjectivity, equality of second moments, and one nonzero
second-moment pairing force the Hadamard square to be the full equal-sheet-sum hyperplane. -/
theorem hadamardSquare_eq_equalSheetSum (L : Submodule K (SheetPair q K))
    (hli : leftIndicator ∈ L) (hri : rightIndicator ∈ L)
    (hres : RestrictsOntoZeroSum L) (hequal : ProductsHaveEqualSheetSums L)
    (hnonzero : HasNonzeroSheetProduct L) :
    hadamardSquare L = equalSheetSum := by
  apply le_antisymm
  · rw [hadamardSquare, Submodule.span_le]
    rintro z ⟨x, hx, y, hy, rfl⟩
    exact hequal x hx y hy
  · intro z hz
    obtain ⟨x, hx, y, hy, hp⟩ := hnonzero
    let p := hadamard x y
    let c := leftSum z / leftSum p
    let u : SheetPair q K := z - c • p
    have hpe : leftSum p = rightSum p := hequal x hx y hy
    have hpsq : p ∈ hadamardSquare L := hadamard_mem_hadamardSquare hx hy
    have hc : c * leftSum p = leftSum z := by
      dsimp [c]
      exact div_mul_cancel₀ _ hp
    have huzl : (∑ i, u.1 i) = 0 := by
      change leftSum u = 0
      rw [show leftSum u = leftSum z - c * leftSum p by
        simp [u, leftSum, Finset.sum_sub_distrib, Finset.mul_sum]]
      rw [hc, sub_self]
    have huzr : (∑ i, u.2 i) = 0 := by
      change rightSum u = 0
      rw [show rightSum u = rightSum z - c * rightSum p by
        simp [u, rightSum, Finset.sum_sub_distrib, Finset.mul_sum]]
      rw [← hz, ← hpe, hc, sub_self]
    have hul := leftSupported_mem_square L hli hres u.1 huzl
    have hur := rightSupported_mem_square L hri hres u.2 huzr
    have hu_parts : u = leftSupported u.1 + rightSupported u.2 := by
      ext i <;> simp [leftSupported, rightSupported]
    have hu : u ∈ hadamardSquare L := by
      rw [hu_parts]
      exact (hadamardSquare L).add_mem hul hur
    have hz_decomp : z = u + c • p := by
      simp [u]
    rw [hz_decomp]
    exact (hadamardSquare L).add_mem hu ((hadamardSquare L).smul_mem c hpsq)

/-- The sheet sign annihilates every pair with equal sheet sums. -/
theorem sheetSign_annihilates_equalSheetSum (x : SheetPair q K) (hx : x ∈ equalSheetSum) :
    (∑ i, (sheetSign : SheetPair q K).1 i * x.1 i) +
      (∑ i, (sheetSign : SheetPair q K).2 i * x.2 i) = 0 := by
  change leftSum x = rightSum x at hx
  have h := sub_eq_zero.mpr hx
  simp only [sheetSign, one_mul, neg_one_mul, Finset.sum_neg_distrib]
  simpa only [leftSum, rightSum, sub_eq_add_neg] using h

/-- The standard coordinate pairing on a pair of sheets. -/
def sheetPairing (t x : SheetPair q K) : K :=
  (∑ i, t.1 i * x.1 i) + (∑ i, t.2 i * x.2 i)

/-- On two nonempty sheets, the annihilator of the equal-sheet-sum hyperplane is exactly the
one-dimensional sheet-sign line. -/
theorem annihilates_equalSheetSum_iff_eq_sheetSignLine (i₀ : Fin q) (t : SheetPair q K) :
    (∀ x ∈ equalSheetSum, sheetPairing t x = 0) ↔
      ∃ c : K, t = (⟨fun _ ↦ c, fun _ ↦ -c⟩ : SheetPair q K) := by
  constructor
  · intro h
    let delta (i : Fin q) : Fin q → K := fun j ↦ if j = i then 1 else 0
    have hmem (i j : Fin q) : (⟨delta i, delta j⟩ : SheetPair q K) ∈ equalSheetSum := by
      change (∑ k, delta i k) = ∑ k, delta j k
      simp [delta]
    have hcrossLeft (i : Fin q) : t.1 i + t.2 i₀ = 0 := by
      have hp := h ⟨delta i, delta i₀⟩ (hmem i i₀)
      simpa [sheetPairing, delta] using hp
    have hcrossRight (j : Fin q) : t.1 i₀ + t.2 j = 0 := by
      have hp := h ⟨delta i₀, delta j⟩ (hmem i₀ j)
      simpa [sheetPairing, delta] using hp
    have hleft (i : Fin q) : t.1 i = t.1 i₀ := by
      rw [eq_neg_of_add_eq_zero_left (hcrossLeft i),
        eq_neg_of_add_eq_zero_left (hcrossLeft i₀)]
    have hright (j : Fin q) : t.2 j = -t.1 i₀ :=
      eq_neg_of_add_eq_zero_right (hcrossRight j)
    refine ⟨t.1 i₀, ?_⟩
    ext i <;> simp [hleft, hright]
  · rintro ⟨c, rfl⟩ x hx
    change leftSum x = rightSum x at hx
    simp only [leftSum, rightSum] at hx
    simp only [sheetPairing]
    rw [← Finset.mul_sum, ← Finset.mul_sum, hx]
    simp

/-- A pointwise `±1` weight in the trade line is the displayed sheet sign, up to complement. -/
theorem balancedHalf_unique_of_annihilates (i₀ : Fin q) (t : SheetPair q K)
    (hann : ∀ x ∈ equalSheetSum, sheetPairing t x = 0)
    (hpmLeft : ∀ i, t.1 i = 1 ∨ t.1 i = -1)
    (_hpmRight : ∀ i, t.2 i = 1 ∨ t.2 i = -1) :
    t = sheetSign ∨ t = -sheetSign := by
  obtain ⟨c, hc⟩ := (annihilates_equalSheetSum_iff_eq_sheetSignLine i₀ t).mp hann
  rcases hpmLeft i₀ with hplus | hminus
  · left
    have hc1 : c = 1 := by simpa [hc] using hplus
    ext i <;> simp [hc, hc1, sheetSign]
  · right
    have hcm1 : c = -1 := by simpa [hc] using hminus
    ext i <;> simp [hc, hcm1, sheetSign]

section AffineEvaluation

variable {r : ℕ}

/-- Evaluation of an affine covector at a coordinate vector. -/
def affineValue (coefficient : K × (Fin r → K)) (point : Fin r → K) : K :=
  coefficient.1 + ∑ j, coefficient.2 j * point j

/-- Evaluation at a fixed point as a linear functional of the affine coefficient. -/
def affineValueLinear (point : Fin r → K) : (K × (Fin r → K)) →ₗ[K] K where
  toFun coefficient := affineValue coefficient point
  map_add' left right := by
    simp [affineValue, add_mul, Finset.sum_add_distrib]
    ring
  map_smul' scalar coefficient := by
    simp [affineValue]
    rw [mul_add]
    congr 1
    rw [Finset.mul_sum]
    apply Finset.sum_congr rfl
    intro j _
    ring

/-- Evaluation commutes with a finite linear combination of affine coefficients. -/
theorem affineValue_sum_smul {s : Type*} [Fintype s]
    (coefficient : s → K × (Fin r → K)) (weight : s → K) (point : Fin r → K) :
    affineValue (∑ i, weight i • coefficient i) point =
      ∑ i, weight i * affineValue (coefficient i) point := by
  change affineValueLinear point (∑ i, weight i • coefficient i) = _
  rw [map_sum]
  apply Finset.sum_congr rfl
  intro i _
  simp only [map_smul, smul_eq_mul]
  rfl

/-- The linear map evaluating an affine covector on two ordered sheets. -/
def affineEvaluationMap (leftPoints rightPoints : Fin q → Fin r → K) :
    (K × (Fin r → K)) →ₗ[K] SheetPair q K where
  toFun coefficient :=
    ⟨fun i ↦ affineValue coefficient (leftPoints i),
      fun i ↦ affineValue coefficient (rightPoints i)⟩
  map_add' left right := by
    ext i
    · change affineValue (left + right) (leftPoints i) =
        affineValue left (leftPoints i) + affineValue right (leftPoints i)
      simp [affineValue, add_mul, Finset.sum_add_distrib]
      ring
    · change affineValue (left + right) (rightPoints i) =
        affineValue left (rightPoints i) + affineValue right (rightPoints i)
      simp [affineValue, add_mul, Finset.sum_add_distrib]
      ring
  map_smul' scalar coefficient := by
    ext i
    · change affineValue (scalar • coefficient) (leftPoints i) =
        scalar * affineValue coefficient (leftPoints i)
      simp [affineValue]
      rw [mul_add]
      congr 1
      rw [Finset.mul_sum]
      apply Finset.sum_congr rfl
      intro j _
      ring
    · change affineValue (scalar • coefficient) (rightPoints i) =
        scalar * affineValue coefficient (rightPoints i)
      simp [affineValue]
      rw [mul_add]
      congr 1
      rw [Finset.mul_sum]
      apply Finset.sum_congr rfl
      intro j _
      ring

/-- The space of affine evaluation functions on a two-sheet configuration. -/
def affineEvaluationSpace (leftPoints rightPoints : Fin q → Fin r → K) :
    Submodule K (SheetPair q K) :=
  LinearMap.range (affineEvaluationMap leftPoints rightPoints)

/-- A pair of explicit decoders proves that the two affine restriction maps cover their zero-sum
hyperplanes. -/
theorem restrictsOntoZeroSum_of_decoders
    (leftPoints rightPoints : Fin q → Fin r → K)
    (leftDecoder rightDecoder : (Fin q → K) → K × (Fin r → K))
    (hleft : ∀ u, (∑ i, u i) = 0 →
      ∀ i, affineValue (leftDecoder u) (leftPoints i) = u i)
    (hright : ∀ u, (∑ i, u i) = 0 →
      ∀ i, affineValue (rightDecoder u) (rightPoints i) = u i) :
    RestrictsOntoZeroSum (affineEvaluationSpace leftPoints rightPoints) := by
  constructor
  · intro u hu
    refine ⟨affineEvaluationMap leftPoints rightPoints (leftDecoder u), ⟨leftDecoder u, rfl⟩, ?_⟩
    funext i
    exact hleft u hu i
  · intro u hu
    refine ⟨affineEvaluationMap leftPoints rightPoints (rightDecoder u), ⟨rightDecoder u, rfl⟩, ?_⟩
    funext i
    exact hright u hu i

/-- A coefficient whose affine evaluations are two distinct constants recovers the sheet
indicators inside the affine evaluation space. -/
theorem affine_indicators_mem_of_separating_coefficient
    (leftPoints rightPoints : Fin q → Fin r → K)
    (coefficient : K × (Fin r → K)) (a b : K) (hab : a ≠ b)
    (hleft : ∀ i, affineValue coefficient (leftPoints i) = a)
    (hright : ∀ i, affineValue coefficient (rightPoints i) = b) :
    leftIndicator ∈ affineEvaluationSpace leftPoints rightPoints ∧
      rightIndicator ∈ affineEvaluationSpace leftPoints rightPoints := by
  apply indicators_mem_of_separating_level
  · refine ⟨⟨1, 0⟩, ?_⟩
    ext i <;> simp [affineEvaluationMap, affineValue]
  · exact ⟨coefficient, rfl⟩
  · exact hab
  · exact hleft
  · exact hright

/-- Zeroth, first, and second signed coordinate moments of a finite vector configuration. -/
def SignedMomentsThroughTwo {n : ℕ} (vectors : Fin n → Fin r → K)
    (epsilon : Fin n → K) : Prop :=
  (∑ i, epsilon i) = 0 ∧
    (∀ j, ∑ i, epsilon i * vectors i j = 0) ∧
    (∀ j k, ∑ i, epsilon i * vectors i j * vectors i k = 0)

private theorem signed_dot_eq_zero {n : ℕ} (vectors : Fin n → Fin r → K)
    (epsilon : Fin n → K) (hfirst : ∀ j, ∑ i, epsilon i * vectors i j = 0)
    (coefficient : Fin r → K) :
    ∑ i, epsilon i * (∑ j, coefficient j * vectors i j) = 0 := by
  calc
    _ = ∑ i, ∑ j, coefficient j * (epsilon i * vectors i j) := by
      apply Finset.sum_congr rfl
      intro i _
      rw [Finset.mul_sum]
      apply Finset.sum_congr rfl
      intro j _
      ring
    _ = ∑ j, ∑ i, coefficient j * (epsilon i * vectors i j) := Finset.sum_comm
    _ = ∑ j, coefficient j * (∑ i, epsilon i * vectors i j) := by
      apply Finset.sum_congr rfl
      intro j _
      rw [Finset.mul_sum]
    _ = 0 := by simp [hfirst]

private theorem signed_dot_product_eq_zero {n : ℕ} (vectors : Fin n → Fin r → K)
    (epsilon : Fin n → K)
    (hsecond : ∀ j k, ∑ i, epsilon i * vectors i j * vectors i k = 0)
    (left right : Fin r → K) :
    ∑ i, epsilon i * (∑ j, left j * vectors i j) *
      (∑ k, right k * vectors i k) = 0 := by
  calc
    _ = ∑ i, ∑ k, ∑ j,
        left j * right k * (epsilon i * vectors i j * vectors i k) := by
      apply Finset.sum_congr rfl
      intro i _
      rw [mul_assoc, Finset.mul_sum, Finset.mul_sum]
      apply Finset.sum_congr rfl
      intro k _
      rw [Finset.sum_mul, Finset.mul_sum]
      apply Finset.sum_congr rfl
      intro j _
      ring
    _ = ∑ k, ∑ j, ∑ i,
        left j * right k * (epsilon i * vectors i j * vectors i k) := by
      rw [Finset.sum_comm]
      apply Finset.sum_congr rfl
      intro k _
      rw [Finset.sum_comm]
    _ = ∑ k, ∑ j, left j * right k *
        (∑ i, epsilon i * vectors i j * vectors i k) := by
      apply Finset.sum_congr rfl
      intro k _
      apply Finset.sum_congr rfl
      intro j _
      rw [Finset.mul_sum]
    _ = 0 := by simp [hsecond]

/-- Vanishing signed coordinate moments through degree two makes every pair of affine evaluations
orthogonal to the sign. -/
theorem signed_affine_product_eq_zero {n : ℕ}
    (vectors : Fin n → Fin r → K) (epsilon : Fin n → K)
    (hmoments : SignedMomentsThroughTwo vectors epsilon)
    (left right : K × (Fin r → K)) :
    ∑ i, epsilon i * affineValue left (vectors i) * affineValue right (vectors i) = 0 := by
  have hleft := signed_dot_eq_zero vectors epsilon hmoments.2.1 left.2
  have hright := signed_dot_eq_zero vectors epsilon hmoments.2.1 right.2
  have hquadratic := signed_dot_product_eq_zero vectors epsilon hmoments.2.2 left.2 right.2
  have hconstant : (∑ i, epsilon i * (left.1 * right.1)) = 0 := by
    calc
      _ = (left.1 * right.1) * (∑ i, epsilon i) := by
        rw [Finset.mul_sum]
        apply Finset.sum_congr rfl
        intro i _
        ring
      _ = 0 := by simp [hmoments.1]
  have hleftScaled :
      (∑ i, right.1 * (epsilon i * (∑ j, left.2 j * vectors i j))) = 0 := by
    rw [← Finset.mul_sum, hleft, mul_zero]
  have hrightScaled :
      (∑ i, left.1 * (epsilon i * (∑ j, right.2 j * vectors i j))) = 0 := by
    rw [← Finset.mul_sum, hright, mul_zero]
  calc
    _ = (∑ i, epsilon i * (left.1 * right.1)) +
          (∑ i, right.1 * (epsilon i * (∑ j, left.2 j * vectors i j))) +
          (∑ i, left.1 * (epsilon i * (∑ j, right.2 j * vectors i j))) +
          (∑ i, epsilon i * (∑ j, left.2 j * vectors i j) *
            (∑ k, right.2 k * vectors i k)) := by
      rw [← Finset.sum_add_distrib, ← Finset.sum_add_distrib, ← Finset.sum_add_distrib]
      apply Finset.sum_congr rfl
      intro i _
      simp only [affineValue]
      ring
    _ = 0 := by rw [hconstant, hleftScaled, hrightScaled, hquadratic]; simp

/-- The symmetric second-moment matrix of a finite vector configuration. -/
def secondMomentMatrix {n : ℕ} (vectors : Fin n → Fin r → K) :
    Matrix (Fin r) (Fin r) K :=
  fun j k ↦ ∑ i, vectors i j * vectors i k

/-- A finite permutation acts affinely on a vector configuration with the displayed linear part
and translation. -/
def IsAffinePermutationAction {n g : ℕ} (vectors : Fin n → Fin r → K)
    (permutation : Fin g → Fin n → Fin n) (linear : Fin g → Matrix (Fin r) (Fin r) K)
    (translation : Fin g → Fin r → K) : Prop :=
  ∀ generator point,
    vectors (permutation generator point) =
      linear generator *ᵥ vectors point + translation generator

/-- A checked matrix factorization identifies the kernel of a second-moment matrix with a given
line.  `complement` embeds a complementary coordinate space, `recover` is a left inverse after the
moment matrix, and `decompose` writes every vector as a complementary part plus a radical scalar. -/
theorem matrix_kernel_eq_line_of_recovery {d : ℕ}
    (moment : Matrix (Fin r) (Fin r) K) (radical : Fin r → K)
    (complement : Matrix (Fin r) (Fin d) K) (recover : Matrix (Fin d) (Fin r) K)
    (project : (Fin r → K) → (Fin d → K)) (coefficient : (Fin r → K) → K)
    (hcertificate : recover * moment * complement = 1)
    (hradical : moment *ᵥ radical = 0)
    (hdecompose : ∀ v, v = complement *ᵥ project v + coefficient v • radical) :
    ∀ v, moment *ᵥ v = 0 ↔ ∃ c : K, v = c • radical := by
  intro v
  constructor
  · intro hv
    have hmoment : moment *ᵥ (complement *ᵥ project v) = moment *ᵥ v := by
      conv_rhs => rw [hdecompose v]
      rw [Matrix.mulVec_add, Matrix.mulVec_smul, hradical, smul_zero, add_zero]
    have hproject : project v = 0 := by
      calc
        project v = (1 : Matrix (Fin d) (Fin d) K) *ᵥ project v := by simp
        _ = (recover * moment * complement) *ᵥ project v := by rw [hcertificate]
        _ = recover *ᵥ (moment *ᵥ (complement *ᵥ project v)) := by
          simp only [Matrix.mulVec_mulVec, Matrix.mul_assoc]
        _ = recover *ᵥ (moment *ᵥ v) := by rw [hmoment]
        _ = 0 := by rw [hv, Matrix.mulVec_zero]
    refine ⟨coefficient v, ?_⟩
    have hvdec := hdecompose v
    rw [hproject, Matrix.mulVec_zero, zero_add] at hvdec
    exact hvdec
  · rintro ⟨c, rfl⟩
    rw [Matrix.mulVec_smul, hradical, smul_zero]

end AffineEvaluation

end SheetAlgebra

section RelativeInvariant

variable {G W K : Type*} [Group G] [Field K] [AddCommGroup W] [Module K W]

/-- Reindexing a signed orbit sum through a permutation that changes the sign by `chi` makes the
sum a `chi`-relative invariant for every linear action carrying each feature to its permuted
feature.  Cubic orientation is obtained by taking `W` to be the symmetric-cubic feature space. -/
theorem signedOrbitSum_isRelativeInvariant {n : ℕ}
    (action : W →ₗ[K] W) (permutation : Equiv.Perm (Fin n))
    (epsilon : Fin n → K) (feature : Fin n → W) (chi : K)
    (hfeature : ∀ i, action (feature i) = feature (permutation i))
    (hsign : ∀ i, epsilon (permutation.symm i) = chi * epsilon i) :
    action (∑ i, epsilon i • feature i) = chi • (∑ i, epsilon i • feature i) := by
  rw [map_sum]
  simp_rw [map_smul, hfeature]
  rw [← permutation.symm.sum_comp (fun i ↦ epsilon i • feature (permutation i))]
  simp_rw [permutation.apply_symm_apply, hsign]
  rw [Finset.smul_sum]
  apply Finset.sum_congr rfl
  intro i _
  simp [smul_smul]

/-- A nonzero vector transforming by a two-valued character has stabilizer equal to the kernel of
that character. -/
theorem stabilizer_eq_ker_of_relative_invariant
    (action : G → W →ₗ[K] W) (_haction : ∀ g h, action (g * h) = (action g).comp (action h))
    (_hone : action 1 = LinearEquiv.refl K W) (chi : G →* Kˣ) (mu : W) (hmu : mu ≠ 0)
    (htwo : (2 : K) ≠ 0)
    (hrelative : ∀ g, action g mu = chi g • mu) (hpm : ∀ g, chi g = 1 ∨ chi g = -1) :
    {g | action g mu = mu} = ↑(MonoidHom.ker chi) := by
  ext g
  simp only [Set.mem_setOf_eq, SetLike.mem_coe, MonoidHom.mem_ker]
  constructor
  · intro hg
    rw [hrelative g] at hg
    rcases hpm g with hchi | hchi
    · exact hchi
    · exfalso
      have hs : (-1 : K) • mu = (1 : K) • mu := by simpa [hchi] using hg
      have hz : ((-1 : K) - 1) • mu = 0 := by
        rw [sub_smul, hs, sub_self]
      have hsne : (-1 : K) - 1 ≠ 0 := by
        rw [show (-1 : K) - 1 = -2 by ring]
        exact neg_ne_zero.mpr htwo
      exact hmu ((smul_eq_zero.mp hz).resolve_left hsne)
  · intro hg
    simp [hrelative g, hg]

end RelativeInvariant

section CubicOrientation

variable {K : Type*} [Field K]

/-- Ordered-coordinate model of a symmetric cubic tensor.  Symmetry is automatic for tensors
constructed by `cubicFeature`; keeping ordered coordinates makes finite witnesses inexpensive. -/
abbrev CubicTensor (d : ℕ) (K : Type*) := Fin d → Fin d → Fin d → K

/-- The rank-one cubic tensor attached to a vector. -/
def cubicFeature {d : ℕ} (v : Fin d → K) : CubicTensor d K :=
  fun i j k ↦ v i * v j * v k

/-- The signed cubic tensor of a finite vector configuration. -/
def signedCubicTensor {n d : ℕ} (vectors : Fin n → Fin d → K)
    (epsilon : Fin n → K) : CubicTensor d K :=
  ∑ i, epsilon i • cubicFeature (vectors i)

@[simp] theorem signedCubicTensor_apply {n d : ℕ} (vectors : Fin n → Fin d → K)
    (epsilon : Fin n → K) (i j k : Fin d) :
    signedCubicTensor vectors epsilon i j k =
      ∑ column, epsilon column * vectors column i * vectors column j * vectors column k := by
  simp [signedCubicTensor, cubicFeature, mul_assoc]

/-- Permutations paired with their exact multiplier on a nonzero signed orbit.  Unlike a
"certified action" record, membership is the covariance equation itself and the group operations
are proved from it. -/
def signedSymmetryGroup {n : ℕ} (epsilon : Fin n → K) :
    Subgroup (Equiv.Perm (Fin n) × Kˣ) where
  carrier := {g | ∀ i, epsilon (g.1 i) = (g.2 : K) * epsilon i}
  one_mem' := by simp
  mul_mem' := by
    rintro ⟨p, u⟩ ⟨q, v⟩ hp hq i
    change epsilon (p (q i)) = ((u * v : Kˣ) : K) * epsilon i
    rw [hp, hq]
    simp [mul_assoc]
  inv_mem' := by
    rintro ⟨p, u⟩ hp i
    change epsilon (p.symm i) = ((u⁻¹ : Kˣ) : K) * epsilon i
    have hi := hp (p.symm i)
    simp only [p.apply_symm_apply] at hi
    calc
      epsilon (p.symm i) = ((u⁻¹ : Kˣ) : K) * ((u : K) * epsilon (p.symm i)) := by simp
      _ = ((u⁻¹ : Kˣ) : K) * epsilon i := by rw [hi]

/-- The permutation underlying a signed symmetry. -/
def signedSymmetryPermutation {n : ℕ} {epsilon : Fin n → K}
    (g : signedSymmetryGroup epsilon) : Equiv.Perm (Fin n) := g.1.1

/-- The multiplier character of the explicit signed-symmetry group. -/
def signedSymmetryCharacter {n : ℕ} {epsilon : Fin n → K} :
    signedSymmetryGroup epsilon →* Kˣ where
  toFun g := g.1.2
  map_one' := rfl
  map_mul' _ _ := rfl

/-- The signed evaluation functional on all functions on the finite orbit.  Its first nonzero
graded restriction is cubic when the signed moments through degree two vanish. -/
def signedEvaluationFunctional {n : ℕ} (epsilon : Fin n → K) :
    (Fin n → K) →ₗ[K] K where
  toFun f := ∑ i, epsilon i * f i
  map_add' left right := by
    rw [← Finset.sum_add_distrib]
    apply Finset.sum_congr rfl
    intro i _
    simp [mul_add]
  map_smul' c f := by
    change (∑ i, epsilon i * (c * f i)) = c * ∑ i, epsilon i * f i
    rw [Finset.mul_sum]
    apply Finset.sum_congr rfl
    intro i _
    ring

/-- Pull a function back through the inverse of a permutation. -/
def permutationPullback {n : ℕ} (p : Equiv.Perm (Fin n)) :
    (Fin n → K) →ₗ[K] (Fin n → K) where
  toFun f := fun i ↦ f (p.symm i)
  map_add' _ _ := rfl
  map_smul' _ _ := rfl

/-- Explicit action of a signed symmetry on the signed evaluation functional. -/
def signedFunctionalAction {n : ℕ} {epsilon : Fin n → K}
    (g : signedSymmetryGroup epsilon) : (Fin n → K) →ₗ[K] K :=
  (signedEvaluationFunctional epsilon).comp
    (permutationPullback (signedSymmetryPermutation g))

/-- Reindexing proves relative invariance for the explicit signed-permutation action. -/
theorem signedFunctionalAction_eq_character_smul {n : ℕ} {epsilon : Fin n → K}
    (g : signedSymmetryGroup epsilon) :
    signedFunctionalAction g =
      (signedSymmetryCharacter g : K) • signedEvaluationFunctional epsilon := by
  apply LinearMap.ext
  intro f
  let p := signedSymmetryPermutation g
  change (∑ i, epsilon i * f (p.symm i)) =
    (signedSymmetryCharacter (epsilon := epsilon) g : K) * ∑ i, epsilon i * f i
  calc
    _ = ∑ i, epsilon (p i) * f i := by
      rw [← Equiv.sum_comp p (fun i ↦ epsilon i * f (p.symm i))]
      simp
    _ = ∑ i, (signedSymmetryCharacter (epsilon := epsilon) g : K) * epsilon i * f i := by
      apply Finset.sum_congr rfl
      intro i _
      have hcov := g.property i
      change epsilon (p i) = (signedSymmetryCharacter (epsilon := epsilon) g : K) * epsilon i at hcov
      rw [hcov]
    _ = _ := by
      rw [Finset.mul_sum]
      apply Finset.sum_congr rfl
      intro i _
      ring

/-- If the signed functional is nonzero on one displayed cubic evaluation and the character is
two-valued, its stabilizer in the explicit signed-symmetry action is exactly the character kernel. -/
theorem signedFunctional_stabilizer_eq_characterKernel {n : ℕ} {epsilon : Fin n → K}
    (witness : Fin n → K) (hwitness : signedEvaluationFunctional epsilon witness ≠ 0)
    (htwo : (2 : K) ≠ 0)
    (hpm : ∀ g : signedSymmetryGroup epsilon,
      signedSymmetryCharacter (epsilon := epsilon) g = 1 ∨
        signedSymmetryCharacter (epsilon := epsilon) g = -1) :
    {g : signedSymmetryGroup epsilon |
      signedFunctionalAction g = signedEvaluationFunctional epsilon} =
      {g : signedSymmetryGroup epsilon |
        signedSymmetryCharacter (epsilon := epsilon) g = 1} := by
  ext g
  simp only [Set.mem_setOf_eq]
  constructor
  · intro hfixed
    rcases hpm g with hplus | hminus
    · exact hplus
    · exfalso
      have hrelative := signedFunctionalAction_eq_character_smul g
      rw [hfixed, hminus] at hrelative
      have heval := LinearMap.congr_fun hrelative witness
      have hzero : (2 : K) * signedEvaluationFunctional epsilon witness = 0 := by
        simpa [two_mul] using congrArg
          (fun x ↦ signedEvaluationFunctional epsilon witness - x) heval |>.symm
      exact hwitness ((mul_eq_zero.mp hzero).resolve_left htwo)
  · intro hker
    rw [signedFunctionalAction_eq_character_smul, hker]
    simp

/-- Pointwise `±1` weights force every multiplier in the explicit signed-symmetry group to be
two-valued. -/
theorem signedSymmetryCharacter_eq_one_or_neg_one {n : ℕ} {epsilon : Fin n → K}
    (i₀ : Fin n) (hbase : epsilon i₀ = 1)
    (hvalues : ∀ i, epsilon i = 1 ∨ epsilon i = -1)
    (g : signedSymmetryGroup epsilon) :
    signedSymmetryCharacter (epsilon := epsilon) g = 1 ∨
      signedSymmetryCharacter (epsilon := epsilon) g = -1 := by
  have hcov := g.property i₀
  rcases hvalues (signedSymmetryPermutation g i₀) with hplus | hminus
  · left
    apply Units.ext
    change (g.1.2 : K) = 1
    change epsilon (g.1.1 i₀) = 1 at hplus
    calc
      (g.1.2 : K) = epsilon (g.1.1 i₀) := by simpa [hbase] using hcov.symm
      _ = 1 := hplus
  · right
    apply Units.ext
    change (g.1.2 : K) = -1
    change epsilon (g.1.1 i₀) = -1 at hminus
    calc
      (g.1.2 : K) = epsilon (g.1.1 i₀) := by simpa [hbase] using hcov.symm
      _ = -1 := hminus

/-- Character restricted to an explicitly generated subgroup of signed symmetries. -/
def signedSubgroupCharacter {n : ℕ} {epsilon : Fin n → K}
    (H : Subgroup (signedSymmetryGroup epsilon)) : H →* Kˣ where
  toFun g := signedSymmetryCharacter (epsilon := epsilon) g.1
  map_one' := rfl
  map_mul' _ _ := rfl

/-- Functional action restricted to an explicitly generated subgroup. -/
def signedSubgroupAction {n : ℕ} {epsilon : Fin n → K}
    {H : Subgroup (signedSymmetryGroup epsilon)} (g : H) : (Fin n → K) →ₗ[K] K :=
  signedFunctionalAction g.1

/-- On a generated signed subgroup, functional transport is multiplication by its character. -/
theorem signedSubgroupAction_eq_character_smul {n : ℕ} {epsilon : Fin n → K}
    {H : Subgroup (signedSymmetryGroup epsilon)} (g : H) :
    signedSubgroupAction g =
      (signedSubgroupCharacter H g : K) • signedEvaluationFunctional epsilon := by
  exact signedFunctionalAction_eq_character_smul g.1

/-- Exact character-kernel stabilizer inside any explicitly generated signed-symmetry subgroup. -/
theorem signedSubgroup_stabilizer_eq_characterKernel {n : ℕ} {epsilon : Fin n → K}
    (H : Subgroup (signedSymmetryGroup epsilon))
    (witness : Fin n → K) (hwitness : signedEvaluationFunctional epsilon witness ≠ 0)
    (htwo : (2 : K) ≠ 0)
    (hpm : ∀ g : H, signedSubgroupCharacter H g = 1 ∨ signedSubgroupCharacter H g = -1) :
    {g : H | signedSubgroupAction g = signedEvaluationFunctional epsilon} =
      {g : H | signedSubgroupCharacter H g = 1} := by
  ext g
  simp only [Set.mem_setOf_eq]
  constructor
  · intro hfixed
    rcases hpm g with hplus | hminus
    · exact hplus
    · exfalso
      have hrelative := signedSubgroupAction_eq_character_smul g
      rw [hfixed, hminus] at hrelative
      have heval := LinearMap.congr_fun hrelative witness
      have hzero : (2 : K) * signedEvaluationFunctional epsilon witness = 0 := by
        simpa [two_mul] using (congrArg
          (fun x ↦ signedEvaluationFunctional epsilon witness - x) heval).symm
      exact hwitness ((mul_eq_zero.mp hzero).resolve_left htwo)
  · intro hker
    rw [signedSubgroupAction_eq_character_smul, hker]
    simp

end CubicOrientation

section PlaneSyzygies

variable {R ι : Type*} [CommRing R] [Fintype ι]

/-- The signed linear identity obtained from `Pᵢ = P₀ + Q · Φᵢ`. -/
theorem signed_sum_affine_expansion_one (epsilon phi : ι → R) (P₀ Q : R)
    (hzero : ∑ i, epsilon i = 0) (hone : ∑ i, epsilon i * phi i = 0) :
    ∑ i, epsilon i * (P₀ + Q * phi i) = 0 := by
  calc
    _ = P₀ * (∑ i, epsilon i) + Q * (∑ i, epsilon i * phi i) := by
      rw [Finset.mul_sum, Finset.mul_sum, ← Finset.sum_add_distrib]
      apply Finset.sum_congr rfl
      intro i _
      ring
    _ = 0 := by simp [hzero, hone]

/-- The signed quadratic identity obtained from `Pᵢ = P₀ + Q · Φᵢ`. -/
theorem signed_sum_affine_expansion_two (epsilon phi : ι → R) (P₀ Q : R)
    (hzero : ∑ i, epsilon i = 0) (hone : ∑ i, epsilon i * phi i = 0)
    (htwo : ∑ i, epsilon i * phi i ^ 2 = 0) :
    ∑ i, epsilon i * (P₀ + Q * phi i) ^ 2 = 0 := by
  calc
    _ = P₀ ^ 2 * (∑ i, epsilon i) + (2 * P₀ * Q) *
          (∑ i, epsilon i * phi i) + Q ^ 2 * (∑ i, epsilon i * phi i ^ 2) := by
      simp only [Finset.mul_sum]
      rw [← Finset.sum_add_distrib, ← Finset.sum_add_distrib]
      apply Finset.sum_congr rfl
      intro i _
      ring
    _ = 0 := by simp [hzero, hone, htwo]

/-- After the lower signed moments vanish, the signed cubic of `P₀ + Q · Φᵢ` is
`Q³` times the signed cubic of `Φᵢ`. -/
theorem signed_sum_affine_expansion_three (epsilon phi : ι → R) (P₀ Q : R)
    (hzero : ∑ i, epsilon i = 0) (hone : ∑ i, epsilon i * phi i = 0)
    (htwo : ∑ i, epsilon i * phi i ^ 2 = 0) :
    ∑ i, epsilon i * (P₀ + Q * phi i) ^ 3 = Q ^ 3 *
      (∑ i, epsilon i * phi i ^ 3) := by
  calc
    _ = P₀ ^ 3 * (∑ i, epsilon i) + (3 * P₀ ^ 2 * Q) *
          (∑ i, epsilon i * phi i) + (3 * P₀ * Q ^ 2) *
          (∑ i, epsilon i * phi i ^ 2) + Q ^ 3 *
          (∑ i, epsilon i * phi i ^ 3) := by
      simp only [Finset.mul_sum]
      rw [← Finset.sum_add_distrib, ← Finset.sum_add_distrib, ← Finset.sum_add_distrib]
      apply Finset.sum_congr rfl
      intro i _
      ring
    _ = _ := by simp [hzero, hone, htwo]

end PlaneSyzygies

end ClebschBalancedSheets
end RelativeConicArcs
