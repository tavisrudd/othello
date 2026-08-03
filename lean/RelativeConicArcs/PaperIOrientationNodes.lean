import RelativeConicArcs.PaperIOrientationTraceDual
import RelativeConicArcs.GoldenCubicNodes
import RelativeConicArcs.GoldenCubicNodeHessians

/-!
# Singular locus and ordinary-node type of the determinantal cubic threefold

Fix a field `K` of characteristic zero containing a root `t` of `t^2 = t + 1`.
Five centered coordinates `x 0, …, x 4` describe the augmentation hyperplane of
the six labelled golden axes, the omitted sixth coordinate being
`-(x 0 + ⋯ + x 4)`; `GoldenCubicNodesBase.centeredLift` performs that
completion and `GoldenCubicNodesBase.centeredNode i` is the centered
representative of the axis vector `1 - 6 e i`.

Two descriptions of one cubic form meet here.  Compressing the diagonal
operator `diag y` between the two conjugate golden eigenspaces produces the
three-by-three cross-golden block `crossGoldenBlock t y`, whose determinant is
the negative oriented triangle cubic of the golden conference matrix.
Independently, an exact ideal-membership elimination classifies the common zero
locus of the five gradient quadrics `GoldenCubicNodesBase.gradient` of that same
cubic.  This module joins the two: differentiating the determinant along a
single centered coordinate line returns the corresponding gradient quadric with
a sign, so the singular points of the determinantal cubic threefold are exactly
the six axis classes, and each of them is an ordinary double point because its
deleted five-by-five Hessian block has rank four and its dehomogenized Hessian
is nonsingular.

Terminal results: `singularPoints_crossGoldenDeterminant_eq_axisClasses`,
`supportCubic_singularLocus_eq_frame`, `supportCubic_framePoints_ordinaryNodes`.
Everything below is proved from the definitions; nothing in this module is
assumed or discharged outside the kernel.
-/

namespace RelativeConicArcs.PaperIOrientationNodes

open scoped Matrix
open GoldenCubicNodesBase
open GoldenCubicNodes
open GoldenCubicNodeHessians
open ClebschGoldenConference
open PaperIOrientationPentagon
open PaperIOrientationHolonomy
open PaperIOrientationDeterminant
open PaperIOrientationTraceDual

/-- Five-by-five principal block obtained by deleting one support axis. -/
def deletedPrincipalBlock (a : Fin 6) : Matrix (Fin 5) (Fin 5) ℚ :=
  fun i j => rationalSignedOrbitalMatrix (a.succAbove i) (a.succAbove j)

/-- Incidence row from the deleted axis to the other five axes. -/
def deletedIncidentRow (a : Fin 6) : Fin 5 → ℚ :=
  fun i => rationalSignedOrbitalMatrix a (a.succAbove i)

/-- Rank-one outer product of the deleted incidence row with itself. -/
def deletedIncidentOuter (a : Fin 6) : Matrix (Fin 5) (Fin 5) ℚ :=
  fun i j => deletedIncidentRow a i * deletedIncidentRow a j

/-- The deleted principal block kills the deleted incidence row. -/
theorem deletedPrincipalBlock_mulVec_incidentRow (a : Fin 6) :
    deletedPrincipalBlock a *ᵥ deletedIncidentRow a = 0 := by
  funext i
  have h := congrArg
    (fun M : Matrix (Fin 6) (Fin 6) ℚ => M (a.succAbove i) a)
    rationalSignedOrbitalMatrix_sq
  simp only [Matrix.mul_apply, Matrix.smul_apply, Matrix.one_apply,
    Fin.succAbove_ne, if_false] at h
  rw [Fin.sum_univ_succAbove _ a] at h
  have hsymm : ∀ j : Fin 5,
      rationalSignedOrbitalMatrix (a.succAbove j) a =
        rationalSignedOrbitalMatrix a (a.succAbove j) := by
    intro j
    simpa [rationalSignedOrbitalMatrix, Matrix.transpose_apply] using
      congrArg (fun M => M a (a.succAbove j))
        fiberOddOrbitalMatrix_transpose
  have hdiag : rationalSignedOrbitalMatrix a a = 0 := by
    simp [rationalSignedOrbitalMatrix, fiberOddOrbitalMatrix_apply_self]
  simpa [deletedPrincipalBlock, deletedIncidentRow,
    hdiag, hsymm, Matrix.mulVec, dotProduct] using h

