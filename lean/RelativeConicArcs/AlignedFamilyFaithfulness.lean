import RelativeConicArcs.AlignedTwoGraph
import Mathlib.Data.Finset.Card
import Mathlib.Data.Fintype.Card

/-!
# Faithfulness of the aligned four-set family

A two-graph on a set `V` is recorded here as a triangle-bit function
`tau : V → V → V → Bool` invariant under permutations of its three arguments
and subject to the four-set parity law `FourSetParity`.  A four-set is
*aligned* when its four triangle bits agree; complementing every triangle bit
preserves that family.

This module proves the converse on seven or more points: two two-graphs with
the same aligned four-sets differ by one global complement bit.  The route is
the one the mechanism itself suggests.  Rooting at a point of a known aligned
four-set turns triangle bits into graph-edge bits and makes the six edges
inside that four-set vanish, so each further point acquires a normalized cut in
`NormalizedCut` and each further pair a mutual edge bit.  Under that
normalization the aligned tests meeting the four-set in three or two points are
exactly the Boolean signatures `anchorSignature` and `pairSignature`, so the
seven-point injectivity theorem `normalizedSevenSignature_injective` applies and
returns equality of all cuts and edges; the parity law then rebuilds every
triangle bit of the seven points.  Larger point sets are handled by covering any
two triples with one seven-point restriction and matching the complement bits on
the overlap.

Every step here is symbolic.  The two finite classifications it depends on,
`anchorSignature_eq_false_iff_balanced` and `pairSignature_classification`, are
kernel-decided in `AlignedTwoGraph`; no compiled evaluation, generated data, or
unproved axiom is used.
-/

namespace RelativeConicArcs
namespace AlignedTwoGraph

variable {α : Type*}

/-! ## Permutation invariance and the global complement bit -/

/-- Invariance of a triangle-bit function under the two adjacent transpositions
of its arguments.  A two-graph, being a function on three-element subsets,
satisfies it; the two generators give invariance under the whole symmetric
group on the three arguments. -/
structure TriangleSymmetric (tau : α → α → α → Bool) : Prop where
  /-- Invariance under transposing the first two arguments. -/
  swap₁₂ : ∀ a b c, tau a b c = tau b a c
  /-- Invariance under transposing the last two arguments. -/
  swap₂₃ : ∀ a b c, tau a b c = tau a c b

namespace TriangleSymmetric

variable {tau : α → α → α → Bool}

/-- Invariance under the cycle sending the first argument to the last place. -/
theorem rotate (h : TriangleSymmetric tau) (a b c : α) : tau a b c = tau b c a := by
  rw [h.swap₁₂ a b c, h.swap₂₃ b a c]

/-- Invariance under transposing the outer two arguments. -/
theorem swap₁₃ (h : TriangleSymmetric tau) (a b c : α) : tau a b c = tau c b a := by
  rw [h.swap₂₃ a b c, h.swap₁₂ a c b, h.swap₂₃ c a b]

end TriangleSymmetric

/-- Adding a fixed bit to every triangle value.  The bit `true` is global
complementation. -/
def xorBit (tau : α → α → α → Bool) (epsilon : Bool) : α → α → α → Bool :=
  fun a b c => Bool.xor (tau a b c) epsilon

@[simp] theorem xorBit_apply (tau : α → α → α → Bool) (epsilon : Bool) (a b c : α) :
    xorBit tau epsilon a b c = Bool.xor (tau a b c) epsilon := rfl

/-- The four-set parity law is insensitive to a global bit, because the four
triangle values of a four-set receive it four times. -/
theorem fourSetParity_xorBit {tau : α → α → α → Bool} (h : FourSetParity tau)
    (epsilon : Bool) : FourSetParity (xorBit tau epsilon) := by
  intro a b c d
  have := h a b c d
  revert this
  simp only [xorBit_apply]
  cases tau a b c <;> cases tau a b d <;> cases tau a c d <;> cases tau b c d <;>
    cases epsilon <;> decide

/-- Permutation invariance is insensitive to a global bit. -/
theorem triangleSymmetric_xorBit {tau : α → α → α → Bool} (h : TriangleSymmetric tau)
    (epsilon : Bool) : TriangleSymmetric (xorBit tau epsilon) where
  swap₁₂ a b c := by simp only [xorBit_apply, h.swap₁₂ a b c]
  swap₂₃ a b c := by simp only [xorBit_apply, h.swap₂₃ a b c]

/-- Adding a global bit preserves the aligned four-sets. -/
theorem aligned_xorBit_iff (tau : α → α → α → Bool) (epsilon : Bool) (a b c d : α) :
    Aligned (xorBit tau epsilon) a b c d ↔ Aligned tau a b c d := by
  unfold Aligned
  simp only [xorBit_apply]
  cases tau a b c <;> cases tau a b d <;> cases tau a c d <;> cases tau b c d <;>
    cases epsilon <;> decide

/-! ## Normalized cuts from triangle bits -/

/-- The normalized cut whose first three coordinates are the given bits; the
fourth coordinate of a normalized cut is fixed to zero. -/
def cutOfBits (b₀ b₁ b₂ : Bool) : NormalizedCut :=
  ⟨(if b₀ then 1 else 0) + (if b₁ then 2 else 0) + (if b₂ then 4 else 0), by
    cases b₀ <;> cases b₁ <;> cases b₂ <;> decide⟩

