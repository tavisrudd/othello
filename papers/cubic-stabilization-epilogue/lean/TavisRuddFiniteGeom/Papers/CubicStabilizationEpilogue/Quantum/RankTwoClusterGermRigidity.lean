import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.Quantum.ResidueDiscriminantInvariance
import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.Quantum.LowDimensionalVanishingCore

/-!
# Rigidity of an isolated rank-two cluster over a formal germ

An even quantum connection restricted to an isolated rank-two spectral cluster
is modelled here by matrix data over a coefficient ring: a leading operator
`eigenvalue • 1 + nilpotent` with `trace nilpotent = 0`, a grading operator, a
connection form recording the covariant derivative of the cluster in a chosen
frame, and, for each base direction, the compression to the cluster of quantum
multiplication by the corresponding tangent vector.  The two flatness identities
of the manuscript enter as hypotheses in that language: the compressed quantum
multiplication commutes with the leading operator, and the covariant derivative
of the leading operator is the compressed multiplication plus its commutator
with the grading operator.

Four steps are proved.

The commutant of a two-by-two matrix whose upper-right entry is a unit consists
of the scalar multiples of the identity and of the matrix itself.  This is the
regularity step: it identifies the compressed quantum multiplication as
`scalar • 1 + multiple • nilpotent` without choosing a Jordan form, using only
invertibility of one off-diagonal entry.

Taking traces in the flatness identity then identifies the scalar with the
derivative of the eigenvalue, so the nilpotent part evolves by
`multiple • nilpotent + multiple • [nilpotent, grading]`.  This uses
cancellability of `2` in the coefficient ring, which is supplied as a hypothesis
and holds in the formal-germ model below.

Jacobi's formula in rank two, `∂ det M = trace M * trace (∂ M) - trace (M ∂M)`,
turns that evolution into the logarithmic equation `∂ d = 2 * multiple * d` for
`d = det nilpotent`, because the commutator terms have vanishing trace against
`nilpotent`.  Over a formal power-series germ in characteristic zero a series
satisfying such an equation and vanishing at the closed point vanishes
identically, so `det nilpotent = 0`; with vanishing trace, Cayley-Hamilton in
rank two gives `nilpotent * nilpotent = 0`, and the unit entry keeps it nonzero.
The cluster therefore stays a single nonzero Jordan block over the whole germ.

The same trace calculus applied to the residue of the canonical elementary
modification, whose base derivatives are commutators by modified flatness, shows
that its trace and determinant are constant series, hence that its
characteristic polynomial has constant coefficients over the germ.  The last
statement of the module transports that constancy to the primitive-sixth count:
two blocks whose exponents have the same monic split characteristic polynomial
have the same framed primitive-sixth multiplicity, because the exponent multiset
is recovered from that polynomial as its root multiset.

Lean models the germ by a multivariate formal power-series ring and represents
every operator by a matrix over it.  It constructs no quantum connection, Euler
operator, spectral projector, elementary modification, or Levelt--Turrittin
solution algebra, and does not prove that the compression of a connection to an
isolated spectral cluster satisfies the displayed identities.  The passage from
residue eigenvalues to the exponents of framed monodromy is likewise not
formalized: the final statement takes the exponent multiset of a block as given
data.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue

namespace Quantum

open Matrix MvPowerSeries

section Commutant

variable {A : Type*} [CommRing A]

/-- The commutant of a two-by-two matrix with invertible upper-right entry.  Any
matrix commuting with `nilpotent` is a scalar multiple of the identity plus a
multiple of `nilpotent`; the coefficients are read off from the upper row.  No
nilpotency is used, only invertibility of the entry in position `(0, 1)`. -/
theorem rankTwo_commutant_of_unit_offDiagonal
    {nilpotent commuting : Matrix (Fin 2) (Fin 2) A}
    (unitEntry : IsUnit (nilpotent 0 1))
    (commutes : commuting * nilpotent = nilpotent * commuting) :
    ∃ scalar multiple : A,
      commuting = scalar • (1 : Matrix (Fin 2) (Fin 2) A) + multiple • nilpotent := by
  obtain ⟨inverse, inverseEquation⟩ := unitEntry.exists_right_inv
  refine ⟨commuting 0 0 - commuting 0 1 * inverse * nilpotent 0 0,
    commuting 0 1 * inverse, ?_⟩
  have upperLeft :
      commuting 0 0 * nilpotent 0 0 + commuting 0 1 * nilpotent 1 0
        = nilpotent 0 0 * commuting 0 0 + nilpotent 0 1 * commuting 1 0 := by
    simpa [Matrix.mul_apply, Fin.sum_univ_two] using congrFun (congrFun commutes 0) 0
  have upperRight :
      commuting 0 0 * nilpotent 0 1 + commuting 0 1 * nilpotent 1 1
        = nilpotent 0 0 * commuting 0 1 + nilpotent 0 1 * commuting 1 1 := by
    simpa [Matrix.mul_apply, Fin.sum_univ_two] using congrFun (congrFun commutes 0) 1
  ext row column
  fin_cases row <;> fin_cases column <;>
    simp [Matrix.add_apply, Matrix.smul_apply, smul_eq_mul]
  · linear_combination (-(commuting 0 1)) * inverseEquation
  · linear_combination (-inverse) * upperLeft - commuting 1 0 * inverseEquation
  · linear_combination (-inverse) * upperRight +
      (commuting 0 0 - commuting 1 1) * inverseEquation

