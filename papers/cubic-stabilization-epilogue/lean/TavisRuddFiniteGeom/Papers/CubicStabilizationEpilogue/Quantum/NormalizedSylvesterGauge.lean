import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.Quantum.BlockSylvesterSolvability

/-!
# The normalized gauge of a block-separated system

Consider a formal system with a second-order pole in the loop coordinate,

  `z ^ 2 * ∂_z S = M(z) * S`,   `M(z) = ∑ Mₙ zⁿ`,

whose leading coefficient `M₀` is block diagonal for a labelling of the
coordinates and has separated blocks: the difference of the scalars attached to
two distinct labels is a unit, and `M₀` differs from the diagonal matrix of
those scalars by a nilpotent matrix.

A gauge `A(z) = ∑ Aₙ zⁿ` transforms the system by `S = A(z) * S̃`, and the
transformed system `z ^ 2 * ∂_z S̃ = M̃(z) * S̃` satisfies

  `A(z) * M̃(z) + z ^ 2 * A'(z) = M(z) * A(z)`,

an identity of formal power series which uses no inverse of `A(z)`.  Its
coefficient at `zⁿ` is the identity recorded by `IsGaugeTransform` below.  The
gauge is *normalized* when `A₀ = 1` and every positive coefficient `Aₙ` is block
off-diagonal, and the transformed system is *reduced* when every coefficient
`M̃ₙ` is block diagonal.

This module proves that a normalized gauge reducing the system exists and is
unique.  At order `n ≥ 1` the identity reads

  `M̃ₙ + (Aₙ * M₀ - M₀ * Aₙ) = Rₙ`,

where the residual `Rₙ` is built from strictly earlier coefficients of the gauge
and of the reduced system together with the coefficients of the original system.
Its block-diagonal part determines `M̃ₙ`, and its block off-diagonal part
determines `Aₙ` through the block Sylvester equation, which has exactly one
block off-diagonal solution.  Both the existence and the uniqueness are proved
by that order-by-order argument: uniqueness by strong induction, existence by
recursion on the prefix of coefficients already determined.

Lean constructs no `F`-bundle, connection, spectral cover, or analytic gauge:
the system is a family of matrices indexed by the order, and the gauge identity
is the family of coefficient identities displayed above.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue

namespace Quantum

open Matrix

variable {R : Type*} [CommRing R] {coordinate : Type*} [Fintype coordinate] [DecidableEq coordinate]
  {factorIndex : Type*} [DecidableEq factorIndex]

/-- The coefficient of `z ^ order` in `z ^ 2` times the formal derivative of a
gauge: the derivative shifts the index by one and multiplies by it, and the
factor `z ^ 2` shifts it back up. -/
def loopDerivativeCoefficient (gauge : ℕ → Matrix coordinate coordinate R) :
    ℕ → Matrix coordinate coordinate R
  | 0 => 0
  | order + 1 => order • gauge order

omit [Fintype coordinate] [DecidableEq coordinate] in
@[simp]
theorem loopDerivativeCoefficient_zero (gauge : ℕ → Matrix coordinate coordinate R) :
    loopDerivativeCoefficient gauge 0 = 0 := rfl

omit [Fintype coordinate] [DecidableEq coordinate] in
@[simp]
theorem loopDerivativeCoefficient_succ (gauge : ℕ → Matrix coordinate coordinate R) (order : ℕ) :
    loopDerivativeCoefficient gauge (order + 1) = order • gauge order := rfl

/-- The coefficientwise form of the gauge identity
`A(z) * M̃(z) + z ^ 2 * A'(z) = M(z) * A(z)` relating a system, a gauge, and the
transformed system. -/
def IsGaugeTransform (system gauge reduced : ℕ → Matrix coordinate coordinate R) : Prop :=
  ∀ order, (∑ index ∈ Finset.range (order + 1), gauge index * reduced (order - index))
      + loopDerivativeCoefficient gauge order
    = ∑ index ∈ Finset.range (order + 1), system index * gauge (order - index)

