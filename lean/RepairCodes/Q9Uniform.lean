import RepairCodes.Q9Affine
import RepairCodes.AxisTwistedCubicInvariants
import Mathlib.NumberTheory.LegendreSymbol.QuadraticChar.Basic

/-!
# Sharp uniform repair invariants over the field of order nine

The only extra certificate beyond the generic characteristic-three formulas is a rainbow
perfect matching at a cubic coordinate.  It is encoded over the eight nonzero coordinate pairs
of `ZMod 3 × ZMod 3`; all field identities are proved in the kernel.
-/

namespace RepairCodes

open Finset Matrix FiniteGeom

variable {F : Type*} [Field F] [Fintype F] [DecidableEq F] [CharP F 3]

local instance : Algebra (ZMod 3) F := ZMod.algebra _ _

private def q9CoordToField (i : F) (p : ZMod 3 × ZMod 3) : F :=
  algebraMap _ _ p.1 + algebraMap _ _ p.2 * i

omit [Fintype F] [DecidableEq F] in
theorem q9CoordToField_injective (i : F) (hi : i ^ 2 = -1) :
    Function.Injective (q9CoordToField i) := by
  let f : ZMod 3 →+* F := algebraMap _ _
  have hf : Function.Injective f := RingHom.injective f
  have hno : ∀ a : ZMod 3, f a ≠ i := by
    intro a hai
    have hs : f (a ^ 2) = f (-1) := by rw [map_pow, hai, hi, map_neg, map_one]
    have ha : a ^ 2 = -1 := hf hs
    exact (show ∀ z : ZMod 3, z ^ 2 ≠ -1 by decide) a ha
  intro p q hpq
  by_cases hb : p.2 = q.2
  · apply Prod.ext
    · apply hf
      change f p.1 + f p.2 * i = f q.1 + f q.2 * i at hpq
      rw [hb] at hpq
      linear_combination hpq
    · exact hb
  · have hd : p.2 - q.2 ≠ 0 := sub_ne_zero.mpr hb
    have hfd : f (p.2 - q.2) ≠ 0 := fun hz => hd (hf (by simpa using hz))
    have hrel : f (p.2 - q.2) * i = f (q.1 - p.1) := by
      change f p.1 + f p.2 * i = f q.1 + f q.2 * i at hpq
      simp only [map_sub]
      linear_combination hpq
    have hiimage : i = f ((q.1 - p.1) / (p.2 - q.2)) := by
      simp only [div_eq_mul_inv, map_mul, map_inv₀]
      apply (eq_mul_inv_iff_mul_eq₀ hfd).mpr
      rw [mul_comm]
      exact hrel
    exact (hno _ hiimage.symm).elim

private def q9OffsetCoord : Fin 8 → ZMod 3 × ZMod 3 :=
  ![(0, 1), (0, -1), (1, 0), (1, 1), (1, -1), (-1, 0), (-1, 1), (-1, -1)]

private theorem q9OffsetCoord_injective : Function.Injective q9OffsetCoord := by decide

private theorem q9OffsetCoord_ne_zero (k : Fin 8) : q9OffsetCoord k ≠ (0, 0) := by
  fin_cases k <;> decide

private def q9Offset (x i : F) (k : Fin 8) : F :=
  x + q9CoordToField i (q9OffsetCoord k)

omit [Fintype F] [DecidableEq F] in
theorem q9Offset_injective (x i : F) (hi : i ^ 2 = -1) :
    Function.Injective (q9Offset x i) := by
  intro a b h
  apply q9OffsetCoord_injective
  apply q9CoordToField_injective i hi
  unfold q9Offset at h
  linear_combination h

omit [Fintype F] [DecidableEq F] in
theorem q9Offset_ne_target (x i : F) (hi : i ^ 2 = -1) (k : Fin 8) :
    x ≠ q9Offset x i k := by
  intro h
  unfold q9Offset at h
  have hz : q9CoordToField i (q9OffsetCoord k) = 0 := by
    apply add_left_cancel (a := x)
    simpa using h.symm
  have hcoord : q9OffsetCoord k = (0, 0) := by
    apply q9CoordToField_injective i hi
    simpa [q9CoordToField] using hz
  exact q9OffsetCoord_ne_zero k hcoord

private def q9CompletionColor (x i : F) : Fin 4 → F ⊕ Unit :=
  ![Sum.inr Unit.unit, Sum.inl (-x - i), Sum.inl (-x - 1 - i), Sum.inl (-x - 1)]