/-- Block form of `B²=5I`: after deleting one axis,
`M²=5I-u uᵀ`. -/
theorem deletedPrincipalBlock_sq (a : Fin 6) :
    deletedPrincipalBlock a * deletedPrincipalBlock a =
      (5 : ℚ) • (1 : Matrix (Fin 5) (Fin 5) ℚ) -
        deletedIncidentOuter a := by
  ext i j
  have h := congrArg
    (fun M : Matrix (Fin 6) (Fin 6) ℚ => M (a.succAbove i) (a.succAbove j))
    rationalSignedOrbitalMatrix_sq
  simp only [Matrix.mul_apply, Matrix.smul_apply, Matrix.one_apply] at h
  rw [Fin.sum_univ_succAbove _ a] at h
  have hsymm : rationalSignedOrbitalMatrix (a.succAbove i) a =
      rationalSignedOrbitalMatrix a (a.succAbove i) := by
    simpa [rationalSignedOrbitalMatrix, Matrix.transpose_apply] using
      congrArg (fun M => M a (a.succAbove i))
        fiberOddOrbitalMatrix_transpose
  simp only [deletedPrincipalBlock, deletedIncidentOuter, Matrix.mul_apply,
    Matrix.sub_apply, Matrix.smul_apply, Matrix.one_apply]
  have heq : a.succAbove i = a.succAbove j ↔ i = j := by
    constructor
    · intro hij
      exact Fin.succAbove_right_injective hij
    · intro hij
      rw [hij]
  have hif : (if a.succAbove i = a.succAbove j then (1 : ℚ) else 0) =
      if i = j then 1 else 0 := if_congr heq rfl rfl
  rw [hif, hsymm] at h
  simp only [deletedIncidentRow]
  linear_combination h

/-- The deleted principal block has exactly the deleted incidence row as its
one-dimensional kernel.  This is the rank-four mechanism used for the node
Hessian. -/
theorem deletedPrincipalBlock_mulVec_eq_zero_iff (a : Fin 6) (v : Fin 5 → ℚ) :
    deletedPrincipalBlock a *ᵥ v = 0 ↔
      ∃ c : ℚ, v = c • deletedIncidentRow a := by
  constructor
  · intro hv
    have hs := congrArg (fun M : Matrix (Fin 5) (Fin 5) ℚ => M *ᵥ v)
      (deletedPrincipalBlock_sq a)
    rw [← Matrix.mulVec_mulVec, hv] at hs
    simp only [Matrix.mulVec_zero] at hs
    let c : ℚ := (∑ j, deletedIncidentRow a j * v j) / 5
    refine ⟨c, ?_⟩
    funext i
    have hi := congrFun hs i
    change 0 = ∑ x, ((5 : ℚ) * (if i = x then 1 else 0) -
      deletedIncidentRow a i * deletedIncidentRow a x) * v x at hi
    have hsum : (∑ x, ((5 : ℚ) * (if i = x then 1 else 0) -
        deletedIncidentRow a i * deletedIncidentRow a x) * v x) =
        5 * v i - deletedIncidentRow a i *
          ∑ j, deletedIncidentRow a j * v j := by
      simp_rw [sub_mul]
      rw [Finset.sum_sub_distrib, Finset.mul_sum]
      simp [mul_assoc]
    have hi' : 0 = 5 * v i - deletedIncidentRow a i *
        ∑ j, deletedIncidentRow a j * v j := by
      rw [← hsum]
      exact hi
    dsimp [c]
    linear_combination -hi' / 5
  · rintro ⟨c, rfl⟩
    rw [Matrix.mulVec_smul, deletedPrincipalBlock_mulVec_incidentRow]
    simp

