import RelativeConicArcs.Defect
import RelativeConicArcs.ProjectiveBridge
import ProjectiveCap.Sym2ConicBridge
import Mathlib.LinearAlgebra.Projectivization.Cardinality

/-!
# Nonsingular conics and finite lower bounds

The standard conic is the Veronese image of `PG(1,K)` in `PG(2,K)`.  A nonsingular conic is
represented by a linear projective image of this standard model, making projective normalization
part of the data rather than an external classification assumption.
-/

open scoped LinearAlgebra.Projectivization

namespace RelativeConicArcs
namespace Conic

open Configuration Projectivization

section AbstractPlane

variable {P L : Type*} [Membership P L]
  [Fintype P] [Fintype L] [DecidableEq P] [DecidableEq L]
  [Configuration.ProjectivePlane P L]

omit [DecidableEq L] in
theorem card_requiredLocus_of_card_holes {A H : Finset P} (hdisj : Disjoint A H)
    (hH : H.card = PlaneOrder P L + 1) :
    (requiredLocus A H).card = PlaneOrder P L ^ 2 - A.card := by
  rw [requiredLocus, Finset.card_sdiff]
  simp only [Finset.inter_univ, Finset.card_univ]
  rw [Finset.card_union_of_disjoint hdisj, hH,
    RelativeConicArcs.card_points (P := P) (L := L)]
  omega

/-- The conic specialization uses only the hole cardinality `q+1`; no coordinate geometry enters
the counting argument. -/
theorem completeOutside_bound_of_card_holes {A H : Finset P}
    (hcomplete : CompleteOutside (L := L) A H)
    (hH : H.card = PlaneOrder P L + 1) :
    (A.card / 2) * (PlaneOrder P L ^ 2 - A.card)
        + holeIncidence (L := L) A H + 6 * Nat.choose A.card 4 ≤
      (A.card / 2) * (Nat.choose A.card 2 * (PlaneOrder P L - 1)) := by
  have hempty : uncovered (L := L) A H = ∅ :=
    (completeOutside_iff_uncovered_eq_empty (L := L)).mp hcomplete |>.2.2
  have hbound := uncovered_bound (L := L) hcomplete.1 hcomplete.2.1
  rw [card_requiredLocus_of_card_holes hcomplete.2.1 hH, hempty] at hbound
  simpa using hbound

/-- Dropping the nonnegative hole-incidence term gives the corrected universal capacity bound. -/
theorem corrected_capacity_bound_of_card_holes {A H : Finset P}
    (hcomplete : CompleteOutside (L := L) A H)
    (hH : H.card = PlaneOrder P L + 1) :
    (A.card / 2) * (PlaneOrder P L ^ 2 - A.card) + 6 * Nat.choose A.card 4 ≤
      (A.card / 2) * (Nat.choose A.card 2 * (PlaneOrder P L - 1)) := by
  have h := completeOutside_bound_of_card_holes (L := L) hcomplete hH
  omega

/-- The first-moment capacity bound, before the second-moment correction. -/
theorem naive_capacity_bound_of_card_holes {A H : Finset P}
    (hcomplete : CompleteOutside (L := L) A H)
    (hH : H.card = PlaneOrder P L + 1) :
    PlaneOrder P L ^ 2 - A.card ≤
      Nat.choose A.card 2 * (PlaneOrder P L - 1) := by
  classical
  have hempty : uncovered (L := L) A H = ∅ :=
    (completeOutside_iff_uncovered_eq_empty (L := L)).mp hcomplete |>.2.2
  have hcovered : coveredRequired (L := L) A H = requiredLocus A H := by
    rw [← covered_union_uncovered (L := L) A H, hempty, Finset.union_empty]
  have hcard : (requiredLocus A H).card ≤
      ∑ x ∈ coveredRequired (L := L) A H, pointIndex (L := L) A x := by
    rw [hcovered]
    have hsum := Finset.card_nsmul_le_sum (requiredLocus A H)
      (pointIndex (L := L) A) 1 (fun x hx => by
        have : x ∈ coveredRequired (L := L) A H := hcovered.symm ▸ hx
        exact (Finset.mem_filter.mp this).2)
    simpa using hsum
  have hfirst := first_secant_moment_split (L := L) hcomplete.1 hcomplete.2.1
  rw [card_requiredLocus_of_card_holes hcomplete.2.1 hH] at hcard
  omega