end Commutant

section TraceCalculus

variable {A : Type*} [CommRing A]

/-- The trace of a matrix against a commutator with it vanishes in rank two: the
two cyclic rearrangements of `M * P * M` and `M * M * P` have the same trace. -/
theorem trace_mul_commutator_self_eq_zero (M P : Matrix (Fin 2) (Fin 2) A) :
    trace (M * (P * M - M * P)) = 0 := by
  rw [Matrix.mul_sub, Matrix.trace_sub, sub_eq_zero, ← Matrix.mul_assoc,
    Matrix.trace_mul_comm (M * P) M]

/-- The same vanishing with the commutator written in the opposite order. -/
theorem trace_mul_commutator_self_reverse_eq_zero (M P : Matrix (Fin 2) (Fin 2) A) :
    trace (M * (M * P - P * M)) = 0 := by
  have opposite : M * (M * P - P * M) = -(M * (P * M - M * P)) := by
    rw [← Matrix.mul_neg, neg_sub]
  rw [opposite, Matrix.trace_neg, trace_mul_commutator_self_eq_zero, neg_zero]

/-- The trace of the square of a two-by-two matrix in terms of its trace and
determinant. -/
theorem trace_mul_self_fin_two (M : Matrix (Fin 2) (Fin 2) A) :
    trace (M * M) = (trace M) ^ 2 - 2 * M.det := by
  simp [Matrix.trace_fin_two, Matrix.det_fin_two, Matrix.mul_apply, Fin.sum_univ_two]
  ring

/-- Jacobi's formula in rank two.  For an entrywise derivation of the coefficient
ring, the derivative of the determinant is the trace of the adjugate against the
derivative of the matrix, and in rank two the adjugate is
`trace M • 1 - M`. -/
theorem det_map_of_derivation {derivation : A → A}
    (additive : ∀ x y, derivation (x + y) = derivation x + derivation y)
    (leibniz : ∀ x y, derivation (x * y) = derivation x * y + x * derivation y)
    (M : Matrix (Fin 2) (Fin 2) A) :
    derivation M.det
      = trace M * trace (M.map derivation) - trace (M * M.map derivation) := by
  rw [Matrix.det_fin_two, map_sub_of_additive additive, leibniz, leibniz]
  simp [Matrix.trace_fin_two, Matrix.mul_apply, Fin.sum_univ_two]
  ring

/-- A matrix family whose derivative is a commutator with a further matrix has
constant trace: the trace of a commutator vanishes. -/
theorem trace_map_eq_zero_of_commutator {derivation : A → A}
    (additive : ∀ x y, derivation (x + y) = derivation x + derivation y)
    (residue regular : Matrix (Fin 2) (Fin 2) A)
    (lax : residue.map derivation = regular * residue - residue * regular) :
    derivation (trace residue) = 0 := by
  rw [trace_map_of_additive additive residue, lax, Matrix.trace_sub,
    Matrix.trace_mul_comm regular residue, sub_self]

/-- A matrix family whose derivative is a commutator with a further matrix has
constant determinant.  Both terms of Jacobi's formula vanish: the trace of a
commutator is zero, and so is the trace of the matrix against its own
commutator. -/
theorem det_map_eq_zero_of_commutator {derivation : A → A}
    (additive : ∀ x y, derivation (x + y) = derivation x + derivation y)
    (leibniz : ∀ x y, derivation (x * y) = derivation x * y + x * derivation y)
    (residue regular : Matrix (Fin 2) (Fin 2) A)
    (lax : residue.map derivation = regular * residue - residue * regular) :
    derivation residue.det = 0 := by
  rw [det_map_of_derivation additive leibniz, lax, Matrix.trace_sub,
    Matrix.trace_mul_comm regular residue, sub_self,
    trace_mul_commutator_self_eq_zero residue regular, mul_zero, sub_zero]