/-- The deleted principal block has rank four.  This is a symbolic consequence
of `B²=5I`: its kernel is the line spanned by the deleted incidence row. -/
theorem finrank_deletedPrincipalBlock_range (a : Fin 6) :
    Module.finrank ℚ (LinearMap.range (deletedPrincipalBlock a).mulVecLin) = 4 := by
  have hu : deletedIncidentRow a ≠ 0 := by
    fin_cases a <;>
      intro h <;>
      have := congrFun h 0 <;>
      norm_num [deletedIncidentRow, rationalSignedOrbitalMatrix,
        fiberOddOrbitalMatrix, conferenceMatrix] at this
  have hker : LinearMap.ker (deletedPrincipalBlock a).mulVecLin =
      ℚ ∙ deletedIncidentRow a := by
    ext v
    rw [LinearMap.mem_ker, Matrix.mulVecLin_apply,
      deletedPrincipalBlock_mulVec_eq_zero_iff,
      Submodule.mem_span_singleton]
    constructor
    · rintro ⟨c, rfl⟩
      exact ⟨c, rfl⟩
    · rintro ⟨c, rfl⟩
      exact ⟨c, rfl⟩
  have hrank := LinearMap.finrank_range_add_finrank_ker
    (deletedPrincipalBlock a).mulVecLin
  rw [hker, finrank_span_singleton hu] at hrank
  have hdomain : Module.finrank ℚ (Fin 5 → ℚ) = 5 := by simp
  omega

/-- The determinant of the cross-golden block restricted to the `j`-th centered
coordinate line, as a univariate polynomial over the base ring.

The five centered coordinates of `x` are frozen as constants except the `j`-th,
which is replaced by the indeterminate; the resulting five-tuple is completed to
six homogeneous coordinates by `centeredLift`, the diagonal operator it names is
compressed between the two conjugate golden eigenspaces attached to the root `t`
of `t^2 = t + 1`, and the three-by-three determinant of that compression is
taken.  Evaluating at `x j` returns the determinant at `x` itself. -/
noncomputable def crossGoldenDeterminantLine {R : Type*} [CommRing R] (t : R)
    (x : Fin 5 → R) (j : Fin 5) : Polynomial R :=
  Matrix.det (crossGoldenBlock (Polynomial.C t)
    (centeredLift (Function.update (fun k => Polynomial.C (x k)) j Polynomial.X)))

/-- Differentiating the cross-golden determinant along the `j`-th centered
coordinate line and evaluating at the original coordinate returns the negative
of the `j`-th displayed gradient quadric.

Concretely: for a golden root `t` in a commutative ring `R` and centered
coordinates `x : Fin 5 → R`, the `j`-th partial derivative of the cubic form
`x ↦ det (crossGoldenBlock t (centeredLift x))` equals `- gradient x j`.  This
is the identification of the determinantal cubic with the negative oriented
triangle cubic, `det_crossGoldenBlock_eq_neg_supportCubic`, transported to the
polynomial ring in one variable. -/
theorem derivative_crossGoldenDeterminantLine_eval
    {R : Type*} [CommRing R] (t : R) (ht : t ^ 2 = t + 1)
    (x : Fin 5 → R) (j : Fin 5) :
    (crossGoldenDeterminantLine t x j).derivative.eval (x j) = -gradient x j := by
  have hC : (Polynomial.C t) ^ 2 = Polynomial.C t + 1 := by
    rw [← Polynomial.C_pow, ht, Polynomial.C_add, Polynomial.C_1]
  rw [crossGoldenDeterminantLine,
    det_crossGoldenBlock_eq_neg_supportCubic (Polynomial.C t) hC]
  fin_cases j <;>
    simp [triangleCubic, cubicTerm, triangleSign, conferenceMatrixOver,
      conferenceMatrix, centeredLift, GoldenCubicNodesBase.gradient,
      Function.update,
      Fin.sum_univ_succ, Polynomial.derivative_pow] <;>
    ring

/-- The singular points of the cross-golden determinantal cubic threefold are
exactly the six axis classes.

Let `K` be a field of characteristic zero containing a root `t` of
`t^2 = t + 1`, and let `x : Fin 5 → K` be a nonzero centered five-vector.  All
five partial derivatives of the cubic form `x ↦ det (crossGoldenBlock t
(centeredLift x))` vanish at `x` if and only if `x` is a nonzero scalar multiple
of one of the six centered axis vectors `centeredNode i`, that is, of `1 - 6 e i`
in the six homogeneous coordinates.  Projectively, the determinantal cubic
threefold cut out in the five-dimensional cross-golden image has exactly the six
axis classes as singular points.

Two further features of the same configuration are established separately: the
six classes are a projective frame because the kernel of the
cross-golden compression is exactly the all-ones line
(`PaperIOrientationTraceDual.crossGoldenMap_mem_ker_iff_constant`), and each is
an ordinary double point (`supportCubic_framePoints_ordinaryNodes`).

The corresponding statement in the literature is the determinantal duality of
Brendan Hassett and Yuri Tschinkel, *Flops on holomorphic symplectic fourfolds
and determinantal cubic hypersurfaces*, Journal of the Institute of Mathematics
of Jussieu 9 (2010), no. 1, 125-153, doi:10.1017/S1474748009000140, Section 3,
Proposition 10, which characterizes the trace-dual partner of a smooth
determinantal cubic surface as a cubic threefold with six ordinary double points
in linear general position.  That result is not used here: the statement above is
established for the cross-golden family directly, without its smoothness or
transversality hypotheses. -/
theorem singularPoints_crossGoldenDeterminant_eq_axisClasses
    {K : Type*} [Field K] [CharZero K] (t : K) (ht : t ^ 2 = t + 1)
    (x : Fin 5 → K) (hx : x ≠ 0) :
    (∀ j, (crossGoldenDeterminantLine t x j).derivative.eval (x j) = 0) ↔
      ∃ c : K, c ≠ 0 ∧ ∃ i : Fin 6, x = c • centeredNode i := by
  have hderiv : ∀ j : Fin 5,
      (crossGoldenDeterminantLine t x j).derivative.eval (x j) = -gradient x j :=
    fun j => derivative_crossGoldenDeterminantLine_eval t ht x j
  simp only [hderiv, neg_eq_zero]
  exact nonzero_gradient_zero_iff_projective_centeredNode x hx

/-- The nonzero singular cone is exactly the six projective frame lines. -/
theorem supportCubic_singularLocus_eq_frame
    {K : Type*} [Field K] [CharZero K] (x : Fin 5 → K) (hx : x ≠ 0) :
    (∀ j, gradient x j = 0) ↔
      ∃ c : K, c ≠ 0 ∧ ∃ i : Fin 6, x = c • centeredNode i :=
  nonzero_gradient_zero_iff_projective_centeredNode x hx

/-- Every displayed projective frame point has the structural rank-four
deleted block forced by `B²=5I`; the small chart normalization then identifies
this block with a nondegenerate dehomogenized Hessian, so the point is an
ordinary double point. -/
theorem supportCubic_framePoints_ordinaryNodes
    {K : Type*} [Field K] [CharZero K] (i : Fin 6) :
    Module.finrank ℚ
        (LinearMap.range (deletedPrincipalBlock i).mulVecLin) = 4 ∧
      Matrix.det (chartHessian (chartNode (K := K) i)) ≠ 0 :=
  ⟨finrank_deletedPrincipalBlock_range i,
    det_chartHessian_chartNode_ne_zero i⟩

#print axioms derivative_crossGoldenDeterminantLine_eval
#print axioms singularPoints_crossGoldenDeterminant_eq_axisClasses
#print axioms supportCubic_singularLocus_eq_frame
#print axioms supportCubic_framePoints_ordinaryNodes
#print axioms deletedPrincipalBlock_mulVec_incidentRow
#print axioms deletedPrincipalBlock_sq
#print axioms deletedPrincipalBlock_mulVec_eq_zero_iff
#print axioms finrank_deletedPrincipalBlock_range

end RelativeConicArcs.PaperIOrientationNodes