omit [Fintype F] [DecidableEq F] in
theorem q9CompletionColor_injective (x i : F) (hi : i ^ 2 = -1) :
    Function.Injective (q9CompletionColor x i) := by
  have hi0 : i ≠ 0 := by intro h; simp [h] at hi
  have hi1 : i ≠ 1 := by
    intro h
    rw [h] at hi
    have hthree : (3 : F) = 0 := CharP.cast_eq_zero F 3
    have htwo : (2 : F) = 0 := by linear_combination hi
    have hone : (1 : F) = 0 := by linear_combination hthree - htwo
    exact one_ne_zero hone
  have honeShift : (-x : F) ≠ -x - 1 := by
    intro h
    apply (one_ne_zero : (1 : F) ≠ 0)
    linear_combination h
  have hiShift : (-x - 1 : F) ≠ -x - 1 - i := by
    intro h
    apply hi0
    linear_combination h
  intro a b h
  fin_cases a <;> fin_cases b <;> simp_all [q9CompletionColor]

private def q9BaseMatching : Finset (Finset (Fin 8 ⊕ Fin 4)) :=
  {{Sum.inl 0, Sum.inl 1, Sum.inr 0},
   {Sum.inl 2, Sum.inl 3, Sum.inr 1},
   {Sum.inl 4, Sum.inl 5, Sum.inr 2},
   {Sum.inl 6, Sum.inl 7, Sum.inr 3}}

private instance q9BaseMatchingDecidable (H M : Finset (Finset (Fin 8 ⊕ Fin 4))) :
    Decidable (IsMatching H M) := by
  unfold IsMatching
  infer_instance

set_option maxRecDepth 100000 in
private theorem q9BaseMatching_self : IsMatching q9BaseMatching q9BaseMatching := by decide

private theorem q9BaseMatching_card : q9BaseMatching.card = 4 := by decide

private def q9PairLeft : Fin 4 → Fin 8 := ![0, 2, 4, 6]
private def q9PairRight : Fin 4 → Fin 8 := ![1, 3, 5, 7]

