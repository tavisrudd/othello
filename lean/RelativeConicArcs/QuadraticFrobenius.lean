import RelativeConicArcs.ProjectiveConjugation
import FiniteGeom.BaerCompletion.OrbitCounting
import Mathlib.FieldTheory.Finite.Basic
import Mathlib.FieldTheory.Finite.Trace
import Mathlib.FieldTheory.Galois.Basic
import Mathlib.RepresentationTheory.Homological.GroupCohomology.Hilbert90
import Mathlib.Data.Sym.Sym2

/-!
# Quadratic Frobenius as projective incidence conjugation

For a quadratic extension of finite fields, the relative Frobenius has order two.  Applying it
coordinatewise therefore gives the concrete involutive projective incidence structure used in the
Baer-extension theorem.
-/

namespace RelativeConicArcs
namespace QuadraticFrobenius

open FiniteGeom.BaerCompletion

variable (F E : Type) [Field F] [Fintype F] [Field E] [Finite E] [Algebra F E]
  [Algebra.IsAlgebraic F E]

/-- Relative Frobenius, forgetting only its `F`-algebra structure. -/
noncomputable def frobeniusRingEquiv : E ≃+* E :=
  (FiniteField.frobeniusAlgEquivOfAlgebraic F E).toRingEquiv

/-- In any finite-field extension, the scalars fixed by relative Frobenius are exactly the image
of the base field.  This uses that relative Frobenius generates the finite Galois group. -/
theorem frobenius_fixed_iff_mem_range (x : E) :
    frobeniusRingEquiv F E x = x ↔ x ∈ Set.range (algebraMap F E) := by
  let σ := FiniteField.frobeniusAlgEquivOfAlgebraic F E
  constructor
  · intro hx
    have hxσ : σ x = x := hx
    apply (IsGalois.mem_range_algebraMap_iff_fixed x).2
    intro g
    obtain ⟨n, rfl⟩ := (FiniteField.bijective_frobeniusAlgEquivOfAlgebraic_pow F E).2 g
    change (σ ^ (n : ℕ)) x = x
    induction (n : ℕ) with
    | zero => simp
    | succ k ih =>
      rw [pow_succ, AlgEquiv.mul_apply, hxσ, ih]
  · rintro ⟨a, rfl⟩
    exact (FiniteField.frobeniusAlgEquivOfAlgebraic F E).commutes a

/-- In a quadratic finite-field extension, relative Frobenius is an involution. -/
theorem frobenius_involutive (hdeg : Module.finrank F E = 2) :
    Function.Involutive (frobeniusRingEquiv F E) := by
  intro a
  let σ := FiniteField.frobeniusAlgEquivOfAlgebraic F E
  have hord : orderOf σ = 2 := by
    rw [FiniteField.orderOf_frobeniusAlgEquivOfAlgebraic F E, hdeg]
  have hp := pow_orderOf_eq_one σ
  rw [hord] at hp
  have ha := DFunLike.congr_fun hp a
  simpa [σ, frobeniusRingEquiv, pow_two] using ha

