import RelativeConicArcs.Conic
import Mathlib.Algebra.BigOperators.ModEq

/-!
# Even-characteristic nuclei

The coordinate layer proves that the standard conic together with its nucleus is a hyperoval.
The incidence layer then extracts the tangent classification and the two nucleus constraints.
-/

namespace RelativeConicArcs
namespace Nucleus

open Configuration Finset
open Conic Projectivization
open scoped LinearAlgebra.Projectivization

section Hyperoval

variable {P L : Type*} [Membership P L]
  [Fintype P] [Fintype L] [DecidableEq P] [DecidableEq L]
  [Configuration.ProjectivePlane P L]

/-- The points of `H` lying on `l`. -/
noncomputable def lineSlice (H : Finset P) (l : L) : Finset P :=
  pointsOnLine (P := P) l ∩ H

omit [Fintype L] [DecidableEq L] [Configuration.ProjectivePlane P L] in
@[simp] theorem mem_lineSlice {H : Finset P} {l : L} {p : P} :
    p ∈ lineSlice H l ↔ p ∈ l ∧ p ∈ H := by
  simp [lineSlice]

omit [Fintype L] [DecidableEq L] [Configuration.ProjectivePlane P L] in
/-- An arc has at most two points on every line. -/
theorem lineSlice_card_le_two {H : Finset P} (hH : Arc (L := L) H) (l : L) :
    (lineSlice H l).card ≤ 2 := by
  by_contra h
  rw [Nat.not_le, Finset.two_lt_card_iff] at h
  obtain ⟨a, b, c, ha, hb, hc, hab, hac, hbc⟩ := h
  exact hH (mem_lineSlice.mp ha).2 (mem_lineSlice.mp hb).2 (mem_lineSlice.mp hc).2
    hab hac hbc ⟨l, (mem_lineSlice.mp ha).1, (mem_lineSlice.mp hb).1,
      (mem_lineSlice.mp hc).1⟩

