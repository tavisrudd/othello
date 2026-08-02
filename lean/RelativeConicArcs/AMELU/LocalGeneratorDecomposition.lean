import RelativeConicArcs.AMELU.ProductUnitaryExponential

/-!
# Traceless and scalar parts of local generators

A Hermitian local operator `H` on an alphabet of size `q` splits uniquely as a
traceless Hermitian operator plus a real multiple of the identity,

  `H = tracelessPart H + (Tr H / q) • 1`,

and the traceless part is again Hermitian.  Summing the site embeddings of a
family of Hermitian local operators therefore gives

  `Σ_j H_j^{(j)} = Σ_j (tracelessPart H_j)^{(j)} + (Σ_j Tr H_j / q) • 1`,

the splitting `L = M + cI` of the generator of a one-parameter group of product
unitaries into a sum `M` of traceless local generators and a real scalar `c`.  Combined with the single-exponential
identity this writes an arbitrary product of one-site unitary exponentials as
one exponential whose generator is split in that way.

All arguments are symbolic and kernel checked.  The module contains no
generated data, native evaluation, axioms, or admitted declarations.
-/

namespace RelativeConicArcs.AMELU.Multipartite

open scoped BigOperators ComplexConjugate
open Finset Matrix

variable {Site Level : Type*} [Fintype Site] [DecidableEq Site]
  [Fintype Level] [DecidableEq Level]

/-- The traceless part of a local operator, obtained by subtracting the
normalized trace. -/
noncomputable def tracelessPart (A : LocalOperator Level) : LocalOperator Level :=
  A - (A.trace / (Fintype.card Level : ℂ)) • 1

/-- A local operator is its traceless part plus the normalized trace. -/
theorem eq_tracelessPart_add_scalar (A : LocalOperator Level) :
    A = tracelessPart A + (A.trace / (Fintype.card Level : ℂ)) • 1 := by
  rw [tracelessPart, sub_add_cancel]

/-- The traceless part has vanishing trace. -/
@[simp]
theorem trace_tracelessPart [Nonempty Level] (A : LocalOperator Level) :
    (tracelessPart A).trace = 0 := by
  have hq : (Fintype.card Level : ℂ) ≠ 0 := by
    exact_mod_cast Nat.cast_ne_zero.mpr Fintype.card_ne_zero
  rw [tracelessPart, Matrix.trace_sub, Matrix.trace_smul, Matrix.trace_one,
    smul_eq_mul, div_mul_cancel₀ _ hq, sub_self]

/-- The traceless part of a Hermitian local operator is Hermitian: the
normalized trace of a Hermitian operator is real. -/
theorem isHermitian_tracelessPart {A : LocalOperator Level} (hA : A.IsHermitian) :
    (tracelessPart A).IsHermitian := by
  have hqstar : star ((Fintype.card Level : ℂ)) = (Fintype.card Level : ℂ) := by
    simp
  have htr : star (A.trace) = A.trace := by
    rw [← Matrix.trace_conjTranspose, hA]
  unfold Matrix.IsHermitian tracelessPart
  rw [Matrix.conjTranspose_sub, Matrix.conjTranspose_smul, Matrix.conjTranspose_one, hA]
  congr 2
  rw [star_div₀, htr, hqstar]

omit [Fintype Level] in
/-- The site embedding of a scalar local operator is the same scalar system
operator. -/
theorem siteOperator_smul_one (j : Site) (c : ℂ) :
    siteOperator j (c • (1 : LocalOperator Level)) =
      c • (1 : SystemOperator Site Level) := by
  rw [siteOperator_smul, siteOperator_one]

/-- The splitting `L = M + cI`: summing the site embeddings of Hermitian local
operators gives a sum of traceless local generators plus a real multiple of the
identity. -/
theorem localGeneratorSum_eq_traceless_add_scalar [Nonempty Level]
    (H : Site → LocalOperator Level) :
    localGeneratorSum H =
      localGeneratorSum (fun j => tracelessPart (H j)) +
        ((∑ j, (H j).trace) / (Fintype.card Level : ℂ)) •
          (1 : SystemOperator Site Level) := by
  unfold localGeneratorSum
  have hsplit : ∀ j : Site,
      siteOperator j (H j) =
        siteOperator j (tracelessPart (H j)) +
          ((H j).trace / (Fintype.card Level : ℂ)) • (1 : SystemOperator Site Level) := by
    intro j
    conv_lhs => rw [eq_tracelessPart_add_scalar (H j)]
    rw [siteOperator_add, siteOperator_smul_one]
  rw [Finset.sum_congr rfl fun j _ => hsplit j, Finset.sum_add_distrib, ← Finset.sum_smul]
  congr 1
  rw [← sum_div_const]

/-- Every product of one-site unitary exponentials is a single exponential whose
generator splits as a sum of traceless local generators plus a scalar. -/
theorem tensorOperator_exp_eq_exp_traceless_add_scalar [Nonempty Level]
    (H : Site → LocalOperator Level) :
    tensorOperator (fun j => NormedSpace.exp (H j)) =
      NormedSpace.exp
        (localGeneratorSum (fun j => tracelessPart (H j)) +
          ((∑ j, (H j).trace) / (Fintype.card Level : ℂ)) •
            (1 : SystemOperator Site Level)) := by
  rw [← localGeneratorSum_eq_traceless_add_scalar H]
  exact tensorOperator_exp H

end RelativeConicArcs.AMELU.Multipartite
