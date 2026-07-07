import ProjectiveCap.GridCounting
import ProjectiveCap.StableFacts
import Mathlib.Tactic

/-!
# The size-three extension count ("total") lemma

Every legal size-three residual grid position has exactly `q^2 - 9q + 21` legal
one-point extensions, where `q` is the field size.  The count is independent of
the position: the free-free grid has `(q-3)^2` cells and each of the three
pair-lines removes exactly `q-4` of them, with no overlaps inside the free-free
grid.

This proves `ProjectiveCap.Stable.SizeThreeExtensionCountStatement`.
-/

namespace ProjectiveCap

variable {K : Type*} [Field K] [Fintype K] [DecidableEq K]

omit [Fintype K] in
instance decidableCollinear (a b c : GridPoint K) :
    Decidable (Collinear (K := K) a b c) := by
  unfold Collinear
  infer_instance

instance decidablePairLineBlockedBy (S : Finset (GridPoint K)) :
    DecidablePred (PairLineBlockedBy (K := K) S) := fun p => by
  unfold PairLineBlockedBy
  infer_instance

/-! ## Collinearity symmetries -/

omit [Fintype K] [DecidableEq K] in
theorem collinear_swap_left {a b c : GridPoint K} :
    Collinear (K := K) a b c ↔ Collinear (K := K) b a c := by
  unfold Collinear
  constructor <;> intro h <;> linear_combination -h

omit [Fintype K] [DecidableEq K] in
theorem collinear_swap_right {a b c : GridPoint K} :
    Collinear (K := K) a b c ↔ Collinear (K := K) a c b := by
  unfold Collinear
  constructor <;> intro h <;> linear_combination -h

omit [Fintype K] [DecidableEq K] in
theorem collinear_rotate {a b c : GridPoint K} :
    Collinear (K := K) a b c ↔ Collinear (K := K) b c a := by
  unfold Collinear
  constructor <;> intro h <;> linear_combination h

omit [Fintype K] [DecidableEq K] in
/-- Two secants through a shared vertex `a` meeting in an off-vertex point `p`
force their far endpoints to be collinear with `a`. -/
theorem collinear_of_collinear_pair {a b c p : GridPoint K} (hpa : p ≠ a)
    (h1 : Collinear (K := K) a b p) (h2 : Collinear (K := K) a c p) :
    Collinear (K := K) a b c := by
  have hcoord : p.1 ≠ a.1 ∨ p.2 ≠ a.2 := by
    rcases eq_or_ne p.1 a.1 with h1' | h1'
    · rcases eq_or_ne p.2 a.2 with h2' | h2'
      · exact absurd (Prod.ext h1' h2') hpa
      · exact Or.inr h2'
    · exact Or.inl h1'
  unfold Collinear at h1 h2 ⊢
  rcases hcoord with hc | hc
  · have hkey :
        ((b.1 - a.1) * (c.2 - a.2) - (b.2 - a.2) * (c.1 - a.1)) * (p.1 - a.1) = 0 := by
      linear_combination (c.1 - a.1) * h1 - (b.1 - a.1) * h2
    have hzero := (mul_eq_zero.mp hkey).resolve_right (sub_ne_zero.mpr hc)
    linear_combination hzero
  · have hkey :
        ((b.1 - a.1) * (c.2 - a.2) - (b.2 - a.2) * (c.1 - a.1)) * (p.2 - a.2) = 0 := by
      linear_combination (c.2 - a.2) * h1 - (b.2 - a.2) * h2
    have hzero := (mul_eq_zero.mp hkey).resolve_right (sub_ne_zero.mpr hc)
    linear_combination hzero

/-! ## Legal extensions = unblocked free-free cells -/

