import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.RankTwoLatticeTransport

/-!
# The canonical rank-two lattice in an adapted frame

In the original free lattice `B[[z]]²`, reduction modulo `z` takes the
preimage of the first coordinate line. This submodule is exactly the image
of `(u,v) ↦ (u,zv)`. For a leading nilpotent matrix with unit upper-right
entry, the line is both its kernel and image. The preimage construction
commutes with injective coefficient extension. These statements concern free
modules in an adapted frame, without constructing a sheaf on a geometric base.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum

/-- The preimage of the nilpotent line under reduction modulo the formal
parameter, expressed as a submodule of the original free rank-two lattice. -/
def adaptedCanonicalLattice {B : Type*} [CommRing B] :
    Submodule (PowerSeries B) (Fin 2 → PowerSeries B) where
  carrier := {v | PowerSeries.constantCoeff (v 1) = 0}
  zero_mem' := by simp
  add_mem' := by intro x y hx hy; simpa using congrArg₂ (· + ·) hx hy
  smul_mem' := by
    intro a v hv
    change PowerSeries.constantCoeff (a * v 1) = 0
    rw [map_mul, hv, mul_zero]

/-- The elementary modification maps the second coordinate to a multiple of
`z` and leaves the first unchanged. -/
noncomputable def adaptedLatticeEmbedding {B : Type*} [CommRing B] :
    (Fin 2 → PowerSeries B) →ₗ[PowerSeries B] (Fin 2 → PowerSeries B) where
  toFun v := ![v 0, PowerSeries.X * v 1]
  map_add' := by intro v w; ext i; fin_cases i <;> simp [mul_add]
  map_smul' := by intro a v; ext i; fin_cases i <;> simp [mul_left_comm]

/-- Membership in the canonical lattice is equivalent to having coordinates
`(u,zv)`; the criterion does not require a field or a domain. -/
theorem mem_adaptedCanonicalLattice_iff {B : Type*} [CommRing B]
    (v : Fin 2 → PowerSeries B) :
    v ∈ adaptedCanonicalLattice ↔ ∃ w, adaptedLatticeEmbedding w = v := by
  constructor
  · intro h
    obtain ⟨w, hw⟩ := PowerSeries.X_dvd_iff.mpr h
    refine ⟨![v 0,w], ?_⟩
    ext i
    fin_cases i <;> simp [adaptedLatticeEmbedding, hw]
  · rintro ⟨w, rfl⟩
    change PowerSeries.constantCoeff (PowerSeries.X * w 1) = 0
    simp

/-- The canonical lattice is the image submodule of the elementary-modification
embedding, so its adapted description is an equality of actual submodules. -/
theorem adaptedCanonicalLattice_eq_range {B : Type*} [CommRing B] :
    adaptedCanonicalLattice (B := B) = LinearMap.range adaptedLatticeEmbedding := by
  ext v
  exact mem_adaptedCanonicalLattice_iff v

/-- Injective coefficient extension both preserves and reflects membership in
the preimage lattice. The extension acts on every power-series coefficient. -/
theorem adaptedCanonicalLattice_mem_map_iff {B C : Type*} [CommRing B] [CommRing C]
    (f : B →+* C) (injective : Function.Injective f) (v : Fin 2 → PowerSeries B) :
    (fun i => PowerSeries.map f (v i)) ∈ adaptedCanonicalLattice ↔
      v ∈ adaptedCanonicalLattice := by
  change PowerSeries.constantCoeff (PowerSeries.map f (v 1)) = 0 ↔
    PowerSeries.constantCoeff (v 1) = 0
  change f (PowerSeries.constantCoeff (v 1)) = 0 ↔ _
  exact ⟨fun h => injective (h.trans (map_zero f).symm), fun h => by rw [h, map_zero]⟩

/-- For an adapted leading nilpotent with unit upper-right entry, its kernel
is precisely the first coordinate line. -/
theorem adaptedLeadingOperator_kernel {B : Type*} [CommRing B]
    {ν : B} (unit : IsUnit ν) (v : Fin 2 → B) :
    (adaptedLeadingOperator ν).mulVec v = 0 ↔ v 1 = 0 := by
  constructor
  · intro h
    have entry := congrArg (fun w : Fin 2 → B => w 0) h
    have product : ν * v 1 = 0 := by simpa [adaptedLeadingOperator, Matrix.mulVec, Matrix.vecHead, Matrix.vecTail] using entry
    exact (unit.mul_right_eq_zero).mp product
  · intro h
    ext i
    fin_cases i <;> simp [adaptedLeadingOperator, Matrix.mulVec, Matrix.vecHead, Matrix.vecTail, h]