/-- A gauge normalized for a labelling of the coordinates, reducing a system to
block-diagonal form: the gauge starts at the identity and all its positive
coefficients are block off-diagonal, and every coefficient of the transformed
system is block diagonal. -/
structure IsNormalizedGauge (label : coordinate → factorIndex)
    (system gauge reduced : ℕ → Matrix coordinate coordinate R) : Prop where
  /-- The gauge starts at the identity. -/
  leading : gauge 0 = 1
  /-- Every positive coefficient of the gauge is block off-diagonal. -/
  gaugeOffDiagonal : ∀ order, 1 ≤ order → IsBlockOffDiagonal label (gauge order)
  /-- Every coefficient of the transformed system is block diagonal. -/
  reducedDiagonal : ∀ order, IsBlockDiagonal label (reduced order)
  /-- The gauge identity holds order by order. -/
  transform : IsGaugeTransform system gauge reduced

/-- The part of the gauge identity at one order that involves the coefficients
of the gauge and of the reduced system strictly between the two ends. -/
def interiorConvolution (gauge reduced : ℕ → Matrix coordinate coordinate R) (order : ℕ) :
    Matrix coordinate coordinate R :=
  ∑ index ∈ Finset.Ico 1 order, gauge index * reduced (order - index)

/-- The part of the gauge identity at one order that involves the positive
coefficients of the original system. -/
def sourceConvolution (system gauge : ℕ → Matrix coordinate coordinate R) (order : ℕ) :
    Matrix coordinate coordinate R :=
  ∑ index ∈ Finset.Ico 1 (order + 1), system index * gauge (order - index)

/-- The residual of the gauge identity at one order: everything except the two
unknowns of that order, namely the coefficient of the reduced system and the
commutator of the gauge coefficient with the leading coefficient of the
system. -/
def gaugeResidual (system gauge reduced : ℕ → Matrix coordinate coordinate R) (order : ℕ) :
    Matrix coordinate coordinate R :=
  sourceConvolution system gauge order - interiorConvolution gauge reduced order
    - loopDerivativeCoefficient gauge order

/-- The order-zero gauge identity says that the reduced system starts where the
system does. -/
theorem reduced_zero_eq {system gauge reduced : ℕ → Matrix coordinate coordinate R}
    (leading : gauge 0 = 1) (transform : IsGaugeTransform system gauge reduced) :
    reduced 0 = system 0 := by
  have identity := transform 0
  simpa [leading] using identity

/-- The gauge identity at a positive order, with the two unknowns of that order
separated from the residual built out of strictly earlier data. -/
theorem gaugeTransform_succ_iff {system gauge reduced : ℕ → Matrix coordinate coordinate R}
    (leading : gauge 0 = 1) (reducedZero : reduced 0 = system 0) (order : ℕ) :
    ((∑ index ∈ Finset.range (order + 2), gauge index * reduced (order + 1 - index))
          + loopDerivativeCoefficient gauge (order + 1)
        = ∑ index ∈ Finset.range (order + 2), system index * gauge (order + 1 - index))
      ↔ reduced (order + 1) + (gauge (order + 1) * system 0 - system 0 * gauge (order + 1))
          = gaugeResidual system gauge reduced (order + 1) := by
  have leftSplit :
      (∑ index ∈ Finset.range (order + 2), gauge index * reduced (order + 1 - index))
        = reduced (order + 1) + interiorConvolution gauge reduced (order + 1)
          + gauge (order + 1) * system 0 := by
    rw [Finset.range_eq_Ico, Finset.sum_eq_sum_Ico_succ_bot (by omega),
      Finset.sum_Ico_succ_top (by omega)]
    simp only [Nat.sub_zero, leading, one_mul, Nat.sub_self, reducedZero]
    rw [interiorConvolution]
    abel
  have rightSplit :
      (∑ index ∈ Finset.range (order + 2), system index * gauge (order + 1 - index))
        = system 0 * gauge (order + 1) + sourceConvolution system gauge (order + 1) := by
    rw [Finset.range_eq_Ico, Finset.sum_eq_sum_Ico_succ_bot (by omega)]
    simp only [Nat.sub_zero]
    rw [sourceConvolution]
  rw [leftSplit, rightSplit, gaugeResidual]
  constructor
  · intro identity
    linear_combination (norm := abel) identity
  · intro identity
    linear_combination (norm := abel) identity

