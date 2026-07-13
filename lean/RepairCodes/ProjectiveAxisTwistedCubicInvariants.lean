import RepairCodes.AxisTwistedCubicInvariants
import RepairCodes.ProjectiveAxisTwistedCubic

/-!
# Invariants of the projectively completed cubic--axis seed

This module begins the exact repair-port layer.  Its first structural map is projective shifted
inversion on the cubic parameter line.  For a finite axis target `a`, it extends the affine map
`s ↦ (s+a)⁻¹` by sending `s=-a` to projective infinity and cubic infinity to zero.  This is
the parameter permutation needed to compare every finite completion fiber with the zero-sum fiber
at axis infinity.
-/

namespace RepairCodes

open Finset FiniteGeom

variable {𝔽 : Type*} [Field 𝔽]

/-- Natural inclusion of the affine cubic--axis coordinate set into its projective completion. -/
def affineToProjectiveAxisIndexEmbedding :
    AxisTwistedCubicIndex 𝔽 ↪ ProjectiveAxisTwistedCubicIndex 𝔽 where
  toFun
    | .inl s => .inl (.inl s)
    | .inr y => .inr y
  inj' := by
    intro x y hxy
    rcases x with s | z <;> rcases y with t | w <;> simp_all

/-- Ambient coordinate change inducing projective shifted inversion. -/
def projectiveShiftInvLinearMap (a : 𝔽) : (Fin 4 → 𝔽) →ₗ[𝔽] (Fin 4 → 𝔽) where
  toFun x := ![a ^ 3 * x 0 + x 3, a ^ 2 * x 0 - a * x 1 + x 2, a * x 0 + x 1, x 0]
  map_add' x y := by
    ext i
    fin_cases i <;> simp <;> ring
  map_smul' c x := by
    ext i
    fin_cases i <;> simp <;> ring

theorem projectiveShiftInvLinearMap_injective (a : 𝔽) :
    Function.Injective (projectiveShiftInvLinearMap a) := by
  intro x y hxy
  have hz : projectiveShiftInvLinearMap a (x - y) = 0 := by
    rw [map_sub, hxy, sub_self]
  have h₀ := congrFun hz (0 : Fin 4)
  have h₁ := congrFun hz (1 : Fin 4)
  have h₂ := congrFun hz (2 : Fin 4)
  have h₃ := congrFun hz (3 : Fin 4)
  change a ^ 3 * (x - y) 0 + (x - y) 3 = 0 at h₀
  change a ^ 2 * (x - y) 0 - a * (x - y) 1 + (x - y) 2 = 0 at h₁
  change a * (x - y) 0 + (x - y) 1 = 0 at h₂
  change (x - y) 0 = 0 at h₃
  have hx₀ : (x - y) 0 = 0 := h₃
  have hx₁ : (x - y) 1 = 0 := by linear_combination h₂ - a * hx₀
  have hx₂ : (x - y) 2 = 0 := by linear_combination h₁ - a ^ 2 * hx₀ + a * hx₁
  have hx₃ : (x - y) 3 = 0 := by linear_combination h₀ - a ^ 3 * hx₀
  apply sub_eq_zero.mp
  funext i
  fin_cases i <;> assumption

/-- The ambient shifted-inversion coordinate change is invertible. -/
noncomputable def projectiveShiftInvLinearEquiv (a : 𝔽) :
    (Fin 4 → 𝔽) ≃ₗ[𝔽] (Fin 4 → 𝔽) :=
  LinearEquiv.ofInjectiveEndo (projectiveShiftInvLinearMap a)
    (projectiveShiftInvLinearMap_injective a)

@[simp] theorem projectiveShiftInvLinearEquiv_apply (a : 𝔽) (x : Fin 4 → 𝔽) :
    projectiveShiftInvLinearEquiv a x = projectiveShiftInvLinearMap a x := rfl

/-- Direct homogeneous action on a finite cubic point. -/
theorem projectiveShiftInvLinearMap_cubic_finite [CharP 𝔽 3] (a s : 𝔽) :
    projectiveShiftInvLinearMap a (projectiveTwistedCubicPoints 𝔽 (.inl s)) =
      ![(s + a) ^ 3, (s + a) ^ 2, s + a, 1] := by
  ext i
  fin_cases i
  · simp [projectiveShiftInvLinearMap, projectiveTwistedCubicPoints, momentCurve,
      add_pow_char, add_comm]
  · simp [projectiveShiftInvLinearMap, projectiveTwistedCubicPoints, momentCurve, add_comm]
    linear_combination -(a * s) * CharP.cast_eq_zero 𝔽 3
  · simp [projectiveShiftInvLinearMap, projectiveTwistedCubicPoints, momentCurve, add_comm]
  · simp [projectiveShiftInvLinearMap, projectiveTwistedCubicPoints, momentCurve]

/-- Away from the pole, the ambient action is the normalized shifted-inversion cubic point up to
the displayed nonzero projective scale. -/
theorem projectiveShiftInvLinearMap_cubic_finite_of_ne [CharP 𝔽 3] (a s : 𝔽)
    (hs : s + a ≠ 0) :
    projectiveShiftInvLinearMap a (projectiveTwistedCubicPoints 𝔽 (.inl s)) =
      (s + a) ^ 3 • projectiveTwistedCubicPoints 𝔽 (.inl ((s + a)⁻¹)) := by
  rw [projectiveShiftInvLinearMap_cubic_finite]
  ext i
  fin_cases i <;>
    simp [projectiveTwistedCubicPoints, momentCurve, Pi.smul_apply] <;> field_simp

@[simp] theorem projectiveShiftInvLinearMap_cubic_pole [CharP 𝔽 3] (a : 𝔽) :
    projectiveShiftInvLinearMap a (projectiveTwistedCubicPoints 𝔽 (.inl (-a))) =
      projectiveTwistedCubicPoints 𝔽 (.inr Unit.unit) := by
  rw [projectiveShiftInvLinearMap_cubic_finite]
  ext i
  fin_cases i <;> simp [projectiveTwistedCubicPoints]

@[simp] theorem projectiveShiftInvLinearMap_cubic_infinity (a : 𝔽) :
    projectiveShiftInvLinearMap a (projectiveTwistedCubicPoints 𝔽 (.inr Unit.unit)) =
      projectiveTwistedCubicPoints 𝔽 (.inl 0) := by
  ext i
  fin_cases i <;>
    simp [projectiveShiftInvLinearMap, projectiveTwistedCubicPoints, momentCurve]

/-- Direct homogeneous action on a finite normalized axis point. -/
theorem projectiveShiftInvLinearMap_axis_finite (a y : 𝔽) :
    projectiveShiftInvLinearMap a (axisTwistedCubicPoints 𝔽 (.inr (.inl y))) =
      ![0, y - a, 1, 0] := by
  ext i
  fin_cases i <;> simp [projectiveShiftInvLinearMap, axisTwistedCubicPoints] <;> ring

theorem projectiveShiftInvLinearMap_axis_finite_of_ne (a y : 𝔽) (hy : y - a ≠ 0) :
    projectiveShiftInvLinearMap a (axisTwistedCubicPoints 𝔽 (.inr (.inl y))) =
      (y - a) • axisTwistedCubicPoints 𝔽 (.inr (.inl ((y - a)⁻¹))) := by
  rw [projectiveShiftInvLinearMap_axis_finite]
  ext i
  fin_cases i <;> simp [axisTwistedCubicPoints, Pi.smul_apply] <;> field_simp

@[simp] theorem projectiveShiftInvLinearMap_axis_target (a : 𝔽) :
    projectiveShiftInvLinearMap a (axisTwistedCubicPoints 𝔽 (.inr (.inl a))) =
      axisTwistedCubicPoints 𝔽 (.inr (.inr Unit.unit)) := by
  rw [projectiveShiftInvLinearMap_axis_finite]
  ext i
  fin_cases i <;> simp [axisTwistedCubicPoints]

@[simp] theorem projectiveShiftInvLinearMap_axis_infinity (a : 𝔽) :
    projectiveShiftInvLinearMap a (axisTwistedCubicPoints 𝔽 (.inr (.inr Unit.unit))) =
      axisTwistedCubicPoints 𝔽 (.inr (.inl 0)) := by
  ext i
  fin_cases i <;> simp [projectiveShiftInvLinearMap, axisTwistedCubicPoints]

variable [DecidableEq 𝔽]

/-- Projective extension of shifted inversion on the cubic parameter line. -/
def projectiveAxisShiftInvEquiv (a : 𝔽) :
    ProjectiveTwistedCubicIndex 𝔽 ≃ ProjectiveTwistedCubicIndex 𝔽 where
  toFun
    | .inl s => if s + a = 0 then .inr Unit.unit else .inl (s + a)⁻¹
    | .inr _ => .inl 0
  invFun
    | .inl r => if r = 0 then .inr Unit.unit else .inl (r⁻¹ - a)
    | .inr _ => .inl (-a)
  left_inv := by
    intro x
    cases x with
    | inl s =>
        by_cases hs : s + a = 0
        · have hsa : s = -a := by linear_combination hs
          simp [hsa]
        · have hinv : (s + a)⁻¹ ≠ 0 := inv_ne_zero hs
          simp [hs, hinv, inv_inv]
    | inr u => simp
  right_inv := by
    intro x
    cases x with
    | inl r =>
        by_cases hr : r = 0
        · subst r
          simp
        · have hinv : r⁻¹ ≠ 0 := inv_ne_zero hr
          simp [hr, hinv, inv_inv]
    | inr u => simp

@[simp] theorem projectiveAxisShiftInvEquiv_infinity (a : 𝔽) :
    projectiveAxisShiftInvEquiv a (.inr Unit.unit) = .inl 0 := rfl

@[simp] theorem projectiveAxisShiftInvEquiv_neg (a : 𝔽) :
    projectiveAxisShiftInvEquiv a (.inl (-a)) = .inr Unit.unit := by
  simp [projectiveAxisShiftInvEquiv]

theorem projectiveAxisShiftInvEquiv_finite_of_ne (a s : 𝔽) (hs : s + a ≠ 0) :
    projectiveAxisShiftInvEquiv a (.inl s) = .inl ((s + a)⁻¹) := by
  simp [projectiveAxisShiftInvEquiv, hs]

theorem projectiveAxisShiftInvEquiv_finite_iff (a s r : 𝔽) :
    projectiveAxisShiftInvEquiv a (.inl s) = .inl r ↔
      s + a ≠ 0 ∧ r = (s + a)⁻¹ := by
  by_cases hs : s + a = 0
  · simp [projectiveAxisShiftInvEquiv, hs]
  · simp [projectiveAxisShiftInvEquiv, hs, eq_comm]

theorem projectiveAxisShiftInvEquiv_eq_infinity_iff (a : 𝔽)
    (x : ProjectiveTwistedCubicIndex 𝔽) :
    projectiveAxisShiftInvEquiv a x = .inr Unit.unit ↔ x = .inl (-a) := by
  cases x with
  | inl s =>
      by_cases hs : s + a = 0
      · have hsa : s = -a := by linear_combination hs
        simp [projectiveAxisShiftInvEquiv, hsa]
      · have hsa : s ≠ -a := by
          intro h
          apply hs
          rw [h]
          simp
        simp [projectiveAxisShiftInvEquiv, hs, hsa]
  | inr u => simp [projectiveAxisShiftInvEquiv]

/-- Coordinate permutation of the completed system induced by the ambient shifted-inversion map.
The cubic parameter uses shift `a`; the axis parameter uses shift `-a`. -/
def projectiveShiftInvIndexEquiv (a : 𝔽) :
    ProjectiveAxisTwistedCubicIndex 𝔽 ≃ ProjectiveAxisTwistedCubicIndex 𝔽 :=
  Equiv.sumCongr (projectiveAxisShiftInvEquiv a) (projectiveAxisShiftInvEquiv (-a))

/-- Nonzero column scale accompanying `projectiveShiftInvIndexEquiv`. -/
def projectiveShiftInvScale (a : 𝔽) : ProjectiveAxisTwistedCubicIndex 𝔽 → 𝔽
  | .inl (.inl s) => if s + a = 0 then 1 else (s + a) ^ 3
  | .inl (.inr _) => 1
  | .inr (.inl y) => if y - a = 0 then 1 else y - a
  | .inr (.inr _) => 1

theorem projectiveShiftInvScale_ne_zero (a : 𝔽)
    (j : ProjectiveAxisTwistedCubicIndex 𝔽) : projectiveShiftInvScale a j ≠ 0 := by
  rcases j with (x | y)
  · rcases x with (s | u)
    · by_cases hs : s + a = 0
      · simp [projectiveShiftInvScale, hs]
      · simp [projectiveShiftInvScale, hs]
    · simp [projectiveShiftInvScale]
  · rcases y with (y | u)
    · by_cases hy : y - a = 0
      · simp [projectiveShiftInvScale, hy]
      · simp [projectiveShiftInvScale, hy]
    · simp [projectiveShiftInvScale]

/-- Exact monomial action of the ambient linear equivalence on every completed-system column. -/
theorem projectiveShiftInvLinearMap_column [CharP 𝔽 3] (a : 𝔽)
    (j : ProjectiveAxisTwistedCubicIndex 𝔽) :
    projectiveShiftInvLinearMap a (projectiveAxisTwistedCubicPoints 𝔽 j) =
      projectiveShiftInvScale a j •
        projectiveAxisTwistedCubicPoints 𝔽 (projectiveShiftInvIndexEquiv a j) := by
  rcases j with (x | y)
  · rcases x with (s | u)
    · by_cases hs : s + a = 0
      · have hsa : s = -a := by linear_combination hs
        subst s
        rw [projectiveAxisTwistedCubicPoints_cubic,
          projectiveShiftInvLinearMap_cubic_pole]
        simp [projectiveShiftInvScale, projectiveShiftInvIndexEquiv,
          projectiveAxisShiftInvEquiv, projectiveAxisTwistedCubicPoints]
      · rw [projectiveAxisTwistedCubicPoints_cubic,
          projectiveShiftInvLinearMap_cubic_finite_of_ne a s hs]
        simp [projectiveShiftInvScale, projectiveShiftInvIndexEquiv,
          projectiveAxisShiftInvEquiv, hs]
    · rw [projectiveAxisTwistedCubicPoints_cubic,
        projectiveShiftInvLinearMap_cubic_infinity]
      simp [projectiveShiftInvScale, projectiveShiftInvIndexEquiv,
        projectiveAxisShiftInvEquiv, projectiveAxisTwistedCubicPoints]
  · rcases y with (y | u)
    · by_cases hy : y - a = 0
      · have hya : y = a := sub_eq_zero.mp hy
        subst y
        rw [projectiveAxisTwistedCubicPoints_axis,
          projectiveShiftInvLinearMap_axis_target]
        simp [projectiveShiftInvScale, projectiveShiftInvIndexEquiv,
          projectiveAxisShiftInvEquiv, projectiveAxisTwistedCubicPoints]
      · rw [projectiveAxisTwistedCubicPoints_axis,
          projectiveShiftInvLinearMap_axis_finite_of_ne a y hy]
        have hy' : y + -a ≠ 0 := by simpa [sub_eq_add_neg] using hy
        simp [projectiveShiftInvScale, projectiveShiftInvIndexEquiv,
          projectiveAxisShiftInvEquiv, hy', sub_eq_add_neg]
    · rw [projectiveAxisTwistedCubicPoints_axis,
        projectiveShiftInvLinearMap_axis_infinity]
      simp [projectiveShiftInvScale, projectiveShiftInvIndexEquiv,
        projectiveAxisShiftInvEquiv, projectiveAxisTwistedCubicPoints]

/-- Unit-valued form of the nonzero projective column scale. -/
noncomputable def projectiveShiftInvScaleUnit (a : 𝔽)
    (j : ProjectiveAxisTwistedCubicIndex 𝔽) : 𝔽ˣ :=
  Units.mk0 (projectiveShiftInvScale a j) (projectiveShiftInvScale_ne_zero a j)

@[simp] theorem projectiveShiftInvScaleUnit_val (a : 𝔽)
    (j : ProjectiveAxisTwistedCubicIndex 𝔽) :
    (projectiveShiftInvScaleUnit a j : 𝔽) = projectiveShiftInvScale a j := rfl

/-- D-PC10 preserves linear independence of every indexed column family. -/
theorem projectiveShiftInv_linearIndependent_iff [CharP 𝔽 3] {I : Type*}
    (a : 𝔽) (f : I → ProjectiveAxisTwistedCubicIndex 𝔽) :
    LinearIndependent 𝔽 (fun i => projectiveAxisTwistedCubicPoints 𝔽 (f i)) ↔
      LinearIndependent 𝔽 (fun i => projectiveAxisTwistedCubicPoints 𝔽
        (projectiveShiftInvIndexEquiv a (f i))) := by
  let T := projectiveShiftInvLinearEquiv a
  let v := fun i => projectiveAxisTwistedCubicPoints 𝔽
    (projectiveShiftInvIndexEquiv a (f i))
  let w := fun i => projectiveShiftInvScaleUnit a (f i)
  have hfamily :
      (T.toLinearMap ∘ fun i => projectiveAxisTwistedCubicPoints 𝔽 (f i)) = w • v := by
    funext i
    exact projectiveShiftInvLinearMap_column a (f i)
  constructor
  · intro hli
    have hmap := hli.map' T.toLinearMap (LinearMap.ker_eq_bot.mpr T.injective)
    rw [hfamily] at hmap
    exact (LinearIndependent.units_smul_iff v w).mp hmap
  · intro hli
    have hmap : LinearIndependent 𝔽 (w • v) := hli.units_smul w
    rw [← hfamily] at hmap
    exact LinearIndependent.of_comp T.toLinearMap hmap

/-- The index equivalence restricted to a finite support and its relabeled image. -/
noncomputable def projectiveShiftInvFinsetEquiv (a : 𝔽)
    (S : Finset (ProjectiveAxisTwistedCubicIndex 𝔽)) :
    S ≃ S.map (projectiveShiftInvIndexEquiv a).toEmbedding where
  toFun x := ⟨projectiveShiftInvIndexEquiv a x, Finset.mem_map.mpr ⟨x, x.property, rfl⟩⟩
  invFun y := ⟨(projectiveShiftInvIndexEquiv a).symm y, by
    obtain ⟨x, hx, hxy⟩ := Finset.mem_map.mp y.property
    have : (projectiveShiftInvIndexEquiv a).symm y = x := by
      rw [← hxy]
      exact (projectiveShiftInvIndexEquiv a).symm_apply_apply x
    simpa [this] using hx⟩
  left_inv x := by ext; simp
  right_inv y := by ext; simp

/-- Finite selected supports preserve linear independence under D-PC10 relabeling. -/
theorem projectiveShiftInv_finset_linearIndependent_iff [CharP 𝔽 3] (a : 𝔽)
    (S : Finset (ProjectiveAxisTwistedCubicIndex 𝔽)) :
    LinearIndependent 𝔽 (fun j : S => projectiveAxisTwistedCubicPoints 𝔽 j) ↔
      LinearIndependent 𝔽
        (fun j : S.map (projectiveShiftInvIndexEquiv a).toEmbedding =>
          projectiveAxisTwistedCubicPoints 𝔽 j) := by
  rw [projectiveShiftInv_linearIndependent_iff a
    (fun j : S => (j : ProjectiveAxisTwistedCubicIndex 𝔽))]
  apply linearIndependent_equiv' (projectiveShiftInvFinsetEquiv a S)
  funext j
  rfl

/-- A finite support is a circuit of the completed column matroid. -/
def IsProjectiveAxisTwistedCubicCircuit
    (S : Finset (ProjectiveAxisTwistedCubicIndex 𝔽)) : Prop :=
  ¬ LinearIndependent 𝔽 (fun j : S => projectiveAxisTwistedCubicPoints 𝔽 j) ∧
    ∀ x ∈ S, LinearIndependent 𝔽
      (fun j : S.erase x => projectiveAxisTwistedCubicPoints 𝔽 j)

/-- D-PC10 relabeling preserves completed-system circuits exactly. -/
theorem isProjectiveAxisTwistedCubicCircuit_map_iff [CharP 𝔽 3] (a : 𝔽)
    (S : Finset (ProjectiveAxisTwistedCubicIndex 𝔽)) :
    IsProjectiveAxisTwistedCubicCircuit
        (S.map (projectiveShiftInvIndexEquiv a).toEmbedding) ↔
      IsProjectiveAxisTwistedCubicCircuit S := by
  let e := (projectiveShiftInvIndexEquiv a).toEmbedding
  constructor
  · rintro ⟨hdep, hdelete⟩
    refine ⟨?_, ?_⟩
    · exact fun hli => hdep ((projectiveShiftInv_finset_linearIndependent_iff a S).mp hli)
    · intro x hx
      have hex : projectiveShiftInvIndexEquiv a x ∈ S.map e :=
        Finset.mem_map.mpr ⟨x, hx, rfl⟩
      have hli := hdelete (projectiveShiftInvIndexEquiv a x) hex
      change LinearIndependent 𝔽
        (fun j : (S.map e).erase (e x) => projectiveAxisTwistedCubicPoints 𝔽 j) at hli
      rw [← Finset.map_erase] at hli
      exact (projectiveShiftInv_finset_linearIndependent_iff a (S.erase x)).mpr hli
  · rintro ⟨hdep, hdelete⟩
    refine ⟨?_, ?_⟩
    · exact fun hli => hdep ((projectiveShiftInv_finset_linearIndependent_iff a S).mpr hli)
    · intro y hy
      obtain ⟨x, hx, hxy⟩ := Finset.mem_map.mp hy
      subst y
      rw [← Finset.map_erase]
      exact (projectiveShiftInv_finset_linearIndependent_iff a (S.erase x)).mp (hdelete x hx)

variable [Fintype 𝔽]

/-- Cubic-coordinate part of a helper set in the completed seed. -/
def projectiveCubicPart
    (E : Finset (ProjectiveAxisTwistedCubicIndex 𝔽)) :
    Finset (ProjectiveAxisTwistedCubicIndex 𝔽) :=
  E.filter fun z => ∃ x : ProjectiveTwistedCubicIndex 𝔽, z = .inl x

/-- Axis-coordinate part of a helper set in the completed seed. -/
def projectiveAxisPart
    (E : Finset (ProjectiveAxisTwistedCubicIndex 𝔽)) :
    Finset (ProjectiveAxisTwistedCubicIndex 𝔽) :=
  E.filter fun z => ∃ y : 𝔽 ⊕ Unit, z = .inr y

theorem card_projectiveCubicPart_add_card_projectiveAxisPart
    (E : Finset (ProjectiveAxisTwistedCubicIndex 𝔽)) :
    (projectiveCubicPart E).card + (projectiveAxisPart E).card = E.card := by
  classical
  rw [projectiveCubicPart, projectiveAxisPart, ← Finset.card_union_of_disjoint]
  · congr 1
    ext z
    rcases z with ((z | z) | (z | z)) <;> simp
  · simp [Finset.disjoint_left]

/-- An independent helper family contains at most two completed-axis columns. -/
theorem projectiveAxisPart_card_le_two_of_linearIndependent
    {E : Finset (ProjectiveAxisTwistedCubicIndex 𝔽)}
    (hli : LinearIndependent 𝔽
      (fun j : E => projectiveAxisTwistedCubicPoints 𝔽 j)) :
    (projectiveAxisPart E).card ≤ 2 := by
  classical
  let A := projectiveAxisPart E
  have hAE : A ⊆ E := Finset.filter_subset _ _
  have hliA : LinearIndependent 𝔽
      (fun j : A => projectiveAxisTwistedCubicPoints 𝔽 j) :=
    hli.comp (fun j : A => (⟨j, hAE j.property⟩ : E))
      (by
        intro i j h
        have hv : (i : ProjectiveAxisTwistedCubicIndex 𝔽) = j :=
          congrArg (fun z : E => (z : ProjectiveAxisTwistedCubicIndex 𝔽)) h
        exact Subtype.ext hv)
  let p : A → (Fin 2 → 𝔽) := fun j =>
    ![(projectiveAxisTwistedCubicPoints 𝔽 j) 1,
      (projectiveAxisTwistedCubicPoints 𝔽 j) 2]
  have hp : LinearIndependent 𝔽 p := by
    rw [Fintype.linearIndependent_iff]
    intro c hc
    apply Fintype.linearIndependent_iff.mp hliA c
    ext i
    fin_cases i
    · simp only [Finset.sum_apply, Pi.smul_apply, Pi.zero_apply]
      apply Finset.sum_eq_zero
      intro j _
      rcases j with ⟨j, hj⟩
      rcases j with x | y
      · simp [A, projectiveAxisPart] at hj
      · simp [projectiveAxisTwistedCubicPoints]
    · simpa [p] using congrFun hc (0 : Fin 2)
    · simpa [p] using congrFun hc (1 : Fin 2)
    · simp only [Finset.sum_apply, Pi.smul_apply, Pi.zero_apply]
      apply Finset.sum_eq_zero
      intro j _
      rcases j with ⟨j, hj⟩
      rcases j with x | y
      · simp [A, projectiveAxisPart] at hj
      · simp [projectiveAxisTwistedCubicPoints]
  have hcard := hp.fintype_card_le_finrank
  simpa [A] using hcard

/-- D-PC10 relabels every complete bounded repair hypergraph exactly. -/
theorem projectiveShiftInv_relabel_repairHypergraph [CharP 𝔽 3]
    (a : 𝔽) (x : ProjectiveAxisTwistedCubicIndex 𝔽) (r : ℕ) :
    relabelHypergraph (projectiveShiftInvIndexEquiv a)
        (projectiveAxisTwistedCubicRepairHypergraph x r) =
      projectiveAxisTwistedCubicRepairHypergraph
        (projectiveShiftInvIndexEquiv a x) r := by
  change relabelHypergraph (projectiveShiftInvIndexEquiv a)
      (repairHypergraph (rowCode projectiveAxisTwistedCubicGenerator) x r) =
    repairHypergraph (rowCode projectiveAxisTwistedCubicGenerator)
      (projectiveShiftInvIndexEquiv a x) r
  apply relabel_repairHypergraph_of_monomial
    (T := projectiveShiftInvLinearEquiv a) (scale := projectiveShiftInvScale a)
  · exact projectiveShiftInvScale_ne_zero a
  · intro j
    simpa [projectiveShiftInvLinearEquiv_apply,
      projectiveAxisTwistedCubicGenerator_col] using
        projectiveShiftInvLinearMap_column a j

/-- D-PC10 relabels every inclusion-minimal bounded repair clutter exactly. -/
theorem projectiveShiftInv_relabel_minimalRepairHypergraph [CharP 𝔽 3]
    (a : 𝔽) (x : ProjectiveAxisTwistedCubicIndex 𝔽) (r : ℕ) :
    relabelHypergraph (projectiveShiftInvIndexEquiv a)
        (minimalProjectiveAxisTwistedCubicRepairHypergraph x r) =
      minimalProjectiveAxisTwistedCubicRepairHypergraph
        (projectiveShiftInvIndexEquiv a x) r := by
  change relabelHypergraph (projectiveShiftInvIndexEquiv a)
      (minimalRepairHypergraph (rowCode projectiveAxisTwistedCubicGenerator) x r) =
    minimalRepairHypergraph (rowCode projectiveAxisTwistedCubicGenerator)
      (projectiveShiftInvIndexEquiv a x) r
  apply relabel_minimalRepairHypergraph_of_monomial
    (T := projectiveShiftInvLinearEquiv a) (scale := projectiveShiftInvScale a)
  · exact projectiveShiftInvScale_ne_zero a
  · intro j
    simpa [projectiveShiftInvLinearEquiv_apply,
      projectiveAxisTwistedCubicGenerator_col] using
        projectiveShiftInvLinearMap_column a j

/-- At axis infinity, the completed minimal radius-three clutter is exactly the natural embedding
of the affine nucleus clutter. In particular, the added cubic-infinity coordinate lies in no
minimal repair edge. -/
theorem minimalProjectiveAxisInfinityRepair_eq_embedAffine [CharP 𝔽 3] :
    minimalProjectiveAxisTwistedCubicRepairHypergraph
        (.inr (.inr Unit.unit : 𝔽 ⊕ Unit) : ProjectiveAxisTwistedCubicIndex 𝔽) 3 =
      embedHypergraph affineToProjectiveAxisIndexEmbedding
        (minimalAxisTwistedCubicRepairHypergraph
          (.inr (.inr Unit.unit : 𝔽 ⊕ Unit) : AxisTwistedCubicIndex 𝔽) 3) := by
  classical
  ext R
  constructor
  · intro hR
    rcases mem_minimalProjectiveAxisInfinityRepair_iff.mp hR with hpair | hcubic
    · obtain ⟨z, w, hyz, hyw, hzw, rfl⟩ := hpair
      apply Finset.mem_image.mpr
      refine ⟨{(.inr z : AxisTwistedCubicIndex 𝔽), .inr w}, ?_, ?_⟩
      · apply mem_minimalAxisRepairHypergraph_iff.mpr
        exact Or.inl ⟨z, w, hyz, hyw, hzw, rfl⟩
      · ext x
        rcases x with x | x <;> simp [affineToProjectiveAxisIndexEmbedding]
    · obtain ⟨s, t, u, hst, hsu, htu, hsum, rfl⟩ := hcubic
      apply Finset.mem_image.mpr
      refine ⟨{(.inl s : AxisTwistedCubicIndex 𝔽), .inl t, .inl u}, ?_, ?_⟩
      · apply mem_minimalAxisRepairHypergraph_iff.mpr
        apply Or.inr
        refine ⟨s, t, u, hst, hsu, htu, ?_, rfl⟩
        simp [twistedCubicTripleAxisIndex, hsum]
      · ext x
        rcases x with x | x <;> simp [affineToProjectiveAxisIndexEmbedding]
  · intro hR
    obtain ⟨S, hS, rfl⟩ := Finset.mem_image.mp hR
    rcases mem_minimalAxisRepairHypergraph_iff.mp hS with hpair | hcubic
    · obtain ⟨z, w, hyz, hyw, hzw, rfl⟩ := hpair
      apply mem_minimalProjectiveAxisInfinityRepair_iff.mpr
      apply Or.inl
      refine ⟨z, w, hyz, hyw, hzw, ?_⟩
      ext x
      rcases x with x | x <;> simp [affineToProjectiveAxisIndexEmbedding]
    · obtain ⟨s, t, u, hst, hsu, htu, hy, rfl⟩ := hcubic
      have hsum : s + t + u = 0 := by
        rw [twistedCubicTripleAxisIndex] at hy
        by_cases h : s + t + u = 0
        · exact h
        · simp [h] at hy
      apply mem_minimalProjectiveAxisInfinityRepair_iff.mpr
      apply Or.inr
      refine ⟨s, t, u, hst, hsu, htu, hsum, ?_⟩
      ext x
      rcases x with x | x <;> simp [affineToProjectiveAxisIndexEmbedding]

/-- Exact radius-three repair invariants at the projective axis point at infinity. -/
theorem minimalProjectiveAxisInfinityRepair_invariants [CharP 𝔽 3] :
    matchingNumber (minimalProjectiveAxisTwistedCubicRepairHypergraph
        (.inr (.inr Unit.unit : 𝔽 ⊕ Unit) : ProjectiveAxisTwistedCubicIndex 𝔽) 3) =
        (5 * Fintype.card 𝔽 - 3) / 6 ∧
      transversalNumber (minimalProjectiveAxisTwistedCubicRepairHypergraph
        (.inr (.inr Unit.unit : 𝔽 ⊕ Unit) : ProjectiveAxisTwistedCubicIndex 𝔽) 3) =
          2 * Fintype.card 𝔽 - 1 - zeroSumCapNumber 𝔽 := by
  rw [minimalProjectiveAxisInfinityRepair_eq_embedAffine,
    matchingNumber_embedHypergraph]
  have hne : ∀ E ∈ minimalAxisTwistedCubicRepairHypergraph
      (.inr (.inr Unit.unit : 𝔽 ⊕ Unit)) 3, E.Nonempty := by
    intro E hE
    rcases mem_minimalAxisRepairHypergraph_iff.mp hE with hpair | hcubic
    · obtain ⟨z, w, -, -, -, rfl⟩ := hpair
      exact ⟨.inr z, by simp⟩
    · obtain ⟨s, t, u, -, -, -, -, rfl⟩ := hcubic
      exact ⟨.inl s, by simp⟩
  rw [transversalNumber_embedHypergraph affineToProjectiveAxisIndexEmbedding _ hne]
  exact minimalAxisRepair_nucleus_invariants

/-- Exact uniform radius-three row for every axis coordinate of the completed seed. -/
theorem minimalProjectiveAxisRepair_invariants [CharP 𝔽 3] (y : 𝔽 ⊕ Unit) :
    matchingNumber (minimalProjectiveAxisTwistedCubicRepairHypergraph (.inr y) 3) =
        (5 * Fintype.card 𝔽 - 3) / 6 ∧
      transversalNumber (minimalProjectiveAxisTwistedCubicRepairHypergraph (.inr y) 3) =
        2 * Fintype.card 𝔽 - 1 - zeroSumCapNumber 𝔽 := by
  cases y with
  | inr u => simpa using minimalProjectiveAxisInfinityRepair_invariants (𝔽 := 𝔽)
  | inl a =>
      have htarget : projectiveShiftInvIndexEquiv a
          (.inr (.inl a) : ProjectiveAxisTwistedCubicIndex 𝔽) =
          .inr (.inr Unit.unit) := by
        simp [projectiveShiftInvIndexEquiv, projectiveAxisShiftInvEquiv]
      have hrel := projectiveShiftInv_relabel_repairHypergraph a
        (.inr (.inl a) : ProjectiveAxisTwistedCubicIndex 𝔽) 3
      rw [htarget] at hrel
      have hmatchRel := matchingNumber_relabelHypergraph
        (projectiveShiftInvIndexEquiv a)
        (projectiveAxisTwistedCubicRepairHypergraph
          (.inr (.inl a) : ProjectiveAxisTwistedCubicIndex 𝔽) 3)
      have htauRel := transversalNumber_relabelHypergraph
        (projectiveShiftInvIndexEquiv a)
        (projectiveAxisTwistedCubicRepairHypergraph
          (.inr (.inl a) : ProjectiveAxisTwistedCubicIndex 𝔽) 3)
      rw [hrel] at hmatchRel htauRel
      have hnucleus := minimalProjectiveAxisInfinityRepair_invariants (𝔽 := 𝔽)
      constructor
      · rw [matchingNumber_minimalProjectiveAxisTwistedCubicRepairHypergraph]
        calc
          matchingNumber (projectiveAxisTwistedCubicRepairHypergraph
              (.inr (.inl a)) 3) =
              matchingNumber (projectiveAxisTwistedCubicRepairHypergraph
                (.inr (.inr Unit.unit)) 3) := hmatchRel.symm
          _ = matchingNumber (minimalProjectiveAxisTwistedCubicRepairHypergraph
                (.inr (.inr Unit.unit)) 3) :=
              (matchingNumber_minimalProjectiveAxisTwistedCubicRepairHypergraph _ _).symm
          _ = (5 * Fintype.card 𝔽 - 3) / 6 := hnucleus.1
      · rw [transversalNumber_minimalProjectiveAxisTwistedCubicRepairHypergraph]
        calc
          transversalNumber (projectiveAxisTwistedCubicRepairHypergraph
              (.inr (.inl a)) 3) =
              transversalNumber (projectiveAxisTwistedCubicRepairHypergraph
                (.inr (.inr Unit.unit)) 3) := htauRel.symm
          _ = transversalNumber (minimalProjectiveAxisTwistedCubicRepairHypergraph
                (.inr (.inr Unit.unit)) 3) :=
              (transversalNumber_minimalProjectiveAxisTwistedCubicRepairHypergraph _ _).symm
          _ = 2 * Fintype.card 𝔽 - 1 - zeroSumCapNumber 𝔽 := hnucleus.2

/-- A matching of cubic-infinity repairs consumes two distinct finite cubic coordinates per
edge. -/
theorem projectiveCubicInfinityRepair_matching_card_bound [CharP 𝔽 3]
    {M : Finset (Finset (ProjectiveAxisTwistedCubicIndex 𝔽))}
    (hM : IsMatching
      (projectiveAxisTwistedCubicRepairHypergraph
        (.inl (.inr Unit.unit) : ProjectiveAxisTwistedCubicIndex 𝔽) 3) M) :
    2 * M.card ≤ Fintype.card 𝔽 := by
  classical
  let cubicPart (E : Finset (ProjectiveAxisTwistedCubicIndex 𝔽)) :
      Finset (ProjectiveAxisTwistedCubicIndex 𝔽) :=
    E.filter fun z => ∃ s : 𝔽, z = .inl (.inl s)
  have hpart (E) (hE : E ∈ M) : (cubicPart E).card = 2 := by
    obtain ⟨s, t, hst, rfl⟩ :=
      mem_projectiveCubicInfinityRepairHypergraph_iff.mp (hM.1 hE)
    rw [show cubicPart
        {(.inl (.inl s) : ProjectiveAxisTwistedCubicIndex 𝔽), .inl (.inl t),
          .inr (.inl (s + t))} =
        {(.inl (.inl s) : ProjectiveAxisTwistedCubicIndex 𝔽), .inl (.inl t)} by
      ext z
      rcases z with ((z | z) | z) <;> simp [cubicPart]]
    simp [hst]
  have hpairwise :
      (M : Set (Finset (ProjectiveAxisTwistedCubicIndex 𝔽))).PairwiseDisjoint cubicPart := by
    intro A hA B hB hAB
    exact (hM.2 hA hB hAB).mono (Finset.filter_subset _ _) (Finset.filter_subset _ _)
  have hsub : M.biUnion cubicPart ⊆
      (univ : Finset 𝔽).map
        (Function.Embedding.inl.trans affineToProjectiveAxisIndexEmbedding) := by
    intro z hz
    obtain ⟨E, hEM, hzE⟩ := Finset.mem_biUnion.mp hz
    have hzfinite := (Finset.mem_filter.mp hzE).2
    obtain ⟨s, rfl⟩ := hzfinite
    simp [affineToProjectiveAxisIndexEmbedding]
  calc
    2 * M.card = ∑ E ∈ M, 2 := by simp [Nat.mul_comm]
    _ = ∑ E ∈ M, (cubicPart E).card := by
      apply Finset.sum_congr rfl
      intro E hE
      exact (hpart E hE).symm
    _ = (M.biUnion cubicPart).card := (Finset.card_biUnion hpairwise).symm
    _ ≤ ((univ : Finset 𝔽).map
        (Function.Embedding.inl.trans affineToProjectiveAxisIndexEmbedding)).card :=
      Finset.card_le_card hsub
    _ = Fintype.card 𝔽 := by simp

/-- Cubic-infinity disjoint availability is at most `(q-1)/2`. -/
theorem projectiveCubicInfinityRepair_matchingNumber_le [CharP 𝔽 3] :
    matchingNumber
      (projectiveAxisTwistedCubicRepairHypergraph
        (.inl (.inr Unit.unit) : ProjectiveAxisTwistedCubicIndex 𝔽) 3) ≤
        (Fintype.card 𝔽 - 1) / 2 := by
  apply matchingNumber_le_of_forall
  intro M hM
  have hbound := projectiveCubicInfinityRepair_matching_card_bound hM
  have hodd := FiniteField.odd_card_of_char_ne_two (F := 𝔽) (by
    rw [ringChar.eq 𝔽 3]
    decide)
  omega

/-- The consecutive-power rainbow matching on the nonzero finite cubic parameters embeds into
the completed cubic-infinity repair hypergraph. -/
theorem projectiveCubicInfinityRepair_matchingNumber_ge_half [CharP 𝔽 3] :
    (Fintype.card 𝔽 - 1) / 2 ≤
      matchingNumber
        (projectiveAxisTwistedCubicRepairHypergraph
          (.inl (.inr Unit.unit) : ProjectiveAxisTwistedCubicIndex 𝔽) 3) := by
  classical
  let e : (𝔽ˣ ⊕ 𝔽) ↪ ProjectiveAxisTwistedCubicIndex 𝔽 :=
    ⟨fun z => match z with
      | .inl u => .inl (.inl (u : 𝔽))
      | .inr w => .inr (.inl w),
    by
      intro a b hab
      cases a with
      | inl u =>
          cases b with
          | inl v => exact congrArg Sum.inl (Units.ext (Sum.inl.inj (Sum.inl.inj hab)))
          | inr w => simp at hab
      | inr w =>
          cases b with
          | inl u => simp at hab
          | inr z => exact congrArg Sum.inr (Sum.inl.inj (Sum.inr.inj hab))⟩
  let color : 𝔽ˣ → 𝔽ˣ → 𝔽 := fun u v => (u : 𝔽) + (v : 𝔽)
  let H := augmentedColorHypergraph color
  have hsub : embedHypergraph e H ⊆
      projectiveAxisTwistedCubicRepairHypergraph
        (.inl (.inr Unit.unit) : ProjectiveAxisTwistedCubicIndex 𝔽) 3 := by
    intro E hE
    obtain ⟨E₀, hE₀, rfl⟩ := Finset.mem_image.mp hE
    obtain ⟨u, v, huv, rfl⟩ := mem_augmentedColorHypergraph.mp hE₀
    have huv' : (u : 𝔽) ≠ (v : 𝔽) := fun h => huv (Units.ext h)
    have hmap : ({Sum.inl u, Sum.inl v, Sum.inr (color u v)} :
        Finset (𝔽ˣ ⊕ 𝔽)).map e =
        {(.inl (.inl (u : 𝔽)) : ProjectiveAxisTwistedCubicIndex 𝔽),
          .inl (.inl (v : 𝔽)), .inr (.inl ((u : 𝔽) + (v : 𝔽)))} := by
      ext z
      rcases z with (z | z) <;> simp [e, color]
    rw [hmap]
    exact mem_projectiveCubicInfinityRepairHypergraph_iff.mpr
      ⟨(u : 𝔽), (v : 𝔽), huv', rfl⟩
  calc
    (Fintype.card 𝔽 - 1) / 2 = Fintype.card 𝔽ˣ / 2 := by
      simp [← Nat.card_eq_fintype_card, Nat.card_units]
    _ ≤ matchingNumber H := units_addColor_matchingNumber_lower
    _ = matchingNumber (embedHypergraph e H) :=
      (matchingNumber_embedHypergraph e H).symm
    _ ≤ matchingNumber
        (projectiveAxisTwistedCubicRepairHypergraph
          (.inl (.inr Unit.unit) : ProjectiveAxisTwistedCubicIndex 𝔽) 3) :=
      matchingNumber_mono hsub

/-- Exact disjoint availability at cubic infinity. -/
theorem projectiveCubicInfinityRepair_matchingNumber [CharP 𝔽 3] :
    matchingNumber
      (projectiveAxisTwistedCubicRepairHypergraph
        (.inl (.inr Unit.unit) : ProjectiveAxisTwistedCubicIndex 𝔽) 3) =
        (Fintype.card 𝔽 - 1) / 2 :=
  le_antisymm projectiveCubicInfinityRepair_matchingNumber_le
    projectiveCubicInfinityRepair_matchingNumber_ge_half

/-- All finite cubic coordinates except one form a transversal at cubic infinity. -/
theorem projectiveCubicInfinityRepair_transversal_of_erase [CharP 𝔽 3] (a₀ : 𝔽) :
    IsTransversal
      (projectiveAxisTwistedCubicRepairHypergraph
        (.inl (.inr Unit.unit) : ProjectiveAxisTwistedCubicIndex 𝔽) 3)
      ((univ.erase a₀).map
        (Function.Embedding.inl.trans affineToProjectiveAxisIndexEmbedding)) := by
  intro E hE
  obtain ⟨s, t, hst, rfl⟩ :=
    mem_projectiveCubicInfinityRepairHypergraph_iff.mp hE
  by_cases hs : s = a₀
  · subst s
    exact ⟨.inl (.inl t), by
      simp [affineToProjectiveAxisIndexEmbedding, hst.symm]⟩
  · exact ⟨.inl (.inl s), by simp [affineToProjectiveAxisIndexEmbedding, hs]⟩

/-- Every cubic-infinity repair transversal has at least `q-1` vertices. -/
theorem projectiveCubicInfinityRepair_transversal_card_ge [CharP 𝔽 3]
    {T : Finset (ProjectiveAxisTwistedCubicIndex 𝔽)}
    (hT : IsTransversal
      (projectiveAxisTwistedCubicRepairHypergraph
        (.inl (.inr Unit.unit) : ProjectiveAxisTwistedCubicIndex 𝔽) 3) T) :
    Fintype.card 𝔽 - 1 ≤ T.card := by
  classical
  let covered : Finset 𝔽 := univ.filter fun s =>
    (.inl (.inl s) : ProjectiveAxisTwistedCubicIndex 𝔽) ∈ T
  let uncovered : Finset 𝔽 := univ \ covered
  by_cases hU : uncovered = ∅
  · have hsub : (univ : Finset 𝔽).map
        (Function.Embedding.inl.trans affineToProjectiveAxisIndexEmbedding) ⊆ T := by
      intro z hz
      obtain ⟨s, -, rfl⟩ := Finset.mem_map.mp hz
      have hsC : s ∈ covered := by
        by_contra hsC
        have : s ∈ uncovered := by simp [uncovered, hsC]
        simp [hU] at this
      exact (Finset.mem_filter.mp hsC).2
    have hcard := Finset.card_le_card hsub
    have hmapcard : ((univ : Finset 𝔽).map
        (Function.Embedding.inl.trans affineToProjectiveAxisIndexEmbedding)).card =
        Fintype.card 𝔽 := by simp
    rw [hmapcard] at hcard
    omega
  · obtain ⟨a₀, ha₀⟩ := Finset.nonempty_iff_ne_empty.mpr hU
    let colors : Finset 𝔽 := (uncovered.erase a₀).image fun b => a₀ + b
    let axisEmbedding : 𝔽 ↪ ProjectiveAxisTwistedCubicIndex 𝔽 :=
      ⟨fun w => .inr (.inl w), by intro u v h; exact Sum.inl.inj (Sum.inr.inj h)⟩
    have hcolorSub : colors.map
        axisEmbedding ⊆ T := by
      intro z hz
      obtain ⟨c, hc, rfl⟩ := Finset.mem_map.mp hz
      obtain ⟨b, hb, rfl⟩ := Finset.mem_image.mp hc
      have hba : b ≠ a₀ := (Finset.mem_erase.mp hb).1
      have hbU : b ∈ uncovered := (Finset.mem_erase.mp hb).2
      have haT : (.inl (.inl a₀) : ProjectiveAxisTwistedCubicIndex 𝔽) ∉ T := by
        intro haT
        have : a₀ ∈ covered := by simp [covered, haT]
        exact (Finset.mem_sdiff.mp ha₀).2 this
      have hbT : (.inl (.inl b) : ProjectiveAxisTwistedCubicIndex 𝔽) ∉ T := by
        intro hbT
        have : b ∈ covered := by simp [covered, hbT]
        exact (Finset.mem_sdiff.mp hbU).2 this
      have hedge :
          {(.inl (.inl a₀) : ProjectiveAxisTwistedCubicIndex 𝔽),
            .inl (.inl b), .inr (.inl (a₀ + b))} ∈
            projectiveAxisTwistedCubicRepairHypergraph (.inl (.inr Unit.unit)) 3 :=
        mem_projectiveCubicInfinityRepairHypergraph_iff.mpr
          ⟨a₀, b, hba.symm, rfl⟩
      obtain ⟨v, hv⟩ := hT hedge
      simp only [Finset.mem_inter, Finset.mem_insert, Finset.mem_singleton] at hv
      rcases hv.2 with hv0 | hvb | hvc
      · exact (haT (hv0 ▸ hv.1)).elim
      · exact (hbT (hvb ▸ hv.1)).elim
      · simpa [axisEmbedding, hvc] using hv.1
    have hcoveredSub : covered.map
        (Function.Embedding.inl.trans affineToProjectiveAxisIndexEmbedding) ⊆ T := by
      intro z hz
      obtain ⟨s, hs, rfl⟩ := Finset.mem_map.mp hz
      exact (Finset.mem_filter.mp hs).2
    have hcolorsCard : colors.card = uncovered.card - 1 := by
      rw [Finset.card_image_iff.mpr]
      · rw [Finset.card_erase_of_mem ha₀]
      · intro b hb c hc hEq
        exact add_left_cancel hEq
    have hdisj : Disjoint
        (covered.map (Function.Embedding.inl.trans affineToProjectiveAxisIndexEmbedding))
        (colors.map axisEmbedding) := by
      simp [Finset.disjoint_left, affineToProjectiveAxisIndexEmbedding, axisEmbedding]
    have hunionSub := Finset.union_subset hcoveredSub hcolorSub
    have hcardCU : covered.card + uncovered.card = Fintype.card 𝔽 := by
      have hsplit : uncovered.card + covered.card = Fintype.card 𝔽 := by
        change ((univ : Finset 𝔽) \ covered).card + covered.card = Fintype.card 𝔽
        have hsplit0 :=
          Finset.card_sdiff_add_card_eq_card (Finset.filter_subset
            (fun s : 𝔽 =>
              (.inl (.inl s) : ProjectiveAxisTwistedCubicIndex 𝔽) ∈ T) univ)
        rw [Finset.card_univ] at hsplit0
        simpa [covered] using hsplit0
      omega
    have hle := Finset.card_le_card hunionSub
    rw [Finset.card_union_of_disjoint hdisj, Finset.card_map, Finset.card_map,
      hcolorsCard] at hle
    omega

/-- Exact transversal number at cubic infinity. -/
theorem projectiveCubicInfinityRepair_transversalNumber [CharP 𝔽 3] :
    transversalNumber
      (projectiveAxisTwistedCubicRepairHypergraph
        (.inl (.inr Unit.unit) : ProjectiveAxisTwistedCubicIndex 𝔽) 3) =
        Fintype.card 𝔽 - 1 := by
  apply le_antisymm
  · have hT := projectiveCubicInfinityRepair_transversal_of_erase (𝔽 := 𝔽) 0
    have hle := transversalNumber_le_card hT
    simpa using hle
  · apply le_transversalNumber_of_forall
    · exact ⟨_, projectiveCubicInfinityRepair_transversal_of_erase (𝔽 := 𝔽) 0⟩
    · exact fun _ hT => projectiveCubicInfinityRepair_transversal_card_ge hT

/-- Exact inclusion-minimal radius-three repair row at cubic infinity. -/
theorem minimalProjectiveCubicInfinityRepair_invariants [CharP 𝔽 3] :
    matchingNumber (minimalProjectiveAxisTwistedCubicRepairHypergraph
        (.inl (.inr Unit.unit) : ProjectiveAxisTwistedCubicIndex 𝔽) 3) =
        (Fintype.card 𝔽 - 1) / 2 ∧
      transversalNumber (minimalProjectiveAxisTwistedCubicRepairHypergraph
        (.inl (.inr Unit.unit) : ProjectiveAxisTwistedCubicIndex 𝔽) 3) =
        Fintype.card 𝔽 - 1 := by
  constructor
  · rw [matchingNumber_minimalProjectiveAxisTwistedCubicRepairHypergraph]
    exact projectiveCubicInfinityRepair_matchingNumber
  · rw [transversalNumber_minimalProjectiveAxisTwistedCubicRepairHypergraph]
    exact projectiveCubicInfinityRepair_transversalNumber

/-- Exact uniform radius-three row for every cubic coordinate of the completed seed.  Projective
completion leaves disjoint availability unchanged from the affine row and raises the minimum
transversal size by one. -/
theorem minimalProjectiveCubicRepair_invariants [CharP 𝔽 3]
    (x : ProjectiveTwistedCubicIndex 𝔽) :
    matchingNumber (minimalProjectiveAxisTwistedCubicRepairHypergraph (.inl x) 3) =
        (Fintype.card 𝔽 - 1) / 2 ∧
      transversalNumber (minimalProjectiveAxisTwistedCubicRepairHypergraph (.inl x) 3) =
        Fintype.card 𝔽 - 1 := by
  cases x with
  | inr u => simpa using minimalProjectiveCubicInfinityRepair_invariants (𝔽 := 𝔽)
  | inl a =>
      have htarget : projectiveShiftInvIndexEquiv (-a)
          (.inl (.inl a) : ProjectiveAxisTwistedCubicIndex 𝔽) =
          .inl (.inr Unit.unit) := by
        simp [projectiveShiftInvIndexEquiv, projectiveAxisShiftInvEquiv]
      have hrel := projectiveShiftInv_relabel_repairHypergraph (-a)
        (.inl (.inl a) : ProjectiveAxisTwistedCubicIndex 𝔽) 3
      rw [htarget] at hrel
      have hmatchRel := matchingNumber_relabelHypergraph
        (projectiveShiftInvIndexEquiv (-a))
        (projectiveAxisTwistedCubicRepairHypergraph
          (.inl (.inl a) : ProjectiveAxisTwistedCubicIndex 𝔽) 3)
      have htauRel := transversalNumber_relabelHypergraph
        (projectiveShiftInvIndexEquiv (-a))
        (projectiveAxisTwistedCubicRepairHypergraph
          (.inl (.inl a) : ProjectiveAxisTwistedCubicIndex 𝔽) 3)
      rw [hrel] at hmatchRel htauRel
      have hinfinity := minimalProjectiveCubicInfinityRepair_invariants (𝔽 := 𝔽)
      constructor
      · rw [matchingNumber_minimalProjectiveAxisTwistedCubicRepairHypergraph]
        calc
          matchingNumber (projectiveAxisTwistedCubicRepairHypergraph
              (.inl (.inl a)) 3) =
              matchingNumber (projectiveAxisTwistedCubicRepairHypergraph
                (.inl (.inr Unit.unit)) 3) := hmatchRel.symm
          _ = matchingNumber (minimalProjectiveAxisTwistedCubicRepairHypergraph
                (.inl (.inr Unit.unit)) 3) :=
              (matchingNumber_minimalProjectiveAxisTwistedCubicRepairHypergraph _ _).symm
          _ = (Fintype.card 𝔽 - 1) / 2 := hinfinity.1
      · rw [transversalNumber_minimalProjectiveAxisTwistedCubicRepairHypergraph]
        calc
          transversalNumber (projectiveAxisTwistedCubicRepairHypergraph
              (.inl (.inl a)) 3) =
              transversalNumber (projectiveAxisTwistedCubicRepairHypergraph
                (.inl (.inr Unit.unit)) 3) := htauRel.symm
          _ = transversalNumber (minimalProjectiveAxisTwistedCubicRepairHypergraph
                (.inl (.inr Unit.unit)) 3) :=
              (transversalNumber_minimalProjectiveAxisTwistedCubicRepairHypergraph _ _).symm
          _ = Fintype.card 𝔽 - 1 := hinfinity.2

/-- Exact full-port transversal number at axis infinity.  The local-primal separator theorem
turns the geometric maximum target-avoiding section size `4` into `τ = 2q-3`. -/
theorem projectiveAxisInfinityFullRepair_transversalNumber [CharP 𝔽 3] :
    transversalNumber
      (projectiveAxisTwistedCubicRepairHypergraph
        (.inr (.inr Unit.unit) : ProjectiveAxisTwistedCubicIndex 𝔽)
        (Fintype.card (ProjectiveAxisTwistedCubicIndex 𝔽))) =
      2 * Fintype.card 𝔽 - 3 := by
  let x : ProjectiveAxisTwistedCubicIndex 𝔽 := .inr (.inr Unit.unit)
  let a := projectiveAxisInfinityAvoidingFourSectionForm 𝔽
  let T := (wordSupport fun j => projectiveAxisTwistedCubicPoints 𝔽 j ⬝ᵥ a).erase x
  have hxa : projectiveAxisTwistedCubicPoints 𝔽 x ⬝ᵥ a ≠ 0 := by
    change axisTwistedCubicPoints 𝔽 (.inr (.inr Unit.unit)) ⬝ᵥ
      projectiveAxisInfinityAvoidingFourSectionForm 𝔽 ≠ 0
    rw [projectiveAxisInfinityAvoidingFourSectionForm_axisInfinity_eval]
    exact one_ne_zero
  have hT : IsTransversal
      (projectiveAxisTwistedCubicRepairHypergraph x
        (Fintype.card (ProjectiveAxisTwistedCubicIndex 𝔽))) T := by
    change IsTransversal
      (repairHypergraph (rowCode (fun i j => projectiveAxisTwistedCubicPoints 𝔽 j i)) x
        (Fintype.card (ProjectiveAxisTwistedCubicIndex 𝔽))) T
    exact sectionFunctionalSupport_isTransversal_fullRepair
      (projectiveAxisTwistedCubicPoints 𝔽) a x hxa
  apply le_antisymm
  · have hle := transversalNumber_le_card hT
    have hle' : transversalNumber
        (projectiveAxisTwistedCubicRepairHypergraph
          (.inr (.inr Unit.unit) : ProjectiveAxisTwistedCubicIndex 𝔽)
          (Fintype.card (ProjectiveAxisTwistedCubicIndex 𝔽))) ≤ T.card := by
      simpa [x] using hle
    have hcard := card_sectionFunctionalSupport_erase_add_sectionCount
      (projectiveAxisTwistedCubicPoints 𝔽) a x hxa
    rw [projectiveAxisInfinityAvoidingFourSectionForm_sectionCount] at hcard
    simp only [card_projectiveAxisTwistedCubicIndex] at hcard
    change T.card + 4 + 1 = 2 * Fintype.card 𝔽 + 2 at hcard
    omega
  · apply le_transversalNumber_of_forall
    · exact ⟨T, hT⟩
    · intro S hS
      change IsTransversal
        (repairHypergraph (rowCode (fun i j => projectiveAxisTwistedCubicPoints 𝔽 j i)) x
          (Fintype.card (ProjectiveAxisTwistedCubicIndex 𝔽))) S at hS
      have hge := fullRepair_transversal_card_ge_of_avoiding_section_le
        (projectiveAxisTwistedCubicPoints 𝔽) x
        (s := 4) (fun b hb => projectiveAxisInfinity_avoiding_section_le_four b hb) hS
      simp only [card_projectiveAxisTwistedCubicIndex] at hge
      omega

/-- Exact full-port transversal number at cubic infinity.  The global maximum section `q+2`
already avoids this target, so the full port has `τ=q-1`. -/
theorem projectiveCubicInfinityFullRepair_transversalNumber [CharP 𝔽 3] :
    transversalNumber
      (projectiveAxisTwistedCubicRepairHypergraph
        (.inl (.inr Unit.unit) : ProjectiveAxisTwistedCubicIndex 𝔽)
        (Fintype.card (ProjectiveAxisTwistedCubicIndex 𝔽))) =
      Fintype.card 𝔽 - 1 := by
  let x : ProjectiveAxisTwistedCubicIndex 𝔽 := .inl (.inr Unit.unit)
  let a := projectiveAxisTwistedCubicMaxForm 𝔽
  let T := (wordSupport fun j => projectiveAxisTwistedCubicPoints 𝔽 j ⬝ᵥ a).erase x
  have hxa : projectiveAxisTwistedCubicPoints 𝔽 x ⬝ᵥ a ≠ 0 := by
    change projectiveTwistedCubicPoints 𝔽 (.inr Unit.unit) ⬝ᵥ
      projectiveAxisTwistedCubicMaxForm 𝔽 ≠ 0
    rw [projectiveAxisTwistedCubicMaxForm_cubicInfinity_eval]
    exact one_ne_zero
  have hT : IsTransversal
      (projectiveAxisTwistedCubicRepairHypergraph x
        (Fintype.card (ProjectiveAxisTwistedCubicIndex 𝔽))) T := by
    change IsTransversal
      (repairHypergraph (rowCode (fun i j => projectiveAxisTwistedCubicPoints 𝔽 j i)) x
        (Fintype.card (ProjectiveAxisTwistedCubicIndex 𝔽))) T
    exact sectionFunctionalSupport_isTransversal_fullRepair
      (projectiveAxisTwistedCubicPoints 𝔽) a x hxa
  apply le_antisymm
  · have hle := transversalNumber_le_card hT
    have hle' : transversalNumber
        (projectiveAxisTwistedCubicRepairHypergraph
          (.inl (.inr Unit.unit) : ProjectiveAxisTwistedCubicIndex 𝔽)
          (Fintype.card (ProjectiveAxisTwistedCubicIndex 𝔽))) ≤ T.card := by
      simpa [x] using hle
    have hcard := card_sectionFunctionalSupport_erase_add_sectionCount
      (projectiveAxisTwistedCubicPoints 𝔽) a x hxa
    rw [projectiveAxisTwistedCubicMaxForm_sectionCount] at hcard
    simp only [card_projectiveAxisTwistedCubicIndex] at hcard
    change T.card + (Fintype.card 𝔽 + 2) + 1 = 2 * Fintype.card 𝔽 + 2 at hcard
    omega
  · apply le_transversalNumber_of_forall
    · exact ⟨T, hT⟩
    · intro S hS
      change IsTransversal
        (repairHypergraph (rowCode (fun i j => projectiveAxisTwistedCubicPoints 𝔽 j i)) x
          (Fintype.card (ProjectiveAxisTwistedCubicIndex 𝔽))) S at hS
      have hge := fullRepair_transversal_card_ge_of_avoiding_section_le
        (projectiveAxisTwistedCubicPoints 𝔽) x
        (s := Fintype.card 𝔽 + 2)
        (fun b hb => projectiveAxisTwistedCubic_section_le b (fun h => hb (by simp [x, h]))) hS
      simp only [card_projectiveAxisTwistedCubicIndex] at hge
      omega

/-- Every inclusion-minimal radius-four repair at cubic infinity consumes at least two other
cubic coordinates. -/
theorem minimalProjectiveCubicInfinityRepair_four_cubicPart_card_ge_two [CharP 𝔽 3]
    {E : Finset (ProjectiveAxisTwistedCubicIndex 𝔽)}
    (hE : E ∈ minimalProjectiveAxisTwistedCubicRepairHypergraph
      (.inl (.inr Unit.unit)) 4) :
    2 ≤ (projectiveCubicPart E).card := by
  have hli : LinearIndependent 𝔽
      (fun j : E => projectiveAxisTwistedCubicPoints 𝔽 j) := by
    exact minimalRepair_helpers_linearIndependent hE
  have haxis := projectiveAxisPart_card_le_two_of_linearIndependent hli
  have hpartition := card_projectiveCubicPart_add_card_projectiveAxisPart E
  by_contra hcubic
  have hcard : E.card ≤ 3 := by omega
  have hErepair := (mem_minimalHyperedges.mp hE).1
  have hE3 : E ∈ projectiveAxisTwistedCubicRepairHypergraph
      (.inl (.inr Unit.unit)) 3 :=
    mem_repairHypergraph_of_mem_of_card_le hErepair hcard
  obtain ⟨s, t, hst, rfl⟩ := mem_projectiveCubicInfinityRepairHypergraph_iff.mp hE3
  have hcpart : projectiveCubicPart
      {(.inl (.inl s) : ProjectiveAxisTwistedCubicIndex 𝔽), .inl (.inl t),
        .inr (.inl (s + t))} = {(.inl (.inl s)), .inl (.inl t)} := by
    ext z
    rcases z with ((z | z) | (z | z)) <;> simp [projectiveCubicPart]
  rw [hcpart] at hcubic
  simp [hst] at hcubic

/-- Every inclusion-minimal radius-four repair at axis infinity has weighted resource cost at
least one, with cubic helpers weighted `1/3` and axis helpers weighted `1/2`. -/
theorem minimalProjectiveAxisInfinityRepair_four_weight [CharP 𝔽 3]
    {E : Finset (ProjectiveAxisTwistedCubicIndex 𝔽)}
    (hE : E ∈ minimalProjectiveAxisTwistedCubicRepairHypergraph
      (.inr (.inr Unit.unit)) 4) :
    6 ≤ 2 * (projectiveCubicPart E).card + 3 * (projectiveAxisPart E).card := by
  have hli : LinearIndependent 𝔽
      (fun j : E => projectiveAxisTwistedCubicPoints 𝔽 j) := by
    exact minimalRepair_helpers_linearIndependent hE
  have haxis := projectiveAxisPart_card_le_two_of_linearIndependent hli
  have hpartition := card_projectiveCubicPart_add_card_projectiveAxisPart E
  by_contra hweight
  have hcard : E.card ≤ 3 := by omega
  have hErepair := (mem_minimalHyperedges.mp hE).1
  have hE3 : E ∈ projectiveAxisTwistedCubicRepairHypergraph
      (.inr (.inr Unit.unit)) 3 :=
    mem_repairHypergraph_of_mem_of_card_le hErepair hcard
  have hEmin3 : E ∈ minimalProjectiveAxisTwistedCubicRepairHypergraph
      (.inr (.inr Unit.unit)) 3 := by
    apply mem_minimalHyperedges.mpr
    refine ⟨hE3, ?_⟩
    intro B hB3 hBE
    have hB4 := repairHypergraph_mono_radius (by omega : 3 ≤ 4) hB3
    exact (mem_minimalHyperedges.mp hE).2 B hB4 hBE
  rcases mem_minimalProjectiveAxisInfinityRepair_iff.mp hEmin3 with hpair | hcubic
  · obtain ⟨z, w, -, -, hzw, rfl⟩ := hpair
    have hcpart : projectiveCubicPart
        {(.inr z : ProjectiveAxisTwistedCubicIndex 𝔽), .inr w} = ∅ := by
      ext v
      rcases v with ((v | v) | (v | v)) <;> simp [projectiveCubicPart]
    have hapart : projectiveAxisPart
        {(.inr z : ProjectiveAxisTwistedCubicIndex 𝔽), .inr w} = {.inr z, .inr w} := by
      ext v
      rcases v with ((v | v) | (v | v)) <;> simp [projectiveAxisPart]
    rw [hcpart, hapart] at hweight
    simp [hzw] at hweight
  · obtain ⟨s, t, u, hst, hsu, htu, -, rfl⟩ := hcubic
    have hcpart : projectiveCubicPart
        {(.inl (.inl s) : ProjectiveAxisTwistedCubicIndex 𝔽),
          .inl (.inl t), .inl (.inl u)} =
        {(.inl (.inl s)), .inl (.inl t), .inl (.inl u)} := by
      ext v
      rcases v with ((v | v) | (v | v)) <;> simp [projectiveCubicPart]
    have hapart : projectiveAxisPart
        {(.inl (.inl s) : ProjectiveAxisTwistedCubicIndex 𝔽),
          .inl (.inl t), .inl (.inl u)} = ∅ := by
      ext v
      rcases v with ((v | v) | (v | v)) <;> simp [projectiveAxisPart]
    rw [hcpart, hapart] at hweight
    simp [hst, hsu, htu] at hweight

/-- A matching in the cubic-infinity radius-four clutter consumes at least two of the `q`
remaining cubic coordinates per edge. -/
theorem minimalProjectiveCubicInfinityRepair_four_matching_card_bound [CharP 𝔽 3]
    {M : Finset (Finset (ProjectiveAxisTwistedCubicIndex 𝔽))}
    (hM : IsMatching
      (minimalProjectiveAxisTwistedCubicRepairHypergraph (.inl (.inr Unit.unit)) 4) M) :
    2 * M.card ≤ Fintype.card 𝔽 := by
  classical
  have hpairwise :
      (M : Set (Finset (ProjectiveAxisTwistedCubicIndex 𝔽))).PairwiseDisjoint
        projectiveCubicPart := by
    intro A hA B hB hAB
    exact (hM.2 hA hB hAB).mono (Finset.filter_subset _ _) (Finset.filter_subset _ _)
  have hsub : M.biUnion projectiveCubicPart ⊆
      (univ.erase (.inr Unit.unit : ProjectiveTwistedCubicIndex 𝔽)).map
        Function.Embedding.inl := by
    intro z hz
    obtain ⟨E, hEM, hzE⟩ := Finset.mem_biUnion.mp hz
    obtain ⟨u, rfl⟩ := (Finset.mem_filter.mp hzE).2
    have hrepair := (mem_minimalHyperedges.mp (hM.1 hEM)).1
    have hhelpers := (mem_repairHypergraph.mp hrepair).1
    have hne : u ≠ (.inr Unit.unit : ProjectiveTwistedCubicIndex 𝔽) := by
      intro h
      subst u
      exact (Finset.mem_erase.mp (hhelpers (Finset.mem_filter.mp hzE).1)).1 rfl
    exact Finset.mem_map.mpr ⟨u, by simp [hne], rfl⟩
  calc
    2 * M.card = ∑ E ∈ M, 2 := by simp [Nat.mul_comm]
    _ ≤ ∑ E ∈ M, (projectiveCubicPart E).card := by
      apply Finset.sum_le_sum
      intro E hE
      exact minimalProjectiveCubicInfinityRepair_four_cubicPart_card_ge_two (hM.1 hE)
    _ = (M.biUnion projectiveCubicPart).card := (Finset.card_biUnion hpairwise).symm
    _ ≤ ((univ.erase (.inr Unit.unit : ProjectiveTwistedCubicIndex 𝔽)).map
        Function.Embedding.inl).card := Finset.card_le_card hsub
    _ = Fintype.card 𝔽 := by simp

/-- Exact cubic-infinity matching number for radius four (hence for the full minimal port). -/
theorem minimalProjectiveCubicInfinityRepair_four_matchingNumber [CharP 𝔽 3] :
    matchingNumber
      (minimalProjectiveAxisTwistedCubicRepairHypergraph
        (.inl (.inr Unit.unit) : ProjectiveAxisTwistedCubicIndex 𝔽) 4) =
      (Fintype.card 𝔽 - 1) / 2 := by
  apply le_antisymm
  · apply matchingNumber_le_of_forall
    intro M hM
    have hbound := minimalProjectiveCubicInfinityRepair_four_matching_card_bound hM
    have hodd := FiniteField.odd_card_of_char_ne_two (F := 𝔽) (by
      rw [ringChar.eq 𝔽 3]
      decide)
    omega
  · calc
      (Fintype.card 𝔽 - 1) / 2 =
          matchingNumber (minimalProjectiveAxisTwistedCubicRepairHypergraph
            (.inl (.inr Unit.unit) : ProjectiveAxisTwistedCubicIndex 𝔽) 3) :=
        (minimalProjectiveCubicInfinityRepair_invariants ( 𝔽 := 𝔽)).1.symm
      _ ≤ matchingNumber (minimalProjectiveAxisTwistedCubicRepairHypergraph
            (.inl (.inr Unit.unit) : ProjectiveAxisTwistedCubicIndex 𝔽) 4) :=
        matchingNumber_mono (minimalRepairHypergraph_mono_radius (by omega))

/-- Weighted resource bound for a radius-four axis-infinity matching.  Cubic infinity adds two
units of capacity, but characteristic-three cardinal arithmetic leaves the old optimum unchanged. -/
theorem minimalProjectiveAxisInfinityRepair_four_matching_weight_bound [CharP 𝔽 3]
    {M : Finset (Finset (ProjectiveAxisTwistedCubicIndex 𝔽))}
    (hM : IsMatching
      (minimalProjectiveAxisTwistedCubicRepairHypergraph (.inr (.inr Unit.unit)) 4) M) :
    6 * M.card ≤ 5 * Fintype.card 𝔽 + 2 := by
  classical
  have hcubicPairwise :
      (M : Set (Finset (ProjectiveAxisTwistedCubicIndex 𝔽))).PairwiseDisjoint
        projectiveCubicPart := by
    intro A hA B hB hAB
    exact (hM.2 hA hB hAB).mono (Finset.filter_subset _ _) (Finset.filter_subset _ _)
  have haxisPairwise :
      (M : Set (Finset (ProjectiveAxisTwistedCubicIndex 𝔽))).PairwiseDisjoint
        projectiveAxisPart := by
    intro A hA B hB hAB
    exact (hM.2 hA hB hAB).mono (Finset.filter_subset _ _) (Finset.filter_subset _ _)
  have hcubicSub : M.biUnion projectiveCubicPart ⊆
      (univ : Finset (ProjectiveTwistedCubicIndex 𝔽)).map Function.Embedding.inl := by
    intro z hz
    obtain ⟨E, -, hzE⟩ := Finset.mem_biUnion.mp hz
    obtain ⟨u, rfl⟩ := (Finset.mem_filter.mp hzE).2
    simp
  have haxisSub : M.biUnion projectiveAxisPart ⊆
      (univ.erase (.inr Unit.unit : 𝔽 ⊕ Unit)).map Function.Embedding.inr := by
    intro z hz
    obtain ⟨E, hEM, hzE⟩ := Finset.mem_biUnion.mp hz
    obtain ⟨u, rfl⟩ := (Finset.mem_filter.mp hzE).2
    have hrepair := (mem_minimalHyperedges.mp (hM.1 hEM)).1
    have hhelpers := (mem_repairHypergraph.mp hrepair).1
    have hne : u ≠ (.inr Unit.unit : 𝔽 ⊕ Unit) := by
      intro h
      subst u
      exact (Finset.mem_erase.mp (hhelpers (Finset.mem_filter.mp hzE).1)).1 rfl
    exact Finset.mem_map.mpr ⟨u, by simp [hne], rfl⟩
  have hcubicCard : (∑ E ∈ M, (projectiveCubicPart E).card) ≤ Fintype.card 𝔽 + 1 := by
    rw [← Finset.card_biUnion hcubicPairwise]
    have := Finset.card_le_card hcubicSub
    simpa using this
  have haxisCard : (∑ E ∈ M, (projectiveAxisPart E).card) ≤ Fintype.card 𝔽 := by
    rw [← Finset.card_biUnion haxisPairwise]
    have := Finset.card_le_card haxisSub
    simpa using this
  have htotal : 6 * M.card ≤
      2 * (∑ E ∈ M, (projectiveCubicPart E).card) +
        3 * (∑ E ∈ M, (projectiveAxisPart E).card) := by
    calc
      6 * M.card = ∑ E ∈ M, 6 := by simp [Nat.mul_comm]
      _ ≤ ∑ E ∈ M,
          (2 * (projectiveCubicPart E).card + 3 * (projectiveAxisPart E).card) := by
        apply Finset.sum_le_sum
        intro E hE
        exact minimalProjectiveAxisInfinityRepair_four_weight (hM.1 hE)
      _ = 2 * (∑ E ∈ M, (projectiveCubicPart E).card) +
          3 * (∑ E ∈ M, (projectiveAxisPart E).card) := by
        simp only [Finset.mul_sum, Finset.sum_add_distrib]
  omega

/-- Exact axis-infinity matching number for radius four (hence for the full minimal port). -/
theorem minimalProjectiveAxisInfinityRepair_four_matchingNumber [CharP 𝔽 3] :
    matchingNumber
      (minimalProjectiveAxisTwistedCubicRepairHypergraph
        (.inr (.inr Unit.unit) : ProjectiveAxisTwistedCubicIndex 𝔽) 4) =
      (5 * Fintype.card 𝔽 - 3) / 6 := by
  apply le_antisymm
  · apply matchingNumber_le_of_forall
    intro M hM
    have hbound := minimalProjectiveAxisInfinityRepair_four_matching_weight_bound hM
    obtain ⟨n, -, hcard⟩ := FiniteField.card 𝔽 3
    have hdiv : 3 ∣ Fintype.card 𝔽 := by
      rw [hcard]
      exact dvd_pow_self 3 n.ne_zero
    obtain ⟨m, hm⟩ := hdiv
    have hodd := FiniteField.odd_card_of_char_ne_two (F := 𝔽) (by
      rw [ringChar.eq 𝔽 3]
      decide)
    omega
  · calc
      (5 * Fintype.card 𝔽 - 3) / 6 =
          matchingNumber (minimalProjectiveAxisTwistedCubicRepairHypergraph
            (.inr (.inr Unit.unit) : ProjectiveAxisTwistedCubicIndex 𝔽) 3) :=
        (minimalProjectiveAxisInfinityRepair_invariants ( 𝔽 := 𝔽)).1.symm
      _ ≤ matchingNumber (minimalProjectiveAxisTwistedCubicRepairHypergraph
            (.inr (.inr Unit.unit) : ProjectiveAxisTwistedCubicIndex 𝔽) 4) :=
        matchingNumber_mono (minimalRepairHypergraph_mono_radius (by omega))

/-- Exact radius-four row at cubic infinity.  Rank four makes this the full minimal repair port. -/
theorem minimalProjectiveCubicInfinityRepair_four_invariants [CharP 𝔽 3] :
    matchingNumber (minimalProjectiveAxisTwistedCubicRepairHypergraph
        (.inl (.inr Unit.unit) : ProjectiveAxisTwistedCubicIndex 𝔽) 4) =
        (Fintype.card 𝔽 - 1) / 2 ∧
      transversalNumber (minimalProjectiveAxisTwistedCubicRepairHypergraph
        (.inl (.inr Unit.unit) : ProjectiveAxisTwistedCubicIndex 𝔽) 4) =
        Fintype.card 𝔽 - 1 := by
  constructor
  · exact minimalProjectiveCubicInfinityRepair_four_matchingNumber
  · let x : ProjectiveAxisTwistedCubicIndex 𝔽 := .inl (.inr Unit.unit)
    let n := Fintype.card (ProjectiveAxisTwistedCubicIndex 𝔽)
    have hfour : 4 ≤ n := by
      simp [n]
      have := Fintype.card_pos_iff.mpr ⟨(0 : 𝔽)⟩
      omega
    have hstab := minimalRepairHypergraph_eq_of_numRows_le_radius
      (G := projectiveAxisTwistedCubicGenerator ( 𝔽 := 𝔽)) (x := x) hfour
    calc
      transversalNumber (minimalProjectiveAxisTwistedCubicRepairHypergraph x 4) =
          transversalNumber (minimalProjectiveAxisTwistedCubicRepairHypergraph x n) := by
        simpa [minimalProjectiveAxisTwistedCubicRepairHypergraph,
          projectiveAxisTwistedCubicCode, n] using congrArg transversalNumber hstab.symm
      _ = transversalNumber (projectiveAxisTwistedCubicRepairHypergraph x n) :=
        transversalNumber_minimalProjectiveAxisTwistedCubicRepairHypergraph x n
      _ = Fintype.card 𝔽 - 1 := by
        simpa [x, n] using projectiveCubicInfinityFullRepair_transversalNumber ( 𝔽 := 𝔽)

/-- Exact radius-four row at axis infinity.  Rank four makes this the full minimal repair port. -/
theorem minimalProjectiveAxisInfinityRepair_four_invariants [CharP 𝔽 3] :
    matchingNumber (minimalProjectiveAxisTwistedCubicRepairHypergraph
        (.inr (.inr Unit.unit) : ProjectiveAxisTwistedCubicIndex 𝔽) 4) =
        (5 * Fintype.card 𝔽 - 3) / 6 ∧
      transversalNumber (minimalProjectiveAxisTwistedCubicRepairHypergraph
        (.inr (.inr Unit.unit) : ProjectiveAxisTwistedCubicIndex 𝔽) 4) =
        2 * Fintype.card 𝔽 - 3 := by
  constructor
  · exact minimalProjectiveAxisInfinityRepair_four_matchingNumber
  · let x : ProjectiveAxisTwistedCubicIndex 𝔽 := .inr (.inr Unit.unit)
    let n := Fintype.card (ProjectiveAxisTwistedCubicIndex 𝔽)
    have hfour : 4 ≤ n := by
      simp [n]
      have := Fintype.card_pos_iff.mpr ⟨(0 : 𝔽)⟩
      omega
    have hstab := minimalRepairHypergraph_eq_of_numRows_le_radius
      (G := projectiveAxisTwistedCubicGenerator ( 𝔽 := 𝔽)) (x := x) hfour
    calc
      transversalNumber (minimalProjectiveAxisTwistedCubicRepairHypergraph x 4) =
          transversalNumber (minimalProjectiveAxisTwistedCubicRepairHypergraph x n) := by
        simpa [minimalProjectiveAxisTwistedCubicRepairHypergraph,
          projectiveAxisTwistedCubicCode, n] using congrArg transversalNumber hstab.symm
      _ = transversalNumber (projectiveAxisTwistedCubicRepairHypergraph x n) :=
        transversalNumber_minimalProjectiveAxisTwistedCubicRepairHypergraph x n
      _ = 2 * Fintype.card 𝔽 - 3 := by
        simpa [x, n] using projectiveAxisInfinityFullRepair_transversalNumber ( 𝔽 := 𝔽)

/-- Exact uniform radius-four/full-minimal row for every completed cubic coordinate. -/
theorem minimalProjectiveCubicRepair_four_invariants [CharP 𝔽 3]
    (x : ProjectiveTwistedCubicIndex 𝔽) :
    matchingNumber (minimalProjectiveAxisTwistedCubicRepairHypergraph (.inl x) 4) =
        (Fintype.card 𝔽 - 1) / 2 ∧
      transversalNumber (minimalProjectiveAxisTwistedCubicRepairHypergraph (.inl x) 4) =
        Fintype.card 𝔽 - 1 := by
  cases x with
  | inr u => simpa using minimalProjectiveCubicInfinityRepair_four_invariants ( 𝔽 := 𝔽)
  | inl a =>
      have htarget : projectiveShiftInvIndexEquiv (-a)
          (.inl (.inl a) : ProjectiveAxisTwistedCubicIndex 𝔽) =
          .inl (.inr Unit.unit) := by
        simp [projectiveShiftInvIndexEquiv, projectiveAxisShiftInvEquiv]
      have hrel := projectiveShiftInv_relabel_minimalRepairHypergraph (-a)
        (.inl (.inl a) : ProjectiveAxisTwistedCubicIndex 𝔽) 4
      rw [htarget] at hrel
      have hm := matchingNumber_relabelHypergraph (projectiveShiftInvIndexEquiv (-a))
        (minimalProjectiveAxisTwistedCubicRepairHypergraph
          (.inl (.inl a) : ProjectiveAxisTwistedCubicIndex 𝔽) 4)
      have ht := transversalNumber_relabelHypergraph (projectiveShiftInvIndexEquiv (-a))
        (minimalProjectiveAxisTwistedCubicRepairHypergraph
          (.inl (.inl a) : ProjectiveAxisTwistedCubicIndex 𝔽) 4)
      rw [hrel] at hm ht
      have hi := minimalProjectiveCubicInfinityRepair_four_invariants ( 𝔽 := 𝔽)
      exact ⟨hm.symm.trans hi.1, ht.symm.trans hi.2⟩

/-- Exact uniform radius-four/full-minimal row for every completed axis coordinate. -/
theorem minimalProjectiveAxisRepair_four_invariants [CharP 𝔽 3] (y : 𝔽 ⊕ Unit) :
    matchingNumber (minimalProjectiveAxisTwistedCubicRepairHypergraph (.inr y) 4) =
        (5 * Fintype.card 𝔽 - 3) / 6 ∧
      transversalNumber (minimalProjectiveAxisTwistedCubicRepairHypergraph (.inr y) 4) =
        2 * Fintype.card 𝔽 - 3 := by
  cases y with
  | inr u => simpa using minimalProjectiveAxisInfinityRepair_four_invariants ( 𝔽 := 𝔽)
  | inl a =>
      have htarget : projectiveShiftInvIndexEquiv a
          (.inr (.inl a) : ProjectiveAxisTwistedCubicIndex 𝔽) =
          .inr (.inr Unit.unit) := by
        simp [projectiveShiftInvIndexEquiv, projectiveAxisShiftInvEquiv]
      have hrel := projectiveShiftInv_relabel_minimalRepairHypergraph a
        (.inr (.inl a) : ProjectiveAxisTwistedCubicIndex 𝔽) 4
      rw [htarget] at hrel
      have hm := matchingNumber_relabelHypergraph (projectiveShiftInvIndexEquiv a)
        (minimalProjectiveAxisTwistedCubicRepairHypergraph
          (.inr (.inl a) : ProjectiveAxisTwistedCubicIndex 𝔽) 4)
      have ht := transversalNumber_relabelHypergraph (projectiveShiftInvIndexEquiv a)
        (minimalProjectiveAxisTwistedCubicRepairHypergraph
          (.inr (.inl a) : ProjectiveAxisTwistedCubicIndex 𝔽) 4)
      rw [hrel] at hm ht
      have hi := minimalProjectiveAxisInfinityRepair_four_invariants ( 𝔽 := 𝔽)
      exact ⟨hm.symm.trans hi.1, ht.symm.trans hi.2⟩

/-- Radius four exhausts the full inclusion-minimal repair port at every completed coordinate. -/
theorem minimalProjectiveAxisTwistedCubicRepair_full_eq_four
    (x : ProjectiveAxisTwistedCubicIndex 𝔽) :
    minimalProjectiveAxisTwistedCubicRepairHypergraph x
        (Fintype.card (ProjectiveAxisTwistedCubicIndex 𝔽)) =
      minimalProjectiveAxisTwistedCubicRepairHypergraph x 4 := by
  have hfour : 4 ≤ Fintype.card (ProjectiveAxisTwistedCubicIndex 𝔽) := by
    simp
    have := Fintype.card_pos_iff.mpr ⟨(0 : 𝔽)⟩
    omega
  exact minimalRepairHypergraph_eq_of_numRows_le_radius
    (G := projectiveAxisTwistedCubicGenerator ( 𝔽 := 𝔽)) (x := x) hfour

/-- Exact full minimal repair-port invariants for every completed cubic coordinate. -/
theorem minimalProjectiveCubicRepair_full_invariants [CharP 𝔽 3]
    (x : ProjectiveTwistedCubicIndex 𝔽) :
    matchingNumber (minimalProjectiveAxisTwistedCubicRepairHypergraph (.inl x)
        (Fintype.card (ProjectiveAxisTwistedCubicIndex 𝔽))) =
        (Fintype.card 𝔽 - 1) / 2 ∧
      transversalNumber (minimalProjectiveAxisTwistedCubicRepairHypergraph (.inl x)
        (Fintype.card (ProjectiveAxisTwistedCubicIndex 𝔽))) =
        Fintype.card 𝔽 - 1 := by
  rw [minimalProjectiveAxisTwistedCubicRepair_full_eq_four]
  exact minimalProjectiveCubicRepair_four_invariants x

/-- Exact full minimal repair-port invariants for every completed axis coordinate. -/
theorem minimalProjectiveAxisRepair_full_invariants [CharP 𝔽 3] (y : 𝔽 ⊕ Unit) :
    matchingNumber (minimalProjectiveAxisTwistedCubicRepairHypergraph (.inr y)
        (Fintype.card (ProjectiveAxisTwistedCubicIndex 𝔽))) =
        (5 * Fintype.card 𝔽 - 3) / 6 ∧
      transversalNumber (minimalProjectiveAxisTwistedCubicRepairHypergraph (.inr y)
        (Fintype.card (ProjectiveAxisTwistedCubicIndex 𝔽))) =
        2 * Fintype.card 𝔽 - 3 := by
  rw [minimalProjectiveAxisTwistedCubicRepair_full_eq_four]
  exact minimalProjectiveAxisRepair_four_invariants y

#print axioms projectiveAxisShiftInvEquiv
#print axioms projectiveAxisShiftInvEquiv_eq_infinity_iff
#print axioms projectiveShiftInvLinearEquiv
#print axioms projectiveShiftInvLinearMap_cubic_finite_of_ne
#print axioms projectiveShiftInvLinearMap_axis_finite_of_ne
#print axioms projectiveShiftInvLinearMap_column
#print axioms projectiveShiftInv_linearIndependent_iff
#print axioms projectiveShiftInv_finset_linearIndependent_iff
#print axioms isProjectiveAxisTwistedCubicCircuit_map_iff
#print axioms minimalProjectiveAxisInfinityRepair_eq_embedAffine
#print axioms minimalProjectiveAxisInfinityRepair_invariants
#print axioms projectiveShiftInv_relabel_repairHypergraph
#print axioms minimalProjectiveAxisRepair_invariants
#print axioms mem_projectiveCubicInfinityRepairHypergraph_iff
#print axioms projectiveCubicInfinityRepair_matchingNumber
#print axioms projectiveCubicInfinityRepair_transversalNumber
#print axioms minimalProjectiveCubicRepair_invariants
#print axioms projectiveAxisInfinityFullRepair_transversalNumber
#print axioms projectiveCubicInfinityFullRepair_transversalNumber
#print axioms minimalProjectiveCubicRepair_full_invariants
#print axioms minimalProjectiveAxisRepair_full_invariants

end RepairCodes