/-- The elementary-modification embedding is injective over every coefficient
ring: multiplication by the formal parameter is injective on power series. -/
theorem adaptedLatticeEmbedding_injective {B : Type*} [CommRing B] :
    Function.Injective (adaptedLatticeEmbedding (B := B)) := by
  intro v w h
  have h0 := congrArg (fun u : Fin 2 → PowerSeries B => u 0) h
  have h1 := congrArg (fun u : Fin 2 → PowerSeries B => u 1) h
  change v 0 = w 0 at h0
  change PowerSeries.X * v 1 = PowerSeries.X * w 1 at h1
  have h1' := PowerSeries.X_mul_cancel h1
  funext i
  fin_cases i
  · exact h0
  · exact h1'

/-- The image of the unit adapted leading nilpotent is its kernel line. -/
theorem adaptedLeadingOperator_image {B : Type*} [CommRing B]
    {ν : B} (unit : IsUnit ν) (v : Fin 2 → B) :
    (∃ w, (adaptedLeadingOperator ν).mulVec w = v) ↔ v 1 = 0 := by
  constructor
  · rintro ⟨w, rfl⟩
    simp [adaptedLeadingOperator, Matrix.mulVec]
  · intro h
    rcases unit with ⟨u, rfl⟩
    refine ⟨![0, (↑u⁻¹ : B)*v 0], ?_⟩
    ext i
    fin_cases i <;>
      simp [adaptedLeadingOperator, Matrix.mulVec, Matrix.vecHead, Matrix.vecTail,
        ← mul_assoc, h]

/-- Exact residue discriminants commute with any extension of coefficient rings. -/
theorem residueDiscriminant_coefficient_map {B C : Type*} [CommRing B] [CommRing C]
    (f : B →+* C) (r : Matrix (Fin 2) (Fin 2) B) :
    residueDiscriminant (r.map f) = f (residueDiscriminant r) := by
  norm_num [residueDiscriminant, Matrix.trace_fin_two, Matrix.det_fin_two, Matrix.map_apply, map_ofNat]

/-- Elementary-modification residues commute with coefficient extension, acting
entrywise on every coefficient of the original matrix power series. -/
theorem modifiedResidue_coefficient_map {B C : Type*} [CommRing B] [CommRing C]
    (f : B →+* C) (loop : PowerSeries (Matrix (Fin 2) (Fin 2) B)) :
    modifiedResidue (PowerSeries.map (f.mapMatrix : Matrix (Fin 2) (Fin 2) B →+*
      Matrix (Fin 2) (Fin 2) C) loop) = (modifiedResidue loop).map f := by
  rw [modifiedResidue_eq, modifiedResidue_eq]
  ext row column
  fin_cases row <;> fin_cases column <;> simp


/-- The usual action of a formal rank-two matrix series on a vector of two
power series, with each matrix entry extracted coefficientwise. -/
noncomputable def formalRankTwoMatrixAction {B : Type*} [CommRing B]
    (comparison : PowerSeries (Matrix (Fin 2) (Fin 2) B))
    (v : Fin 2 → PowerSeries B) : Fin 2 → PowerSeries B :=
  fun row => ∑ column : Fin 2,
    (PowerSeries.mk fun n => PowerSeries.coeff n comparison row column) * v column

/-- A regular horizontal comparison of adapted connections preserves the actual
preimage lattice. The leading-line preservation is derived from horizontality. -/
theorem horizontalComparison_preserves_adaptedCanonicalLattice
    {B : Type*} [CommRing B]
    {source target comparison : PowerSeries (Matrix (Fin 2) (Fin 2) B)}
    {sourceUnit targetUnit : B}
    (horizontal : IsHorizontalLoopComparison source target comparison)
    (sourceAdapted : PowerSeries.coeff 0 source = adaptedLeadingOperator sourceUnit)
    (targetAdapted : PowerSeries.coeff 0 target = adaptedLeadingOperator targetUnit)
    (targetInvertible : IsUnit targetUnit)
    (v : Fin 2 → PowerSeries B) (hv : v ∈ adaptedCanonicalLattice) :
    formalRankTwoMatrixAction comparison v ∈ adaptedCanonicalLattice := by
  have line := horizontal.preserves_nilpotentLine sourceAdapted targetAdapted targetInvertible
  change PowerSeries.constantCoeff (v 1) = 0 at hv
  change PowerSeries.constantCoeff (formalRankTwoMatrixAction comparison v 1) = 0
  simp only [formalRankTwoMatrixAction, Fin.sum_univ_two, map_add, map_mul]
  change PowerSeries.coeff 0 comparison 1 0 * PowerSeries.constantCoeff (v 0) +
    PowerSeries.coeff 0 comparison 1 1 * PowerSeries.constantCoeff (v 1) = 0
  rw [line, hv, zero_mul, mul_zero, add_zero]

end TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum
