import Mathlib.Algebra.BigOperators.Group.Finset.Basic
import Mathlib.Data.Matrix.Basic

/-!
# Weighted evaluations of finite edge systems

An edge system is a finite list of ordered pairs of labels.  Evaluating a
matrix whose entries factor as an affine bracket times a coefficient splits
the product over every edge system into a bracket product and a coefficient
product.  Consequently any signed or weighted sum over a finite family of
edge systems admits the same termwise factorization.

Perfect-matching and Pfaffian identities are instances obtained by taking the
edge systems to be perfect matchings and the weights to be their Pfaffian
signs.  The factorization itself requires neither disjointness nor coverage,
so it is stated on the more general natural domain where it holds.
-/

namespace RelativeConicArcs.WeightedMatchingEvaluation

open scoped BigOperators

/-- The affine difference between two labelled coordinates. -/
def affineBracket {R ι : Type*} [Sub R] (x : ι → R) (i j : ι) : R :=
  x i - x j

/-- The matrix obtained by multiplying every coefficient by its affine
bracket. -/
def bracketWeightedMatrix {R ι : Type*} [Mul R] [Sub R]
    (C : Matrix ι ι R) (x : ι → R) : Matrix ι ι R :=
  fun i j => affineBracket x i j * C i j

/-- The product of matrix entries along a finite edge system. -/
def edgeProduct {R ι κ : Type*} [CommMonoid R] [Fintype κ]
    (A : Matrix ι ι R) (edges : κ → ι × ι) : R :=
  ∏ k, A (edges k).1 (edges k).2

/-- The product of affine brackets along a finite edge system. -/
def bracketProduct {R ι κ : Type*} [CommRing R] [Fintype κ]
    (x : ι → R) (edges : κ → ι × ι) : R :=
  ∏ k, affineBracket x (edges k).1 (edges k).2

/-- The product of coefficients along a finite edge system. -/
def coefficientProduct {R ι κ : Type*} [CommMonoid R] [Fintype κ]
    (C : Matrix ι ι R) (edges : κ → ι × ι) : R :=
  ∏ k, C (edges k).1 (edges k).2

/-- Evaluation on a bracket-weighted matrix factors termwise into its affine
and coefficient parts. -/
theorem edgeProduct_bracketWeightedMatrix {R ι κ : Type*}
    [CommRing R] [Fintype κ] (C : Matrix ι ι R) (x : ι → R)
    (edges : κ → ι × ι) :
    edgeProduct (bracketWeightedMatrix C x) edges =
      bracketProduct x edges * coefficientProduct C edges := by
  simp [edgeProduct, bracketWeightedMatrix, bracketProduct,
    coefficientProduct, Finset.prod_mul_distrib]

/-- A finite weighted sum of edge products. -/
def weightedEdgeSum {R ι κ Ω : Type*} [CommRing R]
    [Fintype κ] [Fintype Ω] (weight : Ω → R)
    (edges : Ω → κ → ι × ι) (A : Matrix ι ι R) : R :=
  ∑ ω, weight ω * edgeProduct A (edges ω)

/-- Every finite weighted edge sum on a bracket-weighted matrix is the same
weighted sum of factored bracket and coefficient products. -/
theorem weightedEdgeSum_bracketWeightedMatrix {R ι κ Ω : Type*}
    [CommRing R] [Fintype κ] [Fintype Ω]
    (weight : Ω → R) (edges : Ω → κ → ι × ι)
    (C : Matrix ι ι R) (x : ι → R) :
    weightedEdgeSum weight edges (bracketWeightedMatrix C x) =
      ∑ ω, weight ω *
        (bracketProduct x (edges ω) * coefficientProduct C (edges ω)) := by
  simp [weightedEdgeSum, edgeProduct_bracketWeightedMatrix]

/-- Common affine translation leaves every bracket product unchanged. -/
theorem bracketProduct_translate {R ι κ : Type*}
    [CommRing R] [Fintype κ] (x : ι → R) (t : R)
    (edges : κ → ι × ι) :
    bracketProduct (fun i => x i + t) edges = bracketProduct x edges := by
  apply Finset.prod_congr rfl
  intro k _
  simp [affineBracket]

/-- Scaling all affine coordinates multiplies an edge product by one copy of
the scalar for each edge. -/
theorem bracketProduct_scale {R ι κ : Type*}
    [CommRing R] [Fintype κ] (x : ι → R) (s : R)
    (edges : κ → ι × ι) :
    bracketProduct (fun i => s * x i) edges =
      s ^ Fintype.card κ * bracketProduct x edges := by
  simp [bracketProduct, affineBracket, mul_sub, Finset.prod_mul_distrib]

end RelativeConicArcs.WeightedMatchingEvaluation