/-- A two-by-two matrix with vanishing trace and determinant is square-zero: this
is the Cayley-Hamilton identity in rank two with both coefficients removed. -/
theorem sq_eq_zero_of_trace_det_eq_zero {M : Matrix (Fin 2) (Fin 2) A}
    (traceZero : trace M = 0) (determinantZero : M.det = 0) : M * M = 0 := by
  have diagonal : M 0 0 + M 1 1 = 0 := by simpa [Matrix.trace_fin_two] using traceZero
  have determinant : M 0 0 * M 1 1 - M 0 1 * M 1 0 = 0 := by
    simpa [Matrix.det_fin_two] using determinantZero
  ext row column
  fin_cases row <;> fin_cases column <;>
    simp [Matrix.mul_apply, Fin.sum_univ_two]
  · linear_combination (M 0 0) * diagonal - determinant
  · linear_combination (M 0 1) * diagonal
  · linear_combination (M 1 0) * diagonal
  · linear_combination (M 1 1) * diagonal - determinant

end TraceCalculus

section ClusterEvolution

variable {A : Type*} [CommRing A]

/-- Entrywise application of an additive map commutes with matrix addition. -/
theorem matrix_map_add_of_additive {derivation : A → A}
    (additive : ∀ x y, derivation (x + y) = derivation x + derivation y)
    (M N : Matrix (Fin 2) (Fin 2) A) :
    (M + N).map derivation = M.map derivation + N.map derivation := by
  ext row column
  simp [additive]

/-- Entrywise application of an additive map to a scalar matrix. -/
theorem matrix_map_smul_one_of_additive {derivation : A → A}
    (additive : ∀ x y, derivation (x + y) = derivation x + derivation y) (value : A) :
    (value • (1 : Matrix (Fin 2) (Fin 2) A)).map derivation
      = derivation value • (1 : Matrix (Fin 2) (Fin 2) A) := by
  have zero := map_zero_of_additive additive
  ext row column
  by_cases equal : row = column
  · subst equal; simp
  · simp [Matrix.one_apply_ne equal, zero]

