import RelativeConicArcs.ClebschPassageInterfacesData
import RelativeConicArcs.ClebschSchemeFourier
import Mathlib.Tactic

/-!
# Checked finite passage interfaces

This module checks finite theta-parity, Fourier-matrix, and code-transport statements.

The theta calculation uses canonical representatives of even subsets modulo complement.  It
checks both Arf-value counts and the complete same-sheet intersection signatures.  The
rank-eight Fourier square is reused from the independently generated finite scheme checker; the
rank-sixteen and signed restrictions are checked here, including weighted adjointness.  The two
golden parity-check matrices are related both by an explicit monomial transport with party
permutation and by a fixed-party signed dual-code transport.

Identifying the rank-eight and rank-sixteen matrices as restrictions of one ambient normalized
Fourier transform, choosing a Schrodinger normalization, or naming its projective class as a Weil
operator are external interpretations; no artificial direct-sum carrier is used as a substitute.
Likewise, character-sum orthogonality turns the signed dual-code equality into an equal-phase
state-vector equality, but arbitrary local-unitary classification is not asserted.
-/

namespace RelativeConicArcs
namespace ClebschPassageInterfaces

set_option maxRecDepth 100000
set_option maxHeartbeats 2000000

local instance : Fact (Nat.Prime 11) := ⟨by norm_num⟩

/-! ## Theta and matching-Lagrangian parity -/

/-- The genus-three quadratic refinement has 36 zero values and 28 one values on its 64
canonical representatives; its Arf invariant is therefore zero. -/
theorem genusThree_theta_value_counts :
    ((Finset.univ.filter fun m : Fin 64 ↦ thetaQuadratic 6 m.val = 0).card,
      (Finset.univ.filter fun m : Fin 64 ↦ thetaQuadratic 6 m.val = 1).card) = (36, 28) := by
  decide

/-- The genus-five quadratic refinement has 496 zero values and 528 one values on its 1024
canonical representatives; its Arf invariant is therefore one. -/
theorem genusFive_theta_value_counts :
    ((Finset.univ.filter fun m : Fin 1024 ↦ thetaQuadratic 10 m.val = 0).card,
      (Finset.univ.filter fun m : Fin 1024 ↦ thetaQuadratic 10 m.val = 1).card) = (496, 528) := by
  decide

/-- At seven points, every distinct same-sheet matching pair has one-dimensional Lagrangian
intersection represented by a weight-four even subset, on which the quadratic value is zero. -/
theorem seven_matching_lagrangian_signature :
    ∀ sheet : Fin 2, ∀ i j : Fin 7, i ≠ j →
      sevenLagrangianIntersection sheet i j = 1 ∧
      sevenIntersectionWeight sheet i j = 4 ∧
      sevenIntersectionWeight sheet i j / 2 % 2 = 0 := by
  decide

/-- At eleven points, every distinct same-sheet matching pair has one-dimensional Lagrangian
intersection represented by a weight-six even subset, on which the quadratic value is one. -/
theorem eleven_matching_lagrangian_signature :
    ∀ sheet : Fin 2, ∀ i j : Fin 11, i ≠ j →
      elevenLagrangianIntersection sheet i j = 1 ∧
      elevenIntersectionWeight sheet i j = 6 ∧
      elevenIntersectionWeight sheet i j / 2 % 2 = 1 := by
  decide

/-- The complete finite theta signatures are unchanged when the sheet label is exchanged. -/
theorem theta_signature_erases_sheet :
    (∀ i j : Fin 7,
      sevenLagrangianIntersection 0 i j = sevenLagrangianIntersection 1 i j ∧
      sevenIntersectionWeight 0 i j = sevenIntersectionWeight 1 i j) ∧
    (∀ i j : Fin 11,
      elevenLagrangianIntersection 0 i j = elevenLagrangianIntersection 1 i j ∧
      elevenIntersectionWeight 0 i j = elevenIntersectionWeight 1 i j) := by
  decide

/-! ## Explicit Fourier restrictions -/

private def listSquareMatrix (n : Nat) (a : List (List ℤ)) : Matrix (Fin n) (Fin n) ℤ :=
  fun i j ↦ (a.getD i.val []).getD j.val 0

/-- The independently reconstructed rank-eight restriction squares to `1331` times the
identity. -/
theorem rankEightFourier_square :
    ClebschSchemeFourier.matMul ClebschSchemeFourier.firstEigenmatrix
        ClebschSchemeFourier.firstEigenmatrix =
      ClebschSchemeFourier.scaledIdentity 1331 8 :=
  ClebschSchemeFourier.frozen_first_eigenmatrix_sq

/-- The frozen rank-sixteen restriction squares to `1331` times the identity. -/
theorem rankSixteenFourier_square :
    ClebschSchemeFourier.matMul rankSixteenFourier rankSixteenFourier =
      ClebschSchemeFourier.scaledIdentity 1331 16 := by
  set_option maxRecDepth 10000 in decide

/-- The signed four-dimensional restriction squares to `1331` times the identity. -/
theorem signedFourier_square : signedFourier * signedFourier = (1331 : ℤ) • 1 := by
  decide

/-- The signed restriction is self-adjoint for the diagonal form defined by the raw
orbit-difference norms. -/
theorem signedFourier_weighted_adjoint :
    (fun i j ↦ signedNorms i * signedFourier i j) =
      (fun i j ↦ signedFourier j i * signedNorms j) := by
  funext i j
  fin_cases i <;> fin_cases j <;> norm_num [signedNorms, signedFourier]

/-- The rank-eight restriction is self-adjoint for its orbit-indicator norm form. -/
theorem rankEightFourier_weighted_adjoint :
    (fun i j : Fin 8 ↦
      ClebschSchemeFourier.valencies.getD i.val 0 *
        listSquareMatrix 8 ClebschSchemeFourier.firstEigenmatrix i j) =
    (fun i j : Fin 8 ↦
      listSquareMatrix 8 ClebschSchemeFourier.firstEigenmatrix j i *
        ClebschSchemeFourier.valencies.getD j.val 0) := by
  decide

/-- The rank-sixteen restriction is self-adjoint for its orbit-indicator norm form. -/
theorem rankSixteenFourier_weighted_adjoint :
    (fun i j : Fin 16 ↦
      rankSixteenNorms.getD i.val 0 * listSquareMatrix 16 rankSixteenFourier i j) =
    (fun i j : Fin 16 ↦
      listSquareMatrix 16 rankSixteenFourier j i * rankSixteenNorms.getD j.val 0) := by
  decide

/-- All three explicit integer restrictions have trace zero.  The associated eigenspace
multiplicities require the standard distinct-root argument after scalar extension and are not
exported as finite table identities. -/
theorem Fourier_restriction_traces_zero :
    (List.ofFn fun i : Fin 8 ↦
      (ClebschSchemeFourier.firstEigenmatrix.getD i.val []).getD i.val 0).sum = 0 ∧
    (List.ofFn fun i : Fin 16 ↦ (rankSixteenFourier.getD i.val []).getD i.val 0).sum = 0 ∧
    (∑ i : Fin 4, signedFourier i i) = 0 := by
  decide

/-! ## Monomial and fixed-party support transports -/

/-- The explicit party permutation and coordinate scalars, written in target order. -/
def monomialTransport (x : Fin 6 → F11) : Fin 6 → F11 :=
  Matrix.mulVec monomialTransportMatrix x

/-- The inverse of `monomialTransport`. -/
def monomialTransportInverse (y : Fin 6 → F11) : Fin 6 → F11 :=
  Matrix.mulVec monomialTransportInverseMatrix y

private theorem monomialTransport_leftInverse :
    monomialTransportInverseMatrix * monomialTransportMatrix = 1 := by decide

private theorem monomialTransport_rightInverse :
    monomialTransportMatrix * monomialTransportInverseMatrix = 1 := by decide

/-- The displayed monomial transport is a bijection of the six-coordinate ambient code space. -/
theorem monomialTransport_bijective : Function.Bijective monomialTransport := by
  have hleft : Function.LeftInverse monomialTransportInverse monomialTransport := by
    intro x
    simp [monomialTransport, monomialTransportInverse, Matrix.mulVec_mulVec,
      monomialTransport_leftInverse]
  have hright : Function.RightInverse monomialTransportInverse monomialTransport := by
    intro y
    simp [monomialTransport, monomialTransportInverse, Matrix.mulVec_mulVec,
      monomialTransport_rightInverse]
  exact ⟨hleft.injective, hright.surjective⟩

/-- The row intertwiner verifies the six columnwise projective identities used by the monomial
transport. -/
theorem monomial_column_intertwiner :
    ∀ j : Fin 6,
      Matrix.mulVec monomialRowIntertwiner (fun i ↦ pencilCheck 8 i j) =
        fun i ↦ monomialScalars j * pencilCheck 4 i (monomialPartyMap j) := by
  decide

private theorem monomial_check_matrix_identity :
    pencilCheck 4 * monomialTransportMatrix =
      monomialRowIntertwiner * pencilCheck 8 := by decide

private theorem monomial_inverse_check_matrix_identity :
    pencilCheck 8 * monomialTransportInverseMatrix =
      monomialRowIntertwinerInverse * pencilCheck 4 := by decide

/-- The explicit monomial map carries the parameter-eight code kernel exactly onto the
parameter-four code kernel. -/
theorem monomialTransport_kernel_equivalence (x : Fin 6 → F11) :
    Matrix.mulVec (pencilCheck 8) x = 0 ↔
      Matrix.mulVec (pencilCheck 4) (monomialTransport x) = 0 := by
  constructor
  · intro h
    calc
      Matrix.mulVec (pencilCheck 4) (monomialTransport x) =
          Matrix.mulVec (pencilCheck 4 * monomialTransportMatrix) x := by
            simp [monomialTransport, Matrix.mulVec_mulVec]
      _ = Matrix.mulVec monomialRowIntertwiner (Matrix.mulVec (pencilCheck 8) x) := by
            rw [monomial_check_matrix_identity, Matrix.mulVec_mulVec]
      _ = 0 := by simp [h]
  · intro h
    have hinverse :
        Matrix.mulVec (pencilCheck 8) (monomialTransportInverse (monomialTransport x)) = 0 := by
      calc
        Matrix.mulVec (pencilCheck 8) (monomialTransportInverse (monomialTransport x)) =
            Matrix.mulVec (pencilCheck 8 * monomialTransportInverseMatrix)
              (monomialTransport x) := by
                simp [monomialTransportInverse, Matrix.mulVec_mulVec]
        _ = Matrix.mulVec monomialRowIntertwinerInverse
              (Matrix.mulVec (pencilCheck 4) (monomialTransport x)) := by
                rw [monomial_inverse_check_matrix_identity, Matrix.mulVec_mulVec]
        _ = 0 := by simp [h]
    simpa [monomialTransport, monomialTransportInverse, Matrix.mulVec_mulVec,
      monomialTransport_leftInverse] using hinverse

/-- The signed dual-code parametrization underlying the fixed-party Fourier transport. -/
def fourierSupportParam (x : Fin 3 → F11) : Fin 6 → F11 :=
  Matrix.mulVec fourierSupportMatrix x

/-- The signed transpose of the parameter-eight parity check. -/
def signedSourceDualParam (x : Fin 3 → F11) : Fin 6 → F11 :=
  fun i ↦ fourierSupportSigns i * Matrix.mulVec (pencilCheck 8).transpose x i

/-- The support matrix is literally the four-minus, two-plus signed transpose of the
parameter-eight parity check. -/
theorem fourierSupport_signed_transpose :
    fourierSupportMatrix =
      fun i j ↦ fourierSupportSigns i * pencilCheck 8 j i := by
  decide

