import Mathlib.Tactic

/-!
# Recorded arithmetic profiles for scalar-`A5` actions

The six profile rows and the three lists of fusion ranks are literal external inputs.  Kernel
reduction checks arithmetic identities about those values, and `orthogonalFusionValencyIdentity`
is a symbolic polynomial identity.  This module does not construct the scalar-`A5` actions, define
their orbit relations or eigenmatrices, run a Bannai--Muzychuk checker, or prove that the displayed
phase and fusion lists are exhaustive.  Thus the declarations retaining the legacy `certified*`
names certify only arithmetic about the displayed definitions, not their geometric semantics.
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

/-- The six phase labels represented by the external profile table. -/
def allPhases : List TransitiveConicPhase := [.q5, .q9, .q11, .q19, .q29, .q59]

/-- Descriptive labels attached to the six externally supplied profile rows. -/
inductive ConicRelationRole
  | sourceD5
  | tripleS3
  | deepC5
  | deepC3
  | mirrorC2
  | deepFree
  deriving DecidableEq, Repr

/-- Numeric fields retained from an external scalar-`A5` calculation.  This structure carries no
orbit witnesses or checker proof. -/
structure CertifiedPhaseProfile where
  fieldOrder : ℕ
  schemeRank : ℕ
  conicOrbitSize : ℕ
  conicPointStabilizerOrder : ℕ
  conicRole : ConicRelationRole
  deepProjectiveCount : ℕ
  deriving DecidableEq, Repr

/-- The six externally supplied arithmetic profile rows.  The legacy name does not make their
geometric interpretation a Lean theorem. -/
def certifiedPhaseProfile : TransitiveConicPhase → CertifiedPhaseProfile
  | .q5 => ⟨5, 4, 6, 10, .sourceD5, 0⟩
  | .q9 => ⟨9, 6, 10, 6, .tripleS3, 0⟩
  | .q11 => ⟨11, 8, 12, 5, .deepC5, 12⟩
  | .q19 => ⟨19, 14, 20, 3, .deepC3, 140⟩
  | .q29 => ⟨29, 24, 30, 2, .mirrorC2, 480⟩
  | .q59 => ⟨59, 76, 60, 1, .deepFree, 2700⟩

/-- The displayed correction indicator for elements of order three. -/
def splitThree : TransitiveConicPhase → ℕ
  | .q19 => 1
  | _ => 0

/-- The displayed correction indicator for elements of order five. -/
def splitFive : TransitiveConicPhase → ℕ
  | .q11 => 1
  | _ => 0

/-- The displayed polynomial numerator used in the recorded affine-rank identity, including its
zero-relation term and the two correction indicators. -/
def rankNumerator (T : TransitiveConicPhase) : ℕ :=
  let q := (certifiedPhaseProfile T).fieldOrder
  q ^ 2 + 16 * q + 135 + 40 * splitThree T + 48 * splitFive T

/-- The recorded rank values satisfy the displayed Burnside-numerator arithmetic identity.  This
does not formalize the orbit-counting argument. -/
theorem certifiedRank_eq_burnside (T : TransitiveConicPhase) :
    60 * (certifiedPhaseProfile T).schemeRank = rankNumerator T := by
  cases T <;> decide

/-- Each recorded orbit-size/stabilizer-order pair has product 60 and orbit size `q+1`.  No action
or transitivity predicate occurs in the statement. -/
theorem certifiedConicOrbitStabilizer (T : TransitiveConicPhase) :
    let profile := certifiedPhaseProfile T
    profile.conicOrbitSize = profile.fieldOrder + 1 ∧
      profile.conicOrbitSize * profile.conicPointStabilizerOrder = 60 := by
  cases T <;> decide

/-- Each recorded projective-count value equals the displayed polynomial in its recorded field
order.  No deep-hole locus is defined in the statement. -/
theorem certifiedDeepProjectiveCount (T : TransitiveConicPhase) :
    let profile := certifiedPhaseProfile T
    profile.deepProjectiveCount =
      (profile.fieldOrder - 5) * (profile.fieldOrder - 9) := by
  cases T <;> decide

/-- The recorded field-order values in phase-label order. -/
theorem certifiedFieldOrders :
    allPhases.map (fun T => (certifiedPhaseProfile T).fieldOrder) = [5, 9, 11, 19, 29, 59] := by
  decide

/-- The recorded scheme-rank values in phase-label order. -/
theorem certifiedSchemeRanks :
    allPhases.map (fun T => (certifiedPhaseProfile T).schemeRank) = [4, 6, 8, 14, 24, 76] := by
  decide

/-- The recorded point-stabilizer orders in phase-label order. -/
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

/-- Labels for the three externally supplied small-field fusion-rank lists.  The type name records
the intended provenance; exhaustiveness is not formalized in this module. -/
inductive ExhaustiveFusionPilot
  | q5
  | q9
  | q11
  deriving DecidableEq, Repr

/-- The externally supplied lists of fusion ranks for three small phase labels. -/
def fusionRanks : ExhaustiveFusionPilot → List ℕ
  | .q5 => [2, 4]
  | .q9 => [2, 4, 6]
  | .q11 => [2, 4, 6, 8]

/-- The three recorded fusion-rank lists unfold to the displayed values.  This is not an exhaustive
Bannai--Muzychuk theorem because no fusion predicate or partition domain occurs in the statement. -/
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