omit [DecidableEq coordinate] in
/-- The residual at one order depends only on the coefficients of the gauge and
of the reduced system at strictly smaller orders. -/
theorem gaugeResidual_congr {system gauge reduced gaugeOther reducedOther :
      ℕ → Matrix coordinate coordinate R} {order : ℕ}
    (gaugeAgreement : ∀ index, index ≤ order → gauge index = gaugeOther index)
    (reducedAgreement : ∀ index, index ≤ order → reduced index = reducedOther index) :
    gaugeResidual system gauge reduced (order + 1)
      = gaugeResidual system gaugeOther reducedOther (order + 1) := by
  have sourceAgreement : sourceConvolution system gauge (order + 1)
      = sourceConvolution system gaugeOther (order + 1) := by
    refine Finset.sum_congr rfl fun index member => ?_
    have bound : 1 ≤ index := (Finset.mem_Ico.mp member).1
    rw [gaugeAgreement (order + 1 - index) (by omega)]
  have interiorAgreement : interiorConvolution gauge reduced (order + 1)
      = interiorConvolution gaugeOther reducedOther (order + 1) := by
    refine Finset.sum_congr rfl fun index member => ?_
    obtain ⟨lower, upper⟩ := Finset.mem_Ico.mp member
    rw [gaugeAgreement index (by omega), reducedAgreement (order + 1 - index) (by omega)]
  rw [gaugeResidual, gaugeResidual, sourceAgreement, interiorAgreement,
    loopDerivativeCoefficient_succ, loopDerivativeCoefficient_succ,
    gaugeAgreement order (by omega)]

