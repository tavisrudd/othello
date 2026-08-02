import Mathlib.Analysis.Matrix.Normed
import Mathlib.Analysis.Normed.Algebra.MatrixExponential
import RelativeConicArcs.AMELU.TwoUniformIsometry

/-!
# Product operators and the single-exponential identity

A *product operator* on a multipartite system applies a local operator `U i` at
every site `i` simultaneously; in the computational basis its entry from the
label `x` to the label `y` is the product of the local entries
`U i (y i) (x i)`.  `tensorOperator` records that operator.

Two facts are proved.  First, product operators multiply site by site, so the
product operators form the image of a monoid homomorphism from the local
operators at each site; combined with the description of a single-site operator
as a product operator with identities elsewhere, this expresses a product
operator as an ordered product of single-site operators over any enumeration of
the sites.

Second, because operators at distinct sites commute, a product of one-site
exponentials is a single exponential of the summed local generators:

  ⊗_j exp (h_j) = exp (Σ_j h_j^{(j)}).

This is the manuscript's observation that a product unitary `⊗_j exp(i H_j)` is
`exp(i L)` with `L = Σ_j H_j^{(j)}`, and it is what lets the traceless/scalar
splitting of the local Hermitian generators be carried out inside one
exponential.  The matrix exponential is Mathlib's `NormedSpace.exp`, computed
here with the operator norms on matrices; the identity itself does not depend
on the choice of norm.

All arguments are symbolic and kernel checked.  The module contains no
generated data, native evaluation, axioms, or admitted declarations.
-/

namespace RelativeConicArcs.AMELU.Multipartite

open scoped BigOperators ComplexConjugate Matrix.Norms.Operator
open Finset Matrix

variable {Site Level : Type*} [Fintype Site] [DecidableEq Site]
  [Fintype Level] [DecidableEq Level]

/-- The product operator applying the local operator `U i` at every site `i`. -/
def tensorOperator (U : Site → LocalOperator Level) : SystemOperator Site Level :=
  fun y x => ∏ i, U i (y i) (x i)

omit [DecidableEq Site] [Fintype Level] [DecidableEq Level] in
/-- The computational-basis entries of a product operator. -/
theorem tensorOperator_apply (U : Site → LocalOperator Level)
    (y x : Label Site Level) :
    tensorOperator U y x = ∏ i, U i (y i) (x i) :=
  rfl

omit [DecidableEq Site] [Fintype Level] in
/-- Applying the identity at every site gives the identity operator. -/
@[simp]
theorem tensorOperator_one :
    tensorOperator (fun _ : Site => (1 : LocalOperator Level)) = 1 := by
  ext y x
  rw [tensorOperator_apply, Matrix.one_apply]
  simp only [Matrix.one_apply]
  rw [Finset.prod_boole]
  by_cases hyx : y = x
  · rw [if_pos hyx, if_pos (fun i _ => congrFun hyx i)]
  · rw [if_neg hyx, if_neg]
    intro hcontra
    exact hyx (funext fun i => hcontra i (Finset.mem_univ i))

omit [DecidableEq Level] in
/-- Product operators multiply site by site. -/
theorem tensorOperator_mul (U V : Site → LocalOperator Level) :
    tensorOperator U * tensorOperator V = tensorOperator fun i => U i * V i := by
  ext y x
  rw [Matrix.mul_apply, tensorOperator_apply]
  let f : Site → Level → ℂ := fun i c => U i (y i) c * V i c (x i)
  have hterm : ∀ z : Label Site Level,
      tensorOperator U y z * tensorOperator V z x = ∏ i, f i (z i) := by
    intro z
    rw [tensorOperator_apply, tensorOperator_apply, ← Finset.prod_mul_distrib]
  simp_rw [hterm]
  rw [← Fintype.prod_sum]
  exact Finset.prod_congr rfl fun i _ => (Matrix.mul_apply).symm

omit [Fintype Level] in
/-- A single-site operator is the product operator with identities elsewhere. -/
theorem siteOperator_eq_tensorOperator (j : Site) (A : LocalOperator Level) :
    siteOperator j A =
      tensorOperator (Function.update (fun _ : Site => (1 : LocalOperator Level)) j A) := by
  ext y x
  rw [siteOperator_apply, tensorOperator_apply,
    ← Finset.mul_prod_erase _ _ (Finset.mem_univ j), Function.update_self]
  have hrest : ∀ i ∈ Finset.univ.erase j,
      Function.update (fun _ : Site => (1 : LocalOperator Level)) j A i (y i) (x i) =
        if y i = x i then (1 : ℂ) else 0 := by
    intro i hi
    rw [Function.update_of_ne (Finset.mem_erase.mp hi).1, Matrix.one_apply]
  rw [Finset.prod_congr rfl hrest, Finset.prod_boole]
  by_cases hagree : AgreesOffSite j y x
  · rw [if_pos hagree, if_pos, mul_one]
    intro i hi
    exact hagree i (Finset.mem_erase.mp hi).1
  · rw [if_neg hagree, if_neg, mul_zero]
    intro hcontra
    exact hagree fun i hi =>
      hcontra i (Finset.mem_erase.mpr ⟨hi, Finset.mem_univ i⟩)

/-- An ordered product of single-site operators over a set of sites is the
product operator carrying those local operators and identities elsewhere. -/
theorem noncommProd_siteOperator (U : Site → LocalOperator Level) (s : Finset Site) :
    s.noncommProd (fun j => siteOperator j (U j))
        (fun j _ k _ hjk => siteOperator_commute hjk (U j) (U k)) =
      tensorOperator fun i => if i ∈ s then U i else 1 := by
  classical
  induction s using Finset.induction_on with
  | empty => simp
  | insert a s ha ih =>
      rw [Finset.noncommProd_insert_of_notMem _ _ _ _ ha, ih,
        siteOperator_eq_tensorOperator, tensorOperator_mul]
      congr 1
      funext i
      by_cases hia : i = a
      · subst hia
        simp [ha]
      · rw [Function.update_of_ne hia, one_mul]
        by_cases his : i ∈ s
        · rw [if_pos his, if_pos (Finset.mem_insert_of_mem his)]
        · rw [if_neg his, if_neg fun hc => (Finset.mem_insert.mp hc).elim hia his]

/-- Every product operator is the ordered product of its single-site factors. -/
theorem tensorOperator_eq_noncommProd (U : Site → LocalOperator Level) :
    tensorOperator U =
      Finset.univ.noncommProd (fun j => siteOperator j (U j))
        (fun j _ k _ hjk => siteOperator_commute hjk (U j) (U k)) := by
  rw [noncommProd_siteOperator]
  simp

/-- The exponential of a single-site operator acts at that site only. -/
theorem exp_siteOperator (j : Site) (A : LocalOperator Level) :
    NormedSpace.exp (siteOperator j A) = siteOperator j (NormedSpace.exp A) :=
  (NormedSpace.map_exp (siteAlgHom j)
    ((siteAlgHom j).toLinearMap.continuous_of_finiteDimensional) A).symm

/-- The single-exponential identity: a product of one-site exponentials is the
exponential of the summed local generators.  Operators at distinct sites
commute, so the exponential of the sum factors, and each factor is the
exponential taken at its own site. -/
theorem tensorOperator_exp (h : Site → LocalOperator Level) :
    tensorOperator (fun j => NormedSpace.exp (h j)) =
      NormedSpace.exp (localGeneratorSum h) := by
  rw [localGeneratorSum,
    Matrix.exp_sum_of_commute Finset.univ (fun j => siteOperator j (h j))
      (fun j _ k _ hjk => siteOperator_commute hjk (h j) (h k))]
  rw [tensorOperator_eq_noncommProd]
  exact Finset.noncommProd_congr rfl (fun j _ => (exp_siteOperator j (h j)).symm) _

end RelativeConicArcs.AMELU.Multipartite
