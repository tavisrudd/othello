import RelativeConicArcs.PaperIOrientationTraceDual
import RelativeConicArcs.GoldenCubicNodes
import RelativeConicArcs.GoldenCubicNodeHessians

/-!
# Singular locus and ordinary-node type

The cross-golden trace-dual theorem supplies the cited completeness route.
Independently, the repository already contains a kernel-checked elimination
of the five gradient quadrics; this packet exposes that stronger internal
certificate as the exact singular-locus statement.  The six frame points are
then ordinary nodes because their deleted four-by-four Hessian blocks have
nonzero determinant.
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

#print axioms supportCubic_singularLocus_eq_frame
#print axioms supportCubic_framePoints_ordinaryNodes
#print axioms deletedPrincipalBlock_mulVec_incidentRow
#print axioms deletedPrincipalBlock_sq
#print axioms deletedPrincipalBlock_mulVec_eq_zero_iff
#print axioms finrank_deletedPrincipalBlock_range

end RelativeConicArcs.PaperIOrientationNodes