theorem completeOutside_card_ge_three_of_card_holes {A H : Finset P}
    (hcomplete : CompleteOutside (L := L) A H)
    (hH : H.card = PlaneOrder P L + 1) : 3 ≤ A.card := by
  have hbound := naive_capacity_bound_of_card_holes (L := L) hcomplete hH
  have hq := Configuration.ProjectivePlane.one_lt_order P L
  change 1 < PlaneOrder P L at hq
  by_contra hcard
  interval_cases A.card <;> norm_num [Nat.choose] at hbound ⊢
  · omega
  · have hsquare : PlaneOrder P L ^ 2 ≤ 1 := Nat.sub_eq_zero_iff_le.mp hbound
    nlinarith
  · have hsimp : PlaneOrder P L - 1 + 2 = PlaneOrder P L + 1 := by omega
    rw [hsimp] at hbound
    nlinarith

end AbstractPlane

/-- The uncorrected first-moment arithmetic condition. -/
def L1Admissible (q k : ℕ) : Prop :=
  3 ≤ k ∧ q ^ 2 - k ≤ Nat.choose k 2 * (q - 1)

/-- The subtraction-free, second-moment-corrected arithmetic condition. -/
def L2Admissible (q k : ℕ) : Prop :=
  3 ≤ k ∧
    (k / 2) * (q ^ 2 - k) + 6 * Nat.choose k 4 ≤
      (k / 2) * (Nat.choose k 2 * (q - 1))

/-- The first-moment lower-bound threshold. -/
noncomputable def L1 (q : ℕ) : ℕ := sInf {k : ℕ | L1Admissible q k}

/-- The second-moment-corrected lower-bound threshold. -/
noncomputable def L2 (q : ℕ) : ℕ := sInf {k : ℕ | L2Admissible q k}

/-- The rational corrected capacity appearing in the manuscript. -/
noncomputable def correctedCapacityQ (q k : ℕ) : ℚ :=
  (Nat.choose k 2 : ℚ) * (q - 1 : ℕ) -
    6 / (k / 2 : ℕ) * (Nat.choose k 4 : ℚ)

theorem twentyFour_mul_choose_four (k : ℕ) :
    24 * Nat.choose k 4 = k * (k - 1) * (k - 2) * (k - 3) := by
  have h := Nat.descFactorial_eq_factorial_mul_choose k 4
  norm_num [Nat.descFactorial, Nat.factorial] at h
  simpa [mul_comm, mul_left_comm, mul_assoc] using h.symm

/-- Corrected capacity for even `k = 2n`. -/
theorem correctedCapacityQ_even (q n : ℕ) (hn : 2 ≤ n) :
    correctedCapacityQ q (2 * n) =
      (((2 * n - 1 : ℕ) : ℚ) / 2) *
        (((2 * n : ℕ) : ℚ) * (q - 1 : ℕ) -
          ((2 * n - 2 : ℕ) : ℚ) * (2 * n - 3 : ℕ)) := by
  unfold correctedCapacityQ
  have hm : 2 * n / 2 = n := by omega
  rw [hm]
  have h2 : (Nat.choose (2 * n) 2 : ℚ) =
      ((2 * n : ℕ) : ℚ) * ((2 * n - 1 : ℕ) : ℚ) / 2 := by
    apply (eq_div_iff (by norm_num : (2 : ℚ) ≠ 0)).mpr
    exact_mod_cast (by simpa [mul_comm] using two_mul_choose_two (2 * n))
  have h4n := twentyFour_mul_choose_four (2 * n)
  have h4 : (Nat.choose (2 * n) 4 : ℚ) =
      ((2 * n : ℕ) : ℚ) * ((2 * n - 1 : ℕ) : ℚ) *
        ((2 * n - 2 : ℕ) : ℚ) * ((2 * n - 3 : ℕ) : ℚ) / 24 := by
    apply (eq_div_iff (by norm_num : (24 : ℚ) ≠ 0)).mpr
    exact_mod_cast (by simpa [mul_comm] using h4n)
  rw [h2, h4]
  norm_num
  field_simp [show (n : ℚ) ≠ 0 by exact_mod_cast (by omega : n ≠ 0)]
  ring

/-- Corrected capacity for odd `k = 2n+1`. -/
theorem correctedCapacityQ_odd (q n : ℕ) (hn : 1 ≤ n) :
    correctedCapacityQ q (2 * n + 1) =
      (((2 * n + 1 : ℕ) : ℚ) / 2) *
        (((2 * n : ℕ) : ℚ) * (q - 1 : ℕ) -
          ((2 * n - 1 : ℕ) : ℚ) * (2 * n - 2 : ℕ)) := by
  unfold correctedCapacityQ
  have hm : (2 * n + 1) / 2 = n := by omega
  rw [hm]
  have h2 : (Nat.choose (2 * n + 1) 2 : ℚ) =
      ((2 * n + 1 : ℕ) : ℚ) * ((2 * n : ℕ) : ℚ) / 2 := by
    apply (eq_div_iff (by norm_num : (2 : ℚ) ≠ 0)).mpr
    have h := two_mul_choose_two (2 * n + 1)
    have hs : 2 * n + 1 - 1 = 2 * n := by omega
    rw [hs] at h
    exact_mod_cast (by simpa [mul_comm] using h)
  have h4n := twentyFour_mul_choose_four (2 * n + 1)
  have h4 : (Nat.choose (2 * n + 1) 4 : ℚ) =
      ((2 * n + 1 : ℕ) : ℚ) * ((2 * n : ℕ) : ℚ) *
        ((2 * n - 1 : ℕ) : ℚ) * ((2 * n - 2 : ℕ) : ℚ) / 24 := by
    apply (eq_div_iff (by norm_num : (24 : ℚ) ≠ 0)).mpr
    have hs1 : 2 * n + 1 - 1 = 2 * n := by omega
    have hs2 : 2 * n + 1 - 2 = 2 * n - 1 := by omega
    have hs3 : 2 * n + 1 - 3 = 2 * n - 2 := by omega
    rw [hs1, hs2, hs3] at h4n
    exact_mod_cast (by simpa [mul_comm] using h4n)
  rw [h2, h4]
  norm_num
  field_simp [show (n : ℚ) ≠ 0 by exact_mod_cast (by omega : n ≠ 0)]
  ring

theorem l2Admissible_l1Admissible {q k : ℕ} (h : L2Admissible q k) :
    L1Admissible q k := by
  rcases h with ⟨hk, hbound⟩
  refine ⟨hk, ?_⟩
  have hm : 0 < k / 2 := Nat.div_pos (by omega : 2 ≤ k) (by omega)
  have hmul : (k / 2) * (q ^ 2 - k) ≤
      (k / 2) * (Nat.choose k 2 * (q - 1)) :=
    (Nat.le_add_right _ _).trans hbound
  exact Nat.le_of_mul_le_mul_left hmul hm

section Transport

variable {P L : Type*} [Membership P L]
  [Fintype P] [Fintype L] [DecidableEq P]

omit [Fintype P] [DecidableEq P] in
theorem covered_iff_collinear_pair {A : Finset P} {x : P} :
    Covered (L := L) A x ↔
      ∃ a ∈ A, ∃ b ∈ A, a ≠ b ∧ Collinear (L := L) x a b := by
  constructor
  · rw [covered_iff_exists_secant]
    rintro ⟨l, ⟨a, ha, b, hb, hab, hal, hbl⟩, hxl⟩
    exact ⟨a, ha, b, hb, hab, l, hxl, hal, hbl⟩
  · rintro ⟨a, ha, b, hb, hab, hcol⟩
    exact covered_of_collinear_pair (L := L) ha hb hab hcol

variable [Configuration.ProjectivePlane P L]

omit [Fintype P] [DecidableEq P] [Configuration.ProjectivePlane P L] in
/-- Relative completeness is preserved by any point permutation preserving collinearity. -/
theorem completeOutside_map (e : P ≃ P)
    (hcol : ∀ x a b, Collinear (L := L) (e x) (e a) (e b) ↔ Collinear (L := L) x a b)
    {A H : Finset P} (hcomplete : CompleteOutside (L := L) A H) :
    CompleteOutside (L := L) (A.map e.toEmbedding) (H.map e.toEmbedding) := by
  classical
  refine ⟨?_, ?_, ?_⟩
  · intro a b c ha hb hc hab hac hbc hmapped
    rw [Finset.mem_map_equiv] at ha hb hc
    apply hcomplete.1 ha hb hc
      (fun h => hab (by simpa using congrArg e h))
      (fun h => hac (by simpa using congrArg e h))
      (fun h => hbc (by simpa using congrArg e h))
    have := (hcol (e.symm a) (e.symm b) (e.symm c)).mp (by simpa using hmapped)
    exact this
  · rw [Finset.disjoint_left]
    intro x hxA hxH
    rw [Finset.mem_map_equiv] at hxA hxH
    exact (Finset.disjoint_left.mp hcomplete.2.1) hxA hxH
  · intro x hxA hxH
    have hxA' : e.symm x ∉ A := by simpa [Finset.mem_map_equiv] using hxA
    have hxH' : e.symm x ∉ H := by simpa [Finset.mem_map_equiv] using hxH
    obtain ⟨a, ha, b, hb, hab, hxab⟩ :=
      covered_iff_collinear_pair.mp (hcomplete.2.2 (e.symm x) hxA' hxH')
    apply covered_iff_collinear_pair.mpr
    refine ⟨e a, by simp [ha], e b,
      by simp [hb], e.injective.ne hab, ?_⟩
    simpa using (hcol (e.symm x) a b).mpr hxab

/-- The relative-completeness parameter is invariant under a collinearity-preserving permutation. -/
theorem rho_map_eq (e : P ≃ P)
    (hcol : ∀ x a b, Collinear (L := L) (e x) (e a) (e b) ↔ Collinear (L := L) x a b)
    (H : Finset P) :
    rho (L := L) (H.map e.toEmbedding) = rho (L := L) H := by
  classical
  apply Nat.le_antisymm
  · obtain ⟨A, hA, hcard⟩ := exists_completeOutside_card_eq_rho (L := L) H
    have hmap := completeOutside_map (L := L) e hcol hA
    have hle := rho_le_card (L := L) hmap
    simpa [hcard] using hle
  · obtain ⟨B, hB, hcard⟩ :=
      exists_completeOutside_card_eq_rho (L := L) (H.map e.toEmbedding)
    have hcol' : ∀ x a b,
        Collinear (L := L) (e.symm x) (e.symm a) (e.symm b) ↔ Collinear (L := L) x a b := by
      intro x a b
      simpa using (hcol (e.symm x) (e.symm a) (e.symm b)).symm
    have hback := completeOutside_map (L := L) e.symm hcol' hB
    have htwice : (H.map e.toEmbedding).map e.symm.toEmbedding = H := by
      ext x
      simp [Finset.mem_map_equiv]
    rw [htwice] at hback
    have hle := rho_le_card (L := L) hback
    simpa [hcard] using hle

end Transport

variable {K : Type*} [Field K]

abbrev LineSpace (K : Type*) := ProjectiveCap.Sym2Bridge.Line K
abbrev PlaneSpace (K : Type*) := ProjectiveCap.Sym2Bridge.Plane K
abbrev LinePoint (K : Type*) [Field K] := Projectivization K (LineSpace K)
abbrev Point (K : Type*) [Field K] := ProjectiveBridge.Point K

/-- The standard conic `XZ = Y²`, parametrized by the projective line. -/
noncomputable def standardConic [Fintype K] [DecidableEq K] : Finset (Point K) := by
  letI : Fintype (LinePoint K) := Fintype.ofFinite (LinePoint K)
  exact Finset.univ.map ProjectiveCap.Sym2Bridge.veronesePointEmb

@[simp] theorem mem_standardConic [Fintype K] [DecidableEq K] {p : Point K} :
    p ∈ standardConic (K := K) ↔
      ∃ t : LinePoint K, ProjectiveCap.Sym2Bridge.veronesePoint t = p := by
  classical
  letI : Fintype (LinePoint K) := Fintype.ofFinite (LinePoint K)
  simp [standardConic]

