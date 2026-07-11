import FiniteGeom.Code
import Mathlib.LinearAlgebra.Matrix.ToLin
import Mathlib.LinearAlgebra.Matrix.DotProduct

/-!
# Projective systems as codes: distance from hyperplane sections (`FiniteGeom` base)

The bridge that turns a *geometric* fact — "no hyperplane meets the point set in more than `s`
points" — into a *coding* fact — "the minimum distance is `n - s`". This is the projective-systems
↔ linear-codes correspondence, the tool the whole geometric-code lane needs (twisted cubic, the
`q = 9` seed, the uniform `q = 3^h` family, the NRC seeds of `RepairCodes`).

Given `n` points `P : ι → 𝔽^k` (the columns of a generator matrix), the **column code**
`columnCode P` is the set of evaluation vectors `a ↦ (⟨P_j, a⟩)_j` as `a` ranges over `𝔽^k`
(here `⟨·,·⟩` is the standard dot product). Its length is `n`, its dimension is `k` when the
points span `𝔽^k` (`finrank_columnCode`), and:

* `hammingNorm_pointEval_add_sectionCount` — weight of the codeword for `a` `+` the number of
  points on the hyperplane `a^⊥` (`sectionCount P a`) `= n`;
* `le_columnCode_minDist` — if **every** hyperplane meets the points in `≤ s` of them, then
  `n - s ≤ d`;
* `columnCode_minDist_le` — an attained section of size `s` gives a codeword of weight `n - s`,
  so `d ≤ n - s`;
* `columnCode_minDist_eq` — the two together pin `d = n - s` when `s` is the **maximum** section.

Pure finite linear algebra, no imported input; `#print axioms`-clean. Applying
`columnCode_minDist_eq` with `max section = q + 2` (proved separately for `S_q`) yields the
`q = 3^h` distance `d = (2q+1) - (q+2) = q - 1`; the `dim = k = 4` half is `finrank_columnCode`
fed by `FiniteGeom.twistedCubic_span`.
-/

namespace FiniteGeom

open Finset Matrix

variable {k : ℕ} {ι : Type*} [Fintype ι] {𝔽 : Type*} [Field 𝔽] [DecidableEq 𝔽]

/-- The codeword of `columnCode P` for message `a`: coordinate `j` is `⟨P_j, a⟩`. -/
def pointEval (P : ι → (Fin k → 𝔽)) (a : Fin k → 𝔽) : ι → 𝔽 := fun j => P j ⬝ᵥ a

/-- The **column code** of a point system `P`: all evaluation vectors `pointEval P a`, packaged as
the range of the `𝔽`-linear map `a ↦ (⟨P_j, a⟩)_j = (Matrix.of P) *ᵥ a`. -/
def columnCode (P : ι → (Fin k → 𝔽)) : Submodule 𝔽 (ι → 𝔽) :=
  LinearMap.range (Matrix.of P).mulVecLin

omit [Fintype ι] [DecidableEq 𝔽] in
theorem pointEval_eq_mulVecLin (P : ι → (Fin k → 𝔽)) (a : Fin k → 𝔽) :
    pointEval P a = (Matrix.of P).mulVecLin a := by
  funext j; rw [Matrix.mulVecLin_apply]; rfl

omit [Fintype ι] [DecidableEq 𝔽] in
@[simp] theorem mem_columnCode {P : ι → (Fin k → 𝔽)} {c : ι → 𝔽} :
    c ∈ columnCode P ↔ ∃ a, pointEval P a = c := by
  simp only [columnCode, LinearMap.mem_range]
  constructor
  · rintro ⟨a, rfl⟩; exact ⟨a, pointEval_eq_mulVecLin P a⟩
  · rintro ⟨a, rfl⟩; exact ⟨a, (pointEval_eq_mulVecLin P a).symm⟩

omit [Fintype ι] [DecidableEq 𝔽] in
theorem pointEval_mem (P : ι → (Fin k → 𝔽)) (a : Fin k → 𝔽) :
    pointEval P a ∈ columnCode P := mem_columnCode.mpr ⟨a, rfl⟩

/-- The **section count** `|{j : ⟨P_j, a⟩ = 0}|`: the number of points lying on the hyperplane
`a^⊥`. The maximum of this over nonzero-codeword messages is the largest hyperplane section. -/
def sectionCount (P : ι → (Fin k → 𝔽)) (a : Fin k → 𝔽) : ℕ :=
  #(univ.filter fun j => P j ⬝ᵥ a = 0)

/-- **Weight ↔ section.** The codeword's Hamming weight plus the size of its hyperplane section
is the length `Fintype.card ι`: a coordinate is nonzero exactly when the point is off the
hyperplane. -/
theorem hammingNorm_pointEval_add_sectionCount (P : ι → (Fin k → 𝔽)) (a : Fin k → 𝔽) :
    hammingNorm (pointEval P a) + sectionCount P a = Fintype.card ι := by
  have hn : hammingNorm (pointEval P a) = #(univ.filter fun j => pointEval P a j ≠ 0) := rfl
  have hs : sectionCount P a = #(univ.filter fun j => pointEval P a j = 0) := rfl
  have hcard := card_filter_add_card_filter_not (s := (univ : Finset ι))
    (fun j => pointEval P a j = 0)
  rw [Finset.card_univ] at hcard
  -- bridge `≠ 0` (Hamming's decidable instance) to `¬ (· = 0)` (the not-filter's instance)
  have hbridge : (univ.filter fun j => pointEval P a j ≠ 0)
      = (univ.filter fun j => ¬ (pointEval P a j = 0)) := Finset.filter_congr (fun _ _ => Iff.rfl)
  rw [hn, hs, hbridge]; omega