/-- One order of the normalized gauge is determined by its residual.  Given a
block-diagonal leading operator with separated blocks, a block-diagonal
coefficient of the reduced system and a block off-diagonal coefficient of the
gauge satisfying the order's identity with a given residual are unique: the
difference of the two reduced coefficients is block diagonal and, being the
commutator of the leading operator with the difference of the two gauge
coefficients, block off-diagonal, hence zero; the difference of the gauge
coefficients then solves the homogeneous block Sylvester equation, whose only
block off-diagonal solution is zero. -/
theorem normalizedGauge_step_unique {label : coordinate → factorIndex} {scalar : factorIndex → R}
    {leadingOperator gaugeValue gaugeOther reducedValue reducedOther residual :
      Matrix coordinate coordinate R}
    (separated : ∀ first second, first ≠ second → IsUnit (scalar first - scalar second))
    (blockDiagonal : IsBlockDiagonal label leadingOperator)
    (nilpotent : IsNilpotent
      (leadingOperator - Matrix.diagonal fun index => scalar (label index)))
    (reducedDiagonal : IsBlockDiagonal label reducedValue)
    (reducedOtherDiagonal : IsBlockDiagonal label reducedOther)
    (gaugeOffDiagonal : IsBlockOffDiagonal label gaugeValue)
    (gaugeOtherOffDiagonal : IsBlockOffDiagonal label gaugeOther)
    (firstIdentity :
      reducedValue + (gaugeValue * leadingOperator - leadingOperator * gaugeValue) = residual)
    (secondIdentity :
      reducedOther + (gaugeOther * leadingOperator - leadingOperator * gaugeOther) = residual) :
    gaugeValue = gaugeOther ∧ reducedValue = reducedOther := by
  have difference : (reducedValue - reducedOther)
      + ((gaugeValue - gaugeOther) * leadingOperator
        - leadingOperator * (gaugeValue - gaugeOther)) = 0 := by
    rw [Matrix.sub_mul, Matrix.mul_sub]
    linear_combination (norm := abel) firstIdentity - secondIdentity
  have gaugeDifferenceOffDiagonal : IsBlockOffDiagonal label (gaugeValue - gaugeOther) := by
    intro row column sameLabel
    rw [Matrix.sub_apply, gaugeOffDiagonal row column sameLabel,
      gaugeOtherOffDiagonal row column sameLabel, sub_zero]
  have commutatorOffDiagonal : IsBlockOffDiagonal label (reducedValue - reducedOther) := by
    have identity : reducedValue - reducedOther
        = sylvesterOperator leadingOperator leadingOperator (gaugeValue - gaugeOther) := by
      rw [sylvesterOperator_apply]
      linear_combination (norm := abel) difference
    rw [identity]
    exact isBlockOffDiagonal_sylvesterOperator blockDiagonal gaugeDifferenceOffDiagonal
  have reducedVanishing : reducedValue - reducedOther = 0 :=
    eq_zero_of_isBlockDiagonal_of_isBlockOffDiagonal
      (isBlockDiagonal_sub reducedDiagonal reducedOtherDiagonal) commutatorOffDiagonal
  have sylvesterVanishing : leadingOperator * (gaugeValue - gaugeOther)
      - (gaugeValue - gaugeOther) * leadingOperator = 0 := by
    rw [reducedVanishing] at difference
    linear_combination (norm := abel) -difference
  obtain ⟨witness, -, uniqueness⟩ := existsUnique_blockOffDiagonal_sylvester_solution
    (label := label) (scalar := scalar) (leadingOperator := leadingOperator) separated
    blockDiagonal nilpotent (target := 0) (fun row column _ => rfl)
  have differenceIsSolution := uniqueness (gaugeValue - gaugeOther)
    ⟨gaugeDifferenceOffDiagonal, sylvesterVanishing⟩
  have zeroIsSolution := uniqueness 0 ⟨fun row column _ => rfl, by simp⟩
  refine ⟨?_, ?_⟩
  · have vanishing : gaugeValue - gaugeOther = 0 :=
      differenceIsSolution.trans zeroIsSolution.symm
    linear_combination (norm := abel) vanishing
  · linear_combination (norm := abel) reducedVanishing

/-- Uniqueness of the normalized gauge.  Two normalized gauges reducing the same
system to block-diagonal form have the same coefficients, and so do the two
reduced systems.  The two coefficients of one order have the same residual as
soon as all strictly earlier coefficients agree, and one order is determined by
its residual, so the conclusion follows by strong induction. -/
theorem normalizedGauge_unique {label : coordinate → factorIndex} {scalar : factorIndex → R}
    {system gauge reduced gaugeOther reducedOther : ℕ → Matrix coordinate coordinate R}
    (separated : ∀ first second, first ≠ second → IsUnit (scalar first - scalar second))
    (blockDiagonal : IsBlockDiagonal label (system 0))
    (nilpotent : IsNilpotent (system 0 - Matrix.diagonal fun index => scalar (label index)))
    (first : IsNormalizedGauge label system gauge reduced)
    (second : IsNormalizedGauge label system gaugeOther reducedOther) :
    ∀ order, gauge order = gaugeOther order ∧ reduced order = reducedOther order := by
  intro order
  induction order using Nat.strong_induction_on with
  | _ order inductionHypothesis =>
    match order with
    | 0 =>
        exact ⟨first.leading.trans second.leading.symm,
          (reduced_zero_eq first.leading first.transform).trans
            (reduced_zero_eq second.leading second.transform).symm⟩
    | step + 1 =>
        have gaugeAgreement : ∀ index, index ≤ step → gauge index = gaugeOther index :=
          fun index bound => (inductionHypothesis index (by omega)).1
        have reducedAgreement : ∀ index, index ≤ step → reduced index = reducedOther index :=
          fun index bound => (inductionHypothesis index (by omega)).2
        have residualAgreement := gaugeResidual_congr (system := system)
          gaugeAgreement reducedAgreement
        have firstIdentity := (gaugeTransform_succ_iff first.leading
          (reduced_zero_eq first.leading first.transform) step).mp (first.transform (step + 1))
        have secondIdentity := (gaugeTransform_succ_iff second.leading
          (reduced_zero_eq second.leading second.transform) step).mp (second.transform (step + 1))
        rw [residualAgreement] at firstIdentity
        exact normalizedGauge_step_unique separated blockDiagonal nilpotent
          (first.reducedDiagonal (step + 1)) (second.reducedDiagonal (step + 1))
          (first.gaugeOffDiagonal (step + 1) (by omega))
          (second.gaugeOffDiagonal (step + 1) (by omega)) firstIdentity secondIdentity

section Existence

variable (solve : Matrix coordinate coordinate R →
    Matrix coordinate coordinate R × Matrix coordinate coordinate R)
  (system : ℕ → Matrix coordinate coordinate R)

/-- The coefficients of the gauge and of the reduced system determined up to one
order, extended beyond it by the value already determined.  At each step the
next pair of coefficients is the value of the supplied solver on the residual of
the previous step's data. -/
def gaugePrefix : ℕ → ℕ → Matrix coordinate coordinate R × Matrix coordinate coordinate R
  | 0 => fun _ => (1, system 0)
  | step + 1 => fun index =>
      if index = step + 1 then
        solve (gaugeResidual system (fun order => (gaugePrefix step order).1)
          (fun order => (gaugePrefix step order).2) (step + 1))
      else gaugePrefix step index

theorem gaugePrefix_succ (step index : ℕ) :
    gaugePrefix solve system (step + 1) index
      = if index = step + 1 then
          solve (gaugeResidual system (fun order => (gaugePrefix solve system step order).1)
            (fun order => (gaugePrefix solve system step order).2) (step + 1))
        else gaugePrefix solve system step index := rfl

/-- The pair of coefficients of one order: the gauge coefficient and the
coefficient of the reduced system. -/
def gaugeSequence (order : ℕ) : Matrix coordinate coordinate R × Matrix coordinate coordinate R :=
  gaugePrefix solve system order order

/-- The prefix of coefficients determined at one step agrees, below that step,
with the coefficients themselves. -/
theorem gaugePrefix_eq_gaugeSequence : ∀ step index, index ≤ step →
    gaugePrefix solve system step index = gaugeSequence solve system index := by
  intro step
  induction step with
  | zero =>
      intro index bound
      have vanishing : index = 0 := Nat.le_zero.mp bound
      rw [vanishing]
      rfl
  | succ step inductionHypothesis =>
      intro index bound
      by_cases top : index = step + 1
      · rw [top]
        rfl
      · rw [gaugePrefix_succ, if_neg top]
        exact inductionHypothesis index (by omega)

/-- The coefficients of one positive order are the value of the solver on the
residual built from all strictly earlier coefficients. -/
theorem gaugeSequence_succ (step : ℕ) :
    gaugeSequence solve system (step + 1)
      = solve (gaugeResidual system (fun order => (gaugeSequence solve system order).1)
          (fun order => (gaugeSequence solve system order).2) (step + 1)) := by
  have unfolded : gaugeSequence solve system (step + 1)
      = solve (gaugeResidual system (fun order => (gaugePrefix solve system step order).1)
          (fun order => (gaugePrefix solve system step order).2) (step + 1)) := by
    rw [gaugeSequence, gaugePrefix_succ, if_pos rfl]
  rw [unfolded]
  congr 1
  exact gaugeResidual_congr
    (fun index bound => congrArg Prod.fst
      (gaugePrefix_eq_gaugeSequence solve system step index bound))
    (fun index bound => congrArg Prod.snd
      (gaugePrefix_eq_gaugeSequence solve system step index bound))

