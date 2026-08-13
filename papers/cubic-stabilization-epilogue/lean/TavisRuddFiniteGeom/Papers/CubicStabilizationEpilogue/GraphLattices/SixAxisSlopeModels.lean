import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.GraphLattices.SixAxisLocalChart
import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.GraphLattices.FrobeniusPacket
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

/-- The concrete quadratic splitting field has degree two over `F₂`. -/
theorem sixAxisQuadraticSplittingField_finrank :
    Module.finrank (ZMod 2) SixAxisQuadraticSplittingField = 2 := by
  rw [(AdjoinRoot.powerBasis
    sixAxisQuadraticSlopePolynomial_irreducible.ne_zero).finrank]
  exact sixAxisQuadraticSlopePolynomial_natDegree

/-- A coefficient-algebra identification between the root-adjoining splitting
field and the concrete four-element field used for the gluing packet. -/
noncomputable def sixAxisQuadraticSplittingFieldAlgEquivF4 :
    SixAxisQuadraticSplittingField ≃ₐ[ZMod 2] F4 := by
  let powerBasis := AdjoinRoot.powerBasis
    sixAxisQuadraticSlopePolynomial_irreducible.ne_zero
  letI : Fintype SixAxisQuadraticSplittingField :=
    Fintype.ofEquiv (Fin powerBasis.dim → ZMod 2)
      powerBasis.basis.equivFun.symm.toEquiv
  letI : Fintype F4 := Fintype.ofFinite F4
  apply FiniteField.algEquivOfCardEq 2
  rw [Fintype.card_eq_nat_card, Fintype.card_eq_nat_card, natCard_F4]
  calc
    Nat.card SixAxisQuadraticSplittingField =
        Nat.card (Fin powerBasis.dim → ZMod 2) :=
      Nat.card_congr powerBasis.basis.equivFun.toEquiv
    _ = 4 := by
      rw [Nat.card_fun, Nat.card_fin]
      have dim : powerBasis.dim = 2 := by
        exact sixAxisQuadraticSlopePolynomial_natDegree
      rw [dim]
      norm_num

/-- The image of the marked quadratic root under the chosen algebra
equivalence to the concrete gluing field. -/
noncomputable def sixAxisQuadraticSlopeRootInF4 : F4 :=
  sixAxisQuadraticSplittingFieldAlgEquivF4 sixAxisQuadraticSlopeRoot

/-- The transported marked root is one of the two exotic gluing scalars: it
satisfies `x²+x+1=0` and hence is neither `0` nor `1`. -/
theorem sixAxisQuadraticSlopeRootInF4_equation_and_exotic :
    sixAxisQuadraticSlopeRootInF4 ^ 2 +
          sixAxisQuadraticSlopeRootInF4 + 1 = 0 ∧
      sixAxisQuadraticSlopeRootInF4 ≠ 0 ∧
      sixAxisQuadraticSlopeRootInF4 ≠ 1 := by
  letI : Algebra (ZMod 2) F4 :=
    FiniteField.instAlgebraExtension (ZMod 2) 2 2
  letI : CharP F4 2 := charP_of_injective_algebraMap' (ZMod 2) 2
  have equation := congrArg sixAxisQuadraticSplittingFieldAlgEquivF4
    sixAxisQuadraticSlopeRoot_equation
  have mappedEquation : sixAxisQuadraticSlopeRootInF4 ^ 2 +
      sixAxisQuadraticSlopeRootInF4 + 1 = 0 := by
    simpa [sixAxisQuadraticSlopeRootInF4] using equation
  refine ⟨mappedEquation, ?_, ?_⟩
  · intro zero
    rw [zero] at mappedEquation
    simpa using mappedEquation
  · intro one
    rw [one] at mappedEquation
    have two : (2 : F4) = 0 := CharP.cast_eq_zero F4 2
    have three : (3 : F4) = 1 := by
      calc
        (3 : F4) = 2 + 1 := by norm_num
        _ = 0 + 1 := congrArg (fun value : F4 ↦ value + 1) two
        _ = 1 := zero_add 1
    norm_num only [one_pow, one_add_one_eq_two] at mappedEquation
    rw [three] at mappedEquation
    exact one_ne_zero mappedEquation

/-- Frobenius exchanges the two exotic roots of the quadratic polynomial. -/
theorem sixAxisQuadraticSlopeRootInF4_frobenius_conjugate :
    f4Frobenius sixAxisQuadraticSlopeRootInF4 ≠
        sixAxisQuadraticSlopeRootInF4 ∧
      f4Frobenius (f4Frobenius sixAxisQuadraticSlopeRootInF4) =
        sixAxisQuadraticSlopeRootInF4 :=
  f4Frobenius_exchanges_nonPrimeElement sixAxisQuadraticSlopeRootInF4
    sixAxisQuadraticSlopeRootInF4_equation_and_exotic.2.1
    sixAxisQuadraticSlopeRootInF4_equation_and_exotic.2.2

/-- The Frobenius conjugate of the transported marked root is exactly the
other quadratic root `x+1`. -/
theorem sixAxisQuadraticSlopeRootInF4_frobenius_eq_add_one :
    f4Frobenius sixAxisQuadraticSlopeRootInF4 =
      sixAxisQuadraticSlopeRootInF4 + 1 := by
  letI : Algebra (ZMod 2) F4 :=
    FiniteField.instAlgebraExtension (ZMod 2) 2 2
  letI : CharP F4 2 := charP_of_injective_algebraMap' (ZMod 2) 2
  have equation := sixAxisQuadraticSlopeRootInF4_equation_and_exotic.1
  rw [f4Frobenius]
  calc
    sixAxisQuadraticSlopeRootInF4 ^ 2 =
        -(sixAxisQuadraticSlopeRootInF4 + 1) := by
      linear_combination equation
    _ = sixAxisQuadraticSlopeRootInF4 + 1 := CharTwo.neg_eq _

/-- In the affine chart of the five-point projective gluing packet, the
transported marked root and `root+1` are distinct points exchanged by
projective Frobenius. -/
theorem sixAxisQuadraticSlope_markedProjectivePair :
    f4ProjectiveFrobenius (some sixAxisQuadraticSlopeRootInF4) =
        some (sixAxisQuadraticSlopeRootInF4 + 1) ∧
      f4ProjectiveFrobenius
          (some (sixAxisQuadraticSlopeRootInF4 + 1)) =
        some sixAxisQuadraticSlopeRootInF4 ∧
      (some sixAxisQuadraticSlopeRootInF4 : Option F4) ≠
        some (sixAxisQuadraticSlopeRootInF4 + 1) := by
  have first := sixAxisQuadraticSlopeRootInF4_frobenius_eq_add_one
  have second := f4Frobenius_involutive sixAxisQuadraticSlopeRootInF4
  rw [first] at second
  refine ⟨congrArg some first, congrArg some second, ?_⟩
  intro equality
  apply sixAxisQuadraticSlopeRootInF4_frobenius_conjugate.1
  rw [first]
  exact Option.some.inj equality.symm

/-- Every element of the concrete four-element field is `0`, `1`, the
transported marked root, or its conjugate `root+1`. -/
theorem f4_eq_zero_or_one_or_markedRoot_or_conjugate (value : F4) :
    value = 0 ∨ value = 1 ∨
      value = sixAxisQuadraticSlopeRootInF4 ∨
      value = sixAxisQuadraticSlopeRootInF4 + 1 := by
  by_cases isZero : value = 0
  · exact Or.inl isZero
  by_cases isOne : value = 1
  · exact Or.inr (Or.inl isOne)
  right
  right
  letI : Algebra (ZMod 2) F4 :=
    FiniteField.instAlgebraExtension (ZMod 2) 2 2
  letI : CharP F4 2 := charP_of_injective_algebraMap' (ZMod 2) 2
  letI : Fintype F4 := Fintype.ofFinite F4
  have cardinality : Fintype.card F4 = 4 := by
    simpa [Nat.card_eq_fintype_card] using natCard_F4
  have fourthPower : value ^ 4 = value := by
    simpa [cardinality] using (FiniteField.pow_card value)
  have polynomial : value ^ 2 + value + 1 = 0 := by
    have factored :
        value * (value - 1) * (value ^ 2 + value + 1) = 0 := by
      calc
        value * (value - 1) * (value ^ 2 + value + 1) =
            value ^ 4 - value := by ring
        _ = 0 := sub_eq_zero.mpr fourthPower
    rcases mul_eq_zero.mp factored with firstFactor | result
    · rcases mul_eq_zero.mp firstFactor with zero | one
      · exact (isZero zero).elim
      · exact (isOne (sub_eq_zero.mp one)).elim
    · exact result
  have two : (2 : F4) = 0 := CharP.cast_eq_zero F4 2
  have product :
      (value - sixAxisQuadraticSlopeRootInF4) *
        (value - (sixAxisQuadraticSlopeRootInF4 + 1)) = 0 := by
    rw [sub_eq_add_neg, sub_eq_add_neg, CharTwo.neg_eq, CharTwo.neg_eq]
    linear_combination polynomial +
      sixAxisQuadraticSlopeRootInF4_equation_and_exotic.1 +
      two * (value * sixAxisQuadraticSlopeRootInF4 - 1)
  rcases mul_eq_zero.mp product with root | conjugate
  · exact Or.inl (sub_eq_zero.mp root)
  · exact Or.inr (sub_eq_zero.mp conjugate)

/-- The nonfixed affine-chart points of projective Frobenius are exactly the
transported marked quadratic root and its conjugate. -/
theorem f4ProjectiveFrobenius_nonfixed_iff_markedProjectivePair
    (point : Option F4) :
    f4ProjectiveFrobenius point ≠ point ↔
      point = some sixAxisQuadraticSlopeRootInF4 ∨
        point = some (sixAxisQuadraticSlopeRootInF4 + 1) := by
  constructor
  · intro moved
    cases point with
    | none => exact (moved rfl).elim
    | some value =>
        rcases f4_eq_zero_or_one_or_markedRoot_or_conjugate value with
          zero | one | root | conjugate
        · subst value
          exact (moved (by simp [f4ProjectiveFrobenius, f4Frobenius])).elim
        · subst value
          exact (moved (by simp [f4ProjectiveFrobenius, f4Frobenius])).elim
        · exact Or.inl (congrArg some root)
        · exact Or.inr (congrArg some conjugate)
  · rintro (rfl | rfl)
    · intro fixed
      apply sixAxisQuadraticSlope_markedProjectivePair.2.2
      calc
        some sixAxisQuadraticSlopeRootInF4 =
            f4ProjectiveFrobenius
              (some sixAxisQuadraticSlopeRootInF4) := fixed.symm
        _ = some (sixAxisQuadraticSlopeRootInF4 + 1) :=
          sixAxisQuadraticSlope_markedProjectivePair.1
    · intro fixed
      apply sixAxisQuadraticSlope_markedProjectivePair.2.2
      calc
        some sixAxisQuadraticSlopeRootInF4 =
            f4ProjectiveFrobenius
              (some (sixAxisQuadraticSlopeRootInF4 + 1)) :=
          sixAxisQuadraticSlope_markedProjectivePair.2.1.symm
        _ = some (sixAxisQuadraticSlopeRootInF4 + 1) := fixed