@[simp] theorem cutBit_cutOfBits_zero (b₀ b₁ b₂ : Bool) :
    cutBit (cutOfBits b₀ b₁ b₂) 0 = b₀ := by
  cases b₀ <;> cases b₁ <;> cases b₂ <;> rfl

@[simp] theorem cutBit_cutOfBits_one (b₀ b₁ b₂ : Bool) :
    cutBit (cutOfBits b₀ b₁ b₂) 1 = b₁ := by
  cases b₀ <;> cases b₁ <;> cases b₂ <;> rfl

@[simp] theorem cutBit_cutOfBits_two (b₀ b₁ b₂ : Bool) :
    cutBit (cutOfBits b₀ b₁ b₂) 2 = b₂ := by
  cases b₀ <;> cases b₁ <;> cases b₂ <;> rfl

@[simp] theorem cutBit_three (p : NormalizedCut) : cutBit p 3 = false := rfl

/-- The normalized cut of a point relative to a four-point anchor rooted at
`q₃`: its three coordinates are the triangle bits formed with the root and one
of the other three anchor points, and its fourth coordinate is the zero fixed
by rooting. -/
def anchorCut (tau : α → α → α → Bool) (q₃ q₀ q₁ q₂ x : α) : NormalizedCut :=
  cutOfBits (tau q₃ q₀ x) (tau q₃ q₁ x) (tau q₃ q₂ x)

/-- A four-point anchor with a distinguished root, normalized so that all four
of its triangle bits vanish.  Rooting at `q₃` then makes the six graph edges
inside the anchor vanish as well. -/
structure NormalizedAnchor (tau : α → α → α → Bool) (q₃ q₀ q₁ q₂ : α) : Prop where
  /-- The triangle bit of the root with the first two remaining anchor points. -/
  root₀₁ : tau q₃ q₀ q₁ = false
  /-- The triangle bit of the root with the first and third remaining points. -/
  root₀₂ : tau q₃ q₀ q₂ = false
  /-- The triangle bit of the root with the last two remaining anchor points. -/
  root₁₂ : tau q₃ q₁ q₂ = false
  /-- The triangle bit of the three anchor points other than the root. -/
  outer : tau q₀ q₁ q₂ = false

/-- An aligned four-set whose common triangle bit is zero is a normalized
anchor at its first point. -/
theorem normalizedAnchor_of_aligned {tau : α → α → α → Bool} {q₃ q₀ q₁ q₂ : α}
    (haligned : Aligned tau q₃ q₀ q₁ q₂) (hzero : tau q₃ q₀ q₁ = false) :
    NormalizedAnchor tau q₃ q₀ q₁ q₂ where
  root₀₁ := hzero
  root₀₂ := haligned.1 ▸ hzero
  root₁₂ := haligned.2.1 ▸ hzero
  outer := haligned.2.2 ▸ hzero

/-! ## The tests meeting the anchor in three points -/

section Transport

variable {tau : α → α → α → Bool} {q₃ q₀ q₁ q₂ : α}

/-- A mixed triangle bit on two anchor points and one further point is the sum
of the two cut coordinates, once the anchor pair is normalized to zero. -/
private theorem mixed_triangle (hpar : FourSetParity tau) {u v : α}
    (huv : tau q₃ u v = false) (x : α) :
    tau u v x = Bool.xor (tau q₃ u x) (tau q₃ v x) := by
  have h := triangle_eq_rooted_xor tau hpar q₃ u v x
  simp only [rootedEdge] at h
  rw [h, huv]
  cases tau q₃ u x <;> cases tau q₃ v x <;> rfl

/-- A triangle bit on one anchor point and two further points is the sum of the
two cut coordinates and the mutual edge bit. -/
private theorem outside_triangle (hpar : FourSetParity tau) (u x y : α) :
    tau u x y = Bool.xor (tau q₃ u x) (Bool.xor (tau q₃ u y) (tau q₃ x y)) := by
  have h := triangle_eq_rooted_xor tau hpar q₃ u x y
  simpa only [rootedEdge] using h

/-- The test on the root, two further anchor points, and one outside point sees
exactly that the two corresponding cut coordinates vanish. -/
private theorem aligned_root_pair_iff (hpar : FourSetParity tau) {u v : α}
    (huv : tau q₃ u v = false) (x : α) :
    (equalBit (tau q₃ u x) (tau q₃ v x) && equalBit (tau q₃ v x) false) = true ↔
      Aligned tau q₃ u v x := by
  have hmix := mixed_triangle (q₃ := q₃) hpar huv x
  unfold Aligned equalBit
  rw [huv, hmix]
  cases tau q₃ u x <;> cases tau q₃ v x <;> decide