/-- The matrix parametrization and the signed-source-dual parametrization agree pointwise. -/
theorem signedSourceDualParam_eq_fourierSupportParam (x : Fin 3 → F11) :
    signedSourceDualParam x = fourierSupportParam x := by
  rw [fourierSupportParam, fourierSupport_signed_transpose]
  ext i
  simp only [signedSourceDualParam, Matrix.mulVec, dotProduct, Matrix.transpose_apply,
    Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro j _
  ring

/-- Coordinates recovered from a word in the target code. -/
def fourierSupportRecover (y : Fin 6 → F11) : Fin 3 → F11 :=
  Matrix.mulVec fourierSupportRecoverMatrix y

private theorem fourierSupport_in_kernel :
    pencilCheck 4 * fourierSupportMatrix = 0 := by decide

private theorem fourierSupport_leftInverse :
    fourierSupportRecoverMatrix * fourierSupportMatrix = 1 := by decide

private theorem fourierSupport_decomposition :
    fourierSupportMatrix * fourierSupportRecoverMatrix +
        fourierSupportCorrection * pencilCheck 4 = 1 := by decide

/-- The three-parameter signed dual-code map is injective. -/
theorem fourierSupportParam_injective : Function.Injective fourierSupportParam := by
  intro x y h
  have := congrArg (Matrix.mulVec fourierSupportRecoverMatrix) h
  simpa [fourierSupportParam, Matrix.mulVec_mulVec, fourierSupport_leftInverse] using this

/-- The signed source dual is exactly the target kernel.  This is the finite support equality
used by character orthogonality in the state-vector calculation. -/
theorem fixedParty_fourier_support_equivalence (y : Fin 6 → F11) :
    Matrix.mulVec (pencilCheck 4) y = 0 ↔
      ∃ x : Fin 3 → F11, y = signedSourceDualParam x := by
  have hsupport :
      Matrix.mulVec (pencilCheck 4) y = 0 ↔
        ∃ x : Fin 3 → F11, y = fourierSupportParam x := by
    constructor
    · intro h
      refine ⟨fourierSupportRecover y, ?_⟩
      calc
        y = Matrix.mulVec (1 : Matrix (Fin 6) (Fin 6) F11) y := by simp
        _ = Matrix.mulVec
            (fourierSupportMatrix * fourierSupportRecoverMatrix +
              fourierSupportCorrection * pencilCheck 4) y := by
                rw [fourierSupport_decomposition]
        _ = fourierSupportParam (fourierSupportRecover y) := by
          rw [Matrix.add_mulVec, ← Matrix.mulVec_mulVec, ← Matrix.mulVec_mulVec, h]
          simp [fourierSupportParam, fourierSupportRecover]
    · rintro ⟨x, rfl⟩
      rw [fourierSupportParam, Matrix.mulVec_mulVec, fourierSupport_in_kernel]
      simp
  simpa only [signedSourceDualParam_eq_fourierSupportParam] using hsupport

/-! ## Finite bitorsor interface -/

/-- The abstract symmetry group used to index the sixty source and target symmetries. -/
abbrev MarkedSymmetry := alternatingGroup (Fin 5)

/-- Left and right regular actions on the equivalence index set. -/
def leftMarkedAction (g e : MarkedSymmetry) : MarkedSymmetry := g * e
def rightMarkedAction (e h : MarkedSymmetry) : MarkedSymmetry := e * h⁻¹

/-- The abstract indexing group has exactly sixty elements. -/
theorem markedSymmetry_card : Fintype.card MarkedSymmetry = 60 := by
  rw [card_alternatingGroup]
  norm_num

/-- The left and right actions commute. -/
theorem marked_actions_commute (g e h : MarkedSymmetry) :
    leftMarkedAction g (rightMarkedAction e h) =
      rightMarkedAction (leftMarkedAction g e) h := by
  simp [leftMarkedAction, rightMarkedAction, mul_assoc]

/-- Each regular action is free and transitive, so the sixty abstract equivalence indices form a
bitorsor.  Identifying these indices with the enumerated projective maps is an external finite
certificate boundary. -/
theorem marked_actions_free_transitive :
    (∀ e₁ e₂ : MarkedSymmetry, ∃! g, leftMarkedAction g e₁ = e₂) ∧
    (∀ e₁ e₂ : MarkedSymmetry, ∃! h, rightMarkedAction e₁ h = e₂) := by
  constructor
  · intro e₁ e₂
    refine ⟨e₂ * e₁⁻¹, by simp [leftMarkedAction], ?_⟩
    intro g hg
    apply mul_right_cancel (b := e₁)
    simpa [leftMarkedAction] using hg
  · intro e₁ e₂
    refine ⟨e₂⁻¹ * e₁, by simp [rightMarkedAction], ?_⟩
    intro h hh
    have := congrArg (fun z ↦ e₁⁻¹ * z) hh
    simp [rightMarkedAction] at this
    exact inv_injective this

end ClebschPassageInterfaces
end RelativeConicArcs