/-- On the actual projective line over `F4`, the nonfixed locus of
coefficientwise Frobenius is exactly the two scalar graphs defined by the
transported marked quadratic root and its conjugate. -/
theorem f4ProjectiveLineFrobenius_nonfixed_iff_markedGraphPair
    (point : Projectivization F4 (F4 × F4)) :
    f4ProjectiveLineFrobenius point ≠ point ↔
      point = scalarGraphPoint F4 sixAxisQuadraticSlopeRootInF4 ∨
        point = scalarGraphPoint F4
          (sixAxisQuadraticSlopeRootInF4 + 1) := by
  let coordinate := (optionEquivProjectiveLine F4).symm point
  constructor
  · intro moved
    have coordinateMoved : f4ProjectiveFrobenius coordinate ≠ coordinate := by
      intro fixed
      apply moved
      change optionEquivProjectiveLine F4
          (f4ProjectiveFrobenius coordinate) = point
      rw [fixed]
      exact Equiv.apply_symm_apply (optionEquivProjectiveLine F4) point
    rcases (f4ProjectiveFrobenius_nonfixed_iff_markedProjectivePair
      coordinate).mp coordinateMoved with root | conjugate
    · left
      calc
        point = optionEquivProjectiveLine F4 coordinate :=
          (Equiv.apply_symm_apply (optionEquivProjectiveLine F4) point).symm
        _ = scalarGraphPoint F4 sixAxisQuadraticSlopeRootInF4 := by
          simp [root, optionEquivProjectiveLine, projectiveLineChart]
    · right
      calc
        point = optionEquivProjectiveLine F4 coordinate :=
          (Equiv.apply_symm_apply (optionEquivProjectiveLine F4) point).symm
        _ = scalarGraphPoint F4
            (sixAxisQuadraticSlopeRootInF4 + 1) := by
          simp [conjugate, optionEquivProjectiveLine, projectiveLineChart]
  · rintro (rfl | rfl)
    · rw [← show projectiveLineChart F4
          (some sixAxisQuadraticSlopeRootInF4) =
          scalarGraphPoint F4 sixAxisQuadraticSlopeRootInF4 by rfl,
        f4ProjectiveLineFrobenius_chart]
      intro fixed
      exact (f4ProjectiveFrobenius_nonfixed_iff_markedProjectivePair
        (some sixAxisQuadraticSlopeRootInF4)).mpr (Or.inl rfl)
        (projectiveLineChart_injective F4 fixed)
    · rw [← show projectiveLineChart F4
          (some (sixAxisQuadraticSlopeRootInF4 + 1)) =
          scalarGraphPoint F4 (sixAxisQuadraticSlopeRootInF4 + 1) by rfl,
        f4ProjectiveLineFrobenius_chart]
      intro fixed
      exact (f4ProjectiveFrobenius_nonfixed_iff_markedProjectivePair
        (some (sixAxisQuadraticSlopeRootInF4 + 1))).mpr (Or.inr rfl)
        (projectiveLineChart_injective F4 fixed)

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

/-- The same marked diagonalization written directly over the concrete `F4`
used for the principal gluing packet. -/
theorem sixAxisTwoQuadraticSlope_f4Marked_split :
    sixAxisTwoQuadraticEigenbasis F4 sixAxisQuadraticSlopeRootInF4 *
        sixAxisTwoQuadraticEigenbasisInverse F4
          sixAxisQuadraticSlopeRootInF4 = 1 ∧
      sixAxisTwoQuadraticEigenbasisInverse F4
          sixAxisQuadraticSlopeRootInF4 *
        sixAxisTwoQuadraticEigenbasis F4
          sixAxisQuadraticSlopeRootInF4 = 1 ∧
      sixAxisTwoQuadraticSlopeOver F4 *
          sixAxisTwoQuadraticEigenbasis F4
            sixAxisQuadraticSlopeRootInF4 =
        sixAxisTwoQuadraticEigenbasis F4
            sixAxisQuadraticSlopeRootInF4 *
          sixAxisTwoQuadraticDiagonal F4
            sixAxisQuadraticSlopeRootInF4 := by
  letI : Algebra (ZMod 2) F4 :=
    FiniteField.instAlgebraExtension (ZMod 2) 2 2
  letI : CharP F4 2 := charP_of_injective_algebraMap' (ZMod 2) 2
  exact ⟨sixAxisTwoQuadraticEigenbasis_mul_inverse _ _,
    sixAxisTwoQuadraticEigenbasis_inverse_mul _ _,
    sixAxisTwoQuadraticSlopeOver_mul_eigenbasis _ _
      sixAxisQuadraticSlopeRootInF4_equation_and_exotic.1⟩

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