omit [Fintype ι] [DecidableEq 𝔽] in
/-- `columnCode P` is nontrivial as soon as one message gives a nonzero codeword. -/
theorem columnCode_ne_bot_of {P : ι → (Fin k → 𝔽)} {a : Fin k → 𝔽}
    (h : pointEval P a ≠ 0) : columnCode P ≠ ⊥ :=
  (Submodule.ne_bot_iff _).mpr ⟨pointEval P a, pointEval_mem P a, h⟩

/-- **Distance lower bound from a section bound.** If every hyperplane meets the point system in
at most `s` points (over all messages with a nonzero codeword), then
`Fintype.card ι - s ≤ d(columnCode P)`. This is the direction that converts "max section `≤ s`"
into a distance guarantee. -/
theorem le_columnCode_minDist {P : ι → (Fin k → 𝔽)} {s : ℕ}
    (hne : columnCode P ≠ ⊥)
    (hsec : ∀ a, pointEval P a ≠ 0 → sectionCount P a ≤ s) :
    Fintype.card ι - s ≤ minDist (columnCode P) := by
  apply le_minDist hne
  intro c hc hcne
  obtain ⟨a, rfl⟩ := mem_columnCode.mp hc
  have hsc : sectionCount P a ≤ s := hsec a hcne
  have hw := hammingNorm_pointEval_add_sectionCount P a
  omega

/-- **Distance upper bound from an attained section.** A message whose hyperplane contains `s`
points gives a codeword of weight `card ι - s`, so `d(columnCode P) ≤ card ι - s`. -/
theorem columnCode_minDist_le {P : ι → (Fin k → 𝔽)} {a : Fin k → 𝔽}
    (hne : pointEval P a ≠ 0) : minDist (columnCode P) ≤ Fintype.card ι - sectionCount P a := by
  have hle := minDist_le_hammingNorm (pointEval_mem P a) hne
  have hw := hammingNorm_pointEval_add_sectionCount P a
  omega

/-- **Distance = length − maximum section.** If `s` is the maximum hyperplane section — attained
by some `a₀` (nonzero codeword) and an upper bound for all messages — then
`d(columnCode P) = n - s`. This is the packaging the `q = 3^h` distance `q - 1 = (2q+1)-(q+2)`
uses, with `s = q + 2` the largest plane section of `S_q`. -/
theorem columnCode_minDist_eq {P : ι → (Fin k → 𝔽)} {s : ℕ} {a₀ : Fin k → 𝔽}
    (hne : pointEval P a₀ ≠ 0) (hmax : sectionCount P a₀ = s)
    (hsec : ∀ a, pointEval P a ≠ 0 → sectionCount P a ≤ s) :
    minDist (columnCode P) = Fintype.card ι - s := by
  have hlo := le_columnCode_minDist (columnCode_ne_bot_of hne) hsec
  have hhi := columnCode_minDist_le hne
  rw [hmax] at hhi
  omega

omit [Fintype ι] [DecidableEq 𝔽] in
/-- **Dimension.** When the points span `𝔽^k`, the message map is injective, so
`dim (columnCode P) = k`. For the `q = 3^h` family this is `k = 4`, via the twisted cubic's
`FiniteGeom.twistedCubic_span`. -/
theorem finrank_columnCode {P : ι → (Fin k → 𝔽)}
    (hspan : Submodule.span 𝔽 (Set.range P) = ⊤) :
    Module.finrank 𝔽 (columnCode P) = k := by
  have hker : LinearMap.ker (Matrix.of P).mulVecLin = ⊥ := by
    rw [Matrix.ker_mulVecLin_eq_bot_iff]
    intro v hv
    -- `v` is orthogonal to every point; orthogonality-to-`v` is a submodule containing the
    -- points, hence all of `span = ⊤`, so `v ⬝ᵥ w = 0` for every `w`, forcing `v = 0`.
    refine dotProduct_eq_zero_iff.mp (fun w => ?_)
    let K : Submodule 𝔽 (Fin k → 𝔽) :=
      { carrier := {w | v ⬝ᵥ w = 0}
        zero_mem' := dotProduct_zero v
        add_mem' := fun {x y} hx hy => by
          simp only [Set.mem_setOf_eq] at hx hy ⊢; rw [dotProduct_add, hx, hy, add_zero]
        smul_mem' := fun c {x} hx => by
          simp only [Set.mem_setOf_eq] at hx ⊢; rw [dotProduct_smul, hx, smul_zero] }
    have hle : (⊤ : Submodule 𝔽 (Fin k → 𝔽)) ≤ K := by
      rw [← hspan]
      apply Submodule.span_le.mpr
      rintro _ ⟨j, rfl⟩
      show v ⬝ᵥ P j = 0
      rw [dotProduct_comm]; exact congrFun hv j
    exact hle (Submodule.mem_top)
  have hinj : Function.Injective (Matrix.of P).mulVecLin := LinearMap.ker_eq_bot.mp hker
  calc Module.finrank 𝔽 (columnCode P)
      = Module.finrank 𝔽 (LinearMap.range (Matrix.of P).mulVecLin) := rfl
    _ = Module.finrank 𝔽 (Fin k → 𝔽) := LinearMap.finrank_range_of_inj hinj
    _ = k := by rw [Module.finrank_pi, Fintype.card_fin]

end FiniteGeom