/-- The test on the three anchor points other than the root sees exactly that
the three cut coordinates agree. -/
private theorem aligned_outer_iff (hpar : FourSetParity tau)
    (hn : NormalizedAnchor tau q₃ q₀ q₁ q₂) (x : α) :
    (equalBit (tau q₃ q₀ x) (tau q₃ q₁ x) && equalBit (tau q₃ q₁ x) (tau q₃ q₂ x)) = true ↔
      Aligned tau q₀ q₁ q₂ x := by
  have h₀₁ := mixed_triangle (q₃ := q₃) hpar hn.root₀₁ x
  have h₀₂ := mixed_triangle (q₃ := q₃) hpar hn.root₀₂ x
  have h₁₂ := mixed_triangle (q₃ := q₃) hpar hn.root₁₂ x
  unfold Aligned equalBit
  rw [hn.outer, h₀₁, h₀₂, h₁₂]
  cases tau q₃ q₀ x <;> cases tau q₃ q₁ x <;> cases tau q₃ q₂ x <;> decide

/-- The test on two anchor points other than the root and two outside points,
in the Boolean form used by `pairAligned`. -/
private theorem aligned_anchor_pair_iff (hpar : FourSetParity tau) {u v : α}
    (huv : tau q₃ u v = false) (x y : α) :
    (equalBit (Bool.xor (tau q₃ u x) (tau q₃ u y))
        (Bool.xor (tau q₃ v x) (tau q₃ v y)) &&
      equalBit (tau q₃ x y) (Bool.xor (tau q₃ v x) (tau q₃ u y))) = true ↔
      Aligned tau u v x y := by
  have hx := mixed_triangle (q₃ := q₃) hpar huv x
  have hy := mixed_triangle (q₃ := q₃) hpar huv y
  have hu := outside_triangle (q₃ := q₃) hpar u x y
  have hv := outside_triangle (q₃ := q₃) hpar v x y
  unfold Aligned equalBit
  rw [hx, hy, hu, hv]
  cases tau q₃ u x <;> cases tau q₃ u y <;> cases tau q₃ v x <;> cases tau q₃ v y <;>
    cases tau q₃ x y <;> decide

/-- The test on the root, one further anchor point, and two outside points. -/
private theorem aligned_root_outside_iff (hsym : TriangleSymmetric tau)
    (hpar : FourSetParity tau) (u x y : α) :
    (equalBit (Bool.xor (tau q₃ u x) (tau q₃ u y)) false &&
      equalBit (tau q₃ x y) (tau q₃ u y)) = true ↔
      Aligned tau u q₃ x y := by
  have hu := outside_triangle (q₃ := q₃) hpar u x y
  have hx : tau u q₃ x = tau q₃ u x := hsym.swap₁₂ u q₃ x
  have hy : tau u q₃ y = tau q₃ u y := hsym.swap₁₂ u q₃ y
  unfold Aligned equalBit
  rw [hx, hy, hu]
  cases tau q₃ u x <;> cases tau q₃ u y <;> cases tau q₃ x y <;> decide

end Transport

/-! ## Agreement on seven points -/

/-- Two Boolean values agree as soon as they are equivalent. -/
private theorem bool_eq_of_iff {a b : Bool} (h : a = true ↔ b = true) : a = b := by
  cases a <;> cases b <;> simp_all

section SevenPoint

variable {tau sigma : α → α → α → Bool}

/-- Seven points carrying an anchor normalized for both two-graphs, with the
same aligned four-sets, carry the same triangle bits.  The seven points are
indexed so that the anchor is `p 0, p 1, p 2, p 3` with root `p 0`, and the
three remaining points are `p 4, p 5, p 6`.  Distinctness of the seven points
is not used: the hypotheses are read at distinct indices and the conclusion is
asserted at distinct indices. -/
theorem sevenPoint_agreement (p : Fin 7 → α)
    (hsymT : TriangleSymmetric tau) (hparT : FourSetParity tau)
    (hsymS : TriangleSymmetric sigma) (hparS : FourSetParity sigma)
    (hnT : NormalizedAnchor tau (p 0) (p 1) (p 2) (p 3))
    (hnS : NormalizedAnchor sigma (p 0) (p 1) (p 2) (p 3))
    (hfam : ∀ i j k l : Fin 7, i ≠ j → i ≠ k → i ≠ l → j ≠ k → j ≠ l → k ≠ l →
      (Aligned tau (p i) (p j) (p k) (p l) ↔ Aligned sigma (p i) (p j) (p k) (p l))) :
    ∀ i j k : Fin 7, i ≠ j → i ≠ k → j ≠ k →
      sigma (p i) (p j) (p k) = tau (p i) (p j) (p k) := by
  classical
  -- The one-outside-point tests agree, coordinate by coordinate.
  have hanchorAll : ∀ m : Fin 7, (0 : Fin 7) ≠ m → (1 : Fin 7) ≠ m → (2 : Fin 7) ≠ m →
      (3 : Fin 7) ≠ m → ∀ i : Fin 4,
      anchorSignature (anchorCut tau (p 0) (p 1) (p 2) (p 3) (p m)) i =
        anchorSignature (anchorCut sigma (p 0) (p 1) (p 2) (p 3) (p m)) i := by
    intro m h0 h1 h2 h3 i
    apply bool_eq_of_iff
    fin_cases i
    · simp only [anchorSignature, anchorCut, cutBit_cutOfBits_one, cutBit_cutOfBits_two,
        cutBit_three]
      rw [aligned_root_pair_iff hparT hnT.root₁₂ (p m),
        aligned_root_pair_iff hparS hnS.root₁₂ (p m)]
      exact hfam 0 2 3 m (by decide) (by decide) h0 (by decide) h2 h3
    · simp only [anchorSignature, anchorCut, cutBit_cutOfBits_zero, cutBit_cutOfBits_two,
        cutBit_three]
      rw [aligned_root_pair_iff hparT hnT.root₀₂ (p m),
        aligned_root_pair_iff hparS hnS.root₀₂ (p m)]
      exact hfam 0 1 3 m (by decide) (by decide) h0 (by decide) h1 h3
    · simp only [anchorSignature, anchorCut, cutBit_cutOfBits_zero, cutBit_cutOfBits_one,
        cutBit_three]
      rw [aligned_root_pair_iff hparT hnT.root₀₁ (p m),
        aligned_root_pair_iff hparS hnS.root₀₁ (p m)]
      exact hfam 0 1 2 m (by decide) (by decide) h0 (by decide) h1 h2
    · simp only [anchorSignature, anchorCut, cutBit_cutOfBits_zero, cutBit_cutOfBits_one,
        cutBit_cutOfBits_two]
      rw [aligned_outer_iff hparT hnT (p m), aligned_outer_iff hparS hnS (p m)]
      exact hfam 1 2 3 m (by decide) (by decide) h1 (by decide) h2 h3
  -- The two-outside-point tests agree, coordinate by coordinate.
  have hpairAll : ∀ m n : Fin 7, (0 : Fin 7) ≠ m → (1 : Fin 7) ≠ m → (2 : Fin 7) ≠ m →
      (3 : Fin 7) ≠ m → (0 : Fin 7) ≠ n → (1 : Fin 7) ≠ n → (2 : Fin 7) ≠ n →
      (3 : Fin 7) ≠ n → m ≠ n → ∀ t : Fin 6,
      pairSignature (anchorCut tau (p 0) (p 1) (p 2) (p 3) (p m))
          (anchorCut tau (p 0) (p 1) (p 2) (p 3) (p n)) (tau (p 0) (p m) (p n)) t =
        pairSignature (anchorCut sigma (p 0) (p 1) (p 2) (p 3) (p m))
          (anchorCut sigma (p 0) (p 1) (p 2) (p 3) (p n)) (sigma (p 0) (p m) (p n)) t := by
    intro m n h0m h1m h2m h3m h0n h1n h2n h3n hmn t
    apply bool_eq_of_iff
    fin_cases t
    · simp only [pairSignature, pairAligned, anchorCut, cutBit_cutOfBits_zero,
        cutBit_cutOfBits_one]
      rw [aligned_anchor_pair_iff hparT hnT.root₀₁ (p m) (p n),
        aligned_anchor_pair_iff hparS hnS.root₀₁ (p m) (p n)]
      exact hfam 1 2 m n (by decide) h1m h1n h2m h2n hmn
    · simp only [pairSignature, pairAligned, anchorCut, cutBit_cutOfBits_zero,
        cutBit_cutOfBits_two]
      rw [aligned_anchor_pair_iff hparT hnT.root₀₂ (p m) (p n),
        aligned_anchor_pair_iff hparS hnS.root₀₂ (p m) (p n)]
      exact hfam 1 3 m n (by decide) h1m h1n h3m h3n hmn
    · simp only [pairSignature, pairAligned, anchorCut, cutBit_cutOfBits_zero, cutBit_three,
        Bool.xor_false, Bool.false_xor]
      rw [aligned_root_outside_iff hsymT hparT (p 1) (p m) (p n),
        aligned_root_outside_iff hsymS hparS (p 1) (p m) (p n)]
      exact hfam 1 0 m n (by decide) h1m h1n h0m h0n hmn
    · simp only [pairSignature, pairAligned, anchorCut, cutBit_cutOfBits_one,
        cutBit_cutOfBits_two]
      rw [aligned_anchor_pair_iff hparT hnT.root₁₂ (p m) (p n),
        aligned_anchor_pair_iff hparS hnS.root₁₂ (p m) (p n)]
      exact hfam 2 3 m n (by decide) h2m h2n h3m h3n hmn
    · simp only [pairSignature, pairAligned, anchorCut, cutBit_cutOfBits_one, cutBit_three,
        Bool.xor_false, Bool.false_xor]
      rw [aligned_root_outside_iff hsymT hparT (p 2) (p m) (p n),
        aligned_root_outside_iff hsymS hparS (p 2) (p m) (p n)]
      exact hfam 2 0 m n (by decide) h2m h2n h0m h0n hmn
    · simp only [pairSignature, pairAligned, anchorCut, cutBit_cutOfBits_two, cutBit_three,
        Bool.xor_false, Bool.false_xor]
      rw [aligned_root_outside_iff hsymT hparT (p 3) (p m) (p n),
        aligned_root_outside_iff hsymS hparS (p 3) (p m) (p n)]
      exact hfam 3 0 m n (by decide) h3m h3n h0m h0n hmn
  -- Hence the two normalized seven-point data coincide.
  set dT : NormalizedSevenData :=
    { cut := ![anchorCut tau (p 0) (p 1) (p 2) (p 3) (p 4),
        anchorCut tau (p 0) (p 1) (p 2) (p 3) (p 5),
        anchorCut tau (p 0) (p 1) (p 2) (p 3) (p 6)],
      edge := ![tau (p 0) (p 4) (p 5), tau (p 0) (p 4) (p 6), tau (p 0) (p 5) (p 6)] } with hdT
  set dS : NormalizedSevenData :=
    { cut := ![anchorCut sigma (p 0) (p 1) (p 2) (p 3) (p 4),
        anchorCut sigma (p 0) (p 1) (p 2) (p 3) (p 5),
        anchorCut sigma (p 0) (p 1) (p 2) (p 3) (p 6)],
      edge := ![sigma (p 0) (p 4) (p 5), sigma (p 0) (p 4) (p 6), sigma (p 0) (p 5) (p 6)] } with hdS
  have hsame : SameNormalizedSevenSignature dT dS := by
    constructor
    · intro x i
      fin_cases x
      · exact hanchorAll 4 (by decide) (by decide) (by decide) (by decide) i
      · exact hanchorAll 5 (by decide) (by decide) (by decide) (by decide) i
      · exact hanchorAll 6 (by decide) (by decide) (by decide) (by decide) i
    · intro q t
      fin_cases q
      · exact hpairAll 4 5 (by decide) (by decide) (by decide) (by decide) (by decide)
          (by decide) (by decide) (by decide) (by decide) t
      · exact hpairAll 4 6 (by decide) (by decide) (by decide) (by decide) (by decide)
          (by decide) (by decide) (by decide) (by decide) t
      · exact hpairAll 5 6 (by decide) (by decide) (by decide) (by decide) (by decide)
          (by decide) (by decide) (by decide) (by decide) t
  have hdata : dT = dS := normalizedSevenSignature_injective dT dS hsame
  -- Reading the coordinates of that equality returns the rooted edge bits.
  have hcutbit : ∀ (m : Fin 3) (i : Fin 4), cutBit (dT.cut m) i = cutBit (dS.cut m) i := by
    intro m i; rw [hdata]
  have hedgebit : ∀ q : Fin 3, dT.edge q = dS.edge q := by
    intro q; rw [hdata]
  have h14 : tau (p 0) (p 1) (p 4) = sigma (p 0) (p 1) (p 4) := by
    simpa [hdT, hdS, anchorCut] using hcutbit 0 0
  have h24 : tau (p 0) (p 2) (p 4) = sigma (p 0) (p 2) (p 4) := by
    simpa [hdT, hdS, anchorCut] using hcutbit 0 1
  have h34 : tau (p 0) (p 3) (p 4) = sigma (p 0) (p 3) (p 4) := by
    simpa [hdT, hdS, anchorCut] using hcutbit 0 2
  have h15 : tau (p 0) (p 1) (p 5) = sigma (p 0) (p 1) (p 5) := by
    simpa [hdT, hdS, anchorCut] using hcutbit 1 0
  have h25 : tau (p 0) (p 2) (p 5) = sigma (p 0) (p 2) (p 5) := by
    simpa [hdT, hdS, anchorCut] using hcutbit 1 1
  have h35 : tau (p 0) (p 3) (p 5) = sigma (p 0) (p 3) (p 5) := by
    simpa [hdT, hdS, anchorCut] using hcutbit 1 2
  have h16 : tau (p 0) (p 1) (p 6) = sigma (p 0) (p 1) (p 6) := by
    simpa [hdT, hdS, anchorCut] using hcutbit 2 0
  have h26 : tau (p 0) (p 2) (p 6) = sigma (p 0) (p 2) (p 6) := by
    simpa [hdT, hdS, anchorCut] using hcutbit 2 1
  have h36 : tau (p 0) (p 3) (p 6) = sigma (p 0) (p 3) (p 6) := by
    simpa [hdT, hdS, anchorCut] using hcutbit 2 2
  have h45 : tau (p 0) (p 4) (p 5) = sigma (p 0) (p 4) (p 5) := by
    simpa [hdT, hdS] using hedgebit 0
  have h46 : tau (p 0) (p 4) (p 6) = sigma (p 0) (p 4) (p 6) := by
    simpa [hdT, hdS] using hedgebit 1
  have h56 : tau (p 0) (p 5) (p 6) = sigma (p 0) (p 5) (p 6) := by
    simpa [hdT, hdS] using hedgebit 2
  have h12 : tau (p 0) (p 1) (p 2) = sigma (p 0) (p 1) (p 2) := by
    rw [hnT.root₀₁, hnS.root₀₁]
  have h13 : tau (p 0) (p 1) (p 3) = sigma (p 0) (p 1) (p 3) := by
    rw [hnT.root₀₂, hnS.root₀₂]
  have h23 : tau (p 0) (p 2) (p 3) = sigma (p 0) (p 2) (p 3) := by
    rw [hnT.root₁₂, hnS.root₁₂]
  have hswap : ∀ a b : α, tau (p 0) a b = sigma (p 0) a b →
      tau (p 0) b a = sigma (p 0) b a := by
    intro a b h
    rw [hsymT.swap₂₃ (p 0) b a, hsymS.swap₂₃ (p 0) b a]
    exact h
  -- Every rooted edge bit therefore agrees.
  have hroot : ∀ u v : Fin 7, u ≠ 0 → v ≠ 0 → u ≠ v →
      tau (p 0) (p u) (p v) = sigma (p 0) (p u) (p v) := by
    intro u v hu hv huv
    fin_cases u <;> fin_cases v <;>
      first
        | exact absurd rfl hu
        | exact absurd rfl hv
        | exact absurd rfl huv
        | assumption
        | exact hswap _ _ (by assumption)
  -- The parity law rebuilds every triangle bit from those edge bits.
  intro i j k hij hik hjk
  by_cases h0i : i = 0
  · subst h0i
    exact (hroot j k (Ne.symm hij) (Ne.symm hik) hjk).symm
  · by_cases h0j : j = 0
    · subst h0j
      rw [hsymS.swap₁₂ (p i) (p 0) (p k), hsymT.swap₁₂ (p i) (p 0) (p k)]
      exact (hroot i k h0i (Ne.symm hjk) hik).symm
    · by_cases h0k : k = 0
      · subst h0k
        rw [hsymS.swap₂₃ (p i) (p j) (p 0), hsymS.swap₁₂ (p i) (p 0) (p j),
          hsymT.swap₂₃ (p i) (p j) (p 0), hsymT.swap₁₂ (p i) (p 0) (p j)]
        exact (hroot i j h0i h0j hij).symm
      · have hT := triangle_eq_rooted_xor tau hparT (p 0) (p i) (p j) (p k)
        have hS := triangle_eq_rooted_xor sigma hparS (p 0) (p i) (p j) (p k)
        simp only [rootedEdge] at hT hS
        rw [hT, hS, hroot i j h0i h0j hij, hroot i k h0i h0k hik,
          hroot j k h0j h0k hjk]

