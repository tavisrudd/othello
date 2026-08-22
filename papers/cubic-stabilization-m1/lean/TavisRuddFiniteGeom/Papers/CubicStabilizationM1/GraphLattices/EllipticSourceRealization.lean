import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.GraphLattices.SquareZeroTransport

/-!
# Exterior realization of elliptic-power coefficient forms

For a finite set of elliptic-power axes, this module models the first
cohomology as two coordinate copies and sends a coefficient matrix to the
corresponding mixed exterior two-form.  A rank-one symmetric coefficient
matrix becomes a decomposable two-form, giving the source square-zero fact
used in the manuscript.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationM1

namespace GraphLattices

/-- Two coordinate copies of the axis module, modelling the two generators
of first cohomology on each elliptic factor. -/
abbrev EllipticSourceHOne (R Index : Type*) :=
  (Index → R) × (Index → R)

/-- Linear inclusion into the first coordinate copy. -/
def ellipticSourceXLinear
    {R Index : Type*} [Semiring R] :
    (Index → R) →ₗ[R] EllipticSourceHOne R Index where
  toFun vector := (vector, 0)
  map_add' := by simp
  map_smul' := by simp

/-- The first coordinate copy of an axis vector. -/
def ellipticSourceX
    {R Index : Type*} [Semiring R] (vector : Index → R) :
    EllipticSourceHOne R Index :=
  ellipticSourceXLinear vector

/-- Linear inclusion into the second coordinate copy. -/
def ellipticSourceYLinear
    {R Index : Type*} [Semiring R] :
    (Index → R) →ₗ[R] EllipticSourceHOne R Index where
  toFun vector := (0, vector)
  map_add' := by simp
  map_smul' := by simp

/-- The second coordinate copy of an axis vector. -/
def ellipticSourceY
    {R Index : Type*} [Semiring R] (vector : Index → R) :
    EllipticSourceHOne R Index :=
  ellipticSourceYLinear vector

/-- The coordinate vector supported on one elliptic-power axis. -/
def axisBasisVector
    {R Index : Type*} [Zero R] [One R] [DecidableEq Index]
    (index : Index) : Index → R :=
  Pi.single index 1

/-- Mixed exterior two-form realization of a coefficient matrix. -/
noncomputable def ellipticSourceCoefficientRealization
    {R Index : Type*} [CommRing R] [Fintype Index] [DecidableEq Index] :
    Matrix Index Index R →+ ExteriorAlgebra R (EllipticSourceHOne R Index) where
  toFun coefficient :=
    ∑ first, ∑ second, coefficient first second •
      (ExteriorAlgebra.ι R (ellipticSourceX (axisBasisVector first)) *
        ExteriorAlgebra.ι R (ellipticSourceY (axisBasisVector second)))
  map_zero' := by simp
  map_add' := by
    intro left right
    simp only [Matrix.add_apply, add_smul, Finset.sum_add_distrib]

/-- Every axis vector is the finite coordinate sum against the standard
basis. -/
theorem sum_axisBasisVector
    {R Index : Type*} [CommRing R] [Fintype Index] [DecidableEq Index]
    (vector : Index → R) :
    (∑ index, vector index • axisBasisVector index) = vector := by
  classical
  ext position
  simp [axisBasisVector, Pi.single_apply]

/-- The coefficient realization of a rank-one symmetric matrix is literally
a decomposable mixed two-form. -/
theorem ellipticSourceCoefficientRealization_matrixRankOne
    {R Index : Type*} [CommRing R] [Fintype Index] [DecidableEq Index]
    (coefficient : R) (vector : Index → R) :
    ellipticSourceCoefficientRealization
        (matrixRankOne coefficient vector) =
      ExteriorAlgebra.ι R (ellipticSourceX (coefficient • vector)) *
        ExteriorAlgebra.ι R (ellipticSourceY vector) := by
  have xExpansion :
      ellipticSourceX (coefficient • vector) =
        ∑ index, (coefficient * vector index) •
          ellipticSourceX (axisBasisVector index) := by
    calc
      ellipticSourceX (coefficient • vector) =
          ellipticSourceX
            (∑ index, (coefficient * vector index) • axisBasisVector index) := by
        congr 1
        simpa only [Pi.smul_apply, smul_eq_mul] using
          (sum_axisBasisVector (coefficient • vector)).symm
      _ = ∑ index, (coefficient * vector index) •
          ellipticSourceX (axisBasisVector index) := by
        simp only [ellipticSourceX, map_sum, map_smul]
  have yExpansion :
      ellipticSourceY vector =
        ∑ index, vector index • ellipticSourceY (axisBasisVector index) := by
    calc
      ellipticSourceY vector =
          ellipticSourceY (∑ index, vector index • axisBasisVector index) := by
        rw [sum_axisBasisVector]
      _ = ∑ index, vector index • ellipticSourceY (axisBasisVector index) := by
        simp only [ellipticSourceY, map_sum, map_smul]
  rw [xExpansion, yExpansion, map_sum, map_sum]
  simp_rw [map_smul]
  simp only [ellipticSourceCoefficientRealization, AddMonoidHom.coe_mk,
    ZeroHom.coe_mk, matrixRankOne, Finset.sum_mul, Finset.mul_sum]
  simp_rw [Algebra.smul_mul_assoc, Algebra.mul_smul_comm]
  simp only [smul_smul, mul_assoc]
  rw [Finset.sum_comm]

/-- Every rank-one coefficient matrix has square-zero image in the canonical
elliptic-source exterior realization. -/
theorem ellipticSourceCoefficientRealization_rankOne_sq_zero
    {R Index : Type*} [CommRing R] [Fintype Index] [DecidableEq Index]
    (coefficient : R) (vector : Index → R) :
    ellipticSourceCoefficientRealization
        (matrixRankOne coefficient vector) *
      ellipticSourceCoefficientRealization
        (matrixRankOne coefficient vector) = 0 := by
  rw [ellipticSourceCoefficientRealization_matrixRankOne,
    ← pow_two]
  exact exterior_decomposableTwoForm_sq_zero
    (ellipticSourceX (coefficient • vector)) (ellipticSourceY vector)

/-- The canonical source realization satisfies the square-zero hypothesis on
the full internal rank-one set of any weighted matrix lattice. -/
theorem ellipticSourceCoefficientRealization_internalRankOne_sq_zero
    {R Index : Type*} [CommRing R] [Fintype Index] [DecidableEq Index]
    (uniformizer : R) (diagonal : Index → ℕ) (cross : Index → Index → ℕ) :
    ∀ candidate,
      candidate ∈ weightedRankOneSet uniformizer diagonal cross →
        ellipticSourceCoefficientRealization candidate *
          ellipticSourceCoefficientRealization candidate = 0 := by
  rintro candidate ⟨coefficient, vector, rfl, _⟩
  exact ellipticSourceCoefficientRealization_rankOne_sq_zero coefficient vector

end GraphLattices

end TavisRuddFiniteGeom.Papers.CubicStabilizationM1