end Existence

/-- Existence of the normalized gauge.  For a system whose leading coefficient
is block diagonal with separated blocks there is a normalized gauge reducing it
to block-diagonal form.  At each positive order the block-diagonal part of the
residual is the new coefficient of the reduced system, and the block Sylvester
equation supplies the new block off-diagonal coefficient of the gauge. -/
theorem exists_normalizedGauge {label : coordinate → factorIndex} {scalar : factorIndex → R}
    {system : ℕ → Matrix coordinate coordinate R}
    (separated : ∀ first second, first ≠ second → IsUnit (scalar first - scalar second))
    (blockDiagonal : IsBlockDiagonal label (system 0))
    (nilpotent : IsNilpotent (system 0 - Matrix.diagonal fun index => scalar (label index))) :
    ∃ gauge reduced : ℕ → Matrix coordinate coordinate R,
      IsNormalizedGauge label system gauge reduced := by
  have step : ∀ residual : Matrix coordinate coordinate R,
      ∃ pair : Matrix coordinate coordinate R × Matrix coordinate coordinate R,
        IsBlockOffDiagonal label pair.1 ∧ IsBlockDiagonal label pair.2 ∧
          pair.2 + (pair.1 * system 0 - system 0 * pair.1) = residual := by
    intro residual
    obtain ⟨solution, ⟨solutionOffDiagonal, solutionEquation⟩, -⟩ :=
      existsUnique_blockOffDiagonal_sylvester_solution (label := label) (scalar := scalar)
        (leadingOperator := system 0) separated blockDiagonal nilpotent
        (target := blockOffDiagonalProjection label (-residual))
        (isBlockOffDiagonal_blockOffDiagonalProjection label (-residual))
    refine ⟨(solution, blockDiagonalProjection label residual), solutionOffDiagonal,
      isBlockDiagonal_blockDiagonalProjection label residual, ?_⟩
    have negated : blockOffDiagonalProjection label (-residual)
        = -blockOffDiagonalProjection label residual := map_neg _ _
    rw [negated] at solutionEquation
    have commutator : solution * system 0 - system 0 * solution
        = blockOffDiagonalProjection label residual := by
      linear_combination (norm := abel) -solutionEquation
    rw [commutator]
    exact blockDiagonalProjection_add_blockOffDiagonalProjection_apply label residual
  choose solve solveOffDiagonal solveDiagonal solveEquation using step
  refine ⟨fun order => (gaugeSequence solve system order).1,
    fun order => (gaugeSequence solve system order).2, ?_, ?_, ?_, ?_⟩
  · rfl
  · intro order bound
    match order with
    | 0 => exact absurd bound (by omega)
    | step + 1 =>
        rw [gaugeSequence_succ]
        exact solveOffDiagonal _
  · intro order
    match order with
    | 0 => exact blockDiagonal
    | step + 1 =>
        rw [gaugeSequence_succ]
        exact solveDiagonal _
  · intro order
    match order with
    | 0 =>
        have zeroValue : gaugeSequence solve system 0 = (1, system 0) := rfl
        simp [zeroValue]
    | step + 1 =>
        have leadingValue : (gaugeSequence solve system 0).1 = 1 := rfl
        have reducedValue : (gaugeSequence solve system 0).2 = system 0 := rfl
        refine (gaugeTransform_succ_iff (system := system)
          (gauge := fun order => (gaugeSequence solve system order).1)
          (reduced := fun order => (gaugeSequence solve system order).2)
          leadingValue reducedValue step).mpr ?_
        have equation := solveEquation (gaugeResidual system
          (fun order => (gaugeSequence solve system order).1)
          (fun order => (gaugeSequence solve system order).2) (step + 1))
        rw [← gaugeSequence_succ solve system step] at equation
        exact equation

end Quantum

end TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue
