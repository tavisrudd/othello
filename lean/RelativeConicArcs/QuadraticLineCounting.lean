import RelativeConicArcs.QuadraticFrobenius
import RelativeConicArcs.Nucleus

/-!
# Fixed-line counting for quadratic Frobenius arcs

This module supplies the incidence-count half of the quadratic pair-extension theorem.  Its first
geometric input is the dichotomy behind the count: a fixed arc point lies on `s+1` fixed lines,
whereas a nonfixed point lies on the unique fixed line joining it to its conjugate.
-/

namespace RelativeConicArcs
namespace QuadraticLineCounting

noncomputable section

open Configuration Finset
open FiniteGeom.BaerCompletion QuadraticFrobenius

variable (F E : Type) [Field F] [Fintype F] [Field E] [Finite E] [Algebra F E]
  [Algebra.IsAlgebraic F E]

abbrev Point := ProjectiveConjugation.Point E
abbrev FixedLine := FixedProjectivePoint F E

local instance : Fintype E := Fintype.ofFinite E
local instance : DecidableEq E := Classical.decEq E
local instance : DecidableEq (Point E) := Classical.decEq _
local instance : DecidableEq (FixedLine F E) := Classical.decEq _
local instance : DecidableRel fun p l : Point E => p.orthogonal l := Classical.decRel _

/-- Fixed dual lines incident with an ambient point. -/
abbrev FixedLinesThrough (p : Point E) :=
  {l : FixedLine F E // p.orthogonal l.1}

/-- A nonfixed point and its conjugate determine a fixed line. -/
noncomputable def mateLine (hdeg : Module.finrank F E = 2) (p : Point E)
    (hp : ProjectiveConjugation.projectiveEquiv (frobeniusRingEquiv F E) p ≠ p) :
    FixedLine F E := by
  let σ := ProjectiveConjugation.projectiveEquiv (frobeniusRingEquiv F E)
  have hp' : p ≠ σ p := Ne.symm hp
  let l : Point E := Configuration.HasLines.mkLine hp'
  have hpl : p.orthogonal l :=
    (Configuration.HasLines.mkLine_ax (P := Point E) (L := Point E) hp').1
  have hσpl : (σ p).orthogonal l :=
    (Configuration.HasLines.mkLine_ax (P := Point E) (L := Point E) hp').2
  have hpσl : p.orthogonal (σ l) := by
    have h := (ProjectiveConjugation.orthogonal_projectiveEquiv_iff
      (frobeniusRingEquiv F E) (σ p) l).2 hσpl
    have hinv : σ (σ p) = p := (incidence F E hdeg).point_involutive p
    rw [hinv] at h
    exact h
  have hσpσl : (σ p).orthogonal (σ l) :=
    (ProjectiveConjugation.orthogonal_projectiveEquiv_iff
      (frobeniusRingEquiv F E) p l).2 hpl
  have hfixed : σ l = l := by
    exact ((Configuration.Nondegenerate.eq_or_eq hpl hσpl hpσl hσpσl).resolve_left
      (Ne.symm hp)).symm
  exact ⟨l, hfixed⟩

theorem mateLine_incident (hdeg : Module.finrank F E = 2) (p : Point E)
    (hp : ProjectiveConjugation.projectiveEquiv (frobeniusRingEquiv F E) p ≠ p) :
    p.orthogonal (mateLine F E hdeg p hp).1 := by
  exact (Configuration.HasLines.mkLine_ax (P := Point E) (L := Point E) (Ne.symm hp)).1

/-- A nonfixed ambient point lies on exactly one fixed line. -/
theorem natCard_fixedLinesThrough_nonfixed (hdeg : Module.finrank F E = 2) (p : Point E)
    (hp : ProjectiveConjugation.projectiveEquiv (frobeniusRingEquiv F E) p ≠ p) :
    Nat.card (FixedLinesThrough F E p) = 1 := by
  let m := mateLine F E hdeg p hp
  have hm : p.orthogonal m.1 := mateLine_incident F E hdeg p hp
  have hall : ∀ l : FixedLinesThrough F E p, l.1 = m := by
    intro l
    apply Subtype.ext
    let σ := ProjectiveConjugation.projectiveEquiv (frobeniusRingEquiv F E)
    have hσpl : (σ p).orthogonal l.1.1 := by
      have h := (ProjectiveConjugation.orthogonal_projectiveEquiv_iff
        (frobeniusRingEquiv F E) p l.1.1).2 l.2
      simpa [σ, l.1.2] using h
    have hσpm : (σ p).orthogonal m.1 := by
      have h := (ProjectiveConjugation.orthogonal_projectiveEquiv_iff
        (frobeniusRingEquiv F E) p m.1).2 hm
      simpa [σ, m.2] using h
    exact (Configuration.Nondegenerate.eq_or_eq l.2 hσpl hm hσpm).resolve_left
      (Ne.symm hp)
  let center : FixedLinesThrough F E p := ⟨m, hm⟩
  let hequiv : FixedLinesThrough F E p ≃ Unit :=
    { toFun := fun _ => Unit.unit
      invFun := fun _ => center
      left_inv := fun l => by
        apply Subtype.ext
        exact (hall l).symm
      right_inv := fun _ => rfl }
  rw [Nat.card_congr hequiv, Nat.card_unique]

/-- A fixed ambient point lies on `s+1` fixed lines.  This is the point-line dual of the already
proved fixed-points-on-a-fixed-line count. -/
theorem natCard_fixedLinesThrough_fixed (hdeg : Module.finrank F E = 2) (p : Point E)
    (hp : ProjectiveConjugation.projectiveEquiv (frobeniusRingEquiv F E) p = p) :
    Nat.card (FixedLinesThrough F E p) = Nat.card F + 1 := by
  let fp : FixedProjectivePoint F E := ⟨p, hp⟩
  let hequiv : FixedLinesThrough F E p ≃ FixedPointsOnFixedLine F E fp :=
    { toFun := fun l => ⟨l.1, (Projectivization.orthogonal_comm).2 l.2⟩
      invFun := fun l => ⟨l.1, (Projectivization.orthogonal_comm).2 l.2⟩
      left_inv := fun _ => rfl
      right_inv := fun _ => rfl }
  rw [Nat.card_congr hequiv]
  exact natCard_fixedPointsOnFixedLine F E hdeg fp

/-- The finite universe of fixed lines. -/
noncomputable def allFixedLines : Finset (FixedLine F E) := Finset.univ

/-- The trace of an ambient point set on a fixed line. -/
noncomputable def fixedLineTrace (C : Finset (Point E)) (l : FixedLine F E) :
    Finset (Point E) := by
  classical
  exact C.filter fun p => p.orthogonal l.1

/-- Fixed points selected by `C`. -/
noncomputable def fixedArcPoints (C : Finset (Point E)) : Finset (Point E) :=
  C.filter fun p =>
    ProjectiveConjugation.projectiveEquiv (frobeniusRingEquiv F E) p = p

/-- Fixed lines through `p`, represented as a finset rather than a subtype. -/
noncomputable def fixedLinesThroughFinset (p : Point E) : Finset (FixedLine F E) :=
  by
    classical
    exact (allFixedLines F E).filter fun l => p.orthogonal l.1

theorem card_fixedLinesThroughFinset (p : Point E) :
    (fixedLinesThroughFinset F E p).card = Nat.card (FixedLinesThrough F E p) := by
  classical
  simp only [fixedLinesThroughFinset, allFixedLines]
  rw [← Fintype.card_subtype, ← Nat.card_eq_fintype_card]

/-- Arc traces on fixed lines have size at most two. -/
theorem fixedLineTrace_card_le_two {C : Finset (Point E)}
    (hC : Arc (L := Point E) C) (l : FixedLine F E) :
    (fixedLineTrace F E C l).card ≤ 2 := by
  classical
  by_contra h
  rw [Nat.not_le, Finset.two_lt_card_iff] at h
  obtain ⟨a, b, c, ha, hb, hc, hab, hac, hbc⟩ := h
  have ha' := Finset.mem_filter.mp ha
  have hb' := Finset.mem_filter.mp hb
  have hc' := Finset.mem_filter.mp hc
  exact hC ha'.1 hb'.1 hc'.1 hab hac hbc
    ⟨l.1, ha'.2, hb'.2, hc'.2⟩

/-- Double-count fixed-line/selected-point incidences by summing the fixed-line degree of each
selected point. -/
theorem sum_fixedLineTrace_card (C : Finset (Point E)) :
    (∑ l ∈ allFixedLines F E, (fixedLineTrace F E C l).card) =
      ∑ p ∈ C, (fixedLinesThroughFinset F E p).card := by
  classical
  simp only [fixedLineTrace, fixedLinesThroughFinset]
  simp_rw [Finset.card_eq_sum_ones, Finset.sum_filter]
  rw [Finset.sum_comm]

/-- Exact incidence sum for an invariant-orbit profile.  The equality `|C|=f+2e` says that the
nonfixed selected points form `e` conjugate pairs; invariance itself is not needed for this
particular double count. -/
theorem sum_fixedLineTrace_card_eq (hdeg : Module.finrank F E = 2)
    (C : Finset (Point E)) (f e : ℕ)
    (hf : (fixedArcPoints F E C).card = f) (hk : C.card = f + 2 * e) :
    (∑ l ∈ allFixedLines F E, (fixedLineTrace F E C l).card) =
      f * (Nat.card F + 1) + 2 * e := by
  classical
  rw [sum_fixedLineTrace_card F E C]
  calc
    (∑ p ∈ C, (fixedLinesThroughFinset F E p).card) =
        ∑ p ∈ C, if ProjectiveConjugation.projectiveEquiv
            (frobeniusRingEquiv F E) p = p then Nat.card F + 1 else 1 := by
      apply Finset.sum_congr rfl
      intro p hpC
      rw [card_fixedLinesThroughFinset F E p]
      split_ifs with hp
      · exact natCard_fixedLinesThrough_fixed F E hdeg p hp
      · exact natCard_fixedLinesThrough_nonfixed F E hdeg p hp
    _ = (fixedArcPoints F E C).card * (Nat.card F + 1) +
        (C.card - (fixedArcPoints F E C).card) := by
      rw [Finset.sum_ite]
      simp only [Finset.sum_const, smul_eq_mul, mul_one]
      have hpart := Finset.card_filter_add_card_filter_not (s := C)
        (fun p => ProjectiveConjugation.projectiveEquiv (frobeniusRingEquiv F E) p = p)
      have hcomp :
          (C.filter fun p => ¬ ProjectiveConjugation.projectiveEquiv
            (frobeniusRingEquiv F E) p = p).card =
            C.card - (C.filter fun p => ProjectiveConjugation.projectiveEquiv
              (frobeniusRingEquiv F E) p = p).card := by
        exact Nat.eq_sub_of_add_eq' hpart
      change (C.filter fun p => ProjectiveConjugation.projectiveEquiv
          (frobeniusRingEquiv F E) p = p).card * (Nat.card F + 1) +
        (C.filter fun p => ¬ ProjectiveConjugation.projectiveEquiv
          (frobeniusRingEquiv F E) p = p).card = _
      unfold fixedArcPoints
      rw [hcomp]
    _ = f * (Nat.card F + 1) + 2 * e := by rw [hf, hk]; omega

/-- Conjugate an unordered endpoint pair of an invariant point set. -/
noncomputable def conjugateArcPair (C : Finset (Point E))
    (hC : IsInvariant (incidence F E hdeg) C) (a : ArcPair C) : ArcPair C := by
  classical
  let σ := (incidence F E hdeg).pointConj
  refine ⟨a.1.map σ.toEmbedding, Finset.mem_powersetCard.mpr ⟨?_, ?_⟩⟩
  · intro p hp
    obtain ⟨q, hqa, rfl⟩ := Finset.mem_map.mp hp
    exact mem_of_invariant_conj (incidence F E hdeg) hC (a.subset hqa)
  · rw [Finset.card_map, a.card]

/-- Joining a conjugated endpoint pair conjugates its joining line. -/
theorem line_conjugateArcPair (C : Finset (Point E))
    (hC : IsInvariant (incidence F E hdeg) C) (a : ArcPair C) :
    (conjugateArcPair F E C hC a).line (L := Point E) =
      (incidence F E hdeg).lineConj (a.line (L := Point E)) := by
  apply ArcPair.line_unique
  intro p hp
  obtain ⟨q, hqa, rfl⟩ := Finset.mem_map.mp hp
  have hq : q.orthogonal (a.line (L := Point E)) := by
    have hmem := a.mem_line (L := Point E) hqa
    change q.orthogonal (a.line (L := Point E)) at hmem
    exact hmem
  exact (ProjectiveConjugation.orthogonal_projectiveEquiv_iff
    (frobeniusRingEquiv F E) q (a.line (L := Point E))).2 hq

/-- Invariant endpoint pairs have fixed joining lines. -/
theorem line_fixed_of_conjugateArcPair_eq (C : Finset (Point E))
    (hArc : Arc (L := Point E) C) (hC : IsInvariant (incidence F E hdeg) C)
    (a : ArcPair C) (ha : conjugateArcPair F E C hC a = a) :
    (incidence F E hdeg).lineConj (a.line (L := Point E)) = a.line (L := Point E) := by
  have hline := line_conjugateArcPair F E C hC a
  rw [ha] at hline
  exact hline.symm

/-- Fixed lines whose arc trace contains two points. -/
noncomputable def doubleFixedLines (C : Finset (Point E)) : Finset (FixedLine F E) :=
  (allFixedLines F E).filter fun l => (fixedLineTrace F E C l).card = 2

/-- Conjugation-invariant unordered endpoint pairs of `C`. -/
abbrev InvariantArcPair (C : Finset (Point E))
    (hC : IsInvariant (incidence F E hdeg) C) :=
  {a : ArcPair C // conjugateArcPair F E C hC a = a}

/-- A fixed two-point trace determines its endpoint pair. -/
noncomputable def doubleLineToPair (C : Finset (Point E))
    (l : {l // l ∈ doubleFixedLines F E C}) : ArcPair C := by
  classical
  refine ⟨fixedLineTrace F E C l.1, Finset.mem_powersetCard.mpr ⟨?_, ?_⟩⟩
  · exact Finset.filter_subset _ _
  · exact (Finset.mem_filter.mp l.2).2

theorem doubleLineToPair_line (C : Finset (Point E))
    (l : {l // l ∈ doubleFixedLines F E C}) :
    (doubleLineToPair F E C l).line (L := Point E) = l.1.1 := by
  classical
  apply ArcPair.line_unique
  intro p hp
  change p.orthogonal l.1.1
  exact (Finset.mem_filter.mp hp).2

/-- The endpoint pair cut out by a fixed two-trace is invariant. -/
theorem doubleLineToPair_invariant (C : Finset (Point E))
    (hArc : Arc (L := Point E) C) (hC : IsInvariant (incidence F E hdeg) C)
    (l : {l // l ∈ doubleFixedLines F E C}) :
    conjugateArcPair F E C hC (doubleLineToPair F E C l) =
      doubleLineToPair F E C l := by
  apply ArcPair.line_injective hArc
  rw [line_conjugateArcPair F E C hC]
  calc
    (incidence F E hdeg).lineConj
        ((doubleLineToPair F E C l).line (L := Point E)) =
        (incidence F E hdeg).lineConj l.1.1 := by
          rw [doubleLineToPair_line F E C l]
    _ = l.1.1 := l.1.2
    _ = (doubleLineToPair F E C l).line (L := Point E) :=
      (doubleLineToPair_line F E C l).symm

/-- An invariant endpoint pair determines its fixed joining line. -/
noncomputable def invariantPairToDoubleLine (C : Finset (Point E))
    (hArc : Arc (L := Point E) C) (hC : IsInvariant (incidence F E hdeg) C)
    (a : InvariantArcPair F E C hC) : {l // l ∈ doubleFixedLines F E C} := by
  classical
  let l : Point E := a.1.line (L := Point E)
  have hl : (incidence F E hdeg).lineConj l = l :=
    line_fixed_of_conjugateArcPair_eq F E C hArc hC a.1 a.2
  let fl : FixedLine F E := ⟨l, hl⟩
  refine ⟨fl, Finset.mem_filter.mpr ⟨Finset.mem_univ _, ?_⟩⟩
  have heq : fixedLineTrace F E C fl = a.1.1 := by
    apply Finset.Subset.antisymm
    · intro p hp
      exact a.1.mem_of_mem_arc_of_mem_line hArc (Finset.mem_filter.mp hp).1
        (by
          change p.orthogonal fl.1
          exact (Finset.mem_filter.mp hp).2)
    · intro p hp
      exact Finset.mem_filter.mpr ⟨a.1.subset hp,
        (by
          have hmem := a.1.mem_line (L := Point E) hp
          change p.orthogonal (a.1.line (L := Point E)) at hmem
          exact hmem)⟩
  rw [heq, a.1.card]

/-- Fixed two-traces are equivalent to invariant endpoint pairs. -/
noncomputable def doubleFixedLineEquivInvariantPair (C : Finset (Point E))
    (hArc : Arc (L := Point E) C) (hC : IsInvariant (incidence F E hdeg) C) :
    {l // l ∈ doubleFixedLines F E C} ≃ InvariantArcPair F E C hC := by
  classical
  exact
   { toFun := fun l =>
       ⟨doubleLineToPair F E C l, doubleLineToPair_invariant F E C hArc hC l⟩
     invFun := invariantPairToDoubleLine F E C hArc hC
     left_inv := fun l => by
      apply Subtype.ext
      apply Subtype.ext
      exact doubleLineToPair_line F E C l
     right_inv := fun a => by
      apply Subtype.ext
      apply ArcPair.line_injective hArc
      exact doubleLineToPair_line F E C _ }

/-- The invariant endpoint pairs whose two endpoints are fixed individually. -/
abbrev FixedInvariantArcPair (C : Finset (Point E))
    (hC : IsInvariant (incidence F E hdeg) C) :=
  {a : InvariantArcPair F E C hC //
    ∀ p ∈ a.1.1, ProjectiveConjugation.projectiveEquiv
      (frobeniusRingEquiv F E) p = p}

/-- Choosing two fixed selected points is equivalent to choosing an invariant endpoint pair all of
whose points are fixed. -/
noncomputable def fixedArcPairEquivFixedInvariantPair (C : Finset (Point E))
    (hC : IsInvariant (incidence F E hdeg) C) :
    ArcPair (fixedArcPoints F E C) ≃ FixedInvariantArcPair F E C hC := by
  classical
  let forward : ArcPair (fixedArcPoints F E C) → FixedInvariantArcPair F E C hC := fun a => by
    let b : ArcPair C := ⟨a.1, Finset.mem_powersetCard.mpr ⟨fun p hp =>
      (Finset.mem_filter.mp (a.subset hp)).1, a.card⟩⟩
    have hinv : conjugateArcPair F E C hC b = b := by
      apply Subtype.ext
      ext p
      constructor
      · intro hp
        obtain ⟨q, hqa, hqp⟩ := Finset.mem_map.mp hp
        have hqfix := (Finset.mem_filter.mp (a.subset hqa)).2
        change ProjectiveConjugation.projectiveEquiv (frobeniusRingEquiv F E) q = p at hqp
        rw [hqfix] at hqp
        simpa [b, hqp] using hqa
      · intro hp
        have hpfix := (Finset.mem_filter.mp (a.subset hp)).2
        exact Finset.mem_map.mpr ⟨p, hp, hpfix⟩
    refine ⟨⟨b, hinv⟩, ?_⟩
    intro p hp
    exact (Finset.mem_filter.mp (a.subset hp)).2
  let backward : FixedInvariantArcPair F E C hC → ArcPair (fixedArcPoints F E C) :=
    fun a => ⟨a.1.1.1, Finset.mem_powersetCard.mpr ⟨fun p hp =>
      Finset.mem_filter.mpr ⟨a.1.1.subset hp, a.2 p hp⟩, a.1.1.card⟩⟩
  exact
    { toFun := forward
      invFun := backward
      left_inv := fun a => by apply Subtype.ext; rfl
      right_inv := fun a => by apply Subtype.ext; apply Subtype.ext; apply Subtype.ext; rfl }

theorem natCard_fixedInvariantArcPair (C : Finset (Point E))
    (hC : IsInvariant (incidence F E hdeg) C) :
    Nat.card (FixedInvariantArcPair F E C hC) =
      Nat.choose (fixedArcPoints F E C).card 2 := by
  calc
    Nat.card (FixedInvariantArcPair F E C hC) =
        Nat.card (ArcPair (fixedArcPoints F E C)) :=
      Nat.card_congr (fixedArcPairEquivFixedInvariantPair F E C hC).symm
    _ = Fintype.card (ArcPair (fixedArcPoints F E C)) := Nat.card_eq_fintype_card
    _ = Nat.choose (fixedArcPoints F E C).card 2 :=
      card_arcPair (fixedArcPoints F E C)

/-- The named nonfixed-point predicate avoids any ambiguity about the orientation of `≠` when
it is used under finite-set filters. -/
def IsFrobeniusNonfixed (p : Point E) : Prop :=
  ProjectiveConjugation.projectiveEquiv (frobeniusRingEquiv F E) p ≠ p

local instance : DecidablePred (IsFrobeniusNonfixed F E) := Classical.decPred _

/-- Selected nonfixed points. -/
abbrev NonfixedArcPoint (C : Finset (Point E)) :=
  {p : Point E // p ∈ C ∧ IsFrobeniusNonfixed F E p}

/-- Invariant endpoint pairs which are not pairs of pointwise fixed endpoints. -/
abbrev ConjugateInvariantArcPair (C : Finset (Point E))
    (hC : IsInvariant (incidence F E hdeg) C) :=
  {a : InvariantArcPair F E C hC //
    ¬ ∀ p ∈ a.1.1, ProjectiveConjugation.projectiveEquiv
      (frobeniusRingEquiv F E) p = p}

/-- Conjugation on selected nonfixed points. -/
noncomputable def selectedMate (C : Finset (Point E))
    (hC : IsInvariant (incidence F E hdeg) C) :
    NonfixedArcPoint F E C ≃ NonfixedArcPoint F E C where
  toFun p := ⟨(incidence F E hdeg).pointConj p.1,
    mem_of_invariant_conj (incidence F E hdeg) hC p.2.1, by
      intro hfix
      exact p.2.2 (hfix.symm.trans ((incidence F E hdeg).point_involutive p.1))⟩
  invFun p := ⟨(incidence F E hdeg).pointConj p.1,
    mem_of_invariant_conj (incidence F E hdeg) hC p.2.1, by
      intro hfix
      exact p.2.2 (hfix.symm.trans ((incidence F E hdeg).point_involutive p.1))⟩
  left_inv p := by apply Subtype.ext; exact (incidence F E hdeg).point_involutive p.1
  right_inv p := by apply Subtype.ext; exact (incidence F E hdeg).point_involutive p.1

/-- The invariant endpoint pair represented by a selected nonfixed point. -/
noncomputable def selectedOrbitPair (C : Finset (Point E))
    (hC : IsInvariant (incidence F E hdeg) C)
    (p : NonfixedArcPoint F E C) : ConjugateInvariantArcPair F E C hC := by
  classical
  let σ := (incidence F E hdeg).pointConj
  have hne : p.1 ≠ σ p.1 := Ne.symm p.2.2
  let a : ArcPair C := by
    refine ⟨{p.1, σ p.1}, Finset.mem_powersetCard.mpr ⟨?_, by simp [hne]⟩⟩
    intro q hq
    simp only [Finset.mem_insert, Finset.mem_singleton] at hq
    rcases hq with rfl | rfl
    · exact p.2.1
    · exact mem_of_invariant_conj (incidence F E hdeg) hC p.2.1
  have hainv : conjugateArcPair F E C hC a = a := by
    apply Subtype.ext
    ext q
    simp only [conjugateArcPair, Finset.mem_map, Equiv.toEmbedding_apply,
      a, Finset.mem_insert, Finset.mem_singleton]
    constructor
    · rintro ⟨r, (rfl | rfl), rfl⟩
      · exact Or.inr rfl
      · exact Or.inl ((incidence F E hdeg).point_involutive p.1)
    · rintro (rfl | rfl)
      · exact ⟨σ p.1, Or.inr rfl, (incidence F E hdeg).point_involutive p.1⟩
      · exact ⟨p.1, Or.inl rfl, rfl⟩
  refine ⟨⟨a, hainv⟩, ?_⟩
  intro hall
  exact p.2.2 (hall p.1 (by simp [a]))

theorem selectedOrbitPair_eq_iff (C : Finset (Point E))
    (hC : IsInvariant (incidence F E hdeg) C)
    (p q : NonfixedArcPoint F E C) :
    selectedOrbitPair F E C hC p = selectedOrbitPair F E C hC q ↔
      p = q ∨ p = selectedMate F E C hC q := by
  constructor
  · intro h
    have hpmem : p.1 ∈ (selectedOrbitPair F E C hC q).1.1.1 := by
      rw [← h]
      simp [selectedOrbitPair]
    simp only [selectedOrbitPair, Finset.mem_insert, Finset.mem_singleton] at hpmem
    rcases hpmem with hpq | hpq
    · left; exact Subtype.ext hpq
    · right; exact Subtype.ext hpq
  · rintro (rfl | rfl)
    · rfl
    · apply Subtype.ext
      apply Subtype.ext
      apply Subtype.ext
      have hinv := (incidence F E hdeg).point_involutive q.1
      change ({(incidence F E hdeg).pointConj q.1,
          (incidence F E hdeg).pointConj ((incidence F E hdeg).pointConj q.1)} :
          Finset (Point E)) = {q.1, (incidence F E hdeg).pointConj q.1}
      rw [hinv]
      exact Finset.pair_comm _ _

/-- Every conjugate invariant pair is represented by one of its nonfixed endpoints. -/
theorem selectedOrbitPair_surjective (C : Finset (Point E))
    (hC : IsInvariant (incidence F E hdeg) C) :
    Function.Surjective (selectedOrbitPair F E C hC) := by
  intro a
  have hnot := a.2
  push Not at hnot
  obtain ⟨p, hp, hpnon⟩ := hnot
  let pp : NonfixedArcPoint F E C := ⟨p, a.1.1.subset hp, hpnon⟩
  refine ⟨pp, ?_⟩
  apply Subtype.ext
  apply Subtype.ext
  apply Subtype.ext
  have hainv : IsInvariant (incidence F E hdeg) a.1.1.1 := by
    unfold IsInvariant
    simpa [conjugateArcPair] using congrArg Subtype.val a.1.2
  exact invariant_pair_eq_conjugate (incidence F E hdeg) hainv a.1.1.card hp hpnon |>.symm

/-- Rebracket selected nonfixed points as the subtype of a filtered finset. -/
noncomputable def nonfixedArcPointEquiv (C : Finset (Point E)) :
    NonfixedArcPoint F E C ≃
      {p // p ∈ C.filter (IsFrobeniusNonfixed F E)} := by
  classical
  exact
    { toFun := fun p => ⟨p.1, Finset.mem_filter.mpr p.2⟩
      invFun := fun p => by
        refine ⟨p.1, ?_⟩
        change p.1 ∈ C ∧ IsFrobeniusNonfixed F E p.1
        exact Finset.mem_filter.mp p.2
      left_inv := fun _ => rfl
      right_inv := fun _ => rfl }

theorem natCard_nonfixedArcPoint (C : Finset (Point E)) :
    Nat.card (NonfixedArcPoint F E C) = C.card - (fixedArcPoints F E C).card := by
  classical
  calc
    Nat.card (NonfixedArcPoint F E C) =
        Nat.card {p // p ∈ C.filter fun p =>
          IsFrobeniusNonfixed F E p} :=
      Nat.card_congr (nonfixedArcPointEquiv F E C)
    _ = (C.filter (IsFrobeniusNonfixed F E)).card := by
      rw [Nat.card_eq_fintype_card, Fintype.card_coe]
    _ = C.card - (fixedArcPoints F E C).card := by
      have hpart := Finset.card_filter_add_card_filter_not (s := C)
        (fun p => ProjectiveConjugation.projectiveEquiv (frobeniusRingEquiv F E) p = p)
      unfold fixedArcPoints
      simpa [IsFrobeniusNonfixed] using Nat.eq_sub_of_add_eq' hpart

/-- The finite fiber of the selected-orbit-pair map. -/
noncomputable def selectedOrbitPairFiber (C : Finset (Point E))
    (hC : IsInvariant (incidence F E hdeg) C)
    (p : NonfixedArcPoint F E C) : Finset (NonfixedArcPoint F E C) := by
  classical
  exact Finset.univ.filter fun q =>
    selectedOrbitPair F E C hC q = selectedOrbitPair F E C hC p

theorem selectedOrbitPair_fiber_card (C : Finset (Point E))
    (hC : IsInvariant (incidence F E hdeg) C)
    (p : NonfixedArcPoint F E C) :
    (selectedOrbitPairFiber F E C hC p).card = 2 := by
  classical
  have hne : p ≠ selectedMate F E C hC p := by
    intro h
    apply p.2.2
    have hv := congrArg Subtype.val h
    change p.1 = (incidence F E hdeg).pointConj p.1 at hv
    exact hv.symm
  have heq : selectedOrbitPairFiber F E C hC p =
      {p, selectedMate F E C hC p} := by
    ext q
    simp only [selectedOrbitPairFiber, Finset.mem_filter, Finset.mem_univ, true_and,
      Finset.mem_insert, Finset.mem_singleton]
    exact selectedOrbitPair_eq_iff F E C hC q p
  rw [heq]
  simp [hne]

/-- The conjugate invariant endpoint pairs number `e` when the selected nonfixed points number
`2e`. -/
theorem natCard_conjugateInvariantArcPair (C : Finset (Point E))
    (hC : IsInvariant (incidence F E hdeg) C) (e : ℕ)
    (hcount : Nat.card (NonfixedArcPoint F E C) = 2 * e) :
    Nat.card (ConjugateInvariantArcPair F E C hC) = e := by
  classical
  let S : Finset (NonfixedArcPoint F E C) := Finset.univ
  let T : Finset (ConjugateInvariantArcPair F E C hC) := Finset.univ
  have hfiber : ∀ q ∈ T,
      (S.filter fun p => selectedOrbitPair F E C hC p = q).card = 2 := by
    intro q hq
    obtain ⟨p, hp⟩ := selectedOrbitPair_surjective F E C hC q
    subst q
    exact selectedOrbitPair_fiber_card F E C hC p
  have hmul := card_eq_card_mul_of_constant_fibers S T
    (selectedOrbitPair F E C hC) 2 (fun _ _ => Finset.mem_univ _) hfiber
  have hS : S.card = 2 * e := by
    rw [Finset.card_univ, ← Nat.card_eq_fintype_card]
    exact hcount
  have hT : T.card = Nat.card (ConjugateInvariantArcPair F E C hC) := by
    rw [Finset.card_univ, ← Nat.card_eq_fintype_card]
  rw [hS, hT] at hmul
  omega

/-- Invariant endpoint pairs split into the pointwise-fixed pairs and the conjugate orbit pairs. -/
theorem natCard_invariantArcPair (C : Finset (Point E))
    (hC : IsInvariant (incidence F E hdeg) C) :
    Nat.card (InvariantArcPair F E C hC) =
      Nat.card (FixedInvariantArcPair F E C hC) +
        Nat.card (ConjugateInvariantArcPair F E C hC) := by
  classical
  let pred : InvariantArcPair F E C hC → Prop := fun a =>
    ∀ p ∈ a.1.1, ProjectiveConjugation.projectiveEquiv
      (frobeniusRingEquiv F E) p = p
  have hpart := Finset.card_filter_add_card_filter_not
    (s := (Finset.univ : Finset (InvariantArcPair F E C hC))) pred
  simpa [pred, Nat.card_eq_fintype_card, Fintype.card_subtype] using hpart.symm

/-- Exact count of fixed lines carrying two selected arc points. -/
theorem card_doubleFixedLines (C : Finset (Point E))
    (hArc : Arc (L := Point E) C) (hC : IsInvariant (incidence F E hdeg) C)
    (f e : ℕ) (hf : (fixedArcPoints F E C).card = f)
    (hk : C.card = f + 2 * e) :
    (doubleFixedLines F E C).card = f.choose 2 + e := by
  have hnon : Nat.card (NonfixedArcPoint F E C) = 2 * e := by
    rw [natCard_nonfixedArcPoint F E C, hf, hk]
    omega
  calc
    (doubleFixedLines F E C).card =
        Nat.card {l // l ∈ doubleFixedLines F E C} := by
      rw [Nat.card_eq_fintype_card, Fintype.card_coe]
    _ = Nat.card (InvariantArcPair F E C hC) :=
      Nat.card_congr (doubleFixedLineEquivInvariantPair F E C hArc hC)
    _ = Nat.card (FixedInvariantArcPair F E C hC) +
        Nat.card (ConjugateInvariantArcPair F E C hC) :=
      natCard_invariantArcPair F E C hC
    _ = (fixedArcPoints F E C).card.choose 2 + e := by
      rw [natCard_fixedInvariantArcPair F E C hC,
        natCard_conjugateInvariantArcPair F E C hC e hnon]
    _ = f.choose 2 + e := by rw [hf]

/-- A pointwise-fixed invariant endpoint pair has a fixed joining line. -/
noncomputable def fixedInvariantPairLine (C : Finset (Point E))
    (hArc : Arc (L := Point E) C) (hC : IsInvariant (incidence F E hdeg) C)
    (a : FixedInvariantArcPair F E C hC) : FixedLine F E :=
  ⟨a.1.1.line (L := Point E),
    line_fixed_of_conjugateArcPair_eq F E C hArc hC a.1.1 a.1.2⟩

theorem fixedInvariantPairLine_injective (C : Finset (Point E))
    (hArc : Arc (L := Point E) C) (hC : IsInvariant (incidence F E hdeg) C) :
    Function.Injective (fixedInvariantPairLine F E C hArc hC) := by
  intro a b hab
  apply Subtype.ext
  apply Subtype.ext
  apply ArcPair.line_injective hArc
  exact congrArg Subtype.val hab

/-- The fixed-point pair correction fits inside the fixed-point star incidence count.  This is
the side condition needed to rewrite the natural-number subtraction without hidden truncation. -/
theorem choose_fixedArcPoints_le_star (hdeg : Module.finrank F E = 2)
    (C : Finset (Point E)) (hArc : Arc (L := Point E) C)
    (hC : IsInvariant (incidence F E hdeg) C) :
    Nat.choose (fixedArcPoints F E C).card 2 ≤
      (fixedArcPoints F E C).card * (Nat.card F + 1) := by
  let f := (fixedArcPoints F E C).card
  have hline : Nat.card (FixedInvariantArcPair F E C hC) ≤
      Nat.card (FixedLine F E) :=
    Nat.card_le_card_of_injective (fixedInvariantPairLine F E C hArc hC)
      (fixedInvariantPairLine_injective F E C hArc hC)
  rw [natCard_fixedInvariantArcPair F E C hC,
    natCard_fixedProjectivePoint F E hdeg] at hline
  have hid := two_mul_choose_two f
  change f.choose 2 ≤ Nat.card F ^ 2 + Nat.card F + 1 at hline
  change f.choose 2 ≤ f * (Nat.card F + 1)
  by_cases hf : f = 0
  · simp [hf]
  by_contra hnot
  have hgt : f * (Nat.card F + 1) < f.choose 2 := Nat.lt_of_not_ge hnot
  obtain ⟨n, hn⟩ := Nat.exists_eq_succ_of_ne_zero hf
  rw [hn] at hid hline hgt
  simp only [Nat.succ_sub_one] at hid
  nlinarith

/-- Fixed lines meeting `C`. -/
noncomputable def occupiedFixedLines (C : Finset (Point E)) : Finset (FixedLine F E) :=
  (allFixedLines F E).filter fun l => (fixedLineTrace F E C l).Nonempty

/-- Fixed lines disjoint from `C`. -/
noncomputable def emptyFixedLines (C : Finset (Point E)) : Finset (FixedLine F E) :=
  allFixedLines F E \ occupiedFixedLines F E C

/-- **Occupied fixed-line formula.** An invariant arc with `f` fixed points and `e` conjugate
point-pairs occupies exactly `f(s+1)-choose(f,2)+e` fixed lines. -/
theorem card_occupiedFixedLines (hdeg : Module.finrank F E = 2)
    (C : Finset (Point E)) (hArc : Arc (L := Point E) C)
    (hC : IsInvariant (incidence F E hdeg) C) (f e : ℕ)
    (hf : (fixedArcPoints F E C).card = f) (hk : C.card = f + 2 * e) :
    (occupiedFixedLines F E C).card =
      f * (Nat.card F + 1) - f.choose 2 + e := by
  apply occupied_card_of_baer_trace_profile
    (allFixedLines F E) (fixedLineTrace F E C) f e (Nat.card F + 1)
  · intro l hl
    exact fixedLineTrace_card_le_two F E hArc l
  · exact sum_fixedLineTrace_card_eq F E hdeg C f e hf hk
  · exact card_doubleFixedLines F E C hArc hC f e hf hk
  · simpa [hf] using choose_fixedArcPoints_le_star F E hdeg C hArc hC

/-- **Empty fixed-line formula.** The complement has exactly the `baerEmptyLineCount` required
by the quadratic pair-extension wrapper. -/
theorem card_emptyFixedLines (hdeg : Module.finrank F E = 2)
    (C : Finset (Point E)) (hArc : Arc (L := Point E) C)
    (hC : IsInvariant (incidence F E hdeg) C) (f e : ℕ)
    (hf : (fixedArcPoints F E C).card = f) (hk : C.card = f + 2 * e) :
    (emptyFixedLines F E C).card = baerEmptyLineCount (Nat.card F) f e := by
  have hsub : occupiedFixedLines F E C ⊆ allFixedLines F E := by
    intro l hl
    exact (Finset.mem_filter.mp hl).1
  rw [emptyFixedLines, Finset.card_sdiff_of_subset hsub,
    card_occupiedFixedLines F E hdeg C hArc hC f e hf hk]
  simp only [allFixedLines, Finset.card_univ, ← Nat.card_eq_fintype_card,
    natCard_fixedProjectivePoint F E hdeg, baerEmptyLineCount, pow_two]

end
end QuadraticLineCounting
end RelativeConicArcs
