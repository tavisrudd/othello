import RelativeConicArcs.Conic
import ProjectiveCap.FrameGridBridge

/-!
# Rules-only certificates for relative conic arcs

The checker ranges over raw nonzero coordinate vectors.  It checks only field arithmetic,
determinants, scalar equivalence, list membership, and the equation `XZ - Y² = 0`; the soundness
theorem is the sole bridge to projective incidence and `CompleteOutside`.
-/

open scoped LinearAlgebra.Projectivization

namespace RelativeConicArcs
namespace Certificate

open Conic ProjectiveBridge Projectivization

variable {K : Type*} [Field K] [Fintype K] [DecidableEq K]

noncomputable local instance : Fintype (Conic.Point K) := Fintype.ofFinite _
noncomputable local instance : DecidableEq (Conic.Point K) := Classical.decEq _

/-- A raw coordinate vector in `K³`, before projectivization. -/
abbrev Vec (K : Type*) := Fin 3 → K
/-- A raw point of the certificate: a nonzero coordinate vector.  Two raw points may represent the
same projective point; the checker compares them by the ray relation below. -/
abbrev RawPoint (K : Type*) [Zero K] := {v : Vec K // v ≠ 0}

/-- The projective point represented by a raw point. -/
def toPoint (v : RawPoint K) : Conic.Point K := Projectivization.mk K v.1 v.2

/-- The finite set of projective points represented by a list of raw points.  Repeated rays
collapse, so its cardinality can be smaller than the list length. -/
noncomputable def pointSet (xs : List (RawPoint K)) : Finset (Conic.Point K) := by
  classical
  exact xs.toFinset.image toPoint

/-- Two raw vectors span the same ray: one is a scalar multiple of the other.  On nonzero vectors
this is exactly equality of the represented projective points. -/
def RayEq (v w : Vec K) : Prop := ∃ a : K, a • w = v

/-- Decision procedure for the ray relation over a finite field: search the finitely many scalars.
It is kernel-reducible arithmetic, with no native evaluation. -/
def rayEq (v w : Vec K) : Bool :=
  Finset.fold (fun x y : Bool => x || y) false
    (fun a : K => decide (a • w = v)) Finset.univ

/-- Every listed raw point lies off the conic, expressed as nonvanishing of the conic form
`XZ - Y²` on its coordinate vector. -/
def RawDisjoint (xs : List (RawPoint K)) : Prop :=
  ∀ a ∈ xs, ProjectiveCap.Sym2Bridge.conicForm a.1 ≠ 0

/-- The arc condition in raw coordinates: any three pairwise ray-distinct listed vectors have
nonzero determinant, hence represent three noncollinear projective points. -/
def RawArc (xs : List (RawPoint K)) : Prop :=
  ∀ a ∈ xs, ∀ b ∈ xs, ∀ c ∈ xs,
    rayEq a.1 b.1 = false → rayEq a.1 c.1 = false → rayEq b.1 c.1 = false →
      Matrix.det ![a.1, b.1, c.1] ≠ 0

/-- Coverage of a raw vector, in the form needed for completeness outside the conic: the vector
lies on the conic, or represents a listed point, or lies on the secant of two ray-distinct listed
points. -/
def RawCovered (xs : List (RawPoint K)) (x : Vec K) : Prop :=
  ProjectiveCap.Sym2Bridge.conicForm x = 0 ∨
    (∃ a ∈ xs, rayEq x a.1 = true) ∨
    ∃ a ∈ xs, ∃ b ∈ xs,
      rayEq a.1 b.1 = false ∧ Matrix.det ![x, a.1, b.1] = 0

/-- Ordinary projective coverage: the raw vector represents a selected point or lies on a secant
of two projectively distinct selected points. Unlike `RawCovered`, there is no prescribed-conic
escape clause. -/
def RawOrdinaryCovered (xs : List (RawPoint K)) (x : Vec K) : Prop :=
  (∃ a ∈ xs, rayEq x a.1 = true) ∨
    ∃ a ∈ xs, ∃ b ∈ xs,
      rayEq a.1 b.1 = false ∧ Matrix.det ![x, a.1, b.1] = 0

/-- Coverage on the canonical projective representatives. -/
def RawCoverage (xs : List (RawPoint K)) : Prop :=
  (∀ y z : K, RawCovered xs ![1, y, z]) ∧
    (∀ z : K, RawCovered xs ![0, 1, z]) ∧
      RawCovered xs ![0, 0, 1]

/-- Ordinary coverage on all canonical projective representatives. -/
def RawOrdinaryCoverage (xs : List (RawPoint K)) : Prop :=
  (∀ y z : K, RawOrdinaryCovered xs ![1, y, z]) ∧
    (∀ z : K, RawOrdinaryCovered xs ![0, 1, z]) ∧
      RawOrdinaryCovered xs ![0, 0, 1]

instance (xs : List (RawPoint K)) (x : Vec K) : Decidable (RawCovered xs x) := by
  unfold RawCovered
  infer_instance

instance (xs : List (RawPoint K)) (x : Vec K) : Decidable (RawOrdinaryCovered xs x) := by
  unfold RawOrdinaryCovered
  infer_instance

/-- The full raw certificate condition: the listed points avoid the conic, form an arc, and cover
every canonical projective representative. -/
def RawValid (xs : List (RawPoint K)) : Prop :=
  RawDisjoint xs ∧ RawArc xs ∧ RawCoverage xs

instance (xs : List (RawPoint K)) : Decidable (RawDisjoint xs) := by
  apply decidable_of_iff
    (∀ i : Fin xs.length,
      ProjectiveCap.Sym2Bridge.conicForm (xs.get i).1 ≠ 0)
  unfold RawDisjoint
  exact (List.forall_mem_iff_get (l := xs)
    (p := fun a => ProjectiveCap.Sym2Bridge.conicForm a.1 ≠ 0)).symm

instance (xs : List (RawPoint K)) : Decidable (RawArc xs) := by
  apply decidable_of_iff
    (∀ i j k : Fin xs.length,
      rayEq (xs.get i).1 (xs.get j).1 = false →
      rayEq (xs.get i).1 (xs.get k).1 = false →
      rayEq (xs.get j).1 (xs.get k).1 = false →
      Matrix.det ![(xs.get i).1, (xs.get j).1, (xs.get k).1] ≠ 0)
  unfold RawArc
  simp only [List.forall_mem_iff_get]

instance (xs : List (RawPoint K)) : Decidable (RawCoverage xs) := by
  unfold RawCoverage
  infer_instance

instance (xs : List (RawPoint K)) : Decidable (RawOrdinaryCoverage xs) := by
  unfold RawOrdinaryCoverage
  infer_instance

/-- The executable checker.  `decide` is kernel reduction; no native evaluator is involved. -/
def check (xs : List (RawPoint K)) : Bool :=
  decide (RawDisjoint xs) && decide (RawArc xs) && decide (RawCoverage xs)

/-- Soundness of the executable checker: a `true` verdict yields the raw certificate condition.
The reduction is by kernel evaluation of the three decidable predicates. -/
theorem check_rawValid {xs : List (RawPoint K)} (h : check xs = true) : RawValid xs := by
  simp only [check, Bool.and_eq_true] at h
  exact ⟨of_decide_eq_true h.1.1, of_decide_eq_true h.1.2, of_decide_eq_true h.2⟩

omit [Fintype K] [DecidableEq K] in
/-- On nonzero vectors, the ray relation is exactly equality of the represented projective
points. -/
theorem rayEq_iff_mk_eq (v w : RawPoint K) :
    RayEq v.1 w.1 ↔ toPoint v = toPoint w := by
  exact (Projectivization.mk_eq_mk_iff' K v.1 w.1 v.2 w.2).symm

omit [Fintype K] in
private theorem fold_or_eq_true_iff {s : Finset K} {p : K → Bool} :
    Finset.fold (fun x y : Bool => x || y) false p s = true ↔
      ∃ a ∈ s, p a = true := by
  classical
  induction s using Finset.induction_on with
  | empty => simp
  | @insert a s ha ih =>
      rw [Finset.fold_insert ha]
      simp [ih]

/-- The Boolean ray test returns `true` exactly on ray-equal vectors. -/
theorem rayEq_eq_true_iff (v w : Vec K) : rayEq v w = true ↔ RayEq v w := by
  rw [rayEq, fold_or_eq_true_iff]
  simp [RayEq]

/-- The Boolean ray test returns `false` exactly on vectors spanning different rays. -/
theorem rayEq_eq_false_iff (v w : Vec K) : rayEq v w = false ↔ ¬ RayEq v w := by
  rw [Bool.eq_false_iff]
  exact not_congr (rayEq_eq_true_iff v w)

omit [Fintype K] in
/-- A projective point belongs to the represented point set exactly when some listed raw point
represents it. -/
theorem mem_pointSet {xs : List (RawPoint K)} {p : Conic.Point K} :
    p ∈ pointSet xs ↔ ∃ v ∈ xs, toPoint v = p := by
  classical
  simp [pointSet]

omit [Fintype K] in
/-- The represented point set has at most as many points as the list has entries. -/
theorem pointSet_card_le_length (xs : List (RawPoint K)) :
    (pointSet xs).card ≤ xs.length := by
  classical
  calc
    (pointSet xs).card ≤ xs.toFinset.card := Finset.card_image_le
    _ ≤ xs.length := by simpa using xs.toFinset_card_le

omit [Fintype K] in
private theorem normalized_rep (p : Conic.Point K) :
    (∃ y z : K, ∃ hn : (![1, y, z] : Vec K) ≠ 0,
      Projectivization.mk K ![1, y, z] hn = p) ∨
    (∃ z : K, ∃ hn : (![0, 1, z] : Vec K) ≠ 0,
      Projectivization.mk K ![0, 1, z] hn = p) ∨
    ∃ hn : (![0, 0, 1] : Vec K) ≠ 0,
      Projectivization.mk K ![0, 0, 1] hn = p := by
  by_cases h0 : p.rep 0 = 0
  · by_cases h1 : p.rep 1 = 0
    · right; right
      have h2 : p.rep 2 ≠ 0 := by
        intro h2
        apply p.rep_nonzero
        funext i
        fin_cases i <;> assumption
      have hn : (![0, 0, 1] : Vec K) ≠ 0 := by
        intro h
        have hh := congrFun h 2
        simp at hh
      refine ⟨hn, ?_⟩
      rw [← Projectivization.mk_rep p]
      apply (Projectivization.mk_eq_mk_iff' K _ _ hn p.rep_nonzero).mpr
      refine ⟨(p.rep 2)⁻¹, ?_⟩
      funext i
      fin_cases i <;> simp [h0, h1, h2]
    · right; left
      let z := p.rep 2 / p.rep 1
      have hn : (![0, 1, z] : Vec K) ≠ 0 := by
        intro h
        have hh := congrFun h 1
        simp at hh
      refine ⟨z, hn, ?_⟩
      rw [← Projectivization.mk_rep p]
      apply (Projectivization.mk_eq_mk_iff' K _ _ hn p.rep_nonzero).mpr
      refine ⟨(p.rep 1)⁻¹, ?_⟩
      funext i
      fin_cases i <;> simp [z, h0, h1, div_eq_mul_inv, mul_comm]
  · left
    let y := p.rep 1 / p.rep 0
    let z := p.rep 2 / p.rep 0
    have hn : (![1, y, z] : Vec K) ≠ 0 := by
      intro h
      have hh := congrFun h 0
      simp at hh
    refine ⟨y, z, hn, ?_⟩
    rw [← Projectivization.mk_rep p]
    apply (Projectivization.mk_eq_mk_iff' K _ _ hn p.rep_nonzero).mpr
    refine ⟨(p.rep 0)⁻¹, ?_⟩
    funext i
    fin_cases i <;> simp [y, z, h0, div_eq_mul_inv] <;> ac_rfl

/-- The raw arc condition transports to the incidence-theoretic arc condition on the represented
projective point set. -/
theorem rawValid_arc {xs : List (RawPoint K)} (h : RawValid xs) :
    Arc (L := Conic.Point K) (pointSet xs) := by
  rw [ProjectiveBridge.arc_iff_projectiveCap]
  intro p q r hp hq hr hpq hpr hqr hcol
  obtain ⟨a, ha, rfl⟩ := mem_pointSet.mp hp
  obtain ⟨b, hb, rfl⟩ := mem_pointSet.mp hq
  obtain ⟨c, hc, rfl⟩ := mem_pointSet.mp hr
  have hab : rayEq a.1 b.1 = false := (rayEq_eq_false_iff _ _).mpr
    (fun hab => hpq ((rayEq_iff_mk_eq a b).mp hab))
  have hac : rayEq a.1 c.1 = false := (rayEq_eq_false_iff _ _).mpr
    (fun hac => hpr ((rayEq_iff_mk_eq a c).mp hac))
  have hbc : rayEq b.1 c.1 = false := (rayEq_eq_false_iff _ _).mpr
    (fun hbc => hqr ((rayEq_iff_mk_eq b c).mp hbc))
  exact (h.2.1 a ha b hb c hc hab hac hbc)
    ((ProjectiveCap.Projective.FrameGridBridge.Coordinate.mk_collinear_iff_det_eq_zero
      a.2 b.2 c.2).mp hcol)

/-- Raw determinant arc validity is exactly projective cap validity for the represented point
set.  Unlike `rawValid_arc`, this theorem does not require disjointness or coverage data, so it
can be applied to arbitrary continuations of a certified seed. -/
theorem rawArc_iff_projectiveCap {xs : List (RawPoint K)} :
    RawArc xs ↔
      ProjectiveCap.Projective.Cap K (Fin 3 → K) (pointSet xs) := by
  constructor
  · intro hraw
    rw [← ProjectiveBridge.arc_iff_projectiveCap]
    intro p q r hp hq hr hpq hpr hqr hcol
    obtain ⟨a, ha, rfl⟩ := mem_pointSet.mp hp
    obtain ⟨b, hb, rfl⟩ := mem_pointSet.mp hq
    obtain ⟨c, hc, rfl⟩ := mem_pointSet.mp hr
    have hab : rayEq a.1 b.1 = false := (rayEq_eq_false_iff _ _).mpr
      (fun hab => hpq ((rayEq_iff_mk_eq a b).mp hab))
    have hac : rayEq a.1 c.1 = false := (rayEq_eq_false_iff _ _).mpr
      (fun hac => hpr ((rayEq_iff_mk_eq a c).mp hac))
    have hbc : rayEq b.1 c.1 = false := (rayEq_eq_false_iff _ _).mpr
      (fun hbc => hqr ((rayEq_iff_mk_eq b c).mp hbc))
    exact (hraw a ha b hb c hc hab hac hbc)
      ((ProjectiveCap.Projective.FrameGridBridge.Coordinate.mk_collinear_iff_det_eq_zero
        a.2 b.2 c.2).mp
        (ProjectiveBridge.collinear_iff_projective_collinear.mp hcol))
  · intro hcap a ha b hb c hc hab hac hbc hdet
    have hpq : toPoint a ≠ toPoint b := fun heq => by
      have hray := (rayEq_eq_true_iff _ _).mpr ((rayEq_iff_mk_eq a b).mpr heq)
      rw [hab] at hray
      contradiction
    have hpr : toPoint a ≠ toPoint c := fun heq => by
      have hray := (rayEq_eq_true_iff _ _).mpr ((rayEq_iff_mk_eq a c).mpr heq)
      rw [hac] at hray
      contradiction
    have hqr : toPoint b ≠ toPoint c := fun heq => by
      have hray := (rayEq_eq_true_iff _ _).mpr ((rayEq_iff_mk_eq b c).mpr heq)
      rw [hbc] at hray
      contradiction
    exact hcap (mem_pointSet.mpr ⟨a, ha, rfl⟩) (mem_pointSet.mpr ⟨b, hb, rfl⟩)
      (mem_pointSet.mpr ⟨c, hc, rfl⟩) hpq hpr hqr
      ((ProjectiveCap.Projective.FrameGridBridge.Coordinate.mk_collinear_iff_det_eq_zero
        a.2 b.2 c.2).mpr hdet)

/-- The raw disjointness condition transports to disjointness of the represented point set from
the standard conic. -/
theorem rawValid_disjoint {xs : List (RawPoint K)} (h : RawValid xs) :
    Disjoint (pointSet xs) (standardConic (K := K)) := by
  classical
  rw [Finset.disjoint_left]
  intro p hpA hpC
  obtain ⟨a, ha, rfl⟩ := mem_pointSet.mp hpA
  have hon : ProjectiveCap.Sym2Bridge.OnConic (toPoint a) :=
    (mem_standardConic_iff_onConic.mp hpC)
  exact h.1 a ha ((ProjectiveCap.Sym2Bridge.onConic_mk a.1 a.2).mp hon)

/-- Soundness of the certificate: a valid raw certificate represents an arc that is complete
outside the standard conic.  This theorem is the sole bridge from the checker's field arithmetic
to projective incidence. -/
theorem rawValid_complete {xs : List (RawPoint K)} (h : RawValid xs) :
    CompleteOutside (L := Conic.Point K) (pointSet xs) (standardConic (K := K)) := by
  classical
  refine ⟨rawValid_arc h, rawValid_disjoint h, ?_⟩
  intro p hpA hpC
  obtain ⟨n, hn, hnp, hncover⟩ : ∃ n : Vec K, ∃ hn : n ≠ 0,
      Projectivization.mk K n hn = p ∧ RawCovered xs n := by
    rcases normalized_rep p with ⟨y, z, hn, hp⟩ | ⟨z, hn, hp⟩ | ⟨hn, hp⟩
    · exact ⟨![1, y, z], hn, hp, h.2.2.1 y z⟩
    · exact ⟨![0, 1, z], hn, hp, h.2.2.2.1 z⟩
    · exact ⟨![0, 0, 1], hn, hp, h.2.2.2.2⟩
  let x : RawPoint K := ⟨n, hn⟩
  rcases hncover with hzero | hmember | hsec
  · exfalso
    apply hpC
    apply mem_standardConic_iff_onConic.mpr
    rw [← hnp]
    exact (ProjectiveCap.Sym2Bridge.onConic_mk n hn).mpr hzero
  · obtain ⟨a, ha, hxa⟩ := hmember
    exfalso
    apply hpA
    apply mem_pointSet.mpr
    refine ⟨a, ha, ?_⟩
    exact ((rayEq_iff_mk_eq x a).mp ((rayEq_eq_true_iff _ _).mp hxa)).symm.trans hnp
  · obtain ⟨a, ha, b, hb, hab, hdet⟩ := hsec
    have habp : toPoint a ≠ toPoint b := fun heq => by
      have ht := (rayEq_eq_true_iff _ _).mpr ((rayEq_iff_mk_eq a b).mpr heq)
      rw [hab] at ht
      contradiction
    apply covered_of_collinear_pair (L := Conic.Point K)
      (mem_pointSet.mpr ⟨a, ha, rfl⟩) (mem_pointSet.mpr ⟨b, hb, rfl⟩) habp
    rw [ProjectiveBridge.collinear_iff_projective_collinear, ← hnp]
    exact (ProjectiveCap.Projective.FrameGridBridge.Coordinate.mk_collinear_iff_det_eq_zero
      x.2 a.2 b.2).mpr hdet

/-- A relative certificate whose selected points or secants cover every canonical representative
is an ordinary complete arc (`CompleteOutside A ∅`). This reuses the same normalization and
determinant-to-incidence bridge as `rawValid_complete`; the stronger coverage predicate removes the
conic escape branch. -/
theorem rawValid_complete_empty {xs : List (RawPoint K)} (h : RawValid xs)
    (hcoverage : RawOrdinaryCoverage xs) :
    CompleteOutside (L := Conic.Point K) (pointSet xs) ∅ := by
  classical
  refine ⟨rawValid_arc h, by simp, ?_⟩
  intro p hpA _hpEmpty
  obtain ⟨n, hn, hnp, hncover⟩ : ∃ n : Vec K, ∃ hn : n ≠ 0,
      Projectivization.mk K n hn = p ∧ RawOrdinaryCovered xs n := by
    rcases normalized_rep p with ⟨y, z, hn, hp⟩ | ⟨z, hn, hp⟩ | ⟨hn, hp⟩
    · exact ⟨![1, y, z], hn, hp, hcoverage.1 y z⟩
    · exact ⟨![0, 1, z], hn, hp, hcoverage.2.1 z⟩
    · exact ⟨![0, 0, 1], hn, hp, hcoverage.2.2⟩
  let x : RawPoint K := ⟨n, hn⟩
  rcases hncover with hmember | hsec
  · obtain ⟨a, ha, hxa⟩ := hmember
    exfalso
    apply hpA
    apply mem_pointSet.mpr
    refine ⟨a, ha, ?_⟩
    exact ((rayEq_iff_mk_eq x a).mp ((rayEq_eq_true_iff _ _).mp hxa)).symm.trans hnp
  · obtain ⟨a, ha, b, hb, hab, hdet⟩ := hsec
    have habp : toPoint a ≠ toPoint b := fun heq => by
      have ht := (rayEq_eq_true_iff _ _).mpr ((rayEq_iff_mk_eq a b).mpr heq)
      rw [hab] at ht
      contradiction
    apply covered_of_collinear_pair (L := Conic.Point K)
      (mem_pointSet.mpr ⟨a, ha, rfl⟩) (mem_pointSet.mpr ⟨b, hb, rfl⟩) habp
    rw [ProjectiveBridge.collinear_iff_projective_collinear, ← hnp]
    exact (ProjectiveCap.Projective.FrameGridBridge.Coordinate.mk_collinear_iff_det_eq_zero
      x.2 a.2 b.2).mpr hdet

/-- Acceptance is sufficient for the full semantic relative-completeness predicate. -/
theorem check_sound {xs : List (RawPoint K)} (h : check xs = true) :
    CompleteOutside (L := Conic.Point K) (pointSet xs) (standardConic (K := K)) :=
  rawValid_complete (check_rawValid h)

/-- A successful relative certificate plus ordinary canonical coverage proves ordinary
completeness. -/
theorem check_sound_empty {xs : List (RawPoint K)} (h : check xs = true)
    (hcoverage : RawOrdinaryCoverage xs) :
    CompleteOutside (L := Conic.Point K) (pointSet xs) ∅ :=
  rawValid_complete_empty (check_rawValid h) hcoverage

/-- A successful list certificate gives an immediate numerical upper bound, even if the list
contains repeated projective representatives. -/
theorem rhoC_le_length_of_check {xs : List (RawPoint K)} (h : check xs = true) :
    rhoC (K := K) ≤ xs.length := by
  classical
  letI : Fintype (Conic.Point K) := Fintype.ofFinite _
  letI : DecidableEq (Conic.Point K) := Classical.decEq _
  rw [rhoC]
  exact (rho_le_card (L := Conic.Point K) (check_sound h)).trans
    (pointSet_card_le_length xs)

end Certificate
end RelativeConicArcs