omit [DecidableEq L] in
/-- A `(q+2)`-arc in a projective plane of order `q` has no tangent lines. -/
theorem hyperoval_lineSlice_ne_one {H : Finset P} (hH : Arc (L := L) H)
    (hcard : H.card = PlaneOrder P L + 2) (l : L) :
    (lineSlice H l).card ≠ 1 := by
  classical
  intro hone
  obtain ⟨p, hp⟩ := Finset.card_eq_one.mp hone
  have hpH : p ∈ H := by
    have : p ∈ lineSlice H l := by simp [hp]
    exact (mem_lineSlice.mp this).2
  have hpl : p ∈ l := by
    have : p ∈ lineSlice H l := by simp [hp]
    exact (mem_lineSlice.mp this).1
  let f : {x // x ∈ H.erase p} → {m : L // p ∈ m} := fun x =>
    ⟨Configuration.HasLines.mkLine (by
      exact fun h => (Finset.mem_erase.mp x.2).1 h.symm),
      (Configuration.HasLines.mkLine_ax (P := P) (L := L) _).1⟩
  have hf : Function.Injective f := by
    intro x y hxy
    apply Subtype.ext
    by_contra hne
    have hline : Configuration.HasLines.mkLine
          (fun h => (Finset.mem_erase.mp x.2).1 h.symm) =
        Configuration.HasLines.mkLine
          (fun h => (Finset.mem_erase.mp y.2).1 h.symm) :=
      Subtype.ext_iff.mp hxy
    have hpx := (Configuration.HasLines.mkLine_ax (P := P) (L := L)
      (fun h => (Finset.mem_erase.mp x.2).1 h.symm)).1
    have hxx := (Configuration.HasLines.mkLine_ax (P := P) (L := L)
      (fun h => (Finset.mem_erase.mp x.2).1 h.symm)).2
    have hyy := (Configuration.HasLines.mkLine_ax (P := P) (L := L)
      (fun h => (Finset.mem_erase.mp y.2).1 h.symm)).2
    exact hH hpH (Finset.mem_erase.mp x.2).2 (Finset.mem_erase.mp y.2).2
      (fun h => (Finset.mem_erase.mp x.2).1 h.symm)
      (fun h => (Finset.mem_erase.mp y.2).1 h.symm) hne
      ⟨_, hpx, hxx, hline ▸ hyy⟩
  have hdom : Fintype.card {x // x ∈ H.erase p} = PlaneOrder P L + 1 := by
    rw [Fintype.card_coe, Finset.card_erase_of_mem hpH, hcard]
    omega
  have hcod : Fintype.card {m : L // p ∈ m} = PlaneOrder P L + 1 := by
    rw [← Nat.card_eq_fintype_card, ← Configuration.lineCount,
      Configuration.ProjectivePlane.lineCount_eq]
  have hbij : Function.Bijective f :=
    (Fintype.bijective_iff_injective_and_card f).mpr ⟨hf, hdom.trans hcod.symm⟩
  obtain ⟨x, hx⟩ := hbij.2 ⟨l, hpl⟩
  have hxl : x.1 ∈ l := by
    have hxline : Configuration.HasLines.mkLine
        (fun h => (Finset.mem_erase.mp x.2).1 h.symm) = l :=
      congrArg Subtype.val hx
    rw [← hxline]
    exact (Configuration.HasLines.mkLine_ax (P := P) (L := L)
      (fun h => (Finset.mem_erase.mp x.2).1 h.symm)).2
  have hxSlice : x.1 ∈ lineSlice H l :=
    mem_lineSlice.mpr ⟨hxl, (Finset.mem_erase.mp x.2).2⟩
  have hxp : x.1 = p := by simpa [hp] using hxSlice
  exact (Finset.mem_erase.mp x.2).1 hxp

omit [DecidableEq L] in
/-- Every line meets a hyperoval in zero or two points. -/
theorem hyperoval_lineSlice_card {H : Finset P} (hH : Arc (L := L) H)
    (hcard : H.card = PlaneOrder P L + 2) (l : L) :
    (lineSlice H l).card = 0 ∨ (lineSlice H l).card = 2 := by
  have hle := lineSlice_card_le_two hH l
  have hne := hyperoval_lineSlice_ne_one hH hcard l
  omega

/-- Secants meeting `H` in exactly one point. -/
noncomputable def tangentSecants (A H : Finset P) : Finset L :=
  (secants (L := L) A).filter fun l => (lineSlice H l).card = 1

omit [DecidableEq L] [Configuration.ProjectivePlane P L] in
@[simp] theorem mem_tangentSecants {A H : Finset P} {l : L} :
    l ∈ tangentSecants (L := L) A H ↔ Secant A l ∧ (lineSlice H l).card = 1 := by
  simp [tangentSecants]

omit [Fintype P] in
/-- At a point of an arc, there is one secant for each other arc point. -/
theorem pointIndex_eq_card_sub_one_of_mem {A : Finset P} (hA : Arc (L := L) A)
    {p : P} (hp : p ∈ A) : pointIndex (L := L) A p = A.card - 1 := by
  classical
  rw [pointIndex_eq_card_pairsThrough hA]
  have hthrough : pairsThrough (L := L) A p =
      (Finset.univ : Finset (ArcPair A)).filter fun e => p ∈ e.1 := by
    ext e
    simp only [Finset.mem_filter, Finset.mem_univ, true_and, mem_pairsThrough]
    constructor
    · exact fun h => e.mem_of_mem_arc_of_mem_line hA hp h
    · exact e.mem_line
  rw [hthrough]
  have huniv : (Finset.univ : Finset (ArcPair A)) = (A.powersetCard 2).attach := by
    ext e
    simp [ArcPair]
  rw [huniv, Finset.filter_attach']
  rw [Finset.card_map, Finset.card_attach]
  have hfilter :
      (A.powersetCard 2).filter
          (fun s => ∃ _h : s ∈ A.powersetCard 2, p ∈ s) =
        (A.powersetCard 2).filter fun s => p ∈ s := by
    ext s
    simp
  rw [hfilter]
  have hcontain : ({p} : Finset P) ⊆ A := by simpa using hp
  have hpred : (A.powersetCard 2).filter (fun s => p ∈ s) =
      (A.powersetCard 2).filter (fun s => ({p} : Finset P) ⊆ s) := by
    ext s
    simp
  calc
    ((A.powersetCard 2).filter (fun s => p ∈ s)).card =
        ((A.powersetCard 2).filter (fun s => ({p} : Finset P) ⊆ s)).card :=
      congrArg Finset.card hpred
    _ = Nat.choose (A.card - 1) 1 :=
      Finset.card_filter_powersetCard_subset {p} A 2 hcontain (by simp)
    _ = A.card - 1 := by simp

omit [DecidableEq L] [Configuration.ProjectivePlane P L] in
/-- Hole incidence can be summed line-first over the secants. -/
theorem holeIncidence_eq_sum_lineSlice (A H : Finset P) :
    holeIncidence (L := L) A H =
      ∑ l ∈ secants (L := L) A, (lineSlice H l).card := by
  classical
  have hindex (y : P) : pointIndex (L := L) A y =
      ∑ l ∈ secants (L := L) A, if y ∈ l then 1 else 0 := by
    rw [pointIndex, Finset.card_eq_sum_ones]
    simp
  have hslice (l : L) : (lineSlice H l).card =
      ∑ y ∈ H, if y ∈ l then 1 else 0 := by
    have heq : pointsOnLine (P := P) l ∩ H = H.filter fun y => y ∈ l := by
      ext y
      simp [and_comm]
    rw [lineSlice, heq, Finset.card_eq_sum_ones]
    simp
  rw [holeIncidence]
  simp_rw [hindex, hslice]
  rw [Finset.sum_comm]

end Hyperoval

section StandardConic

variable {K : Type*} [Field K] [Fintype K] [DecidableEq K]

noncomputable local instance instFintypePoint : Fintype (Point K) :=
  Fintype.ofFinite (Point K)

noncomputable local instance instDecidableEqPoint : DecidableEq (Point K) :=
  Classical.decEq (Point K)

/-- The nucleus vector `(0,1,0)` of `XZ=Y²` in characteristic two. -/
def standardNucleusVector : PlaneSpace K := ![0, 1, 0]

omit [Fintype K] [DecidableEq K] in
theorem standardNucleusVector_ne_zero : standardNucleusVector (K := K) ≠ 0 := by
  intro h
  have := congrFun h 1
  simp [standardNucleusVector] at this

/-- The projective nucleus `[0:1:0]`. -/
noncomputable def standardNucleus : Point K :=
  Projectivization.mk K standardNucleusVector standardNucleusVector_ne_zero

/-- The `2×2` determinant of two line-parameter vectors. -/
def cross2 (v w : LineSpace K) : K := v 0 * w 1 - v 1 * w 0

omit [Fintype K] in
theorem cross2_ne_zero_of_mk_ne {v w : LineSpace K} (hv : v ≠ 0) (hw : w ≠ 0)
    (hvw : Projectivization.mk K v hv ≠ Projectivization.mk K w hw) :
    cross2 v w ≠ 0 := by
  intro hcross
  apply hvw
  apply (Projectivization.mk_eq_mk_iff' K _ _ _ _).mpr
  by_cases hw0 : w 0 = 0
  · have hw1 : w 1 ≠ 0 := by
      intro hw1
      apply hw
      funext i
      fin_cases i <;> assumption
    have hv0 : v 0 = 0 := by
      have : v 0 * w 1 = 0 := by simpa [cross2, hw0] using hcross
      exact (mul_eq_zero.mp this).resolve_right hw1
    refine ⟨v 1 / w 1, ?_⟩
    funext i
    fin_cases i
    · simp [hw0, hv0]
    · simp [Pi.smul_apply, smul_eq_mul, hw1]
  · refine ⟨v 0 / w 0, ?_⟩
    have hrel : v 0 * w 1 = v 1 * w 0 := sub_eq_zero.mp hcross
    funext i
    fin_cases i
    · simp [Pi.smul_apply, smul_eq_mul, hw0]
    · simp only [Pi.smul_apply, smul_eq_mul]
      rw [div_mul_eq_mul_div]
      exact (div_eq_iff hw0).mpr hrel

omit [Fintype K] [DecidableEq K] in
theorem det_veronese_triple (u v w : LineSpace K) :
    Matrix.det ![ProjectiveCap.Sym2Bridge.veronese u,
      ProjectiveCap.Sym2Bridge.veronese v,
      ProjectiveCap.Sym2Bridge.veronese w] =
      cross2 u v * cross2 u w * cross2 v w := by
  simp [Matrix.det_fin_three, ProjectiveCap.Sym2Bridge.veronese, cross2]
  ring

omit [Fintype K] in
theorem veronese_triple_linearIndependent {u v w : LineSpace K}
    (hu : u ≠ 0) (hv : v ≠ 0) (hw : w ≠ 0)
    (huv : Projectivization.mk K u hu ≠ Projectivization.mk K v hv)
    (huw : Projectivization.mk K u hu ≠ Projectivization.mk K w hw)
    (hvw : Projectivization.mk K v hv ≠ Projectivization.mk K w hw) :
    LinearIndependent K ![ProjectiveCap.Sym2Bridge.veronese u,
      ProjectiveCap.Sym2Bridge.veronese v,
      ProjectiveCap.Sym2Bridge.veronese w] := by
  apply Matrix.linearIndependent_rows_of_det_ne_zero
  rw [det_veronese_triple]
  exact mul_ne_zero (mul_ne_zero (cross2_ne_zero_of_mk_ne hu hv huv)
    (cross2_ne_zero_of_mk_ne hu hw huw)) (cross2_ne_zero_of_mk_ne hv hw hvw)

omit [Fintype K] [DecidableEq K] in
theorem det_nucleus_veronese_pair (h2 : (2 : K) = 0) (v w : LineSpace K) :
    Matrix.det ![standardNucleusVector (K := K),
      ProjectiveCap.Sym2Bridge.veronese v,
      ProjectiveCap.Sym2Bridge.veronese w] = cross2 v w ^ 2 := by
  simp [Matrix.det_fin_three, standardNucleusVector,
    ProjectiveCap.Sym2Bridge.veronese, cross2]
  linear_combination (v 0 * w 1 * v 1 * w 0 - v 0 ^ 2 * w 1 ^ 2) * h2

omit [Fintype K] in
theorem nucleus_veronese_pair_linearIndependent (h2 : (2 : K) = 0)
    {v w : LineSpace K} (hv : v ≠ 0) (hw : w ≠ 0)
    (hvw : Projectivization.mk K v hv ≠ Projectivization.mk K w hw) :
    LinearIndependent K ![standardNucleusVector (K := K),
      ProjectiveCap.Sym2Bridge.veronese v,
      ProjectiveCap.Sym2Bridge.veronese w] := by
  apply Matrix.linearIndependent_rows_of_det_ne_zero
  rw [det_nucleus_veronese_pair h2]
  exact pow_ne_zero 2 (cross2_ne_zero_of_mk_ne hv hw hvw)

/-- The nucleus is not on the standard conic. -/
theorem standardNucleus_not_mem_standardConic :
    standardNucleus (K := K) ∉ standardConic (K := K) := by
  rw [mem_standardConic_iff_onConic]
  unfold standardNucleus
  rw [ProjectiveCap.Sym2Bridge.onConic_mk]
  simp [standardNucleusVector, ProjectiveCap.Sym2Bridge.conicForm]

omit [Fintype K] in
theorem standardNucleus_veronese_pair_independent (h2 : (2 : K) = 0)
    {v w : LinePoint K} (hvw : v ≠ w) :
    Projectivization.Independent
      ![standardNucleus (K := K), ProjectiveCap.Sym2Bridge.veronesePoint v,
        ProjectiveCap.Sym2Bridge.veronesePoint w] := by
  induction v using Projectivization.ind with
  | h v hv =>
    induction w using Projectivization.ind with
    | h w hw =>
      rw [ProjectiveCap.Sym2Bridge.veronesePoint_mk,
        ProjectiveCap.Sym2Bridge.veronesePoint_mk]
      exact ProjectiveCap.Projective.independent_triple_of_li
        standardNucleusVector_ne_zero
        (ProjectiveCap.Sym2Bridge.veronese_ne_zero hv)
        (ProjectiveCap.Sym2Bridge.veronese_ne_zero hw)
        (nucleus_veronese_pair_linearIndependent h2 hv hw hvw)

/-- In characteristic two, the standard conic together with `[0:1:0]` is a hyperoval. -/
theorem standardHyperoval_arc (h2 : (2 : K) = 0) :
    Arc (L := Point K) (insert (standardNucleus (K := K)) (standardConic (K := K))) := by
  rw [ProjectiveBridge.arc_iff_projectiveCap]
  intro a b c ha hb hc hab hac hbc hcol
  rw [Finset.mem_insert] at ha hb hc
  apply (ProjectiveCap.Projective.not_collinear_iff_independent.mpr ?_) hcol
  rcases ha with rfl | ha
  · rcases hb with rfl | hb
    · exact (hab rfl).elim
    · rcases hc with rfl | hc
      · exact (hac rfl).elim
      · obtain ⟨v, rfl⟩ := mem_standardConic.mp hb
        obtain ⟨w, rfl⟩ := mem_standardConic.mp hc
        exact standardNucleus_veronese_pair_independent h2
          (fun h => hbc (congrArg ProjectiveCap.Sym2Bridge.veronesePoint h))
  · rcases hb with rfl | hb
    · rcases hc with rfl | hc
      · exact (hbc rfl).elim
      · obtain ⟨u, rfl⟩ := mem_standardConic.mp ha
        obtain ⟨w, rfl⟩ := mem_standardConic.mp hc
        rw [ProjectiveCap.Projective.independent_triple_iff]
        exact ProjectiveCap.Projective.li_rotate
          ((ProjectiveCap.Projective.independent_triple_iff.mp
            (standardNucleus_veronese_pair_independent h2
              (fun h => hac (congrArg ProjectiveCap.Sym2Bridge.veronesePoint h.symm)))))
    · rcases hc with rfl | hc
      · obtain ⟨u, rfl⟩ := mem_standardConic.mp ha
        obtain ⟨v, rfl⟩ := mem_standardConic.mp hb
        rw [ProjectiveCap.Projective.independent_triple_iff]
        exact ProjectiveCap.Projective.li_rotate (ProjectiveCap.Projective.li_rotate
          ((ProjectiveCap.Projective.independent_triple_iff.mp
            (standardNucleus_veronese_pair_independent h2
              (fun h => hab (congrArg ProjectiveCap.Sym2Bridge.veronesePoint h))))))
      · obtain ⟨u, rfl⟩ := mem_standardConic.mp ha
        obtain ⟨v, rfl⟩ := mem_standardConic.mp hb
        obtain ⟨w, rfl⟩ := mem_standardConic.mp hc
        induction u using Projectivization.ind with
        | h u hu =>
          induction v using Projectivization.ind with
          | h v hv =>
            induction w using Projectivization.ind with
            | h w hw =>
              rw [ProjectiveCap.Sym2Bridge.veronesePoint_mk,
                ProjectiveCap.Sym2Bridge.veronesePoint_mk,
                ProjectiveCap.Sym2Bridge.veronesePoint_mk]
              exact ProjectiveCap.Projective.independent_triple_of_li
                (ProjectiveCap.Sym2Bridge.veronese_ne_zero hu)
                (ProjectiveCap.Sym2Bridge.veronese_ne_zero hv)
                (ProjectiveCap.Sym2Bridge.veronese_ne_zero hw)
                (veronese_triple_linearIndependent hu hv hw
                  (fun h => hab (congrArg ProjectiveCap.Sym2Bridge.veronesePoint h))
                  (fun h => hac (congrArg ProjectiveCap.Sym2Bridge.veronesePoint h))
                  (fun h => hbc (congrArg ProjectiveCap.Sym2Bridge.veronesePoint h)))

/-- The standard hyperoval has `q+2` points. -/
theorem standardHyperoval_card :
    (insert (standardNucleus (K := K)) (standardConic (K := K))).card =
      Fintype.card K + 2 := by
  rw [Finset.card_insert_of_notMem standardNucleus_not_mem_standardConic,
    standardConic_card]

/-- Every line meets the standard characteristic-two hyperoval in zero or two points. -/
theorem standardHyperoval_lineSlice_card (h2 : (2 : K) = 0) (l : Point K) :
    (lineSlice (insert (standardNucleus (K := K)) (standardConic (K := K))) l).card = 0 ∨
      (lineSlice (insert (standardNucleus (K := K)) (standardConic (K := K))) l).card = 2 := by
  apply hyperoval_lineSlice_card (standardHyperoval_arc h2)
  rw [standardHyperoval_card, ProjectiveBridge.planeOrder_eq_card]

/-- A line is tangent to the standard conic exactly when it passes through the nucleus. -/
theorem standardConic_tangent_iff_mem_nucleus (h2 : (2 : K) = 0) (l : Point K) :
    (lineSlice (standardConic (K := K)) l).card = 1 ↔ standardNucleus (K := K) ∈ l := by
  classical
  have hslice : lineSlice
      (insert (standardNucleus (K := K)) (standardConic (K := K))) l =
      (if standardNucleus (K := K) ∈ l then {standardNucleus (K := K)} else ∅) ∪
        lineSlice (standardConic (K := K)) l := by
    ext p
    by_cases hn : standardNucleus (K := K) ∈ l <;>
      simp [lineSlice, hn]
  constructor
  · intro hcard
    by_contra hn
    have hhyper := standardHyperoval_lineSlice_card h2 l
    rw [hslice, if_neg hn, Finset.empty_union, hcard] at hhyper
    omega
  · intro hn
    have hhyper := standardHyperoval_lineSlice_card h2 l
    rw [hslice, if_pos hn] at hhyper
    have hnuDisj : Disjoint ({standardNucleus (K := K)} : Finset (Point K))
        (lineSlice (standardConic (K := K)) l) := by
      rw [Finset.disjoint_left]
      intro p hpnu hpC
      simp only [Finset.mem_singleton] at hpnu
      subst p
      exact standardNucleus_not_mem_standardConic (mem_lineSlice.mp hpC).2
    rw [Finset.card_union_of_disjoint hnuDisj, Finset.card_singleton] at hhyper
    omega

/-- A non-tangent line meets the standard conic in zero or two points. -/
theorem standardConic_nontangent_card (h2 : (2 : K) = 0) (l : Point K)
    (hn : standardNucleus (K := K) ∉ l) :
    (lineSlice (standardConic (K := K)) l).card = 0 ∨
      (lineSlice (standardConic (K := K)) l).card = 2 := by
  have hhyper := standardHyperoval_lineSlice_card h2 l
  have heq : lineSlice
      (insert (standardNucleus (K := K)) (standardConic (K := K))) l =
      lineSlice (standardConic (K := K)) l := by
    ext p
    simp [lineSlice, hn]
  rwa [heq] at hhyper

/-- The number of tangent secants is the secant index at the nucleus. -/
theorem card_tangentSecants_standard (h2 : (2 : K) = 0) (A : Finset (Point K)) :
    (tangentSecants (L := Point K) A (standardConic (K := K))).card =
      pointIndex (L := Point K) A (standardNucleus (K := K)) := by
  classical
  rw [pointIndex]
  congr 1
  ext l
  simp [tangentSecants, standardConic_tangent_iff_mem_nucleus h2, and_comm]

/-- The conic-incidence term has the parity of the number of tangent secants. -/
theorem holeIncidence_modEq_tangentSecants (h2 : (2 : K) = 0)
    (A : Finset (Point K)) :
    Nat.ModEq 2 (holeIncidence (L := Point K) A (standardConic (K := K)))
      (tangentSecants (L := Point K) A (standardConic (K := K))).card := by
  classical
  rw [holeIncidence_eq_sum_lineSlice]
  have hsum : Nat.ModEq 2
      (∑ l ∈ secants (L := Point K) A,
        (lineSlice (standardConic (K := K)) l).card)
      (∑ l ∈ secants (L := Point K) A,
        if standardNucleus (K := K) ∈ l then 1 else 0) := by
    apply Nat.ModEq.sum
    intro l _hl
    by_cases hn : standardNucleus (K := K) ∈ l
    · rw [if_pos hn, (standardConic_tangent_iff_mem_nucleus h2 l).mpr hn]
    · rw [if_neg hn]
      rcases standardConic_nontangent_card h2 l hn with hzero | htwo
      · rw [hzero]
      · rw [htwo]
        norm_num [Nat.ModEq]
  have hcard : (∑ l ∈ secants (L := Point K) A,
        if standardNucleus (K := K) ∈ l then 1 else 0) =
      (tangentSecants (L := Point K) A (standardConic (K := K))).card := by
    rw [Finset.card_eq_sum_ones]
    simp [tangentSecants, standardConic_tangent_iff_mem_nucleus h2]
  rwa [hcard] at hsum

/-- Each tangent secant contributes one to conic incidence. -/
theorem card_tangentSecants_le_holeIncidence (h2 : (2 : K) = 0)
    (A : Finset (Point K)) :
    (tangentSecants (L := Point K) A (standardConic (K := K))).card ≤
      holeIncidence (L := Point K) A (standardConic (K := K)) := by
  classical
  rw [holeIncidence_eq_sum_lineSlice, Finset.card_eq_sum_ones]
  simp only [tangentSecants, Finset.sum_filter]
  apply Finset.sum_le_sum
  intro l hl
  by_cases hn : standardNucleus (K := K) ∈ l
  · simp [(standardConic_tangent_iff_mem_nucleus h2 l).mpr hn]
  · have hnot : (lineSlice (standardConic (K := K)) l).card ≠ 1 :=
      fun h => hn ((standardConic_tangent_iff_mem_nucleus h2 l).mp h)
    simp [hnot]

/-- Nucleus-in case: exactly `k-1` tangent secants, with the corresponding incidence lower bound
and parity. -/
theorem nucleus_mem_arc_constraints (h2 : (2 : K) = 0) {A : Finset (Point K)}
    (hA : Arc (L := Point K) A) (hnu : standardNucleus (K := K) ∈ A) :
    (tangentSecants (L := Point K) A (standardConic (K := K))).card = A.card - 1 ∧
      A.card - 1 ≤ holeIncidence (L := Point K) A (standardConic (K := K)) ∧
      Nat.ModEq 2 (holeIncidence (L := Point K) A (standardConic (K := K))) (A.card - 1) := by
  have ht := (card_tangentSecants_standard h2 A).trans
    (pointIndex_eq_card_sub_one_of_mem hA hnu)
  refine ⟨ht, ?_, ?_⟩
  · rw [← ht]
    exact card_tangentSecants_le_holeIncidence h2 A
  · simpa [ht] using holeIncidence_modEq_tangentSecants h2 A

/-- Corrected nucleus-in inequality, in subtraction-free integer form. -/
theorem nucleus_mem_complete_bound (h2 : (2 : K) = 0) {A : Finset (Point K)}
    (hA : CompleteOutside (L := Point K) A (standardConic (K := K)))
    (hnu : standardNucleus (K := K) ∈ A) :
    (A.card / 2) * (Fintype.card K ^ 2 - A.card) + (A.card - 1) +
        6 * Nat.choose A.card 4 ≤
      (A.card / 2) * (Nat.choose A.card 2 * (Fintype.card K - 1)) := by
  have hC : (standardConic (K := K)).card = PlaneOrder (Point K) (Point K) + 1 := by
    rw [ProjectiveBridge.planeOrder_eq_card]
    exact standardConic_card
  have hbase := completeOutside_bound_of_card_holes
    (P := Point K) (L := Point K) hA hC
  rw [ProjectiveBridge.planeOrder_eq_card] at hbase
  have hinc := (nucleus_mem_arc_constraints h2 hA.1 hnu).2.1
  omega

/-- Nucleus-out case: positive bounded index, exact tangent count, incidence lower bound, and
parity. -/
theorem nucleus_not_mem_arc_constraints (h2 : (2 : K) = 0) {A : Finset (Point K)}
    (hA : CompleteOutside (L := Point K) A (standardConic (K := K)))
    (hnu : standardNucleus (K := K) ∉ A) :
    1 ≤ pointIndex (L := Point K) A (standardNucleus (K := K)) ∧
      pointIndex (L := Point K) A (standardNucleus (K := K)) ≤ A.card / 2 ∧
      (tangentSecants (L := Point K) A (standardConic (K := K))).card =
        pointIndex (L := Point K) A (standardNucleus (K := K)) ∧
      pointIndex (L := Point K) A (standardNucleus (K := K)) ≤
        holeIncidence (L := Point K) A (standardConic (K := K)) ∧
      Nat.ModEq 2 (holeIncidence (L := Point K) A (standardConic (K := K)))
        (pointIndex (L := Point K) A (standardNucleus (K := K))) := by
  have hpos : 0 < pointIndex (L := Point K) A (standardNucleus (K := K)) :=
    hA.2.2 _ hnu standardNucleus_not_mem_standardConic
  have hle := pointIndex_le_half_card hA.1 hnu
  have ht := card_tangentSecants_standard h2 A
  refine ⟨hpos, hle, ht, ?_, ?_⟩
  · rw [← ht]
    exact card_tangentSecants_le_holeIncidence h2 A
  · simpa [ht] using holeIncidence_modEq_tangentSecants h2 A

/-- Every relative-complete arc in even characteristic spends at least one secant incidence on
the prescribed conic, independently of whether it contains the nucleus. -/
theorem complete_holeIncidence_pos (h2 : (2 : K) = 0) {A : Finset (Point K)}
    (hA : CompleteOutside (L := Point K) A (standardConic (K := K))) :
    1 ≤ holeIncidence (L := Point K) A (standardConic (K := K)) := by
  by_cases hnu : standardNucleus (K := K) ∈ A
  · have hcard : 3 ≤ A.card := by
      have hC : (standardConic (K := K)).card = PlaneOrder (Point K) (Point K) + 1 := by
        rw [ProjectiveBridge.planeOrder_eq_card]
        exact standardConic_card
      exact completeOutside_card_ge_three_of_card_holes hA hC
    have hinc := (nucleus_mem_arc_constraints h2 hA.1 hnu).2.1
    omega
  · exact (nucleus_not_mem_arc_constraints h2 hA hnu).2.2.2.1.trans'
      (nucleus_not_mem_arc_constraints h2 hA hnu).1

#print axioms complete_holeIncidence_pos

/-- Corrected nucleus-out inequality, in subtraction-free integer form. -/
theorem nucleus_not_mem_complete_bound (h2 : (2 : K) = 0) {A : Finset (Point K)}
    (hA : CompleteOutside (L := Point K) A (standardConic (K := K)))
    (hnu : standardNucleus (K := K) ∉ A) :
    (A.card / 2) * (Fintype.card K ^ 2 - A.card) + 1 +
        6 * Nat.choose A.card 4 ≤
      (A.card / 2) * (Nat.choose A.card 2 * (Fintype.card K - 1)) := by
  have hC : (standardConic (K := K)).card = PlaneOrder (Point K) (Point K) + 1 := by
    rw [ProjectiveBridge.planeOrder_eq_card]
    exact standardConic_card
  have hbase := completeOutside_bound_of_card_holes
    (P := Point K) (L := Point K) hA hC
  rw [ProjectiveBridge.planeOrder_eq_card] at hbase
  have hpos := (nucleus_not_mem_arc_constraints h2 hA hnu).1
  have hinc := (nucleus_not_mem_arc_constraints h2 hA hnu).2.2.2.1
  omega

end StandardConic

end Nucleus
end RelativeConicArcs