end SevenPoint

/-! ## Faithfulness on seven or more points -/

/-- Four labels are pairwise distinct. -/
def DistinctQuadruple (a b c d : α) : Prop :=
  a ≠ b ∧ a ≠ c ∧ a ≠ d ∧ b ≠ c ∧ b ≠ d ∧ c ≠ d

section Global

variable {tau sigma : α → α → α → Bool}

/-- On a seven-point set, two two-graphs with the same aligned four-sets differ
by a single complement bit.  The anchor is produced inside the proof by the
six-point Ramsey bound, and both two-graphs are shifted so that their common
anchor bit vanishes before the normalized seven-point classification is
applied. -/
theorem exists_complementBit_on_seven [DecidableEq α]
    (hsymT : TriangleSymmetric tau) (hparT : FourSetParity tau)
    (hsymS : TriangleSymmetric sigma) (hparS : FourSetParity sigma)
    (S : Finset α) (hS : S.card = 7)
    (hfam : ∀ a b c d : α, a ∈ S → b ∈ S → c ∈ S → d ∈ S → DistinctQuadruple a b c d →
      (Aligned tau a b c d ↔ Aligned sigma a b c d)) :
    ∃ epsilon : Bool, ∀ a b c : α, a ∈ S → b ∈ S → c ∈ S → DistinctTriple a b c →
      AgreesWithComplementBit tau sigma epsilon a b c := by
  classical
  -- Choose a root and enumerate the six remaining points.
  obtain ⟨r, hr⟩ : ∃ r, r ∈ S := Finset.card_pos.mp (by omega) |>.imp fun _ h => h
  set T : Finset α := S.erase r with hTdef
  have hT : T.card = 6 := by rw [hTdef, Finset.card_erase_of_mem hr, hS]
  have hTsub : T ⊆ S := Finset.erase_subset _ _
  have hrT : r ∉ T := fun h => (Finset.mem_erase.mp h).1 rfl
  let eqv : Fin 6 ≃ {x // x ∈ T} :=
    (Fintype.equivFinOfCardEq (by simpa using hT)).symm
  let v : Fin 6 → α := fun t => (eqv t : α)
  have hvT : ∀ t, v t ∈ T := fun t => (eqv t).2
  have hvinj : Function.Injective v := by
    intro a b hab
    exact eqv.injective (Subtype.ext hab)
  have hvsurj : ∀ a ∈ T, ∃ t, v t = a := by
    intro a ha
    exact ⟨eqv.symm ⟨a, ha⟩, congrArg Subtype.val (eqv.apply_symm_apply ⟨a, ha⟩)⟩
  -- The six-point Ramsey bound supplies an aligned four-set through the root.
  obtain ⟨i, j, k, hij, hjk, hanchor⟩ := exists_alignedAnchor tau hparT r v
  have hik : i < k := hij.trans hjk
  -- The three points outside the anchor.
  set U : Finset α := T \ {v i, v j, v k} with hUdef
  have hvij : v i ≠ v j := fun h => hij.ne (hvinj h)
  have hvik : v i ≠ v k := fun h => hik.ne (hvinj h)
  have hvjk : v j ≠ v k := fun h => hjk.ne (hvinj h)
  have hUcard : U.card = 3 := by
    have hsub : ({v i, v j, v k} : Finset α) ⊆ T := by
      intro a ha
      simp only [Finset.mem_insert, Finset.mem_singleton] at ha
      rcases ha with rfl | rfl | rfl <;> exact hvT _
    have hcard3 : ({v i, v j, v k} : Finset α).card = 3 :=
      Finset.card_eq_three.mpr ⟨v i, v j, v k, hvij, hvik, hvjk, rfl⟩
    rw [hUdef, Finset.card_sdiff, Finset.inter_eq_left.mpr hsub, hT, hcard3]
  obtain ⟨x₀, x₁, x₂, hx₀₁, hx₀₂, hx₁₂, hUeq⟩ := Finset.card_eq_three.mp hUcard
  have hxT : ∀ y ∈ ({x₀, x₁, x₂} : Finset α), y ∈ T ∧ y ≠ v i ∧ y ≠ v j ∧ y ≠ v k := by
    intro y hy
    have : y ∈ U := by rw [hUeq]; exact hy
    rw [hUdef, Finset.mem_sdiff] at this
    refine ⟨this.1, ?_, ?_, ?_⟩ <;>
      · intro h
        exact this.2 (by simp [h])
  have hx₀ := hxT x₀ (by simp)
  have hx₁ := hxT x₁ (by simp)
  have hx₂ := hxT x₂ (by simp)
  -- Index the seven points, root first and anchor next.
  set p : Fin 7 → α := ![r, v i, v j, v k, x₀, x₁, x₂] with hp
  have hrne : ∀ t : Fin 6, r ≠ v t := fun t h => hrT (h ▸ hvT t)
  have hpS : ∀ t : Fin 7, p t ∈ S := by
    intro t
    fin_cases t <;> simp only [hp]
    · exact hr
    · exact hTsub (hvT i)
    · exact hTsub (hvT j)
    · exact hTsub (hvT k)
    · exact hTsub hx₀.1
    · exact hTsub hx₁.1
    · exact hTsub hx₂.1
  have hpsurj : ∀ a ∈ S, ∃ t : Fin 7, p t = a := by
    intro a ha
    by_cases hra : a = r
    · exact ⟨0, by simp [hp, hra]⟩
    · have haT : a ∈ T := Finset.mem_erase.mpr ⟨hra, ha⟩
      obtain ⟨t, rfl⟩ := hvsurj a haT
      by_cases hti : t = i
      · exact ⟨1, by simp [hp, hti]⟩
      · by_cases htj : t = j
        · exact ⟨2, by simp [hp, htj]⟩
        · by_cases htk : t = k
          · exact ⟨3, by simp [hp, htk]⟩
          · have : v t ∈ U := by
              rw [hUdef, Finset.mem_sdiff]
              refine ⟨hvT t, ?_⟩
              simp only [Finset.mem_insert, Finset.mem_singleton]
              simp only [not_or]
              exact ⟨fun h => hti (hvinj h), fun h => htj (hvinj h), fun h => htk (hvinj h)⟩
            rw [hUeq] at this
            simp only [Finset.mem_insert, Finset.mem_singleton] at this
            rcases this with h | h | h
            · exact ⟨4, by simp [hp, h]⟩
            · exact ⟨5, by simp [hp, h]⟩
            · exact ⟨6, by simp [hp, h]⟩
  -- Seven points hitting a seven-element set are distinct.
  have hpinj : Function.Injective p := by
    intro a b hab
    refine Finset.inj_on_of_surj_on_of_card_le (t := S) (fun t _ => p t)
      (fun t _ => hpS t) (fun y hy => ?_) ?_ (Finset.mem_univ a) (Finset.mem_univ b) hab
    · obtain ⟨t, ht⟩ := hpsurj y hy
      exact ⟨t, Finset.mem_univ t, ht⟩
    · simp [hS]
  -- Shift both two-graphs so that the anchor bit vanishes.
  set eT : Bool := tau (p 0) (p 1) (p 2) with heT
  set eS : Bool := sigma (p 0) (p 1) (p 2) with heS
  have hanchorT : Aligned tau (p 0) (p 1) (p 2) (p 3) := by
    simpa [hp] using hanchor
  have hanchorS : Aligned sigma (p 0) (p 1) (p 2) (p 3) := by
    refine (hfam (p 0) (p 1) (p 2) (p 3) (hpS 0) (hpS 1) (hpS 2) (hpS 3) ?_).mp hanchorT
    exact ⟨fun h => absurd (hpinj h) (by decide), fun h => absurd (hpinj h) (by decide),
      fun h => absurd (hpinj h) (by decide), fun h => absurd (hpinj h) (by decide),
      fun h => absurd (hpinj h) (by decide), fun h => absurd (hpinj h) (by decide)⟩
  have hnT : NormalizedAnchor (xorBit tau eT) (p 0) (p 1) (p 2) (p 3) :=
    normalizedAnchor_of_aligned ((aligned_xorBit_iff tau eT _ _ _ _).mpr hanchorT)
      (by simp [xorBit, heT])
  have hnS : NormalizedAnchor (xorBit sigma eS) (p 0) (p 1) (p 2) (p 3) :=
    normalizedAnchor_of_aligned ((aligned_xorBit_iff sigma eS _ _ _ _).mpr hanchorS)
      (by simp [xorBit, heS])
  have hagree := sevenPoint_agreement p (triangleSymmetric_xorBit hsymT eT)
    (fourSetParity_xorBit hparT eT) (triangleSymmetric_xorBit hsymS eS)
    (fourSetParity_xorBit hparS eS) hnT hnS
    (by
      intro a b c d hab hac had hbc hbd hcd
      rw [aligned_xorBit_iff, aligned_xorBit_iff]
      exact hfam (p a) (p b) (p c) (p d) (hpS a) (hpS b) (hpS c) (hpS d)
        ⟨fun h => hab (hpinj h), fun h => hac (hpinj h), fun h => had (hpinj h),
          fun h => hbc (hpinj h), fun h => hbd (hpinj h), fun h => hcd (hpinj h)⟩)
  refine ⟨Bool.xor eT eS, ?_⟩
  intro a b c ha hb hc habc
  obtain ⟨ia, rfl⟩ := hpsurj a ha
  obtain ⟨ib, rfl⟩ := hpsurj b hb
  obtain ⟨ic, rfl⟩ := hpsurj c hc
  have hne : ia ≠ ib ∧ ia ≠ ic ∧ ib ≠ ic :=
    ⟨fun h => habc.1 (congrArg p h), fun h => habc.2.1 (congrArg p h),
      fun h => habc.2.2 (congrArg p h)⟩
  have := hagree ia ib ic hne.1 hne.2.1 hne.2.2
  simp only [xorBit_apply] at this
  unfold AgreesWithComplementBit
  revert this
  cases tau (p ia) (p ib) (p ic) <;> cases sigma (p ia) (p ib) (p ic) <;>
    cases eT <;> cases eS <;> simp

/-- Faithfulness of the aligned four-set family.  On a finite point set with at
least seven points, two two-graphs with the same aligned four-sets have the same
triangle bits after one global complement, on every triple of distinct points.
With `aligned_complement_iff`, which says that complementing preserves the
family, this is the exact statement that the aligned four-sets determine the
two-graph up to complement.

The hypotheses quantify over triples and four-sets of pairwise distinct points
only; nothing is assumed about the value of a triangle bit at a repeated
argument, and nothing is concluded about it. -/
theorem exists_complementBit_of_alignedFamily_eq [Fintype α]
    (hsymT : TriangleSymmetric tau) (hparT : FourSetParity tau)
    (hsymS : TriangleSymmetric sigma) (hparS : FourSetParity sigma)
    (hcard : 7 ≤ Fintype.card α)
    (hfam : ∀ a b c d : α, DistinctQuadruple a b c d →
      (Aligned tau a b c d ↔ Aligned sigma a b c d)) :
    ∃ epsilon : Bool, ∀ a b c : α, DistinctTriple a b c →
      sigma a b c = Bool.xor (tau a b c) epsilon := by
  classical
  -- Any two triples lie in a common seven-point set, which carries one
  -- complement bit for both of them.
  have hpair : ∀ a b c x y z : α, DistinctTriple a b c → DistinctTriple x y z →
      ∃ epsilon, AgreesWithComplementBit tau sigma epsilon a b c ∧
        AgreesWithComplementBit tau sigma epsilon x y z := by
    intro a b c x y z habc hxyz
    have hcard6 : ({a, b, c, x, y, z} : Finset α).card ≤ 6 :=
      le_trans (Finset.card_insert_le _ _)
        (Nat.succ_le_succ (le_trans (Finset.card_insert_le _ _)
          (Nat.succ_le_succ (le_trans (Finset.card_insert_le _ _)
            (Nat.succ_le_succ (le_trans (Finset.card_insert_le _ _)
              (Nat.succ_le_succ (le_trans (Finset.card_insert_le _ _)
                (Nat.succ_le_succ (Finset.card_singleton z).le)))))))))
    obtain ⟨S, hsub, hS⟩ :=
      Finset.exists_superset_card_eq (s := ({a, b, c, x, y, z} : Finset α))
        (n := 7) (le_trans hcard6 (by norm_num)) hcard
    obtain ⟨epsilon, hagree⟩ :=
      exists_complementBit_on_seven hsymT hparT hsymS hparS S hS
        (fun a' b' c' d' _ _ _ _ hd => hfam a' b' c' d' hd)
    have hmem : ∀ w ∈ ({a, b, c, x, y, z} : Finset α), w ∈ S := fun w hw => hsub hw
    exact ⟨epsilon,
      hagree a b c (hmem a (by simp)) (hmem b (by simp)) (hmem c (by simp)) habc,
      hagree x y z (hmem x (by simp)) (hmem y (by simp)) (hmem z (by simp)) hxyz⟩
  -- Three distinct points calibrate the bit globally.
  obtain ⟨R, -, hR⟩ :=
    Finset.exists_superset_card_eq (s := (∅ : Finset α)) (n := 3) (by simp) (by omega)
  obtain ⟨r₀, r₁, r₂, h₀₁, h₀₂, h₁₂, -⟩ := Finset.card_eq_three.mp hR
  obtain ⟨epsilon, hglobal⟩ :=
    global_agreement_of_common_seven_restrictions tau sigma r₀ r₁ r₂ ⟨h₀₁, h₀₂, h₁₂⟩ hpair
  exact ⟨epsilon, fun a b c habc => hglobal a b c habc⟩

end Global

end AlignedTwoGraph
end RelativeConicArcs