theorem legalGridExtensions_eq_filter_freeFree {S : Finset (GridPoint K)}
    (hS : GridCap (K := K) S) :
    Stable.LegalGridExtensions (K := K) S =
      (FreeFreeCells (K := K) S).filter
        fun p => ¬ PairLineBlockedBy (K := K) S p := by
  classical
  ext p
  rw [Stable.mem_legalGridExtensions, Finset.mem_filter, mem_freeFreeCells]
  constructor
  · rintro ⟨hpS, hcap⟩
    refine ⟨⟨?_, ?_⟩, ?_⟩
    · intro hrow
      rcases mem_usedRows.mp hrow with ⟨t, htS, ht1⟩
      have hpt : p = t :=
        hcap.1.1 (Finset.mem_insert_self p S) (Finset.mem_insert_of_mem htS) ht1.symm
      exact hpS (hpt ▸ htS)
    · intro hcol
      rcases mem_usedCols.mp hcol with ⟨t, htS, ht2⟩
      have hpt : p = t :=
        hcap.1.2 (Finset.mem_insert_self p S) (Finset.mem_insert_of_mem htS) ht2.symm
      exact hpS (hpt ▸ htS)
    · rintro ⟨x, y, hxS, hyS, hxy, hcolp⟩
      have hxp : x ≠ p := fun h => hpS (h ▸ hxS)
      have hyp : y ≠ p := fun h => hpS (h ▸ hyS)
      exact hcap.2 (Finset.mem_insert_of_mem hxS) (Finset.mem_insert_of_mem hyS)
        (Finset.mem_insert_self p S) hxy hxp hyp hcolp
  · rintro ⟨⟨hrow, hcol⟩, hnb⟩
    have hpS : p ∉ S := fun hp => hrow (mem_usedRows.mpr ⟨p, hp, rfl⟩)
    refine ⟨hpS, ⟨⟨?_, ?_⟩, ?_⟩⟩
    · intro x y hx hy hxy1
      rcases Finset.mem_insert.mp hx with rfl | hxS
      · rcases Finset.mem_insert.mp hy with rfl | hyS
        · rfl
        · exact absurd (mem_usedRows.mpr ⟨y, hyS, hxy1.symm⟩) hrow
      · rcases Finset.mem_insert.mp hy with rfl | hyS
        · exact absurd (mem_usedRows.mpr ⟨x, hxS, hxy1⟩) hrow
        · exact hS.1.1 hxS hyS hxy1
    · intro x y hx hy hxy2
      rcases Finset.mem_insert.mp hx with rfl | hxS
      · rcases Finset.mem_insert.mp hy with rfl | hyS
        · rfl
        · exact absurd (mem_usedCols.mpr ⟨y, hyS, hxy2.symm⟩) hcol
      · rcases Finset.mem_insert.mp hy with rfl | hyS
        · exact absurd (mem_usedCols.mpr ⟨x, hxS, hxy2⟩) hcol
        · exact hS.1.2 hxS hyS hxy2
    · intro x y z hx hy hz hxy hxz hyz hcol3
      rcases Finset.mem_insert.mp hx with rfl | hxS
      · have hyS : y ∈ S := (Finset.mem_insert.mp hy).resolve_left fun h => hxy h.symm
        have hzS : z ∈ S := (Finset.mem_insert.mp hz).resolve_left fun h => hxz h.symm
        exact hnb ⟨y, z, hyS, hzS, hyz, collinear_rotate.mp hcol3⟩
      · rcases Finset.mem_insert.mp hy with rfl | hyS
        · have hzS : z ∈ S := (Finset.mem_insert.mp hz).resolve_left fun h => hyz h.symm
          exact hnb ⟨x, z, hxS, hzS, hxz, collinear_swap_right.mp hcol3⟩
        · rcases Finset.mem_insert.mp hz with rfl | hzS
          · exact hnb ⟨x, y, hxS, hyS, hxy, hcol3⟩
          · exact hS.2 hxS hyS hzS hxy hxz hyz hcol3

/-! ## Free-free grid size -/

omit [Field K] in
theorem freeFreeCells_eq_product (S : Finset (GridPoint K)) :
    FreeFreeCells (K := K) S =
      (UsedRows (K := K) S)ᶜ ×ˢ (UsedCols (K := K) S)ᶜ := by
  ext p
  simp [mem_freeFreeCells, Finset.mem_product]

omit [Field K] in
theorem card_freeFreeCells (S : Finset (GridPoint K)) :
    (FreeFreeCells (K := K) S).card =
      (UsedRows (K := K) S)ᶜ.card * (UsedCols (K := K) S)ᶜ.card := by
  rw [freeFreeCells_eq_product, Finset.card_product]

omit [Field K] [Fintype K] in
theorem usedRows_triple (a b c : GridPoint K) :
    UsedRows (K := K) ({a, b, c} : Finset (GridPoint K)) = {a.1, b.1, c.1} := by
  simp [UsedRows, Finset.image_insert]

omit [Field K] [Fintype K] in
theorem usedCols_triple (a b c : GridPoint K) :
    UsedCols (K := K) ({a, b, c} : Finset (GridPoint K)) = {a.2, b.2, c.2} := by
  simp [UsedCols, Finset.image_insert]

/-! ## Row parametrization of a pair-line -/

/-- The second coordinate of the point of the line through `a` and `b` lying in
row `r`, defined for lines with `a.1 ≠ b.1`. -/
def lineRowPoint (a b : GridPoint K) (r : K) : K :=
  a.2 + (b.2 - a.2) / (b.1 - a.1) * (r - a.1)

omit [Fintype K] [DecidableEq K] in
theorem collinear_iff_lineRowPoint {a b : GridPoint K} (hr : a.1 ≠ b.1)
    {p : GridPoint K} :
    Collinear (K := K) a b p ↔ p.2 = lineRowPoint a b p.1 := by
  have hd : b.1 - a.1 ≠ 0 := sub_ne_zero.mpr (Ne.symm hr)
  unfold Collinear lineRowPoint
  rw [div_mul_eq_mul_div, ← sub_eq_iff_eq_add', eq_div_iff hd]
  constructor <;> intro h <;> linear_combination h

omit [Fintype K] [DecidableEq K] in
theorem lineRowPoint_fst (a b : GridPoint K) : lineRowPoint a b a.1 = a.2 := by
  simp [lineRowPoint]

omit [Fintype K] [DecidableEq K] in
theorem lineRowPoint_snd {a b : GridPoint K} (hr : a.1 ≠ b.1) :
    lineRowPoint a b b.1 = b.2 := by
  have hd : b.1 - a.1 ≠ 0 := sub_ne_zero.mpr (Ne.symm hr)
  unfold lineRowPoint
  field_simp
  ring

omit [Fintype K] [DecidableEq K] in
theorem lineRowPoint_injective {a b : GridPoint K} (hr : a.1 ≠ b.1)
    (hc : a.2 ≠ b.2) : Function.Injective (lineRowPoint a b) := by
  intro r r' hrr
  have hd : b.1 - a.1 ≠ 0 := sub_ne_zero.mpr (Ne.symm hr)
  have hs : b.2 - a.2 ≠ 0 := sub_ne_zero.mpr (Ne.symm hc)
  unfold lineRowPoint at hrr
  have h1 := add_left_cancel hrr
  have h2 := mul_left_cancel₀ (div_ne_zero hs hd) h1
  exact sub_left_inj.mp h2

/-! ## Each pair-line meets the free-free grid in exactly `q - 4` cells -/

theorem card_pairLine_inter_freeFree {a b c : GridPoint K}
    (hr_ab : a.1 ≠ b.1) (hr_ac : a.1 ≠ c.1) (hr_bc : b.1 ≠ c.1)
    (hc_ab : a.2 ≠ b.2) (hc_ac : a.2 ≠ c.2) (hc_bc : b.2 ≠ c.2)
    (hnc : ¬ Collinear (K := K) a b c) :
    (PairLine (K := K) a b ∩
        FreeFreeCells (K := K) ({a, b, c} : Finset (GridPoint K))).card + 4 =
      Fintype.card K := by
  classical
  have hd : b.1 - a.1 ≠ 0 := sub_ne_zero.mpr (Ne.symm hr_ab)
  have hs : b.2 - a.2 ≠ 0 := sub_ne_zero.mpr (Ne.symm hc_ab)
  have hinj := lineRowPoint_injective (K := K) hr_ab hc_ab
  set d : K := a.1 + (c.2 - a.2) * (b.1 - a.1) / (b.2 - a.2) with hdDef
  have hld : lineRowPoint a b d = c.2 := by
    rw [hdDef]
    unfold lineRowPoint
    field_simp
    ring
  have hda : d ≠ a.1 := by
    intro h
    exact hc_ac ((lineRowPoint_fst a b).symm.trans (h ▸ hld))
  have hdb : d ≠ b.1 := by
    intro h
    exact hc_bc ((lineRowPoint_snd hr_ab).symm.trans (h ▸ hld))
  have hdc : d ≠ c.1 := by
    intro h
    exact hnc ((collinear_iff_lineRowPoint hr_ab).mpr (h ▸ hld).symm)
  have himg :
      PairLine (K := K) a b ∩
          FreeFreeCells (K := K) ({a, b, c} : Finset (GridPoint K)) =
        (({a.1, b.1, c.1, d} : Finset K)ᶜ).image
          fun r => ((r, lineRowPoint a b r) : GridPoint K) := by
    ext p
    simp only [Finset.mem_inter, mem_pairLine, mem_freeFreeCells, usedRows_triple,
      usedCols_triple, Finset.mem_image, Finset.mem_compl, Finset.mem_insert,
      Finset.mem_singleton, not_or]
    constructor
    · rintro ⟨hcolp, ⟨hpa1, hpb1, hpc1⟩, ⟨hpa2, hpb2, hpc2⟩⟩
      have hp2 : p.2 = lineRowPoint a b p.1 :=
        (collinear_iff_lineRowPoint hr_ab).mp hcolp
      refine ⟨p.1, ⟨hpa1, hpb1, hpc1, ?_⟩, ?_⟩
      · intro h
        exact hpc2 (hp2.trans (h ▸ hld))
      · exact Prod.ext rfl hp2.symm
    · rintro ⟨r, ⟨hra, hrb, hrc, hrd⟩, rfl⟩
      refine ⟨(collinear_iff_lineRowPoint hr_ab).mpr rfl, ⟨hra, hrb, hrc⟩,
        ⟨?_, ?_, ?_⟩⟩
      · intro h
        exact hra (hinj (h.trans (lineRowPoint_fst a b).symm))
      · intro h
        exact hrb (hinj (h.trans (lineRowPoint_snd hr_ab).symm))
      · intro h
        exact hrd (hinj (h.trans hld.symm))
  have hT4 : ({a.1, b.1, c.1, d} : Finset K).card = 4 := by
    rw [Finset.card_insert_of_notMem (by simp [hr_ab, hr_ac, Ne.symm hda]),
      Finset.card_insert_of_notMem (by simp [hr_bc, Ne.symm hdb]),
      Finset.card_insert_of_notMem (by simp [Ne.symm hdc]),
      Finset.card_singleton]
  have hcompl := Finset.card_add_card_compl ({a.1, b.1, c.1, d} : Finset K)
  rw [himg, Finset.card_image_of_injective _
    (fun r r' h => congrArg Prod.fst h)]
  omega

/-! ## The blocked cells split into three disjoint line traces -/

theorem filter_blocked_triple {a b c : GridPoint K}
    (hab : a ≠ b) (hac : a ≠ c) (hbc : b ≠ c) :
    ((FreeFreeCells (K := K) ({a, b, c} : Finset (GridPoint K))).filter
        fun p => PairLineBlockedBy (K := K) ({a, b, c} : Finset (GridPoint K)) p) =
      (PairLine (K := K) a b ∩ FreeFreeCells (K := K) ({a, b, c})) ∪
        (PairLine (K := K) a c ∩ FreeFreeCells (K := K) ({a, b, c})) ∪
        (PairLine (K := K) b c ∩ FreeFreeCells (K := K) ({a, b, c})) := by
  classical
  ext p
  simp only [Finset.mem_filter, Finset.mem_union, Finset.mem_inter, mem_pairLine]
  constructor
  · rintro ⟨hFF, x, y, hx, hy, hxy, hcolp⟩
    simp only [Finset.mem_insert, Finset.mem_singleton] at hx hy
    rcases hx with rfl | rfl | rfl <;> rcases hy with rfl | rfl | rfl
    · exact absurd rfl hxy
    · exact Or.inl (Or.inl ⟨hcolp, hFF⟩)
    · exact Or.inl (Or.inr ⟨hcolp, hFF⟩)
    · exact Or.inl (Or.inl ⟨collinear_swap_left.mp hcolp, hFF⟩)
    · exact absurd rfl hxy
    · exact Or.inr ⟨hcolp, hFF⟩
    · exact Or.inl (Or.inr ⟨collinear_swap_left.mp hcolp, hFF⟩)
    · exact Or.inr ⟨collinear_swap_left.mp hcolp, hFF⟩
    · exact absurd rfl hxy
  · rintro ((⟨h, hFF⟩ | ⟨h, hFF⟩) | ⟨h, hFF⟩)
    · exact ⟨hFF, a, b, by simp, by simp, hab, h⟩
    · exact ⟨hFF, a, c, by simp, by simp, hac, h⟩
    · exact ⟨hFF, b, c, by simp, by simp, hbc, h⟩

omit [Field K] [Fintype K] in
theorem ne_of_fst_notMem_usedRows {S : Finset (GridPoint K)} {p t : GridPoint K}
    (hrow : p.1 ∉ UsedRows (K := K) S) (ht : t ∈ S) : p ≠ t := by
  intro h
  exact hrow (mem_usedRows.mpr ⟨t, ht, (congrArg Prod.fst h).symm⟩)

/-! ## The main count -/

theorem card_legalGridExtensions_of_card_three {S : Finset (GridPoint K)}
    (hcard : S.card = 3) (hS : GridCap (K := K) S) :
    ((Stable.LegalGridExtensions (K := K) S).card : Int) =
      (Fintype.card K : Int) ^ 2 - 9 * (Fintype.card K : Int) + 21 := by
  classical
  obtain ⟨a, b, c, hab, hac, hbc, rfl⟩ := Finset.card_eq_three.mp hcard
  have hmema : a ∈ ({a, b, c} : Finset (GridPoint K)) := by simp
  have hmemb : b ∈ ({a, b, c} : Finset (GridPoint K)) := by simp
  have hmemc : c ∈ ({a, b, c} : Finset (GridPoint K)) := by simp
  have hnc : ¬ Collinear (K := K) a b c := hS.2 hmema hmemb hmemc hab hac hbc
  have hr_ab : a.1 ≠ b.1 := fun h => hab (hS.1.1 hmema hmemb h)
  have hr_ac : a.1 ≠ c.1 := fun h => hac (hS.1.1 hmema hmemc h)
  have hr_bc : b.1 ≠ c.1 := fun h => hbc (hS.1.1 hmemb hmemc h)
  have hc_ab : a.2 ≠ b.2 := fun h => hab (hS.1.2 hmema hmemb h)
  have hc_ac : a.2 ≠ c.2 := fun h => hac (hS.1.2 hmema hmemc h)
  have hc_bc : b.2 ≠ c.2 := fun h => hbc (hS.1.2 hmemb hmemc h)
  -- the three line traces inside the free-free grid, each of size q - 4
  have e1 := card_pairLine_inter_freeFree (K := K)
    hr_ab hr_ac hr_bc hc_ab hc_ac hc_bc hnc
  have hset_acb : ({a, c, b} : Finset (GridPoint K)) = {a, b, c} := by
    ext x; simp only [Finset.mem_insert, Finset.mem_singleton]; tauto
  have e2 := card_pairLine_inter_freeFree (K := K)
    hr_ac hr_ab (Ne.symm hr_bc) hc_ac hc_ab (Ne.symm hc_bc)
    (fun h => hnc (collinear_swap_right.mpr h))
  rw [hset_acb] at e2
  have hset_bca : ({b, c, a} : Finset (GridPoint K)) = {a, b, c} := by
    ext x; simp only [Finset.mem_insert, Finset.mem_singleton]; tauto
  have e3 := card_pairLine_inter_freeFree (K := K)
    hr_bc (Ne.symm hr_ab) (Ne.symm hr_ac) hc_bc (Ne.symm hc_ab) (Ne.symm hc_ac)
    (fun h => hnc (collinear_rotate.mpr h))
  rw [hset_bca] at e3
  -- pairwise disjointness of the three traces inside the free-free grid
  have hne_a : ∀ {p : GridPoint K},
      p ∈ FreeFreeCells (K := K) ({a, b, c} : Finset (GridPoint K)) -> p ≠ a :=
    fun hp => ne_of_fst_notMem_usedRows (mem_freeFreeCells.mp hp).1 hmema
  have hne_b : ∀ {p : GridPoint K},
      p ∈ FreeFreeCells (K := K) ({a, b, c} : Finset (GridPoint K)) -> p ≠ b :=
    fun hp => ne_of_fst_notMem_usedRows (mem_freeFreeCells.mp hp).1 hmemb
  have hne_c : ∀ {p : GridPoint K},
      p ∈ FreeFreeCells (K := K) ({a, b, c} : Finset (GridPoint K)) -> p ≠ c :=
    fun hp => ne_of_fst_notMem_usedRows (mem_freeFreeCells.mp hp).1 hmemc
  have hd12 : Disjoint
      (PairLine (K := K) a b ∩ FreeFreeCells (K := K) ({a, b, c}))
      (PairLine (K := K) a c ∩ FreeFreeCells (K := K) ({a, b, c})) := by
    rw [Finset.disjoint_left]
    rintro p hp1 hp2
    rw [Finset.mem_inter, mem_pairLine] at hp1 hp2
    exact hnc (collinear_of_collinear_pair (hne_a hp1.2) hp1.1 hp2.1)
  have hd13 : Disjoint
      (PairLine (K := K) a b ∩ FreeFreeCells (K := K) ({a, b, c}))
      (PairLine (K := K) b c ∩ FreeFreeCells (K := K) ({a, b, c})) := by
    rw [Finset.disjoint_left]
    rintro p hp1 hp2
    rw [Finset.mem_inter, mem_pairLine] at hp1 hp2
    have h1 : Collinear (K := K) b a p := collinear_swap_left.mp hp1.1
    exact hnc (collinear_swap_left.mp
      (collinear_of_collinear_pair (hne_b hp1.2) h1 hp2.1))
  have hd23 : Disjoint
      (PairLine (K := K) a c ∩ FreeFreeCells (K := K) ({a, b, c}))
      (PairLine (K := K) b c ∩ FreeFreeCells (K := K) ({a, b, c})) := by
    rw [Finset.disjoint_left]
    rintro p hp1 hp2
    rw [Finset.mem_inter, mem_pairLine] at hp1 hp2
    have h1 : Collinear (K := K) c a p :=
      collinear_swap_right.mp (collinear_rotate.mp hp1.1)
    have h2 : Collinear (K := K) c b p :=
      collinear_swap_right.mp (collinear_rotate.mp hp2.1)
    exact hnc (collinear_rotate.mp (collinear_of_collinear_pair (hne_c hp1.2) h1 h2))
  -- assemble the blocked-cell count
  have hbl :
      ((FreeFreeCells (K := K) ({a, b, c} : Finset (GridPoint K))).filter
          fun p => PairLineBlockedBy (K := K) ({a, b, c} : Finset (GridPoint K)) p).card =
        (PairLine (K := K) a b ∩ FreeFreeCells (K := K) ({a, b, c})).card +
          (PairLine (K := K) a c ∩ FreeFreeCells (K := K) ({a, b, c})).card +
          (PairLine (K := K) b c ∩ FreeFreeCells (K := K) ({a, b, c})).card := by
    rw [filter_blocked_triple hab hac hbc,
      Finset.card_union_of_disjoint (Finset.disjoint_union_left.mpr ⟨hd13, hd23⟩),
      Finset.card_union_of_disjoint hd12]
  -- split the free-free grid into blocked and legal cells
  have hsplit :
      ((FreeFreeCells (K := K) ({a, b, c} : Finset (GridPoint K))).filter
            fun p => PairLineBlockedBy (K := K) ({a, b, c} : Finset (GridPoint K)) p).card +
          (Stable.LegalGridExtensions (K := K) ({a, b, c} : Finset (GridPoint K))).card =
        (FreeFreeCells (K := K) ({a, b, c} : Finset (GridPoint K))).card := by
    rw [legalGridExtensions_eq_filter_freeFree hS]
    exact Finset.card_filter_add_card_filter_not
      (s := FreeFreeCells (K := K) ({a, b, c} : Finset (GridPoint K)))
      (p := fun p => PairLineBlockedBy (K := K) ({a, b, c} : Finset (GridPoint K)) p)
  -- row/column complements
  have hcard' : ({a, b, c} : Finset (GridPoint K)).card = 3 :=
    Finset.card_eq_three.mpr ⟨a, b, c, hab, hac, hbc, rfl⟩
  have hrows := Finset.card_add_card_compl (UsedRows (K := K) ({a, b, c}))
  have hcols := Finset.card_add_card_compl (UsedCols (K := K) ({a, b, c}))
  rw [card_usedRows_of_card_three hcard' hS] at hrows
  rw [card_usedCols_of_card_three hcard' hS] at hcols
  have hFF := card_freeFreeCells (K := K) ({a, b, c} : Finset (GridPoint K))
  -- move everything to the integers and finish by ring arithmetic
  have z1 : ((PairLine (K := K) a b ∩
      FreeFreeCells (K := K) ({a, b, c})).card : Int) = (Fintype.card K : Int) - 4 := by
    omega
  have z2 : ((PairLine (K := K) a c ∩
      FreeFreeCells (K := K) ({a, b, c})).card : Int) = (Fintype.card K : Int) - 4 := by
    omega
  have z3 : ((PairLine (K := K) b c ∩
      FreeFreeCells (K := K) ({a, b, c})).card : Int) = (Fintype.card K : Int) - 4 := by
    omega
  have zr : (((UsedRows (K := K) ({a, b, c}))ᶜ.card : Int)) = (Fintype.card K : Int) - 3 := by
    omega
  have zc : (((UsedCols (K := K) ({a, b, c}))ᶜ.card : Int)) = (Fintype.card K : Int) - 3 := by
    omega
  have zFF : ((FreeFreeCells (K := K) ({a, b, c} : Finset (GridPoint K))).card : Int) =
      ((Fintype.card K : Int) - 3) * ((Fintype.card K : Int) - 3) := by
    have h : ((FreeFreeCells (K := K) ({a, b, c} : Finset (GridPoint K))).card : Int) =
        ((UsedRows (K := K) ({a, b, c}))ᶜ.card : Int) *
          ((UsedCols (K := K) ({a, b, c}))ᶜ.card : Int) := by
      exact_mod_cast hFF
    rw [h, zr, zc]
  have zbl : (((FreeFreeCells (K := K) ({a, b, c} : Finset (GridPoint K))).filter
      fun p => PairLineBlockedBy (K := K) ({a, b, c} : Finset (GridPoint K)) p).card : Int) =
      3 * ((Fintype.card K : Int) - 4) := by
    rw [hbl]
    push_cast
    rw [z1, z2, z3]; ring
  have zsplit : (((FreeFreeCells (K := K) ({a, b, c} : Finset (GridPoint K))).filter
        fun p => PairLineBlockedBy (K := K) ({a, b, c} : Finset (GridPoint K)) p).card : Int) +
      ((Stable.LegalGridExtensions (K := K) ({a, b, c} : Finset (GridPoint K))).card : Int) =
      ((FreeFreeCells (K := K) ({a, b, c} : Finset (GridPoint K))).card : Int) := by
    exact_mod_cast hsplit
  rw [zbl, zFF] at zsplit
  linear_combination zsplit

/-- The stable size-three extension-count target is a theorem. -/
theorem sizeThreeExtensionCount : Stable.SizeThreeExtensionCountStatement K :=
  fun _S hcard hS => card_legalGridExtensions_of_card_three hcard hS

end ProjectiveCap