/-- Evolution of the nilpotent part of an isolated rank-two cluster.  The
hypotheses are the compressed flatness identities of the manuscript: the
compressed quantum multiplication `compressed` commutes with the leading
operator, and the covariant derivative of the leading operator
`eigenvalue • 1 + nilpotent` in the frame recorded by `connection` equals
`compressed` plus its commutator with the grading operator.  The conclusion is
that the nilpotent part evolves by a multiple of itself plus the same multiple of
its commutator with the grading operator; the scalar part of the compressed
multiplication is absorbed by the derivative of the eigenvalue. -/
theorem nilpotentCluster_evolution_of_flatness
    {derivation : A → A}
    (additive : ∀ x y, derivation (x + y) = derivation x + derivation y)
    (twoCancel : ∀ x y : A, 2 * x = 2 * y → x = y)
    {eigenvalue : A} {nilpotent grading connection compressed : Matrix (Fin 2) (Fin 2) A}
    (traceless : trace nilpotent = 0)
    (unitEntry : IsUnit (nilpotent 0 1))
    (commutes : compressed * nilpotent = nilpotent * compressed)
    (flatness :
      (eigenvalue • (1 : Matrix (Fin 2) (Fin 2) A) + nilpotent).map derivation
          + connection * (eigenvalue • (1 : Matrix (Fin 2) (Fin 2) A) + nilpotent)
          - (eigenvalue • (1 : Matrix (Fin 2) (Fin 2) A) + nilpotent) * connection
        = compressed + (compressed * grading - grading * compressed)) :
    ∃ multiple : A,
      nilpotent.map derivation + connection * nilpotent - nilpotent * connection
        = multiple • nilpotent + multiple • (nilpotent * grading - grading * nilpotent) := by
  obtain ⟨scalar, multiple, decomposition⟩ :=
    rankTwo_commutant_of_unit_offDiagonal unitEntry commutes
  refine ⟨multiple, ?_⟩
  set derived :=
    nilpotent.map derivation + connection * nilpotent - nilpotent * connection with derivedEquation
  set evolved :=
    multiple • nilpotent + multiple • (nilpotent * grading - grading * nilpotent) with
    evolvedEquation
  have leftSide :
      (eigenvalue • (1 : Matrix (Fin 2) (Fin 2) A) + nilpotent).map derivation
          + connection * (eigenvalue • (1 : Matrix (Fin 2) (Fin 2) A) + nilpotent)
          - (eigenvalue • (1 : Matrix (Fin 2) (Fin 2) A) + nilpotent) * connection
        = derivation eigenvalue • (1 : Matrix (Fin 2) (Fin 2) A) + derived := by
    rw [matrix_map_add_of_additive additive, matrix_map_smul_one_of_additive additive,
      derivedEquation]
    simp [Matrix.mul_add, Matrix.add_mul]
    abel
  have rightSide :
      compressed + (compressed * grading - grading * compressed)
        = scalar • (1 : Matrix (Fin 2) (Fin 2) A) + evolved := by
    rw [decomposition, evolvedEquation]
    simp [Matrix.add_mul, Matrix.mul_add, smul_sub]
    abel
  have combined :
      derivation eigenvalue • (1 : Matrix (Fin 2) (Fin 2) A) + derived
        = scalar • (1 : Matrix (Fin 2) (Fin 2) A) + evolved := by
    rw [← leftSide, ← rightSide]; exact flatness
  have traceDerived : trace derived = 0 := by
    rw [derivedEquation, Matrix.trace_sub, Matrix.trace_add,
      ← trace_map_of_additive additive nilpotent, traceless, map_zero_of_additive additive,
      Matrix.trace_mul_comm connection nilpotent, zero_add, sub_self]
  have traceEvolved : trace evolved = 0 := by
    rw [evolvedEquation, Matrix.trace_add, Matrix.trace_smul, Matrix.trace_smul, traceless,
      Matrix.trace_sub, Matrix.trace_mul_comm nilpotent grading, sub_self]
    simp
  have scalarEquation : scalar = derivation eigenvalue := by
    have traced := congrArg trace combined
    rw [Matrix.trace_add, Matrix.trace_add, Matrix.trace_smul, Matrix.trace_smul,
      Matrix.trace_one, Fintype.card_fin, traceDerived, traceEvolved] at traced
    refine twoCancel scalar (derivation eigenvalue) ?_
    simp only [smul_eq_mul, add_zero] at traced
    linear_combination -traced
  rw [scalarEquation] at combined
  exact add_left_cancel combined

end ClusterEvolution

section FormalGerm

variable {σ : Type*} [DecidableEq σ] {K : Type*} [Field K] [CharZero K]

omit [DecidableEq σ] in
/-- Cancellation of `2` in a multivariate formal power-series ring over a field
of characteristic zero, verified coefficient by coefficient. -/
theorem two_mul_cancel_mvPowerSeries {x y : MvPowerSeries σ K} (equation : 2 * x = 2 * y) :
    x = y := by
  ext d
  have doubled : x + x = y + y := by rw [← two_mul, ← two_mul]; exact equation
  have coefficient := congrArg (coeff d) doubled
  rw [map_add, map_add] at coefficient
  have scaled : (2 : K) * coeff d x = 2 * coeff d y := by
    rw [two_mul, two_mul]; exact coefficient
  exact mul_left_cancel₀ (by norm_num : (2 : K) ≠ 0) scaled

