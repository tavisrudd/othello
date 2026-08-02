import Mathlib.Data.Complex.Basic
import Mathlib.LinearAlgebra.Matrix.Trace
import Mathlib.LinearAlgebra.Matrix.ConjTranspose

/-!
# Single-site operators on a multipartite computational basis

This module fixes the conventions for a system of finitely many sites, each
carrying the same finite local alphabet, and for operators acting on one site
only.

A *site* is an element of a finite type `Site`; the local alphabet is a finite
type `Level`, and the local dimension is `q = Fintype.card Level`.  A
computational-basis label is a function `Site → Level`, and an operator on the
whole system is a complex matrix indexed by labels, with the convention that
`A y x` is the coefficient from input label `x` to output label `y`.  A local
operator is a complex matrix indexed by `Level`, with the same convention.

`siteOperator j A` applies the local operator `A` at the site `j` and the
identity at every other site.  It is an embedding of the local matrix algebra
determined by `j`, bundled as `siteAlgHom j`, and embeddings attached to
distinct sites commute.

All arguments are symbolic and kernel checked.  The module contains no
generated data, native evaluation, axioms, or admitted declarations.
-/

namespace RelativeConicArcs.AMELU.Multipartite

open scoped BigOperators ComplexConjugate
open Finset Matrix

variable {Site Level : Type*} [Fintype Site] [DecidableEq Site]
  [Fintype Level] [DecidableEq Level]

/-- A computational-basis label assigns a local alphabet letter to every site. -/
abbrev Label (Site Level : Type*) := Site → Level

/-- A local operator acts on the alphabet of a single site, with the
convention that `A y x` is the coefficient from input letter `x` to output
letter `y`. -/
abbrev LocalOperator (Level : Type*) := Matrix Level Level ℂ

/-- An operator on the whole system, indexed by computational-basis labels
with the same input/output convention as `LocalOperator`. -/
abbrev SystemOperator (Site Level : Type*) :=
  Matrix (Label Site Level) (Label Site Level) ℂ

/-- Two labels agree away from the site `j`. -/
abbrev AgreesOffSite (j : Site) (y x : Label Site Level) : Prop :=
  ∀ i, i ≠ j → y i = x i

omit [Fintype Site] [DecidableEq Site] [Fintype Level] [DecidableEq Level] in
theorem agreesOffSite_symm {j : Site} {y x : Label Site Level}
    (h : AgreesOffSite j y x) : AgreesOffSite j x y :=
  fun i hi => (h i hi).symm

omit [Fintype Site] [Fintype Level] [DecidableEq Level] in
theorem agreesOffSite_update (j : Site) (y : Label Site Level) (c : Level) :
    AgreesOffSite j y (Function.update y j c) :=
  fun _ hi => (Function.update_of_ne hi c y).symm

/-- A sum over all labels of a function supported on the labels agreeing with
`y` away from the site `j` collapses to a sum over the local alphabet. -/
theorem sum_eq_sum_update (j : Site) (y : Label Site Level)
    (g : Label Site Level → ℂ)
    (hg : ∀ z, ¬ AgreesOffSite j y z → g z = 0) :
    ∑ z, g z = ∑ c : Level, g (Function.update y j c) := by
  classical
  have hsupport :
      (∑ z, g z) = ∑ z ∈ univ.filter (fun z => AgreesOffSite j y z), g z := by
    refine (Finset.sum_subset (Finset.filter_subset _ _) ?_).symm
    intro z _ hz
    exact hg z (by simpa using hz)
  rw [hsupport]
  refine Finset.sum_nbij' (fun z => z j) (fun c => Function.update y j c)
    (fun a _ => Finset.mem_univ _) (fun c _ => ?_) (fun z hz => ?_)
    (fun c _ => ?_) (fun z hz => ?_)
  · exact Finset.mem_filter.mpr ⟨Finset.mem_univ _, agreesOffSite_update j y c⟩
  · have hz' : AgreesOffSite j y z := by simpa using hz
    funext i
    by_cases hi : i = j
    · subst hi; simp
    · rw [Function.update_of_ne hi]
      exact hz' i hi
  · simp
  · have hz' : AgreesOffSite j y z := by simpa using hz
    congr 1
    funext i
    by_cases hi : i = j
    · subst hi; simp
    · rw [Function.update_of_ne hi]
      exact (hz' i hi).symm

/-- The operator applying the local operator `A` at the site `j` and the
identity at every other site. -/
def siteOperator (j : Site) (A : LocalOperator Level) : SystemOperator Site Level :=
  fun y x => if AgreesOffSite j y x then A (y j) (x j) else 0

omit [Fintype Level] in
theorem siteOperator_apply (j : Site) (A : LocalOperator Level)
    (y x : Label Site Level) :
    siteOperator j A y x = if AgreesOffSite j y x then A (y j) (x j) else 0 :=
  rfl

omit [Fintype Level] in
@[simp]
theorem siteOperator_zero (j : Site) : siteOperator j (0 : LocalOperator Level) = 0 := by
  ext y x
  rw [siteOperator_apply]
  by_cases hagree : AgreesOffSite j y x <;> simp [hagree]

omit [Fintype Level] in
@[simp]
theorem siteOperator_one (j : Site) : siteOperator j (1 : LocalOperator Level) = 1 := by
  ext y x
  rw [siteOperator_apply]
  by_cases hagree : AgreesOffSite j y x
  · rw [if_pos hagree, Matrix.one_apply, Matrix.one_apply]
    by_cases hyx : y j = x j
    · rw [if_pos hyx, if_pos]
      funext i
      by_cases hi : i = j
      · subst hi; exact hyx
      · exact hagree i hi
    · rw [if_neg hyx, if_neg]
      exact fun hcontra => hyx (congrFun hcontra j)
  · rw [if_neg hagree, Matrix.one_apply, if_neg]
    exact fun hcontra => hagree (fun i _ => congrFun hcontra i)

omit [Fintype Level] in
theorem siteOperator_add (j : Site) (A B : LocalOperator Level) :
    siteOperator j (A + B) = siteOperator j A + siteOperator j B := by
  ext y x
  rw [Matrix.add_apply, siteOperator_apply, siteOperator_apply, siteOperator_apply]
  by_cases hagree : AgreesOffSite j y x
  · rw [if_pos hagree, if_pos hagree, if_pos hagree, Matrix.add_apply]
  · rw [if_neg hagree, if_neg hagree, if_neg hagree, add_zero]

omit [Fintype Level] in
theorem siteOperator_smul (j : Site) (c : ℂ) (A : LocalOperator Level) :
    siteOperator j (c • A) = c • siteOperator j A := by
  ext y x
  rw [Matrix.smul_apply, siteOperator_apply, siteOperator_apply]
  by_cases hagree : AgreesOffSite j y x
  · rw [if_pos hagree, if_pos hagree, Matrix.smul_apply]
  · rw [if_neg hagree, if_neg hagree, smul_zero]

/-- Site embedding is multiplicative: composing two local operators at the same
site is the same as composing their embeddings. -/
theorem siteOperator_mul (j : Site) (A B : LocalOperator Level) :
    siteOperator j (A * B) = siteOperator j A * siteOperator j B := by
  ext y x
  have hcollapse := sum_eq_sum_update j y
    (fun z => siteOperator j A y z * siteOperator j B z x)
    (fun z hz => by rw [siteOperator_apply, if_neg hz, zero_mul])
  rw [Matrix.mul_apply, hcollapse]
  have hfirst : ∀ c : Level,
      siteOperator j A y (Function.update y j c) = A (y j) c := by
    intro c
    rw [siteOperator_apply, if_pos (agreesOffSite_update j y c), Function.update_self]
  by_cases hagree : AgreesOffSite j y x
  · have hsecond : ∀ c : Level,
        siteOperator j B (Function.update y j c) x = B c (x j) := by
      intro c
      rw [siteOperator_apply, if_pos, Function.update_self]
      intro i hi
      rw [Function.update_of_ne hi]
      exact hagree i hi
    rw [siteOperator_apply, if_pos hagree, Matrix.mul_apply]
    exact Finset.sum_congr rfl fun c _ => by rw [hfirst c, hsecond c]
  · have hsecond : ∀ c : Level,
        siteOperator j B (Function.update y j c) x = 0 := by
      intro c
      rw [siteOperator_apply, if_neg]
      intro hcontra
      refine hagree fun i hi => ?_
      have h' := hcontra i hi
      rwa [Function.update_of_ne hi] at h'
    rw [siteOperator_apply, if_neg hagree]
    exact (Finset.sum_eq_zero fun c _ => by rw [hsecond c, mul_zero]).symm

omit [Fintype Level] in
theorem siteOperator_conjTranspose (j : Site) (A : LocalOperator Level) :
    (siteOperator j A)ᴴ = siteOperator j Aᴴ := by
  ext y x
  rw [Matrix.conjTranspose_apply, siteOperator_apply, siteOperator_apply]
  by_cases hagree : AgreesOffSite j y x
  · rw [if_pos hagree, if_pos (agreesOffSite_symm hagree), Matrix.conjTranspose_apply]
  · rw [if_neg hagree, if_neg (fun h => hagree (agreesOffSite_symm h)), star_zero]

/-- The site embedding, bundled as a homomorphism of complex algebras. -/
def siteAlgHom (j : Site) : LocalOperator Level →ₐ[ℂ] SystemOperator Site Level where
  toFun := siteOperator j
  map_one' := siteOperator_one j
  map_mul' := siteOperator_mul j
  map_zero' := siteOperator_zero j
  map_add' := siteOperator_add j
  commutes' := by
    intro c
    rw [Algebra.algebraMap_eq_smul_one, Algebra.algebraMap_eq_smul_one,
      siteOperator_smul, siteOperator_one]

@[simp]
theorem siteAlgHom_apply (j : Site) (A : LocalOperator Level) :
    siteAlgHom j A = siteOperator j A :=
  rfl

/-- Operators at two distinct sites act independently on their own sites and
leave every other site fixed. -/
theorem siteOperator_mul_apply_of_ne {j k : Site} (hjk : j ≠ k)
    (A B : LocalOperator Level) (y x : Label Site Level) :
    (siteOperator j A * siteOperator k B) y x =
      if ∀ i, i ≠ j → i ≠ k → y i = x i then
        A (y j) (x j) * B (y k) (x k)
      else 0 := by
  classical
  have hcollapse := sum_eq_sum_update j y
    (fun z => siteOperator j A y z * siteOperator k B z x)
    (fun z hz => by rw [siteOperator_apply, if_neg hz, zero_mul])
  rw [Matrix.mul_apply, hcollapse]
  have hval : ∀ c : Level,
      siteOperator j A y (Function.update y j c) *
          siteOperator k B (Function.update y j c) x =
        A (y j) c *
          (if (∀ i, i ≠ j → i ≠ k → y i = x i) ∧ c = x j then B (y k) (x k) else 0) := by
    intro c
    rw [siteOperator_apply, if_pos (agreesOffSite_update j y c), Function.update_self,
      siteOperator_apply]
    congr 1
    by_cases hcond : (∀ i, i ≠ j → i ≠ k → y i = x i) ∧ c = x j
    · rw [if_pos hcond, if_pos]
      · rw [Function.update_of_ne (Ne.symm hjk)]
      · intro i hi
        by_cases hij : i = j
        · subst hij
          rw [Function.update_self]
          exact hcond.2
        · rw [Function.update_of_ne hij]
          exact hcond.1 i hij hi
    · rw [if_neg hcond, if_neg]
      intro hcontra
      refine hcond ⟨fun i hij hik => ?_, ?_⟩
      · have h' := hcontra i hik
        rwa [Function.update_of_ne hij] at h'
      · have h' := hcontra j hjk
        rwa [Function.update_self] at h'
  simp_rw [hval]
  by_cases hoff : ∀ i, i ≠ j → i ≠ k → y i = x i
  · rw [if_pos hoff, Finset.sum_eq_single (x j)]
    · rw [if_pos ⟨hoff, rfl⟩]
    · intro c _ hc
      rw [if_neg (fun h => hc h.2), mul_zero]
    · intro hmem
      exact absurd (Finset.mem_univ (x j)) hmem
  · rw [if_neg hoff]
    refine Finset.sum_eq_zero fun c _ => ?_
    rw [if_neg (fun h => hoff h.1), mul_zero]

/-- Operators supported at distinct sites commute. -/
theorem siteOperator_commute {j k : Site} (hjk : j ≠ k) (A B : LocalOperator Level) :
    Commute (siteOperator j A) (siteOperator k B) := by
  show siteOperator j A * siteOperator k B = siteOperator k B * siteOperator j A
  ext y x
  rw [siteOperator_mul_apply_of_ne hjk, siteOperator_mul_apply_of_ne (Ne.symm hjk)]
  by_cases hoff : ∀ i, i ≠ j → i ≠ k → y i = x i
  · rw [if_pos hoff, if_pos (fun i hik hij => hoff i hij hik), mul_comm]
  · rw [if_neg hoff, if_neg]
    exact fun h => hoff (fun i hij hik => h i hik hij)

end RelativeConicArcs.AMELU.Multipartite
