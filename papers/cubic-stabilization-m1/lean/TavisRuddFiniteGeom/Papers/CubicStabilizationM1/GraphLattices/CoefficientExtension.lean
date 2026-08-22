import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.GraphLattices.MatrixOfIdeals

/-!
# Coefficient extension for weighted graph lattices

This module formalizes the entrywise passage from a base coefficient ring to
an extension ring.  In particular, it proves that weighted-lattice membership
and rank-one coefficient matrices are preserved under the ring map.  It does
not claim that rank-one generation descends or ascends.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationM1

namespace GraphLattices

variable {Index R S : Type*} [CommRing R] [CommRing S] [Algebra R S]

/-- Entrywise coefficient extension of a matrix, as an `R`-linear map. -/
def matrixCoefficientExtension :
    Matrix Index Index R →ₗ[R] Matrix Index Index S where
  toFun form row column := algebraMap R S (form row column)
  map_add' := by
    intro left right
    ext row column
    simp
  map_smul' := by
    intro scalar form
    ext row column
    simp [Algebra.smul_def]

/-- Coefficient extension commutes exactly with the rank-one matrix
construction. -/
theorem matrixCoefficientExtension_matrixRankOne
    (coefficient : R) (vector : Index → R) :
    matrixCoefficientExtension (matrixRankOne coefficient vector) =
      matrixRankOne (algebraMap R S coefficient)
        (fun index ↦ algebraMap R S (vector index)) := by
  ext row column
  simp [matrixCoefficientExtension, matrixRankOne]

/-- Entrywise coefficient extension sends the base weighted lattice into the
weighted lattice with mapped uniformizer and unchanged depth data. -/
theorem matrixCoefficientExtension_mem_weightedMatrix
    (uniformizer : R) (diagonal : Index → ℕ) (cross : Index → Index → ℕ)
    (form : Matrix Index Index R)
    (member : MemWeightedMatrix uniformizer diagonal cross form) :
    MemWeightedMatrix (algebraMap R S uniformizer) diagonal cross
      (matrixCoefficientExtension form) := by
  rcases member with ⟨symmetric, diagonalMember, crossMember⟩
  constructor
  · ext row column
    change algebraMap R S (form column row) = algebraMap R S (form row column)
    rw [show form column row = form row column by
      simpa [Matrix.IsSymm, Matrix.transpose_apply] using
        congrFun (congrFun symmetric row) column]
  constructor
  · intro index
    rcases diagonalMember index with ⟨coefficient, equality⟩
    refine ⟨algebraMap R S coefficient, ?_⟩
    simp only [matrixCoefficientExtension, LinearMap.coe_mk,
      AddHom.coe_mk, equality, map_mul, map_pow]
  · intro row column distinct
    rcases crossMember row column distinct with ⟨coefficient, equality⟩
    refine ⟨algebraMap R S coefficient, ?_⟩
    simp only [matrixCoefficientExtension, LinearMap.coe_mk,
      AddHom.coe_mk, equality, map_mul, map_pow]

/-- Submodule formulation of preservation of weighted-lattice membership. -/
theorem matrixCoefficientExtension_mem_weightedMatrixSubmodule
    (uniformizer : R) (diagonal : Index → ℕ) (cross : Index → Index → ℕ)
    (form : Matrix Index Index R)
    (member : form ∈ weightedMatrixSubmodule uniformizer diagonal cross) :
    matrixCoefficientExtension form ∈
      weightedMatrixSubmodule (algebraMap R S uniformizer) diagonal cross :=
  matrixCoefficientExtension_mem_weightedMatrix
    uniformizer diagonal cross form member

/-- An internal rank-one base matrix remains an internal rank-one matrix in
the extended weighted lattice. -/
theorem matrixCoefficientExtension_mem_weightedRankOneSet
    (uniformizer : R) (diagonal : Index → ℕ) (cross : Index → Index → ℕ)
    (form : Matrix Index Index R)
    (member : form ∈ weightedRankOneSet uniformizer diagonal cross) :
    matrixCoefficientExtension form ∈
      weightedRankOneSet (algebraMap R S uniformizer) diagonal cross := by
  rcases member with ⟨coefficient, vector, rfl, latticeMember⟩
  refine ⟨algebraMap R S coefficient,
    (fun index ↦ algebraMap R S (vector index)),
    matrixCoefficientExtension_matrixRankOne coefficient vector, ?_⟩
  exact matrixCoefficientExtension_mem_weightedMatrix
    uniformizer diagonal cross (matrixRankOne coefficient vector) latticeMember

end GraphLattices

end TavisRuddFiniteGeom.Papers.CubicStabilizationM1