/-- The nilpotent part of an isolated rank-two cluster stays square-zero over the
formal germ.  Jacobi's formula turns the evolution equation into a logarithmic
equation for the determinant, whose vanishing at the closed point then forces it
to vanish identically; with vanishing trace, Cayley-Hamilton gives the square-zero
identity. -/
theorem nilpotentCluster_sq_eq_zero_of_germ_evolution
    {nilpotent grading : Matrix (Fin 2) (Fin 2) (MvPowerSeries σ K)}
    {connection : σ → Matrix (Fin 2) (Fin 2) (MvPowerSeries σ K)}
    {multiple : σ → MvPowerSeries σ K}
    (traceless : trace nilpotent = 0)
    (nilpotentAtClosedPoint : coeff 0 nilpotent.det = 0)
    (evolution : ∀ i, nilpotent.map (formalPartialDerivative i)
        + connection i * nilpotent - nilpotent * connection i
      = multiple i • nilpotent + multiple i • (nilpotent * grading - grading * nilpotent)) :
    nilpotent * nilpotent = 0 := by
  have determinantZero : nilpotent.det = 0 := by
    refine eq_zero_of_constantCoeff_eq_zero_of_logarithmic (ω := fun i => 2 * multiple i)
      nilpotentAtClosedPoint ?_
    intro i
    have derivativeEquation : nilpotent.map (formalPartialDerivative i)
        = multiple i • nilpotent + multiple i • (nilpotent * grading - grading * nilpotent)
          - (connection i * nilpotent - nilpotent * connection i) := by
      rw [← evolution i]; abel
    rw [det_map_of_derivation (derivation := formalPartialDerivative i)
        (formalPartialDerivative_add i) (formalPartialDerivative_mul i) nilpotent,
      traceless, zero_mul, zero_sub, derivativeEquation]
    have expansion :
        nilpotent * (multiple i • nilpotent
              + multiple i • (nilpotent * grading - grading * nilpotent)
            - (connection i * nilpotent - nilpotent * connection i))
          = multiple i • (nilpotent * nilpotent)
            + multiple i • (nilpotent * (nilpotent * grading - grading * nilpotent))
            - nilpotent * (connection i * nilpotent - nilpotent * connection i) := by
      simp [Matrix.mul_add, Matrix.mul_sub]
    rw [expansion, Matrix.trace_sub, Matrix.trace_add, Matrix.trace_smul, Matrix.trace_smul,
      trace_mul_commutator_self_reverse_eq_zero nilpotent grading,
      trace_mul_commutator_self_eq_zero nilpotent (connection i),
      trace_mul_self_fin_two, traceless]
    simp only [smul_eq_mul]
    ring
  exact sq_eq_zero_of_trace_det_eq_zero traceless determinantZero

/-- A two-by-two matrix with an invertible entry is nonzero. -/
theorem ne_zero_of_unit_entry {A : Type*} [CommRing A] [Nontrivial A]
    {M : Matrix (Fin 2) (Fin 2) A} (unitEntry : IsUnit (M 0 1)) : M ≠ 0 := by
  intro vanishing
  rw [vanishing] at unitEntry
  simp at unitEntry

/-- Formal-germ rigidity of an isolated rank-two cluster.  Over a formal
power-series germ in characteristic zero, a cluster whose leading operator is
`eigenvalue • 1 + nilpotent` with traceless nilpotent part, whose nilpotent part
has an invertible upper-right entry and vanishing determinant at the closed
point, and whose compressed quantum multiplications commute with the leading
operator and satisfy the compressed flatness identity, keeps a square-zero
nonzero nilpotent part throughout the germ.  That is the matrix form of the
statement that the cluster remains a single nonzero Jordan block. -/
theorem rankTwoCluster_nilpotent_persists_on_germ
    {eigenvalue : MvPowerSeries σ K}
    {nilpotent grading : Matrix (Fin 2) (Fin 2) (MvPowerSeries σ K)}
    {connection compressed : σ → Matrix (Fin 2) (Fin 2) (MvPowerSeries σ K)}
    (traceless : trace nilpotent = 0)
    (unitEntry : IsUnit (nilpotent 0 1))
    (nilpotentAtClosedPoint : coeff 0 nilpotent.det = 0)
    (commutes : ∀ i, compressed i * nilpotent = nilpotent * compressed i)
    (flatness : ∀ i,
      (eigenvalue • (1 : Matrix (Fin 2) (Fin 2) (MvPowerSeries σ K)) + nilpotent).map
            (formalPartialDerivative i)
          + connection i * (eigenvalue • 1 + nilpotent)
          - (eigenvalue • 1 + nilpotent) * connection i
        = compressed i + (compressed i * grading - grading * compressed i)) :
    nilpotent * nilpotent = 0 ∧ nilpotent ≠ 0 := by
  choose multiple evolution using fun i =>
    nilpotentCluster_evolution_of_flatness (formalPartialDerivative_add i)
      (fun _ _ => two_mul_cancel_mvPowerSeries) traceless unitEntry (commutes i) (flatness i)
  exact ⟨nilpotentCluster_sq_eq_zero_of_germ_evolution (multiple := multiple) traceless
      nilpotentAtClosedPoint evolution,
    ne_zero_of_unit_entry unitEntry⟩

/-- The residue of the canonical elementary modification has constant trace and
determinant over the formal germ.  The hypothesis is modified flatness in each
base direction: the derivative of the residue is its commutator with a matrix
regular in the germ. -/
theorem residue_trace_det_constant_of_lax
    {residue : Matrix (Fin 2) (Fin 2) (MvPowerSeries σ K)}
    {regular : σ → Matrix (Fin 2) (Fin 2) (MvPowerSeries σ K)}
    (lax : ∀ i, residue.map (formalPartialDerivative i)
      = regular i * residue - residue * regular i) :
    trace residue = MvPowerSeries.C (MvPowerSeries.constantCoeff (trace residue)) ∧
      residue.det = MvPowerSeries.C (MvPowerSeries.constantCoeff residue.det) := by
  constructor
  · exact eq_constant_of_formalPartialDerivative_eq_zero fun i =>
      trace_map_eq_zero_of_commutator (formalPartialDerivative_add i) residue (regular i) (lax i)
  · exact eq_constant_of_formalPartialDerivative_eq_zero fun i =>
      det_map_eq_zero_of_commutator (formalPartialDerivative_add i)
        (formalPartialDerivative_mul i) residue (regular i) (lax i)

/-- The characteristic polynomial of the residue has constant coefficients over
the formal germ.  In rank two those coefficients are the trace and the
determinant, both constant by modified flatness, so the polynomial is the one
attached to two scalars of the coefficient field. -/
theorem residue_charpoly_constant_of_lax
    {residue : Matrix (Fin 2) (Fin 2) (MvPowerSeries σ K)}
    {regular : σ → Matrix (Fin 2) (Fin 2) (MvPowerSeries σ K)}
    (lax : ∀ i, residue.map (formalPartialDerivative i)
      = regular i * residue - residue * regular i) :
    ∃ traceValue determinantValue : K,
      residue.charpoly = Polynomial.X ^ 2
          - Polynomial.C (MvPowerSeries.C traceValue) * Polynomial.X
        + Polynomial.C (MvPowerSeries.C determinantValue) := by
  obtain ⟨traceConstant, determinantConstant⟩ := residue_trace_det_constant_of_lax lax
  refine ⟨MvPowerSeries.constantCoeff (trace residue),
    MvPowerSeries.constantCoeff residue.det, ?_⟩
  rw [Matrix.charpoly_fin_two, ← traceConstant, ← determinantConstant]

end FormalGerm

section ExponentTransport

/-- The framed monodromy eigenvalue attached to a formal exponent by one turn of
the unramified loop coordinate. -/
noncomputable def framedEigenvalue (exponent : ℂ) : ℂ :=
  Complex.exp (2 * (Real.pi : ℂ) * Complex.I * exponent)

/-- The monic split polynomial with a given multiset of roots. -/
noncomputable def splitMonicPolynomial (roots : Multiset ℂ) : Polynomial ℂ :=
  (roots.map fun value => Polynomial.X - Polynomial.C value).prod

/-- The polynomial attached to a multiset of roots is monic. -/
theorem splitMonicPolynomial_monic (roots : Multiset ℂ) :
    (splitMonicPolynomial roots).Monic :=
  Polynomial.monic_multiset_prod_of_monic _ _ fun value _ => Polynomial.monic_X_sub_C value

/-- The polynomial attached to a multiset of roots is nonzero. -/
theorem splitMonicPolynomial_ne_zero (roots : Multiset ℂ) :
    splitMonicPolynomial roots ≠ 0 :=
  (splitMonicPolynomial_monic roots).ne_zero

/-- Constancy of the primitive-sixth count contributed by a block.  Two blocks
whose exponents have the same monic split characteristic polynomial have the same
framed primitive-sixth multiplicity: the exponent multiset is recovered from that
polynomial as its multiset of roots, and framed monodromy attaches to each
exponent the eigenvalue determined by it.  Over a formal germ the hypothesis is
supplied by constancy of the residue characteristic polynomial. -/
theorem sixthMultiplicity_eq_of_exponent_polynomial_eq
    {first second : Multiset ℂ}
    (equal : splitMonicPolynomial first = splitMonicPolynomial second) :
    sixthMultiplicityPolynomial (splitMonicPolynomial (first.map framedEigenvalue))
      = sixthMultiplicityPolynomial (splitMonicPolynomial (second.map framedEigenvalue)) := by
  have multisetEqual : first = second := by
    have rootsEqual := congrArg Polynomial.roots equal
    rwa [splitMonicPolynomial, splitMonicPolynomial, Polynomial.roots_multiset_prod_X_sub_C,
      Polynomial.roots_multiset_prod_X_sub_C] at rootsEqual
  rw [multisetEqual]

end ExponentTransport

end Quantum

end TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue
