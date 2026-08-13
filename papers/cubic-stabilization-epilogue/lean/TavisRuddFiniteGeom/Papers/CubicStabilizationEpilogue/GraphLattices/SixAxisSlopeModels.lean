import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.GraphLattices.SixAxisLocalChart
import Mathlib.Algebra.Polynomial.SpecificDegree
import Mathlib.Algebra.Polynomial.Degree.IsMonicOfDegree
import Mathlib.LinearAlgebra.Matrix.Charpoly.Minpoly
import Mathlib.RingTheory.Etale.Field

/-!
# Explicit residue-field slope models for the six-axis chart

This module records literal four-dimensional matrices having the two slope
types quoted in the manuscript: two copies of the irreducible quadratic
companion block in characteristic two, and a scalar block in characteristic
three.  It does not identify either matrix with the geometric principal
kernel.

The two finite characteristic-two checks below are evaluated by ordinary
kernel reduction with `decide`: one equality of explicit `4 × 4` matrices and
one exhaustive check over the two elements of `ZMod 2`.  No native-code
decision procedure, external certificate, or oracle is used.  The
minimal-polynomial derivation, construction of its quadratic finite-etale
splitting field, scalar-extension identity, inverse and splitting identities,
and characteristic-three scalar claims are symbolic kernel-checked proofs.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue

namespace GraphLattices

open Polynomial

noncomputable section

/-- The quadratic polynomial defining the two-primary residue slope type. -/
def sixAxisQuadraticSlopePolynomial : (ZMod 2)[X] :=
  X ^ 2 + X + 1

/-- The quadratic residue-slope polynomial is monic. -/
theorem sixAxisQuadraticSlopePolynomial_monic :
    sixAxisQuadraticSlopePolynomial.Monic := by
  simpa [sixAxisQuadraticSlopePolynomial] using
    (Polynomial.isMonicOfDegree_add_add_two (R := ZMod 2) 1 1).monic

/-- The quadratic residue-slope polynomial has degree two. -/
theorem sixAxisQuadraticSlopePolynomial_natDegree :
    sixAxisQuadraticSlopePolynomial.natDegree = 2 := by
  simpa [sixAxisQuadraticSlopePolynomial] using
    (Polynomial.isMonicOfDegree_add_add_two (R := ZMod 2) 1 1).natDegree_eq

/-- Two copies of the companion matrix of `t²+t+1` over `F₂`, written on the
four-dimensional depth-one block. -/
def sixAxisTwoQuadraticSlope : Matrix (Fin 4) (Fin 4) (ZMod 2) :=
  !![0, 1, 0, 0;
     1, 1, 0, 0;
     0, 0, 0, 1;
     0, 0, 1, 1]

/-- The displayed characteristic-two slope satisfies its quadratic
polynomial `T²+T+1=0`.  Ordinary kernel `decide` evaluates the explicit
`4 × 4` equality. -/
theorem sixAxisTwoQuadraticSlope_polynomial :
    sixAxisTwoQuadraticSlope * sixAxisTwoQuadraticSlope +
        sixAxisTwoQuadraticSlope + 1 = 0 := by
  decide

/-- The polynomial `t²+t+1` has no root in `F₂`.  Ordinary kernel `decide`
checks the two possible inputs. -/
theorem zmodTwo_quadraticSlopePolynomial_no_root :
    ∀ value : ZMod 2, value ^ 2 + value + 1 ≠ 0 := by
  decide

/-- The quadratic residue-slope polynomial is irreducible over `F₂`. -/
theorem sixAxisQuadraticSlopePolynomial_irreducible :
    Irreducible sixAxisQuadraticSlopePolynomial := by
  apply Polynomial.irreducible_of_degree_le_three_of_not_isRoot
  · simp [sixAxisQuadraticSlopePolynomial_natDegree]
  · intro value root
    apply zmodTwo_quadraticSlopePolynomial_no_root value
    simpa [sixAxisQuadraticSlopePolynomial, Polynomial.IsRoot] using root

/-- The concrete quadratic splitting field obtained by adjoining a root of
`t²+t+1` to `F₂`. -/
abbrev SixAxisQuadraticSplittingField :=
  AdjoinRoot sixAxisQuadraticSlopePolynomial

noncomputable instance sixAxisQuadraticSlopePolynomial_irreducibleFact :
    Fact (Irreducible sixAxisQuadraticSlopePolynomial) :=
  ⟨sixAxisQuadraticSlopePolynomial_irreducible⟩

/-- The marked root in the concrete quadratic splitting field. -/
def sixAxisQuadraticSlopeRoot : SixAxisQuadraticSplittingField :=
  AdjoinRoot.root sixAxisQuadraticSlopePolynomial

/-- The marked root satisfies the defining quadratic equation. -/
theorem sixAxisQuadraticSlopeRoot_equation :
    sixAxisQuadraticSlopeRoot ^ 2 + sixAxisQuadraticSlopeRoot + 1 = 0 := by
  change AdjoinRoot.root sixAxisQuadraticSlopePolynomial ^ 2 +
      AdjoinRoot.root sixAxisQuadraticSlopePolynomial + 1 = 0
  have equation := AdjoinRoot.eval₂_root sixAxisQuadraticSlopePolynomial
  simp [sixAxisQuadraticSlopePolynomial] at equation
  exact equation

noncomputable instance sixAxisQuadraticSplittingField_moduleFiniteInstance :
    Module.Finite (ZMod 2) SixAxisQuadraticSplittingField :=
  sixAxisQuadraticSlopePolynomial_monic.finite_adjoinRoot

noncomputable instance sixAxisQuadraticSplittingField_charP :
    CharP SixAxisQuadraticSplittingField 2 :=
  charP_of_injective_algebraMap
    (algebraMap (ZMod 2) SixAxisQuadraticSplittingField).injective 2

noncomputable instance sixAxisQuadraticSplittingField_formallyEtale :
    Algebra.FormallyEtale (ZMod 2) SixAxisQuadraticSplittingField :=
  Algebra.FormallyEtale.of_isSeparable (ZMod 2)
    SixAxisQuadraticSplittingField

noncomputable instance sixAxisQuadraticSplittingField_etaleInstance :
    Algebra.Etale (ZMod 2) SixAxisQuadraticSplittingField where

/-- The concrete quadratic splitting field is finite over `F₂`. -/
theorem sixAxisQuadraticSplittingField_moduleFinite :
    Module.Finite (ZMod 2) SixAxisQuadraticSplittingField := by
  infer_instance

/-- The concrete quadratic splitting field is etale over `F₂`. -/
theorem sixAxisQuadraticSplittingField_etale :
    Algebra.Etale (ZMod 2) SixAxisQuadraticSplittingField := by
  infer_instance

/-- The displayed characteristic-two matrix is annihilated by the quadratic
residue-slope polynomial under matrix evaluation. -/
theorem sixAxisQuadraticSlopePolynomial_aeval :
    aeval sixAxisTwoQuadraticSlope sixAxisQuadraticSlopePolynomial = 0 := by
  simpa [sixAxisQuadraticSlopePolynomial, pow_two] using
    sixAxisTwoQuadraticSlope_polynomial

/-- The displayed characteristic-two matrix has minimal polynomial exactly
`t²+t+1`; in particular this proves the stated slope type for the displayed
model, without identifying it with the geometric slope. -/
theorem sixAxisTwoQuadraticSlope_minpoly :
    minpoly (ZMod 2) sixAxisTwoQuadraticSlope =
      sixAxisQuadraticSlopePolynomial := by
  symm
  exact minpoly.eq_of_irreducible_of_monic
    sixAxisQuadraticSlopePolynomial_irreducible
    sixAxisQuadraticSlopePolynomial_aeval
    sixAxisQuadraticSlopePolynomial_monic

/-- Consequently the displayed quadratic slope is not a scalar matrix. -/
theorem sixAxisTwoQuadraticSlope_not_scalar
    (value : ZMod 2) :
    sixAxisTwoQuadraticSlope ≠ Matrix.scalar (Fin 4) value := by
  intro equality
  have offDiagonal := congrArg
    (fun matrix : Matrix (Fin 4) (Fin 4) (ZMod 2) ↦ matrix 0 1) equality
  norm_num [sixAxisTwoQuadraticSlope, Matrix.scalar_apply] at offDiagonal

section QuadraticSplitting

variable (K : Type*) [CommRing K] [CharP K 2]

/-- The same two-companion-block matrix over an arbitrary coefficient ring of
characteristic two. -/
def sixAxisTwoQuadraticSlopeOver : Matrix (Fin 4) (Fin 4) K :=
  !![0, 1, 0, 0;
     1, 1, 0, 0;
     0, 0, 0, 1;
     0, 0, 1, 1]

/-- The characteristic-two matrix over `K` is exactly the entrywise scalar
extension of the displayed matrix over `F₂`. -/
theorem sixAxisTwoQuadraticSlope_map_castHom :
    sixAxisTwoQuadraticSlope.map (ZMod.castHom dvd_rfl K) =
      sixAxisTwoQuadraticSlopeOver K := by
  ext row column
  fin_cases row <;> fin_cases column <;>
    norm_num [sixAxisTwoQuadraticSlope, sixAxisTwoQuadraticSlopeOver]

/-- Eigenvector matrix for the two roots `ω` and `ω+1`, repeated once on each
quadratic companion block. -/
def sixAxisTwoQuadraticEigenbasis (ω : K) : Matrix (Fin 4) (Fin 4) K :=
  !![1, 1, 0, 0;
     ω, ω + 1, 0, 0;
     0, 0, 1, 1;
     0, 0, ω, ω + 1]

/-- Explicit inverse of the eigenvector matrix.  In characteristic two these
matrices are mutual inverses for every `ω`; the quadratic root equation is
needed only for diagonalization. -/
def sixAxisTwoQuadraticEigenbasisInverse (ω : K) :
    Matrix (Fin 4) (Fin 4) K :=
  !![ω + 1, 1, 0, 0;
     ω, 1, 0, 0;
     0, 0, ω + 1, 1;
     0, 0, ω, 1]

/-- Diagonal form with the two conjugate quadratic roots, each occurring
twice. -/
def sixAxisTwoQuadraticDiagonal (ω : K) : Matrix (Fin 4) (Fin 4) K :=
  Matrix.diagonal ![ω, ω + 1, ω, ω + 1]

/-- In characteristic two, the displayed eigenvector matrix is explicitly
invertible for every `ω`. -/
theorem sixAxisTwoQuadraticEigenbasis_mul_inverse (ω : K) :
    sixAxisTwoQuadraticEigenbasis K ω *
        sixAxisTwoQuadraticEigenbasisInverse K ω = 1 := by
  have two : (2 : K) = 0 := CharP.cast_eq_zero K 2
  ext row column
  fin_cases row <;> fin_cases column <;>
    simp [sixAxisTwoQuadraticEigenbasis,
      sixAxisTwoQuadraticEigenbasisInverse, Matrix.mul_apply,
      Fin.sum_univ_succ] <;> ring_nf at two ⊢ <;> simp_all

/-- The proposed inverse is also a left inverse. -/
theorem sixAxisTwoQuadraticEigenbasis_inverse_mul (ω : K) :
    sixAxisTwoQuadraticEigenbasisInverse K ω *
        sixAxisTwoQuadraticEigenbasis K ω = 1 := by
  have two : (2 : K) = 0 := CharP.cast_eq_zero K 2
  ext row column
  fin_cases row <;> fin_cases column <;>
    simp [sixAxisTwoQuadraticEigenbasis,
      sixAxisTwoQuadraticEigenbasisInverse, Matrix.mul_apply,
      Fin.sum_univ_succ] <;> ring_nf at two ⊢ <;> simp_all

/-- Over any characteristic-two ring containing a root of `t²+t+1`, the two
companion blocks split into the two conjugate scalar roots, each with
multiplicity two. -/
theorem sixAxisTwoQuadraticSlopeOver_mul_eigenbasis (ω : K)
    (root : ω ^ 2 + ω + 1 = 0) :
    sixAxisTwoQuadraticSlopeOver K * sixAxisTwoQuadraticEigenbasis K ω =
      sixAxisTwoQuadraticEigenbasis K ω *
        sixAxisTwoQuadraticDiagonal K ω := by
  have two : (2 : K) = 0 := CharP.cast_eq_zero K 2
  have square : ω ^ 2 = ω + 1 := by
    calc
      ω ^ 2 = -(ω + 1) := by linear_combination root
      _ = ω + 1 := CharTwo.neg_eq _
  have conjugateSquare : (ω + 1) ^ 2 = ω := by
    rw [add_sq, square]
    linear_combination two * (ω + 1)
  ext row column
  fin_cases row <;> fin_cases column <;>
    simp [sixAxisTwoQuadraticSlopeOver, sixAxisTwoQuadraticEigenbasis,
      sixAxisTwoQuadraticDiagonal, Matrix.mul_apply, Fin.sum_univ_succ]
  all_goals rw [← pow_two]
  all_goals simp only [square, conjugateSquare, add_comm]
  all_goals linear_combination two

end QuadraticSplitting

/-- Over the explicitly constructed finite-etale quadratic extension, the
displayed four-dimensional slope matrix has the marked invertible eigenbasis
and diagonal form with the two conjugate roots, each repeated twice. -/
theorem sixAxisTwoQuadraticSlope_concreteFiniteEtale_split :
    sixAxisTwoQuadraticEigenbasis SixAxisQuadraticSplittingField
          sixAxisQuadraticSlopeRoot *
        sixAxisTwoQuadraticEigenbasisInverse SixAxisQuadraticSplittingField
          sixAxisQuadraticSlopeRoot = 1 ∧
      sixAxisTwoQuadraticEigenbasisInverse SixAxisQuadraticSplittingField
          sixAxisQuadraticSlopeRoot *
        sixAxisTwoQuadraticEigenbasis SixAxisQuadraticSplittingField
          sixAxisQuadraticSlopeRoot = 1 ∧
      sixAxisTwoQuadraticSlopeOver SixAxisQuadraticSplittingField *
          sixAxisTwoQuadraticEigenbasis SixAxisQuadraticSplittingField
            sixAxisQuadraticSlopeRoot =
        sixAxisTwoQuadraticEigenbasis SixAxisQuadraticSplittingField
            sixAxisQuadraticSlopeRoot *
          sixAxisTwoQuadraticDiagonal SixAxisQuadraticSplittingField
            sixAxisQuadraticSlopeRoot := by
  exact ⟨sixAxisTwoQuadraticEigenbasis_mul_inverse _ _,
    sixAxisTwoQuadraticEigenbasis_inverse_mul _ _,
    sixAxisTwoQuadraticSlopeOver_mul_eigenbasis _ _
      sixAxisQuadraticSlopeRoot_equation⟩

/-- The characteristic-three one-point model is a scalar slope on the full
four-dimensional depth-one block. -/
def sixAxisThreeScalarSlope (value : ZMod 3) :
    Matrix (Fin 4) (Fin 4) (ZMod 3) :=
  Matrix.scalar (Fin 4) value

/-- The characteristic-three model is literally the image of its scalar
under the matrix-algebra structure. -/
theorem sixAxisThreeScalarSlope_eq_algebraMap (value : ZMod 3) :
    sixAxisThreeScalarSlope value =
      algebraMap (ZMod 3) (Matrix (Fin 4) (Fin 4) (ZMod 3)) value := by
  rfl

/-- A scalar slope commutes with every coefficient block, so it contributes
no residual commutator condition beyond the diagonal depth. -/
theorem sixAxisThreeScalarSlope_commutes
    (value : ZMod 3) (coefficient : Matrix (Fin 4) (Fin 4) (ZMod 3)) :
    coefficient * sixAxisThreeScalarSlope value =
      sixAxisThreeScalarSlope value * coefficient := by
  exact (Matrix.scalar_comm value (fun otherValue =>
    Commute.all value otherValue) coefficient).symm

end

end GraphLattices

end TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue
