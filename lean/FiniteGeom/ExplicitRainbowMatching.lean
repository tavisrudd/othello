import FiniteGeom.ColoredCompleteGraph
import Mathlib.FieldTheory.Finite.Basic

/-!
# Explicit rainbow matchings

This file packages the elementary bookkeeping needed to turn an indexed family of disjoint
graph edges with distinct colors into a matching of an augmented color hypergraph.
-/

namespace FiniteGeom

open Finset

variable {α β ι : Type*} [Fintype α] [DecidableEq α] [Fintype β] [DecidableEq β]
  [Fintype ι] [DecidableEq ι]

/-- The augmented edge selected by endpoints `a i`, `b i`. -/
def explicitAugmentedEdge (color : α → α → β) (a b : ι → α) (i : ι) :
    Finset (α ⊕ β) :=
  {Sum.inl (a i), Sum.inl (b i), Sum.inr (color (a i) (b i))}

omit [Fintype β] [DecidableEq ι] in
/-- Indexed vertex-disjoint graph edges with pairwise distinct colors form a matching in the
augmented color hypergraph.  The deliberately strong cross-index endpoint hypothesis makes the
lemma easy to instantiate and audit. -/
theorem isMatching_explicitAugmentedEdge (color : α → α → β) (a b : ι → α)
    (hend : ∀ i, a i ≠ b i)
    (hcross : ∀ i j, i ≠ j →
      a i ≠ a j ∧ a i ≠ b j ∧ b i ≠ a j ∧ b i ≠ b j)
    (hcolor : Function.Injective fun i => color (a i) (b i)) :
    IsMatching (augmentedColorHypergraph color)
      (univ.image (explicitAugmentedEdge color a b)) := by
  classical
  constructor
  · intro E hE
    obtain ⟨i, -, rfl⟩ := Finset.mem_image.mp hE
    exact mem_augmentedColorHypergraph.mpr ⟨a i, b i, hend i, rfl⟩
  · intro E hE E' hE' hne
    obtain ⟨i, -, rfl⟩ := Finset.mem_image.mp hE
    obtain ⟨j, -, rfl⟩ := Finset.mem_image.mp hE'
    have hij : i ≠ j := by
      intro hij
      subst j
      exact hne rfl
    rcases hcross i j hij with ⟨haa, hab, hba, hbb⟩
    have hc : color (a i) (b i) ≠ color (a j) (b j) := fun h => hij (hcolor h)
    simp only [Finset.disjoint_left, explicitAugmentedEdge, Finset.mem_insert,
      Finset.mem_singleton]
    intro z hz hz'
    rcases hz with rfl | rfl | rfl <;> simp_all

omit [Fintype α] [Fintype β] in
/-- The explicit matching has one edge per index. -/
theorem card_explicitAugmentedEdge (color : α → α → β) (a b : ι → α)
    (_hend : ∀ i, a i ≠ b i)
    (hcross : ∀ i j, i ≠ j →
      a i ≠ a j ∧ a i ≠ b j ∧ b i ≠ a j ∧ b i ≠ b j) :
    (univ.image (explicitAugmentedEdge color a b)).card = Fintype.card ι := by
  rw [Finset.card_image_iff.mpr]
  · simp
  · intro i _ j _ hEq
    by_contra hij
    rcases hcross i j hij with ⟨haa, hab, hba, hbb⟩
    have hi : Sum.inl (a i) ∈ explicitAugmentedEdge color a b i := by simp [explicitAugmentedEdge]
    rw [hEq] at hi
    simp only [explicitAugmentedEdge, Finset.mem_insert, Finset.mem_singleton,
      Sum.inl.injEq, Sum.inl_ne_inr, or_false] at hi
    exact hi.elim haa hab

omit [Fintype β] in
/-- An explicit rainbow perfect matching proves the corresponding matching-number lower bound. -/
theorem card_le_matchingNumber_augmentedColorHypergraph_of_explicit
    (color : α → α → β) (a b : ι → α)
    (hend : ∀ i, a i ≠ b i)
    (hcross : ∀ i j, i ≠ j →
      a i ≠ a j ∧ a i ≠ b j ∧ b i ≠ a j ∧ b i ≠ b j)
    (hcolor : Function.Injective fun i => color (a i) (b i)) :
    Fintype.card ι ≤ matchingNumber (augmentedColorHypergraph color) := by
  let M := univ.image (explicitAugmentedEdge color a b)
  have hM := isMatching_explicitAugmentedEdge color a b hend hcross hcolor
  rw [← card_explicitAugmentedEdge color a b hend hcross]
  exact card_le_matchingNumber hM

end FiniteGeom

namespace FiniteGeom

open Finset

variable {F : Type*} [Field F] [Fintype F] [DecidableEq F]

/-- Over a finite field of characteristic three, the complete graph on the nonzero field
elements, colored by endpoint sum, has a rainbow perfect matching.  A generator `g` supplies the
matching `g^(2i)--g^(2i+1)`. -/
theorem units_addColor_matchingNumber_lower [CharP F 3] :
    Fintype.card Fˣ / 2 ≤
      matchingNumber (augmentedColorHypergraph fun u v : Fˣ => (u : F) + (v : F)) := by
  classical
  obtain ⟨g, hg⟩ := IsCyclic.exists_generator (α := Fˣ)
  let n := Fintype.card F - 1
  let m := n / 2
  have hq : 3 ≤ Fintype.card F := by
    obtain ⟨k, -, hk⟩ := FiniteField.card F 3
    rw [hk]
    exact Nat.le_pow k.prop
  have hchar : ringChar F ≠ 2 := by
    rw [ringChar.eq F 3]
    decide
  have hncard : Fintype.card Fˣ = n := by
    simp [n, ← Nat.card_eq_fintype_card, Nat.card_units]
  have hn : n = 2 * m := by
    have hodd := Nat.two_mul_odd_div_two (FiniteField.odd_card_of_char_ne_two hchar)
    dsimp [n, m]
    omega
  have hnpos : 0 < n := by omega
  have horder : orderOf g = n := by
    rw [orderOf_eq_card_of_forall_mem_zpowers hg, Nat.card_eq_fintype_card, hncard]
  have hpow_inj {r s : ℕ} (hr : r < n) (hs : s < n) (hpow : g ^ r = g ^ s) : r = s := by
    rw [pow_eq_pow_iff_modEq, horder] at hpow
    exact hpow.eq_of_lt_of_lt hr hs
  let a : Fin m → Fˣ := fun i => g ^ (2 * i.1)
  let b : Fin m → Fˣ := fun i => g ^ (2 * i.1 + 1)
  have heven_lt (i : Fin m) : 2 * i.1 < n := by
    rw [hn]
    omega
  have hodd_lt (i : Fin m) : 2 * i.1 + 1 < n := by
    rw [hn]
    omega
  have hend : ∀ i, a i ≠ b i := by
    intro i hi
    have := hpow_inj (heven_lt i) (hodd_lt i) hi
    omega
  have hcross : ∀ i j, i ≠ j →
      a i ≠ a j ∧ a i ≠ b j ∧ b i ≠ a j ∧ b i ≠ b j := by
    intro i j hij
    have hfin : i.1 ≠ j.1 := fun h => hij (Fin.ext h)
    constructor
    · intro h
      have := hpow_inj (heven_lt i) (heven_lt j) h
      omega
    constructor
    · intro h
      have := hpow_inj (heven_lt i) (hodd_lt j) h
      omega
    constructor
    · intro h
      have := hpow_inj (hodd_lt i) (heven_lt j) h
      omega
    · intro h
      have := hpow_inj (hodd_lt i) (hodd_lt j) h
      omega
  have hcolor : Function.Injective fun i : Fin m => ((a i : F) + (b i : F)) := by
    by_cases hsmall : Fintype.card F = 3
    · have hm : m = 1 := by simp [m, n, hsmall]
      intro i j _
      apply Fin.ext
      rw [show i.1 = 0 by omega, show j.1 = 0 by omega]
    · have hgnot : (g : F) ≠ -1 := by
        intro hneg
        have hgpow : g ^ 2 = 1 := by
          apply Units.ext
          simp [hneg]
        have hdvd : n ∣ 2 := by
          rw [← horder]
          exact orderOf_dvd_of_pow_eq_one hgpow
        have hnle : n ≤ 2 := Nat.le_of_dvd (by decide) hdvd
        omega
      have hcoef : (1 : F) + (g : F) ≠ 0 := by
        intro hzero
        exact hgnot (eq_neg_of_add_eq_zero_right hzero)
      intro i j hij
      have hfac : (a i : F) * (1 + (g : F)) = (a j : F) * (1 + (g : F)) := by
        simpa [a, b, pow_succ, mul_add] using hij
      have hval : (a i : F) = (a j : F) := mul_right_cancel₀ hcoef hfac
      have hai : a i = a j := Units.ext hval
      have hexp := hpow_inj (heven_lt i) (heven_lt j) hai
      exact Fin.ext (by omega)
  have hlower := card_le_matchingNumber_augmentedColorHypergraph_of_explicit
    (fun u v : Fˣ => (u : F) + (v : F)) a b hend hcross hcolor
  simpa [m, hncard] using hlower

end FiniteGeom
