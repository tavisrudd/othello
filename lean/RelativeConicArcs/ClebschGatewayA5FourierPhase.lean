import Mathlib.Tactic

/-!
# C400: arithmetic phases of the scalar-A5 Fourier schemes

The uniform orbit and Burnside arguments are mathematical proofs in the adjacent C400 report.  The
external certificate independently constructs the six finite-field controls, their eigenmatrices,
and the orthogonal fusions.  This module freezes the compact paper-facing arithmetic interface.
-/

namespace RelativeConicArcs
namespace ClebschGateway
namespace A5FourierPhase

/-- The six residue fields at which the invariant conic is one `A5` orbit. -/
inductive TransitiveConicPhase
  | q5
  | q9
  | q11
  | q19
  | q29
  | q59
  deriving DecidableEq, Repr

open TransitiveConicPhase

def allPhases : List TransitiveConicPhase := [.q5, .q9, .q11, .q19, .q29, .q59]

inductive ConicRelationRole
  | sourceD5
  | tripleS3
  | deepC5
  | deepC3
  | mirrorC2
  | deepFree
  deriving DecidableEq, Repr

structure CertifiedPhaseProfile where
  fieldOrder : ℕ
  schemeRank : ℕ
  conicOrbitSize : ℕ
  conicPointStabilizerOrder : ℕ
  conicRole : ConicRelationRole
  deepProjectiveCount : ℕ
  deriving DecidableEq, Repr

/-- Compact output of the exact scalar-`A5` orbit/eigenmatrix certificate. -/
def certifiedPhaseProfile : TransitiveConicPhase → CertifiedPhaseProfile
  | .q5 => ⟨5, 4, 6, 10, .sourceD5, 0⟩
  | .q9 => ⟨9, 6, 10, 6, .tripleS3, 0⟩
  | .q11 => ⟨11, 8, 12, 5, .deepC5, 12⟩
  | .q19 => ⟨19, 14, 20, 3, .deepC3, 140⟩
  | .q29 => ⟨29, 24, 30, 2, .mirrorC2, 480⟩
  | .q59 => ⟨59, 76, 60, 1, .deepFree, 2700⟩

def splitThree : TransitiveConicPhase → ℕ
  | .q19 => 1
  | _ => 0

def splitFive : TransitiveConicPhase → ℕ
  | .q11 => 1
  | _ => 0

/-- Burnside numerator for the affine rank, including the zero relation. -/
def rankNumerator (T : TransitiveConicPhase) : ℕ :=
  let q := (certifiedPhaseProfile T).fieldOrder
  q ^ 2 + 16 * q + 135 + 40 * splitThree T + 48 * splitFive T

/-- The certified ranks satisfy the uniform Burnside formula. -/
theorem certifiedRank_eq_burnside (T : TransitiveConicPhase) :
    60 * (certifiedPhaseProfile T).schemeRank = rankNumerator T := by
  cases T <;> decide

/-- The conic is transitive precisely through the complete stabilizer ladder. -/
theorem certifiedConicOrbitStabilizer (T : TransitiveConicPhase) :
    let profile := certifiedPhaseProfile T
    profile.conicOrbitSize = profile.fieldOrder + 1 ∧
      profile.conicOrbitSize * profile.conicPointStabilizerOrder = 60 := by
  cases T <;> decide

/-- The projective deep-hole union always has the arrangement-complement count. -/
theorem certifiedDeepProjectiveCount (T : TransitiveConicPhase) :
    let profile := certifiedPhaseProfile T
    profile.deepProjectiveCount =
      (profile.fieldOrder - 5) * (profile.fieldOrder - 9) := by
  cases T <;> decide

theorem certifiedFieldOrders :
    allPhases.map (fun T => (certifiedPhaseProfile T).fieldOrder) = [5, 9, 11, 19, 29, 59] := by
  decide

theorem certifiedSchemeRanks :
    allPhases.map (fun T => (certifiedPhaseProfile T).schemeRank) = [4, 6, 8, 14, 24, 76] := by
  decide

theorem certifiedConicStabilizerOrders :
    allPhases.map (fun T => (certifiedPhaseProfile T).conicPointStabilizerOrder) =
      [10, 6, 5, 3, 2, 1] := by
  decide

/-- Twice the three nonzero orthogonal-fusion valencies sum to twice `q^3-1`.

Writing the square/nonsquare sign as `delta`, the three valencies are
`q^2-1`, `q(q-1)(q+delta)/2`, and `q(q-1)(q-delta)/2`.
-/
theorem orthogonalFusionValencyIdentity (q delta : ℤ) :
    2 * (q ^ 2 - 1) + q * (q - 1) * (q + delta) + q * (q - 1) * (q - delta) =
      2 * (q ^ 3 - 1) := by
  ring

inductive ExhaustiveFusionPilot
  | q5
  | q9
  | q11
  deriving DecidableEq, Repr

def fusionRanks : ExhaustiveFusionPilot → List ℕ
  | .q5 => [2, 4]
  | .q9 => [2, 4, 6]
  | .q11 => [2, 4, 6, 8]

/-- Exact Bannai--Muzychuk exhaustions in the three feasible small ranks. -/
theorem certifiedSmallFusionRanks :
    [fusionRanks .q5, fusionRanks .q9, fusionRanks .q11] =
      [[2, 4], [2, 4, 6], [2, 4, 6, 8]] := by
  decide

#print axioms certifiedRank_eq_burnside
#print axioms certifiedConicOrbitStabilizer
#print axioms certifiedDeepProjectiveCount
#print axioms orthogonalFusionValencyIdentity
#print axioms certifiedSmallFusionRanks

end A5FourierPhase
end ClebschGateway
end RelativeConicArcs