/-- A semilinear eigenvector for quadratic Frobenius can be rescaled to a genuinely fixed vector.
This is the Hilbert-90 normalization step required to identify projectively fixed points with the
embedded base-field projective plane. -/
theorem exists_fixed_scalar_multiple (hdeg : Module.finrank F E = 2)
    {v : Fin 3 → E} (hv : v ≠ 0) {a : E}
    (heigen : ProjectiveConjugation.coordinatewise (frobeniusRingEquiv F E) v = a • v) :
    ∃ b : Eˣ,
      ProjectiveConjugation.coordinatewise (frobeniusRingEquiv F E) ((b : E) • v) =
        (b : E) • v := by
  let σ := FiniteField.frobeniusAlgEquivOfAlgebraic F E
  have hinv := frobenius_involutive F E hdeg
  have hinvσ : ∀ x, σ (σ x) = x := hinv
  have hcoord : ∀ i, σ (v i) = a * v i := by
    intro i
    exact congrFun heigen i
  have hi : ∃ i, v i ≠ 0 := by
    simpa [funext_iff] using hv
  obtain ⟨i, hi⟩ := hi
  have hnorm_pair : σ a * a = 1 := by
    have h := congrArg σ (hcoord i)
    rw [map_mul, hinvσ (v i), hcoord i] at h
    apply (mul_right_cancel₀ hi)
    simpa [mul_assoc] using h.symm
  have hnorm : Algebra.norm F a = 1 := by
    apply (algebraMap F E).injective
    rw [map_one, FiniteField.algebraMap_norm_eq_prod_pow, hdeg]
    simp only [Finset.prod_range_succ, Finset.prod_range_zero, Nat.card_eq_fintype_card,
      pow_zero, pow_one, one_mul]
    change a * σ a = 1
    simpa [mul_comm] using hnorm_pair
  have hgen : ∀ g : E ≃ₐ[F] E,
      g ∈ Subgroup.zpowers (FiniteField.frobeniusAlgEquivOfAlgebraic F E) := by
    intro g
    obtain ⟨n, rfl⟩ :=
      (FiniteField.bijective_frobeniusAlgEquivOfAlgebraic_pow F E).2 g
    exact Subgroup.npow_mem_zpowers _ _
  obtain ⟨b, hb⟩ := groupCohomology.exists_div_of_norm_eq_one
    (K := F) (L := E) (g := σ) hgen hnorm
  refine ⟨b, ?_⟩
  have hbval : (b : E) / σ b = a := hb
  have hσba : σ b * a = (b : E) := by
    have hσb : σ (b : E) ≠ 0 := (map_ne_zero σ).2 b.ne_zero
    have := (div_eq_iff hσb).mp hbval
    simpa [mul_comm] using this.symm
  ext j
  change σ ((b : E) * v j) = (b : E) * v j
  rw [map_mul, hcoord j, ← mul_assoc, hσba]

/-- Coordinatewise scalar extension from the base field. -/
def baseChange : (Fin 3 → F) →ₛₗ[algebraMap F E] (Fin 3 → E) where
  toFun v i := algebraMap F E (v i)
  map_add' v w := by ext i; simp
  map_smul' a v := by ext i; simp

omit [Fintype F] [Finite E] [Algebra.IsAlgebraic F E] in
theorem baseChange_injective : Function.Injective (baseChange F E) := by
  intro v w h
  ext i
  exact (algebraMap F E).injective (congrFun h i)

/-- The canonical embedding `PG(2,F) → PG(2,E)`. -/
def projectiveBaseChange :
    ProjectiveConjugation.Point F → ProjectiveConjugation.Point E :=
  Projectivization.map (baseChange F E) (baseChange_injective F E)

