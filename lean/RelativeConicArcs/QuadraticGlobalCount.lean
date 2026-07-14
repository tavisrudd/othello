import RelativeConicArcs.QuadraticForbidden

namespace RelativeConicArcs
namespace QuadraticGlobalCount

noncomputable section

open Configuration Finset
open FiniteGeom.BaerCompletion QuadraticFrobenius QuadraticLineCounting
  QuadraticForbidden

variable (F E : Type) [Field F] [Fintype F] [Field E] [Finite E] [Algebra F E]
  [Algebra.IsAlgebraic F E]

abbrev Point := ProjectiveConjugation.Point E
abbrev FixedLine := FixedProjectivePoint F E

local instance : Fintype E := Fintype.ofFinite E
local instance : DecidableEq E := Classical.decEq E
local instance : DecidableEq (Point E) := Classical.decEq _
local instance : DecidableEq (FixedLine F E) := Classical.decEq _
local instance : DecidableRel fun p l : Point E => p.orthogonal l := Classical.decRel _

/-- The semantic predicate for a fresh nonfixed Frobenius pair. -/
def IsFreshConjugatePair (hdeg : Module.finrank F E = 2) (C : Finset (Point E))
    (q : Sym2 (Point E)) : Prop :=
  ∃ p : Point E,
    (incidence F E hdeg).pointConj p ≠ p ∧
      q = s(p, (incidence F E hdeg).pointConj p) ∧
      Disjoint q.toFinset C

/-- All semantic fresh conjugate-pair extensions of `C`. -/
noncomputable def globalLegalPairs (hdeg : Module.finrank F E = 2)
    (C : Finset (Point E)) : Finset (Sym2 (Point E)) := by
  classical
  exact Finset.univ.filter fun q =>
    IsFreshConjugatePair F E hdeg C q ∧ Arc (L := Point E) (C ∪ q.toFinset)

theorem mem_globalLegalPairs_iff (hdeg : Module.finrank F E = 2)
    (C : Finset (Point E)) (q : Sym2 (Point E)) :
    q ∈ globalLegalPairs F E hdeg C ↔
      IsFreshConjugatePair F E hdeg C q ∧ Arc (L := Point E) (C ∪ q.toFinset) := by
  classical
  simp [globalLegalPairs]

/-- The carrierwise union already counted by `PairExtensionData.legalCount`. -/
noncomputable def carrierwiseLegalPairs (hdeg : Module.finrank F E = 2)
    (C : Finset (Point E)) (hC : IsInvariant (incidence F E hdeg) C) :
    Finset (Sym2 (Point E)) := by
  classical
  exact (emptyFixedLines F E C).biUnion fun m =>
    conjugateCandidatesOnFixedLine F E hdeg m \
      coordinateForbidden F E hdeg C hC m

/-- A conjugate candidate determines its fixed carrier uniquely. -/
theorem candidate_carrier_unique (hdeg : Module.finrank F E = 2)
    {l m : FixedLine F E} {q : Sym2 (Point E)}
    (hql : q ∈ conjugateCandidatesOnFixedLine F E hdeg l)
    (hqm : q ∈ conjugateCandidatesOnFixedLine F E hdeg m) : l = m := by
  obtain ⟨x, hx⟩ := (mem_candidates_iff_exists F E hdeg l q).mp hql
  have hpxq : x.1.1 ∈ q := by
    rw [← hx, matePair, ← Sym2.mem_iff_mem, Sym2.mem_iff']
    exact Or.inl rfl
  by_contra hlm
  have hlm' : l.1 ≠ m.1 := by
    intro h
    exact hlm (Subtype.ext h)
  have hpm : x.1.1 ∈ m.1 :=
    candidate_mem_fixedLine F E hdeg m q hqm hpxq
  have hpfix := point_fixed_of_mem_two_fixedLines F E hdeg l m hlm' x.1.1 x.1.2 hpm
  exact x.2 hpfix

/-- The carrierwise candidate finsets, and hence their legal subsets, are pairwise disjoint. -/
theorem carrierwiseLegal_pairwiseDisjoint (hdeg : Module.finrank F E = 2)
    (C : Finset (Point E)) (hC : IsInvariant (incidence F E hdeg) C) :
    ((emptyFixedLines F E C : Finset (FixedLine F E)) : Set (FixedLine F E)).PairwiseDisjoint
      (fun m => conjugateCandidatesOnFixedLine F E hdeg m \
        coordinateForbidden F E hdeg C hC m) := by
  rw [Finset.pairwiseDisjoint_iff]
  intro l _hl m _hm hinter
  obtain ⟨q, hq⟩ := hinter
  have ⟨hql, hqm⟩ := Finset.mem_inter.mp hq
  exact candidate_carrier_unique F E hdeg
    (Finset.mem_sdiff.mp hql).1 (Finset.mem_sdiff.mp hqm).1

/-- A nonfixed point's conjugate pair belongs to the candidate finset on its mate line. -/
theorem conjugatePair_mem_mateLine_candidates (hdeg : Module.finrank F E = 2)
    (p : Point E) (hp : (incidence F E hdeg).pointConj p ≠ p) :
    s(p, (incidence F E hdeg).pointConj p) ∈
      conjugateCandidatesOnFixedLine F E hdeg (mateLine F E hdeg p hp) := by
  let m := mateLine F E hdeg p hp
  let x : NonfixedPointsOnFixedLine F E m :=
    ⟨⟨p, mateLine_incident F E hdeg p hp⟩, hp⟩
  apply (mem_candidates_iff_exists F E hdeg m _).2
  refine ⟨x, ?_⟩
  rfl

/-- A fresh conjugate pair whose union with `C` is an arc has an empty mate line. -/
theorem mateLine_mem_emptyFixedLines_of_arc_union (hdeg : Module.finrank F E = 2)
    (C : Finset (Point E)) (p : Point E)
    (hp : (incidence F E hdeg).pointConj p ≠ p)
    (hdisj : Disjoint
      s(p, (incidence F E hdeg).pointConj p).toFinset C)
    (hArc : Arc (L := Point E)
      (C ∪ s(p, (incidence F E hdeg).pointConj p).toFinset)) :
    mateLine F E hdeg p hp ∈ emptyFixedLines F E C := by
  classical
  let σp := (incidence F E hdeg).pointConj p
  let m := mateLine F E hdeg p hp
  have hpm : p ∈ m.1 := mateLine_incident F E hdeg p hp
  have hσpm : σp ∈ m.1 := by
    have hc := (incidence F E hdeg).incident_conj_iff p m.1 |>.2 hpm
    change (incidence F E hdeg).incident σp ((incidence F E hdeg).lineConj m.1) at hc
    rw [show (incidence F E hdeg).lineConj m.1 = m.1 by exact m.2] at hc
    exact hc
  rw [emptyFixedLines]
  apply Finset.mem_sdiff.mpr
  refine ⟨Finset.mem_univ _, ?_⟩
  intro hmocc
  obtain ⟨r, hrtrace⟩ := (Finset.mem_filter.mp hmocc).2
  have hrC := (Finset.mem_filter.mp hrtrace).1
  have hrm := (Finset.mem_filter.mp hrtrace).2
  have hpq : p ∈ s(p, σp).toFinset := by simp [Sym2.toFinset_mk_eq]
  have hσpq : σp ∈ s(p, σp).toFinset := by simp [Sym2.toFinset_mk_eq]
  have hpr : p ≠ r := by
    intro h
    exact (Finset.disjoint_left.mp hdisj) hpq (h ▸ hrC)
  have hσpr : σp ≠ r := by
    intro h
    exact (Finset.disjoint_left.mp hdisj) hσpq (h ▸ hrC)
  exact hArc (Finset.mem_union_right C hpq) (Finset.mem_union_right C hσpq)
    (Finset.mem_union_left _ hrC) hp.symm hpr hσpr ⟨m.1, hpm, hσpm, hrm⟩

/-- The semantic global finset is exactly the disjoint carrierwise union. -/
theorem globalLegalPairs_eq_carrierwiseLegalPairs (hdeg : Module.finrank F E = 2)
    (C : Finset (Point E)) (hArc : Arc (L := Point E) C)
    (hC : IsInvariant (incidence F E hdeg) C) :
    globalLegalPairs F E hdeg C = carrierwiseLegalPairs F E hdeg C hC := by
  classical
  ext q
  rw [mem_globalLegalPairs_iff]
  constructor
  · rintro ⟨⟨p, hp, rfl, hdisj⟩, hArcUnion⟩
    let m := mateLine F E hdeg p hp
    have hm : m ∈ emptyFixedLines F E C :=
      mateLine_mem_emptyFixedLines_of_arc_union F E hdeg C p hp hdisj hArcUnion
    have hcand := conjugatePair_mem_mateLine_candidates F E hdeg p hp
    apply Finset.mem_biUnion.mpr
    refine ⟨m, hm, Finset.mem_sdiff.mpr ⟨hcand, ?_⟩⟩
    let mm : {m // m ∈ emptyFixedLines F E C} := ⟨m, hm⟩
    rw [show coordinateForbidden F E hdeg C hC m =
        forbiddenCandidates F E hdeg C hC mm by
      exact coordinateForbidden_eq F E hdeg C hC mm]
    intro hforbidden
    obtain ⟨z, hzq, hzcovered⟩ :=
      (mem_forbiddenCandidates_iff_exists_covered F E hdeg C hArc hC mm _ hcand).1
        hforbidden
    have hzC : z ∉ C := by
      intro hz
      exact (Finset.disjoint_left.mp hdisj) hzq hz
    have hArcInsert : Arc (L := Point E) (insert z C) := by
      apply arc_mono (B := C ∪ s(p, (incidence F E hdeg).pointConj p).toFinset) _ hArcUnion
      intro x hx
      simp only [Finset.mem_insert] at hx
      rcases hx with rfl | hx
      · exact Finset.mem_union_right C hzq
      · exact Finset.mem_union_left _ hx
    exact ((arc_insert_iff_not_covered hArc hzC).1 hArcInsert) hzcovered
  · intro hq
    obtain ⟨m, hm, hqlegal⟩ := Finset.mem_biUnion.mp hq
    have hcand := (Finset.mem_sdiff.mp hqlegal).1
    have hnotforbidden := (Finset.mem_sdiff.mp hqlegal).2
    obtain ⟨x, hx⟩ := (mem_candidates_iff_exists F E hdeg m q).mp hcand
    have hdisj := candidate_disjoint_arc F E hdeg C ⟨m, hm⟩ q hcand
    refine ⟨⟨x.1.1, x.2, ?_, hdisj⟩, ?_⟩
    · exact hx.symm.trans rfl
    · let mm : {m // m ∈ emptyFixedLines F E C} := ⟨m, hm⟩
      have hnotforbidden' : q ∉ forbiddenCandidates F E hdeg C hC mm := by
        rw [← coordinateForbidden_eq F E hdeg C hC mm]
        exact hnotforbidden
      exact arc_union_candidate_of_not_mem_forbidden F E hdeg C hArc hC mm q hcand
        hnotforbidden'

/-- The semantic global count is exactly the existing carrierwise legal count. -/
theorem card_globalLegalPairs_eq_legalCount (hdeg : Module.finrank F E = 2)
    (C : Finset (Point E)) (hArc : Arc (L := Point E) C)
    (hC : IsInvariant (incidence F E hdeg) C) (k f e : ℕ)
    (hkcard : C.card = k) (hf : (fixedArcPoints F E C).card = f)
    (horbit : k = f + 2 * e) :
    (globalLegalPairs F E hdeg C).card =
      PairExtensionData.legalCount
        (coordinateQuadraticExtensionData F E hdeg C hArc hC k f e hkcard hf horbit).toPairExtensionData := by
  rw [globalLegalPairs_eq_carrierwiseLegalPairs F E hdeg C hArc hC]
  unfold carrierwiseLegalPairs
  rw [Finset.card_biUnion (carrierwiseLegal_pairwiseDisjoint F E hdeg C hC)]
  rfl

end
end QuadraticGlobalCount
end RelativeConicArcs