omit [Fintype F] in
theorem q9Completion_eq (x i : F) (hi : i ^ 2 = -1) (j : Fin 4) :
    twistedCubicTripleAxisIndex
        ![x, q9Offset x i (q9PairLeft j), q9Offset x i (q9PairRight j)] =
      q9CompletionColor x i j := by
  have hi0 : i ≠ 0 := by intro h; simp [h] at hi
  have hi1 : i ≠ 1 := by
    intro h
    rw [h] at hi
    have hthree : (3 : F) = 0 := CharP.cast_eq_zero F 3
    have htwo : (2 : F) = 0 := by linear_combination hi
    have hone : (1 : F) = 0 := by linear_combination hthree - htwo
    exact one_ne_zero hone
  have htwo : (2 : F) = -1 := by
    linear_combination CharP.cast_eq_zero F 3
  fin_cases j
  · change twistedCubicTripleAxisIndex ![x, q9Offset x i 0, q9Offset x i 1] =
      q9CompletionColor x i 0
    rw [show q9Offset x i 0 = x + i by simp [q9Offset, q9OffsetCoord, q9CoordToField],
      show q9Offset x i 1 = x + (-i) by simp [q9Offset, q9OffsetCoord, q9CoordToField],
      twistedCubicTripleAxisIndex_translate]
    simp [q9CompletionColor, sub_eq_add_neg]
  · change twistedCubicTripleAxisIndex ![x, q9Offset x i 2, q9Offset x i 3] =
      q9CompletionColor x i 1
    rw [show q9Offset x i 2 = x + 1 by simp [q9Offset, q9OffsetCoord, q9CoordToField],
      show q9Offset x i 3 = x + (1 + i) by simp [q9Offset, q9OffsetCoord, q9CoordToField],
      twistedCubicTripleAxisIndex_translate]
    have hsum : (1 : F) + (1 + i) = -1 + i := by rw [← htwo]; ring
    have hden : (-1 : F) + i ≠ 0 := by
      intro h
      exact hi1 (by linear_combination h)
    have hratio : (1 : F) * (1 + i) / (-1 + i) = -i := by
      apply (div_eq_iff hden).mpr
      calc
        (1 : F) * (1 + i) = 1 + i := by ring
        _ = (-i) * (-1 + i) := by rw [show (-i) * (-1 + i) = i - i ^ 2 by ring, hi]; ring
    rw [hsum, if_neg hden, hratio]
    simp [q9CompletionColor, sub_eq_add_neg]
    ring
  · change twistedCubicTripleAxisIndex ![x, q9Offset x i 4, q9Offset x i 5] =
      q9CompletionColor x i 2
    rw [show q9Offset x i 4 = x + (1 - i) by
          simp [q9Offset, q9OffsetCoord, q9CoordToField, sub_eq_add_neg],
      show q9Offset x i 5 = x + (-1) by simp [q9Offset, q9OffsetCoord, q9CoordToField],
      twistedCubicTripleAxisIndex_translate]
    have hsum : (1 : F) - i + -1 = -i := by ring
    have hden : (-i : F) ≠ 0 := neg_ne_zero.mpr hi0
    have hratio : (1 - i) * (-1 : F) / (-i) = -1 - i := by
      apply (div_eq_iff hden).mpr
      calc
        (1 - i) * (-1 : F) = -1 + i := by ring
        _ = (-1 - i) * (-i) := by
          rw [show (-1 - i) * (-i) = i + i ^ 2 by ring, hi]
          ring
    rw [hsum, if_neg hden, hratio]
    simp [q9CompletionColor, sub_eq_add_neg]
    ring
  · change twistedCubicTripleAxisIndex ![x, q9Offset x i 6, q9Offset x i 7] =
      q9CompletionColor x i 3
    rw [show q9Offset x i 6 = x + (-1 + i) by simp [q9Offset, q9OffsetCoord, q9CoordToField],
      show q9Offset x i 7 = x + (-1 + -i) by simp [q9Offset, q9OffsetCoord, q9CoordToField],
      twistedCubicTripleAxisIndex_translate]
    have hsum : (-1 : F) + i + (-1 + -i) = 1 := by
      calc
        (-1 : F) + i + (-1 + -i) = -2 := by ring
        _ = 1 := by simpa using congrArg (fun z : F => -z) htwo
    have hden : (1 : F) ≠ 0 := one_ne_zero
    have hratio : (-1 + i) * (-1 + -i) / (1 : F) = -1 := by
      apply (div_eq_iff hden).mpr
      rw [show (-1 + i) * (-1 + -i) = 1 - i ^ 2 by ring, hi]
      linear_combination htwo
    rw [hsum, if_neg hden, hratio]
    simp [q9CompletionColor, sub_eq_add_neg]
    ring

private def q9MatchingEmbedding (x i : F) (hi : i ^ 2 = -1) :
    (Fin 8 ⊕ Fin 4) ↪ AxisTwistedCubicIndex F where
  toFun z := match z with
    | .inl k => .inl (q9Offset x i k)
    | .inr j => .inr (q9CompletionColor x i j)
  inj' := by
    intro a b h
    cases a with
    | inl a =>
      cases b with
      | inl b => exact congrArg Sum.inl (q9Offset_injective x i hi (Sum.inl.inj h))
      | inr b => simp at h
    | inr a =>
      cases b with
      | inl b => simp at h
      | inr b => exact congrArg Sum.inr (q9CompletionColor_injective x i hi (Sum.inr.inj h))

private theorem q9MatchingEdge_mem (x i : F) (hi : i ^ 2 = -1) (j : Fin 4) :
    {(.inl (q9Offset x i (q9PairLeft j)) : AxisTwistedCubicIndex F),
        .inl (q9Offset x i (q9PairRight j)), .inr (q9CompletionColor x i j)} ∈
      axisTwistedCubicRepairHypergraph (.inl x) 3 := by
  apply mem_cubicRepairHypergraph_iff.mpr
  refine ⟨q9Offset x i (q9PairLeft j), q9Offset x i (q9PairRight j),
    q9Offset_ne_target x i hi _, q9Offset_ne_target x i hi _, ?_, ?_⟩
  · intro h
    have hj := q9Offset_injective x i hi h
    fin_cases j <;> simp [q9PairLeft, q9PairRight] at hj
  · rw [q9Completion_eq x i hi j]