omit [Fintype F] [Finite E] [Algebra.IsAlgebraic F E] in
/-- Scalar extension embeds the base-field projective plane. -/
theorem projectiveBaseChange_injective : Function.Injective (projectiveBaseChange F E) := by
  intro p q hpq
  induction p using Projectivization.ind with
  | h v hv =>
    induction q using Projectivization.ind with
    | h w hw =>
      change Projectivization.map (baseChange F E) (baseChange_injective F E)
          (Projectivization.mk F v hv) =
        Projectivization.map (baseChange F E) (baseChange_injective F E)
          (Projectivization.mk F w hw) at hpq
      rw [Projectivization.map_mk, Projectivization.map_mk,
        Projectivization.mk_eq_mk_iff' E] at hpq
      obtain ⟨c, hc⟩ := hpq
      have hi : ∃ i, w i ≠ 0 := by simpa [funext_iff] using hw
      obtain ⟨i, hi⟩ := hi
      let d : F := v i / w i
      have hcval : c * algebraMap F E (w i) = algebraMap F E (v i) := congrFun hc i
      have hc_eq : c = algebraMap F E d := by
        change c = algebraMap F E (v i / w i)
        rw [map_div₀]
        apply (eq_div_iff ((map_ne_zero (algebraMap F E)).2 hi)).2
        exact hcval
      apply (Projectivization.mk_eq_mk_iff' F _ _ _ _).mpr
      refine ⟨d, ?_⟩
      ext j
      apply (algebraMap F E).injective
      change algebraMap F E (d * w j) = algebraMap F E (v j)
      rw [map_mul, ← hc_eq]
      exact congrFun hc j

omit [Fintype F] [Finite E] [Algebra.IsAlgebraic F E] in
/-- Scalar extension preserves and reflects point-line orthogonality. -/
theorem orthogonal_projectiveBaseChange_iff
    (p l : ProjectiveConjugation.Point F) :
    (projectiveBaseChange F E p).orthogonal (projectiveBaseChange F E l) ↔
      p.orthogonal l := by
  induction p using Projectivization.ind with
  | h v hv =>
    induction l using Projectivization.ind with
    | h w hw =>
      change (Projectivization.map (baseChange F E) (baseChange_injective F E)
          (Projectivization.mk F v hv)).orthogonal
        (Projectivization.map (baseChange F E) (baseChange_injective F E)
          (Projectivization.mk F w hw)) ↔ _
      rw [Projectivization.map_mk, Projectivization.map_mk,
        Projectivization.orthogonal_mk, Projectivization.orthogonal_mk]
      change (algebraMap F E ∘ v) ⬝ᵥ (algebraMap F E ∘ w) = 0 ↔ v ⬝ᵥ w = 0
      rw [← (algebraMap F E).map_dotProduct]
      exact (map_eq_zero (algebraMap F E)).trans Iff.rfl

/-- **Quadratic Frobenius fixed-locus theorem.** The projectively fixed points of relative
Frobenius on `PG(2,E)` are exactly the image of the canonical embedded `PG(2,F)`. -/
theorem projective_fixed_iff_mem_range_baseChange (hdeg : Module.finrank F E = 2)
    (p : ProjectiveConjugation.Point E) :
    ProjectiveConjugation.projectiveEquiv (frobeniusRingEquiv F E) p = p ↔
      p ∈ Set.range (projectiveBaseChange F E) := by
  constructor
  · intro hp
    induction p using Projectivization.ind with
    | h v hv =>
      obtain ⟨a, ha⟩ :=
        (ProjectiveConjugation.projectiveEquiv_mk_eq_iff
          (frobeniusRingEquiv F E) v hv).mp hp
      obtain ⟨b, hb⟩ := exists_fixed_scalar_multiple F E hdeg hv ha.symm
      have hbcoord : ∀ i, frobeniusRingEquiv F E ((b : E) * v i) = (b : E) * v i := by
        intro i
        exact congrFun hb i
      have hrange : ∀ i, (b : E) * v i ∈ Set.range (algebraMap F E) := by
        intro i
        exact (frobenius_fixed_iff_mem_range F E ((b : E) * v i)).mp (hbcoord i)
      choose u hu using hrange
      have huvec : baseChange F E u = (b : E) • v := by
        ext i
        exact hu i
      have hu0 : u ≠ 0 := by
        intro hzero
        have hwzero : (b : E) • v = 0 := by simpa [hzero] using huvec.symm
        exact hv ((smul_eq_zero.mp hwzero).resolve_left b.ne_zero)
      refine ⟨Projectivization.mk F u hu0, ?_⟩
      change Projectivization.map (baseChange F E) (baseChange_injective F E)
          (Projectivization.mk F u hu0) = Projectivization.mk E v hv
      rw [Projectivization.map_mk]
      apply (Projectivization.mk_eq_mk_iff' E _ _ _ _).mpr
      exact ⟨b, huvec.symm⟩
  · rintro ⟨q, rfl⟩
    induction q using Projectivization.ind with
    | h u hu =>
      change ProjectiveConjugation.projectiveEquiv (frobeniusRingEquiv F E)
          (Projectivization.map (baseChange F E) (baseChange_injective F E)
            (Projectivization.mk F u hu)) = _
      rw [Projectivization.map_mk]
      apply (ProjectiveConjugation.projectiveEquiv_mk_eq_iff
        (frobeniusRingEquiv F E) (baseChange F E u) _).mpr
      refine ⟨1, ?_⟩
      ext i
      simp only [Pi.smul_apply, one_smul]
      change algebraMap F E (u i) =
        FiniteField.frobeniusAlgEquivOfAlgebraic F E (algebraMap F E (u i))
      exact ((FiniteField.frobeniusAlgEquivOfAlgebraic F E).commutes (u i)).symm

/-- Projective points fixed by relative Frobenius. The same type also models fixed dual lines in
the orthogonality presentation of the plane. -/
abbrev FixedProjectivePoint :=
  {p : ProjectiveConjugation.Point E //
    ProjectiveConjugation.projectiveEquiv (frobeniusRingEquiv F E) p = p}

/-- The embedded base-field plane is equivalent to the quadratic-Frobenius fixed locus. -/
noncomputable def fixedPointEquiv (hdeg : Module.finrank F E = 2) :
    ProjectiveConjugation.Point F ≃ FixedProjectivePoint F E where
  toFun q := ⟨projectiveBaseChange F E q,
    (projective_fixed_iff_mem_range_baseChange F E hdeg _).2 ⟨q, rfl⟩⟩
  invFun p := Classical.choose
    ((projective_fixed_iff_mem_range_baseChange F E hdeg p).1 p.property)
  left_inv q := by
    apply projectiveBaseChange_injective F E
    exact Classical.choose_spec
      ((projective_fixed_iff_mem_range_baseChange F E hdeg
        (projectiveBaseChange F E q)).1
        ((projective_fixed_iff_mem_range_baseChange F E hdeg _).2 ⟨q, rfl⟩))
  right_inv p := by
    apply Subtype.ext
    exact Classical.choose_spec
      ((projective_fixed_iff_mem_range_baseChange F E hdeg p).1 p.property)

/-- There are exactly `s²+s+1` fixed projective points (and, dually, fixed lines), where
`s = #F`. -/
theorem natCard_fixedProjectivePoint (hdeg : Module.finrank F E = 2) :
    Nat.card (FixedProjectivePoint F E) = Nat.card F ^ 2 + Nat.card F + 1 := by
  calc
    Nat.card (FixedProjectivePoint F E) =
        Nat.card (ProjectiveConjugation.Point F) :=
      Nat.card_congr (fixedPointEquiv F E hdeg).symm
    _ = ∑ i ∈ Finset.range 3, Nat.card F ^ i := by
      apply Projectivization.card_of_finrank F (Fin 3 → F)
      simp
    _ = Nat.card F ^ 2 + Nat.card F + 1 := by
      norm_num [Finset.sum_range_succ]
      omega

/-- Fixed points incident with a fixed dual line. -/
abbrev FixedPointsOnFixedLine (l : FixedProjectivePoint F E) :=
  {p : FixedProjectivePoint F E // p.1.orthogonal l.1}

/-- Incidence on a fixed line is exactly incidence on the corresponding embedded base-field
line. -/
noncomputable def fixedPointsOnLineEquiv (hdeg : Module.finrank F E = 2)
    (l : FixedProjectivePoint F E) :
    {p : ProjectiveConjugation.Point F //
      p.orthogonal ((fixedPointEquiv F E hdeg).symm l)} ≃
      FixedPointsOnFixedLine F E l :=
  (fixedPointEquiv F E hdeg).subtypeEquiv fun p => by
    change p.orthogonal ((fixedPointEquiv F E hdeg).symm l) ↔
      (projectiveBaseChange F E p).orthogonal l.1
    have hl : projectiveBaseChange F E ((fixedPointEquiv F E hdeg).symm l) = l.1 :=
      congrArg Subtype.val ((fixedPointEquiv F E hdeg).apply_symm_apply l)
    rw [← hl]
    exact (orthogonal_projectiveBaseChange_iff F E p
      ((fixedPointEquiv F E hdeg).symm l)).symm

/-- Every fixed line contains exactly `s+1` fixed points, where `s=#F`. -/
theorem natCard_fixedPointsOnFixedLine (hdeg : Module.finrank F E = 2)
    (l : FixedProjectivePoint F E) :
    Nat.card (FixedPointsOnFixedLine F E l) = Nat.card F + 1 := by
  letI : DecidableEq F := Classical.decEq F
  calc
    Nat.card (FixedPointsOnFixedLine F E l) =
        Nat.card {p : ProjectiveConjugation.Point F //
          p.orthogonal ((fixedPointEquiv F E hdeg).symm l)} :=
      Nat.card_congr (fixedPointsOnLineEquiv F E hdeg l).symm
    _ = PlaneOrder (ProjectiveConjugation.Point F) (ProjectiveConjugation.Point F) + 1 :=
      card_points_on_line ((fixedPointEquiv F E hdeg).symm l)
    _ = Nat.card F + 1 := by
      rw [ProjectiveBridge.planeOrder_eq_card]
      simp

/-- All ambient points incident with a fixed dual line. -/
abbrev PointsOnFixedLine (l : FixedProjectivePoint F E) :=
  {p : ProjectiveConjugation.Point E // p.orthogonal l.1}

/-- Nonfixed ambient points incident with a fixed dual line. -/
abbrev NonfixedPointsOnFixedLine (l : FixedProjectivePoint F E) :=
  {p : PointsOnFixedLine F E l //
    ProjectiveConjugation.projectiveEquiv (frobeniusRingEquiv F E) p.1 ≠ p.1}

/-- Rebracketing equivalence between fixed points within a line and fixed projective points
incident with that line. -/
def fixedWithinLineEquiv (l : FixedProjectivePoint F E) :
    {p : PointsOnFixedLine F E l //
      ProjectiveConjugation.projectiveEquiv (frobeniusRingEquiv F E) p.1 = p.1} ≃
      FixedPointsOnFixedLine F E l where
  toFun p := ⟨⟨p.1.1, p.2⟩, p.1.2⟩
  invFun p := ⟨⟨p.1.1, p.2⟩, p.1.2⟩
  left_inv _ := rfl
  right_inv _ := rfl

/-- Every fixed line contains exactly `s²-s` nonfixed ambient points. Equivalently, those points
form `(s²-s)/2` conjugate pairs once the mate quotient is taken. -/
theorem natCard_nonfixedPointsOnFixedLine (hdeg : Module.finrank F E = 2)
    (l : FixedProjectivePoint F E) :
    Nat.card (NonfixedPointsOnFixedLine F E l) = Nat.card F ^ 2 - Nat.card F := by
  letI : Fintype E := Fintype.ofFinite E
  letI : DecidableEq E := Classical.decEq E
  letI : Fintype (ProjectiveConjugation.Point E) := Fintype.ofFinite _
  letI : Fintype (PointsOnFixedLine F E l) := Fintype.ofFinite _
  let fixedPred : PointsOnFixedLine F E l → Prop := fun p =>
    ProjectiveConjugation.projectiveEquiv (frobeniusRingEquiv F E) p.1 = p.1
  letI : Fintype {p : PointsOnFixedLine F E l // fixedPred p} := Fintype.ofFinite _
  letI : Fintype {p : PointsOnFixedLine F E l // ¬ fixedPred p} := Fintype.ofFinite _
  have htotal : Fintype.card (PointsOnFixedLine F E l) = Nat.card E + 1 := by
    rw [← Nat.card_eq_fintype_card]
    calc
      Nat.card (PointsOnFixedLine F E l) =
          PlaneOrder (ProjectiveConjugation.Point E) (ProjectiveConjugation.Point E) + 1 :=
        card_points_on_line l.1
      _ = Nat.card E + 1 := by
        rw [ProjectiveBridge.planeOrder_eq_card]
        simp
  have hfixed : Fintype.card {p : PointsOnFixedLine F E l // fixedPred p} =
      Nat.card F + 1 := by
    rw [← Nat.card_eq_fintype_card]
    calc
      Nat.card {p : PointsOnFixedLine F E l // fixedPred p} =
          Nat.card (FixedPointsOnFixedLine F E l) :=
        Nat.card_congr (fixedWithinLineEquiv F E l)
      _ = Nat.card F + 1 := natCard_fixedPointsOnFixedLine F E hdeg l
  have hnonfixed := Fintype.card_subtype_compl fixedPred
  have hE : Nat.card E = Nat.card F ^ 2 := by
    rw [Module.natCard_eq_pow_finrank (K := F) (V := E), hdeg]
  rw [Nat.card_eq_fintype_card]
  change Fintype.card {p : PointsOnFixedLine F E l // ¬ fixedPred p} = _
  rw [hnonfixed, htotal, hfixed, hE]
  omega

/-- Conjugation as a fixed-point-free involution on the nonfixed points of a fixed line. -/
noncomputable def nonfixedMate (hdeg : Module.finrank F E = 2)
    (l : FixedProjectivePoint F E) :
    NonfixedPointsOnFixedLine F E l ≃ NonfixedPointsOnFixedLine F E l where
  toFun p := by
    let σ := frobeniusRingEquiv F E
    have hproj := (ProjectiveConjugation.involutiveIncidence σ
      (frobenius_involutive F E hdeg)).point_involutive
    refine ⟨⟨ProjectiveConjugation.projectiveEquiv σ p.1.1, ?_⟩, ?_⟩
    · have hinc := (ProjectiveConjugation.orthogonal_projectiveEquiv_iff σ p.1.1 l.1).2 p.1.2
      rw [l.2] at hinc
      exact hinc
    · intro hfix
      exact p.2 (hfix.symm.trans (hproj p.1.1))
  invFun p := by
    let σ := frobeniusRingEquiv F E
    have hproj := (ProjectiveConjugation.involutiveIncidence σ
      (frobenius_involutive F E hdeg)).point_involutive
    refine ⟨⟨ProjectiveConjugation.projectiveEquiv σ p.1.1, ?_⟩, ?_⟩
    · have hinc := (ProjectiveConjugation.orthogonal_projectiveEquiv_iff σ p.1.1 l.1).2 p.1.2
      rw [l.2] at hinc
      exact hinc
    · intro hfix
      exact p.2 (hfix.symm.trans (hproj p.1.1))
  left_inv p := by
    apply Subtype.ext
    apply Subtype.ext
    exact (ProjectiveConjugation.involutiveIncidence (frobeniusRingEquiv F E)
      (frobenius_involutive F E hdeg)).point_involutive p.1.1
  right_inv p := by
    apply Subtype.ext
    apply Subtype.ext
    exact (ProjectiveConjugation.involutiveIncidence (frobeniusRingEquiv F E)
      (frobenius_involutive F E hdeg)).point_involutive p.1.1

/-- The unordered conjugate pair represented by a nonfixed point on a fixed line. -/
noncomputable def matePair (hdeg : Module.finrank F E = 2)
    (l : FixedProjectivePoint F E) (p : NonfixedPointsOnFixedLine F E l) :
    Sym2 (ProjectiveConjugation.Point E) :=
  s(p.1.1, (nonfixedMate F E hdeg l p).1.1)

/-- Candidate conjugate pairs on a fixed line. -/
noncomputable def nonfixedPointsOnFixedLineFinset
    (l : FixedProjectivePoint F E) : Finset (NonfixedPointsOnFixedLine F E l) := by
  classical
  letI : Fintype (NonfixedPointsOnFixedLine F E l) := Fintype.ofFinite _
  exact Finset.univ

theorem card_nonfixedPointsOnFixedLineFinset (l : FixedProjectivePoint F E) :
    (nonfixedPointsOnFixedLineFinset F E l).card =
      Nat.card (NonfixedPointsOnFixedLine F E l) := by
  classical
  letI : Fintype (NonfixedPointsOnFixedLine F E l) := Fintype.ofFinite _
  unfold nonfixedPointsOnFixedLineFinset
  rw [Finset.card_univ, Nat.card_eq_fintype_card]

/-- Candidate conjugate pairs on a fixed line. -/
noncomputable def conjugateCandidatesOnFixedLine (hdeg : Module.finrank F E = 2)
    (l : FixedProjectivePoint F E) : Finset (Sym2 (ProjectiveConjugation.Point E)) := by
  classical
  exact (nonfixedPointsOnFixedLineFinset F E l).image (matePair F E hdeg l)

/-- Two nonfixed points determine the same mate pair exactly when they are equal or conjugate. -/
theorem matePair_eq_iff (hdeg : Module.finrank F E = 2)
    (l : FixedProjectivePoint F E) (p q : NonfixedPointsOnFixedLine F E l) :
    matePair F E hdeg l p = matePair F E hdeg l q ↔
      p = q ∨ p = nonfixedMate F E hdeg l q := by
  constructor
  · intro h
    rw [matePair, matePair, Sym2.eq_iff] at h
    rcases h with h | h
    · left
      apply Subtype.ext
      apply Subtype.ext
      exact h.1
    · right
      apply Subtype.ext
      apply Subtype.ext
      exact h.1
  · rintro (rfl | rfl)
    · rfl
    · rw [matePair, matePair, Sym2.eq_iff]
      right
      refine ⟨rfl, ?_⟩
      exact congrArg (fun r : NonfixedPointsOnFixedLine F E l => r.1.1)
        ((nonfixedMate F E hdeg l).left_inv q)

/-- The finite fiber of the mate-pair map. -/
noncomputable def matePairFiber (hdeg : Module.finrank F E = 2)
    (l : FixedProjectivePoint F E) (p : NonfixedPointsOnFixedLine F E l) :
    Finset (NonfixedPointsOnFixedLine F E l) := by
  classical
  exact (nonfixedPointsOnFixedLineFinset F E l).filter fun q =>
    matePair F E hdeg l q = matePair F E hdeg l p

/-- Every mate-pair fiber consists of its two conjugate representatives. -/
theorem matePair_fiber_card (hdeg : Module.finrank F E = 2)
    (l : FixedProjectivePoint F E) (p : NonfixedPointsOnFixedLine F E l) :
    (matePairFiber F E hdeg l p).card = 2 := by
  classical
  have hne : p ≠ nonfixedMate F E hdeg l p := by
    intro h
    apply p.2
    exact (congrArg (fun q : NonfixedPointsOnFixedLine F E l => q.1.1) h).symm
  have heq :
      matePairFiber F E hdeg l p =
        {p, nonfixedMate F E hdeg l p} := by
    ext q
    simp only [matePairFiber, nonfixedPointsOnFixedLineFinset, Finset.mem_filter,
      Finset.mem_univ, true_and, Finset.mem_insert,
      Finset.mem_singleton]
    exact matePair_eq_iff F E hdeg l q p
  rw [heq]
  simp [hne]

/-- Each fixed line contains exactly `(s²-s)/2` conjugate candidate pairs. This discharges the
`candidate_count` field of the quadratic pair-extension wrapper. -/
theorem card_conjugateCandidatesOnFixedLine (hdeg : Module.finrank F E = 2)
    (l : FixedProjectivePoint F E) :
    (conjugateCandidatesOnFixedLine F E hdeg l).card =
      (Nat.card F * Nat.card F - Nat.card F) / 2 := by
  classical
  let S : Finset (NonfixedPointsOnFixedLine F E l) :=
    nonfixedPointsOnFixedLineFinset F E l
  let T : Finset (Sym2 (ProjectiveConjugation.Point E)) :=
    conjugateCandidatesOnFixedLine F E hdeg l
  apply FiniteGeom.BaerCompletion.quadraticCandidate_card_of_two_fibers
    S T (matePair F E hdeg l) (Nat.card F)
  · rw [show S.card = Nat.card (NonfixedPointsOnFixedLine F E l) by
      exact card_nonfixedPointsOnFixedLineFinset F E l]
    rw [natCard_nonfixedPointsOnFixedLine F E hdeg l, pow_two]
  · intro p hp
    change matePair F E hdeg l p ∈
      ((nonfixedPointsOnFixedLineFinset F E l).image (matePair F E hdeg l))
    exact Finset.mem_image.mpr ⟨p, hp, rfl⟩
  · intro q hq
    change q ∈ (nonfixedPointsOnFixedLineFinset F E l).image
      (matePair F E hdeg l) at hq
    obtain ⟨p, _hp, rfl⟩ := Finset.mem_image.mp hq
    change (matePairFiber F E hdeg l p).card = 2
    exact matePair_fiber_card F E hdeg l p

/-- The concrete coordinate Frobenius incidence involution on points and dual lines of
`PG(2,E)`. -/
noncomputable def incidence (hdeg : Module.finrank F E = 2) :
    InvolutiveIncidence
      (ProjectiveConjugation.Point E) (ProjectiveConjugation.Point E) :=
  ProjectiveConjugation.involutiveIncidence (frobeniusRingEquiv F E)
    (frobenius_involutive F E hdeg)

end QuadraticFrobenius
end RelativeConicArcs