theorem standardConic_card [Fintype K] [DecidableEq K] :
    (standardConic (K := K)).card = Fintype.card K + 1 := by
  classical
  letI : Fintype (LinePoint K) := Fintype.ofFinite (LinePoint K)
  rw [standardConic, Finset.card_map, Finset.card_univ, ← Nat.card_eq_fintype_card]
  simpa [Nat.card_eq_fintype_card] using
    (Projectivization.card_of_finrank_two K (LineSpace K) (by simp))

/-- The relative-completeness parameter for the standard nonsingular conic. -/
noncomputable def rhoC [Fintype K] [DecidableEq K] : ℕ := by
  letI : Fintype (Point K) := Fintype.ofFinite (Point K)
  letI : DecidableEq (Point K) := Classical.decEq (Point K)
  exact rho (L := Point K) (standardConic (K := K))

theorem standardConic_subset_zeroLocus [Fintype K] [DecidableEq K] :
    ∀ p ∈ standardConic (K := K), ProjectiveCap.Sym2Bridge.OnConic p := by
  intro p hp
  obtain ⟨t, rfl⟩ := mem_standardConic.mp hp
  exact ProjectiveCap.Sym2Bridge.veronesePoint_onConic t

/-- The Veronese parametrization is exactly the projective zero locus `XZ = Y²`. -/
theorem mem_standardConic_iff_onConic [Fintype K] [DecidableEq K] {p : Point K} :
    p ∈ standardConic (K := K) ↔ ProjectiveCap.Sym2Bridge.OnConic p := by
  classical
  constructor
  · exact standardConic_subset_zeroLocus p
  · intro hp
    have heq : p.rep 1 ^ 2 = p.rep 0 * p.rep 2 := by
      unfold ProjectiveCap.Sym2Bridge.OnConic ProjectiveCap.Sym2Bridge.conicForm at hp
      linear_combination hp
    by_cases hx : p.rep 0 = 0
    · have hy : p.rep 1 = 0 := by
        have : p.rep 1 ^ 2 = 0 := by simpa [hx] using heq
        exact pow_eq_zero_iff (n := 2) (by norm_num) |>.mp this
      have hz : p.rep 2 ≠ 0 := by
        intro hz
        apply p.rep_nonzero
        funext i
        fin_cases i <;> assumption
      let v : LineSpace K := ![0, 1]
      have hv : v ≠ 0 := by
        intro h
        have := congrFun h 1
        simp [v] at this
      let t : LinePoint K := Projectivization.mk K v hv
      apply mem_standardConic.mpr
      refine ⟨t, ?_⟩
      rw [ProjectiveCap.Sym2Bridge.veronesePoint_mk, ← Projectivization.mk_rep p]
      apply (Projectivization.mk_eq_mk_iff' K _ _ _ _).mpr
      refine ⟨(p.rep 2)⁻¹, ?_⟩
      funext i
      fin_cases i
      · simp [v, ProjectiveCap.Sym2Bridge.veronese, hx]
      · simp [v, ProjectiveCap.Sym2Bridge.veronese, hy]
      · simp [v, ProjectiveCap.Sym2Bridge.veronese, hz]
    · let v : LineSpace K := ![p.rep 0, p.rep 1]
      have hv : v ≠ 0 := by
        intro h
        exact hx (by simpa [v] using congrFun h 0)
      let t : LinePoint K := Projectivization.mk K v hv
      apply mem_standardConic.mpr
      refine ⟨t, ?_⟩
      rw [ProjectiveCap.Sym2Bridge.veronesePoint_mk, ← Projectivization.mk_rep p]
      apply (Projectivization.mk_eq_mk_iff' K _ _ _ _).mpr
      refine ⟨p.rep 0, ?_⟩
      funext i
      fin_cases i
      · simp [v, ProjectiveCap.Sym2Bridge.veronese, pow_two]
      · simp [v, ProjectiveCap.Sym2Bridge.veronese]
      · simpa [v, ProjectiveCap.Sym2Bridge.veronese] using heq.symm

/-- A nonsingular coordinate conic is, equivalently, a projective linear image of the standard
Veronese conic.  This orbit presentation includes its normalization map explicitly. -/
structure NonsingularConic [Fintype K] [DecidableEq K] where
  coordinateChange : PlaneSpace K ≃ₗ[K] PlaneSpace K

namespace NonsingularConic

variable [Fintype K] [DecidableEq K]

noncomputable local instance instFintypePoint : Fintype (Point K) :=
  Fintype.ofFinite (Point K)

noncomputable local instance instDecidableEqPoint : DecidableEq (Point K) :=
  Classical.decEq (Point K)

/-- The point set of a nonsingular conic. -/
noncomputable def points (C : NonsingularConic (K := K)) : Finset (Point K) :=
  (standardConic (K := K)).map
    (ProjectiveCap.Projective.mapEquiv C.coordinateChange).toEmbedding

@[simp] theorem card_points (C : NonsingularConic (K := K)) :
    C.points.card = Fintype.card K + 1 := by
  rw [points, Finset.card_map, standardConic_card]

/-- The standard conic, with the identity normalization. -/
noncomputable def standard : NonsingularConic (K := K) where
  coordinateChange := LinearEquiv.refl K (PlaneSpace K)

/-- Projective linear coordinate changes preserve incidence collinearity. -/
theorem collinear_map_coordinateChange (C : NonsingularConic (K := K))
    (x a b : Point K) :
    Collinear (L := Point K)
        (ProjectiveCap.Projective.mapEquiv C.coordinateChange x)
        (ProjectiveCap.Projective.mapEquiv C.coordinateChange a)
        (ProjectiveCap.Projective.mapEquiv C.coordinateChange b) ↔
      Collinear (L := Point K) x a b := by
  rw [ProjectiveBridge.collinear_iff_projective_collinear,
    ProjectiveCap.Projective.collinear_mapEquiv,
    ProjectiveBridge.collinear_iff_projective_collinear]

/-- Every nonsingular conic comes with an explicit projective normalization from the standard
Veronese model. -/
theorem points_eq_map_standard (C : NonsingularConic (K := K)) :
    C.points = (standardConic (K := K)).map
      (ProjectiveCap.Projective.mapEquiv C.coordinateChange).toEmbedding := rfl

/-- Relative completeness is transported by the normalization projectivity. -/
theorem completeOutside_map_coordinateChange (C : NonsingularConic (K := K))
    {A : Finset (Point K)}
    (hA : CompleteOutside (L := Point K) A (standardConic (K := K))) :
    CompleteOutside (L := Point K)
      (A.map (ProjectiveCap.Projective.mapEquiv C.coordinateChange).toEmbedding) C.points := by
  rw [points_eq_map_standard]
  exact completeOutside_map (L := Point K)
    (ProjectiveCap.Projective.mapEquiv C.coordinateChange)
    C.collinear_map_coordinateChange hA

/-- The value of `rho` is independent of the chosen nonsingular conic. -/
theorem rho_points_eq_standardConic (C : NonsingularConic (K := K)) :
    rho (L := Point K) C.points = rho (L := Point K) (standardConic (K := K)) := by
  rw [points_eq_map_standard]
  exact rho_map_eq (L := Point K)
    (ProjectiveCap.Projective.mapEquiv C.coordinateChange)
    C.collinear_map_coordinateChange (standardConic (K := K))

theorem rho_points_eq (C D : NonsingularConic (K := K)) :
    rho (L := Point K) C.points = rho (L := Point K) D.points :=
  C.rho_points_eq_standardConic.trans D.rho_points_eq_standardConic.symm

theorem rho_points_eq_rhoC (C : NonsingularConic (K := K)) :
    rho (L := Point K) C.points = rhoC (K := K) := by
  rw [rhoC]
  exact C.rho_points_eq_standardConic

/-- The exact finite conic-completeness inequality, retaining the conic-incidence loss. -/
theorem completeOutside_bound (C : NonsingularConic (K := K)) {A : Finset (Point K)}
    (hcomplete : CompleteOutside (L := Point K) A C.points) :
    (A.card / 2) * (Fintype.card K ^ 2 - A.card)
        + holeIncidence (L := Point K) A C.points + 6 * Nat.choose A.card 4 ≤
      (A.card / 2) * (Nat.choose A.card 2 * (Fintype.card K - 1)) := by
  have hC : C.points.card = PlaneOrder (Point K) (Point K) + 1 := by
    rw [ProjectiveBridge.planeOrder_eq_card]
    exact C.card_points
  have h := completeOutside_bound_of_card_holes (P := Point K) (L := Point K)
    hcomplete hC
  rw [ProjectiveBridge.planeOrder_eq_card] at h
  exact h

/-- The incidence-free corrected capacity inequality used to define `L2`. -/
theorem corrected_capacity_bound (C : NonsingularConic (K := K)) {A : Finset (Point K)}
    (hcomplete : CompleteOutside (L := Point K) A C.points) :
    (A.card / 2) * (Fintype.card K ^ 2 - A.card) + 6 * Nat.choose A.card 4 ≤
      (A.card / 2) * (Nat.choose A.card 2 * (Fintype.card K - 1)) := by
  have hC : C.points.card = PlaneOrder (Point K) (Point K) + 1 := by
    rw [ProjectiveBridge.planeOrder_eq_card]
    exact C.card_points
  have h := corrected_capacity_bound_of_card_holes (P := Point K) (L := Point K)
    hcomplete hC
  rw [ProjectiveBridge.planeOrder_eq_card] at h
  exact h

theorem completeOutside_card_ge_three (C : NonsingularConic (K := K))
    {A : Finset (Point K)} (hcomplete : CompleteOutside (L := Point K) A C.points) :
    3 ≤ A.card := by
  have hC : C.points.card = PlaneOrder (Point K) (Point K) + 1 := by
    rw [ProjectiveBridge.planeOrder_eq_card]
    exact C.card_points
  exact completeOutside_card_ge_three_of_card_holes (P := Point K) (L := Point K)
    hcomplete hC

theorem l2Admissible_card (C : NonsingularConic (K := K)) {A : Finset (Point K)}
    (hcomplete : CompleteOutside (L := Point K) A C.points) :
    L2Admissible (Fintype.card K) A.card :=
  ⟨C.completeOutside_card_ge_three hcomplete, C.corrected_capacity_bound hcomplete⟩

/-- Every conic-complete arc has size at least the corrected threshold. -/
theorem L2_le_card (C : NonsingularConic (K := K)) {A : Finset (Point K)}
    (hcomplete : CompleteOutside (L := Point K) A C.points) :
    L2 (Fintype.card K) ≤ A.card := by
  apply Nat.sInf_le
  exact C.l2Admissible_card hcomplete

/-- The relative-completeness parameter is bounded below by `L2`. -/
theorem L2_le_rho (C : NonsingularConic (K := K)) :
    L2 (Fintype.card K) ≤ rho (L := Point K) C.points := by
  obtain ⟨A, hcomplete, hcard⟩ :=
    exists_completeOutside_card_eq_rho (L := Point K) C.points
  rw [← hcard]
  exact C.L2_le_card hcomplete

/-- The corrected threshold dominates the first-moment threshold. -/
theorem L1_le_L2 (C : NonsingularConic (K := K)) :
    L1 (Fintype.card K) ≤ L2 (Fintype.card K) := by
  have hne : {k : ℕ | L2Admissible (Fintype.card K) k}.Nonempty := by
    obtain ⟨A, hcomplete⟩ := exists_completeOutside (L := Point K) C.points
    exact ⟨A.card, C.l2Admissible_card hcomplete⟩
  have hmem : L2Admissible (Fintype.card K) (L2 (Fintype.card K)) := by
    exact Nat.sInf_mem hne
  apply Nat.sInf_le
  exact l2Admissible_l1Admissible hmem

/-- Exact finite lower-bound chain for arcs complete outside a nonsingular conic. -/
theorem finite_lower_bound (C : NonsingularConic (K := K)) :
    L1 (Fintype.card K) ≤ L2 (Fintype.card K) ∧
      L2 (Fintype.card K) ≤ rhoC (K := K) := by
  refine ⟨C.L1_le_L2, ?_⟩
  rw [← C.rho_points_eq_rhoC]
  exact C.L2_le_rho

end NonsingularConic

end Conic
end RelativeConicArcs