/-- Four disjoint repairs at every cubic coordinate over a field containing a square root of
`-1`.  For order nine this is the sharp certificate. -/
theorem cubicRepair_matching_four_of_sqrt_neg_one (x i : F) (hi : i ^ 2 = -1) :
    ∃ M, IsMatching (axisTwistedCubicRepairHypergraph (.inl x) 3) M ∧ M.card = 4 := by
  let e := q9MatchingEmbedding x i hi
  let M := embedHypergraph e q9BaseMatching
  have hself : IsMatching M M := by
    exact q9BaseMatching_self.embedHypergraph e
  have hsub : M ⊆ axisTwistedCubicRepairHypergraph (.inl x) 3 := by
    intro E hE
    obtain ⟨E₀, hE₀, rfl⟩ := Finset.mem_image.mp hE
    simp only [q9BaseMatching, Finset.mem_insert, Finset.mem_singleton] at hE₀
    rcases hE₀ with rfl | rfl | rfl | rfl
    · simpa [e, q9MatchingEmbedding, q9PairLeft, q9PairRight] using
        q9MatchingEdge_mem x i hi 0
    · simpa [e, q9MatchingEmbedding, q9PairLeft, q9PairRight] using
        q9MatchingEdge_mem x i hi 1
    · simpa [e, q9MatchingEmbedding, q9PairLeft, q9PairRight] using
        q9MatchingEdge_mem x i hi 2
    · simpa [e, q9MatchingEmbedding, q9PairLeft, q9PairRight] using
        q9MatchingEdge_mem x i hi 3
  refine ⟨M, ⟨hsub, hself.2⟩, ?_⟩
  rw [show M = embedHypergraph e q9BaseMatching by rfl, card_embedHypergraph,
    q9BaseMatching_card]

/-- Cubic-coordinate matching number is exactly four over every field of order nine. -/
theorem cubicRepair_matchingNumber_q9 (hcard : Fintype.card F = 9) (x : F) :
    matchingNumber (axisTwistedCubicRepairHypergraph (.inl x) 3) = 4 := by
  have hsquare : IsSquare (-1 : F) := by
    apply FiniteField.isSquare_neg_one_iff.mpr
    omega
  obtain ⟨i, hi⟩ := (isSquare_iff_exists_sq (-1 : F)).mp hsquare
  have hM := cubicRepair_matching_four_of_sqrt_neg_one x i hi.symm
  apply le_antisymm
  · have hle := cubicRepair_matchingNumber_le x
    rw [hcard] at hle
    norm_num at hle
    exact hle
  · obtain ⟨M, hM, hMcard⟩ := hM
    rw [← hMcard]
    exact card_le_matchingNumber hM

/-- The cap number of the additive group of a field of order nine is four. -/
theorem zeroSumCapNumber_q9 (hcard : Fintype.card F = 9) : zeroSumCapNumber F = 4 := by
  letI : Fintype GF9 := Fintype.ofFinite GF9
  letI : DecidableEq GF9 := Classical.decEq GF9
  have hgf9 : Fintype.card GF9 = 9 := by
    rw [Fintype.card_eq_nat_card, GaloisField.card 3 2 (by decide)]
    norm_num
  let e : F ≃+ GF9 :=
    (FiniteField.algEquivOfCardEq 3 (hcard.trans hgf9.symm)).toAddEquiv
  have hmap := relabel_zeroSumTripleHypergraph e
  have htau := transversalNumber_relabelHypergraph e.toEquiv (zeroSumTripleHypergraph F)
  rw [hmap] at htau
  have htauF : transversalNumber (zeroSumTripleHypergraph F) = 5 :=
    htau.symm.trans gf9_zeroSum_invariants.2
  have hformula := transversalNumber_zeroSumTripleHypergraph (A := F)
  rw [htauF, hcard] at hformula
  omega

/-- A field of order nine has twelve affine-line triples, eight avoiding zero. -/
theorem zeroSum_edge_counts_q9 (hcard : Fintype.card F = 9) :
    (zeroSumTripleHypergraph F).card = 12 ∧
      (zeroSumTripleHypergraphAvoidingZero F).card = 8 := by
  letI : Fintype GF9 := Fintype.ofFinite GF9
  letI : DecidableEq GF9 := Classical.decEq GF9
  have hgf9 : Fintype.card GF9 = 9 := by
    rw [Fintype.card_eq_nat_card, GaloisField.card 3 2 (by decide)]
    norm_num
  let e : F ≃+ GF9 :=
    (FiniteField.algEquivOfCardEq 3 (hcard.trans hgf9.symm)).toAddEquiv
  have hall := congrArg Finset.card (relabel_zeroSumTripleHypergraph e)
  have havoid := congrArg Finset.card (relabel_zeroSumTripleHypergraphAvoidingZero e)
  rw [card_relabelHypergraph] at hall havoid
  exact ⟨hall.trans gf9_zeroSum_edge_counts.1,
    havoid.trans gf9_zeroSum_edge_counts.2⟩

/-- Exact edge counts in the two disjoint components of every q=9 axis repair clutter. -/
theorem axisRepair_component_edge_counts_q9 (hcard : Fintype.card F = 9)
    (y : F ⊕ Unit) :
    (axisPairRepairComponent y).card = 36 ∧
      (axisCubicRepairComponent y).card =
        match y with
        | .inl _ => 8
        | .inr _ => 12 := by
  have hlines := zeroSum_edge_counts_q9 (F := F) hcard
  constructor
  · rw [axisPairRepairComponent_eq_completePair, card_embedHypergraph,
      completePairHypergraph, card_powersetCard]
    simp [hcard]
    decide
  · cases y with
    | inl a =>
        rw [axisCubicRepairComponent_finite_eq_avoidingZero, card_embedHypergraph]
        exact hlines.2
    | inr u =>
        cases u
        rw [axisCubicRepairComponent_infinity_eq_zeroSum, card_embedHypergraph]
        exact hlines.1

/-- Every cubic coordinate of the q=9 code has exactly twenty-eight radius-three repairs. -/
theorem cubicRepair_edge_count_q9 (hcard : Fintype.card F = 9) (x : F) :
    (axisTwistedCubicRepairHypergraph (.inl x) 3).card = 28 := by
  rw [cubicRepairHypergraph_card, hcard]
  decide

/-- Exact q=9 uniform row table for the `[19,4,8]₉` axis–twisted-cubic code. -/
theorem axisTwistedCubic_q9_row_invariants (hcard : Fintype.card F = 9)
    (z : AxisTwistedCubicIndex F) :
    (match z with
      | .inl x =>
          matchingNumber (axisTwistedCubicRepairHypergraph (.inl x) 3) = 4 ∧
            transversalNumber (axisTwistedCubicRepairHypergraph (.inl x) 3) = 7
      | .inr (Sum.inr _) =>
          matchingNumber (axisTwistedCubicRepairHypergraph z 3) = 7 ∧
            transversalNumber (axisTwistedCubicRepairHypergraph z 3) = 13
      | .inr (Sum.inl _) =>
          matchingNumber (axisTwistedCubicRepairHypergraph z 3) = 6 ∧
            transversalNumber (axisTwistedCubicRepairHypergraph z 3) = 12) := by
  have hcap := zeroSumCapNumber_q9 (F := F) hcard
  cases z with
  | inl x =>
      exact ⟨cubicRepair_matchingNumber_q9 hcard x, by
        rw [cubicRepair_transversalNumber, hcard]⟩
  | inr y =>
      cases y with
      | inl a =>
          rw [← matchingNumber_minimalAxisTwistedCubicRepairHypergraph,
            ← transversalNumber_minimalAxisTwistedCubicRepairHypergraph]
          have h := minimalAxisRepair_finite_invariants a
          rw [hcard, hcap] at h
          norm_num at h ⊢
          exact h
      | inr u =>
          cases u
          rw [← matchingNumber_minimalAxisTwistedCubicRepairHypergraph,
            ← transversalNumber_minimalAxisTwistedCubicRepairHypergraph]
          have h := minimalAxisRepair_nucleus_invariants (𝔽 := F)
          rw [hcard, hcap] at h
          norm_num at h ⊢
          exact h

/-- Every coordinate of the q=9 code satisfies the paper's uniform `7ν ≤ 4τ` ratio;
cubic coordinates attain equality. -/
theorem axisTwistedCubic_q9_ratio (hcard : Fintype.card F = 9)
    (z : AxisTwistedCubicIndex F) :
    7 * matchingNumber (axisTwistedCubicRepairHypergraph z 3) ≤
      4 * transversalNumber (axisTwistedCubicRepairHypergraph z 3) := by
  have h := axisTwistedCubic_q9_row_invariants hcard z
  split at h <;> omega

#print axioms cubicRepair_matchingNumber_q9
#print axioms zeroSumCapNumber_q9
#print axioms zeroSum_edge_counts_q9
#print axioms axisRepair_component_edge_counts_q9
#print axioms cubicRepair_edge_count_q9
#print axioms axisTwistedCubic_q9_row_invariants
#print axioms axisTwistedCubic_q9_ratio

end RepairCodes
