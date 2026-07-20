import Mathlib.Tactic

/-!
# C399: the rank-three Coxeter-number conic phase

The symbolic identities explaining the field `q = h+1` are kernel proofs.  The exact A3/B3
incidence ledgers, finite-field conic equalities, group normalizers, and the inherited H3 data are
checked by the adjacent external C399 certificate.  This module freezes their compact
paper-facing interface and keeps that trust boundary explicit.
-/

namespace RelativeConicArcs
namespace ClebschGateway
namespace CoxeterPhase

/-- The irreducible finite real reflection groups of rank three. -/
inductive RankThreeType
  | A3
  | B3
  | H3
  deriving DecidableEq, Repr

open RankThreeType

def allTypes : List RankThreeType := [.A3, .B3, .H3]

def coxeterNumber : RankThreeType → ℕ
  | .A3 => 4
  | .B3 => 6
  | .H3 => 10

def middleExponent : RankThreeType → ℕ
  | .A3 => 2
  | .B3 => 3
  | .H3 => 5

def mirrorCount : RankThreeType → ℕ
  | .A3 => 6
  | .B3 => 9
  | .H3 => 15

def conicField : RankThreeType → ℕ := fun T => coxeterNumber T + 1

/-- Projective arrangement-complement length on a good reduction. -/
def complementLength (T : RankThreeType) (q : ℕ) : ℕ :=
  (q - middleExponent T) * (q - (coxeterNumber T - 1))

/-- Minimum distance of the dimension-three complement evaluation code. -/
def complementDistance (T : RankThreeType) (q : ℕ) : ℕ :=
  (q - (middleExponent T + 1)) * (q - (coxeterNumber T - 1))

/-- The common algebra behind the `q=h+1` complement count, written with `h=2e`. -/
theorem coxeterConicLengthIdentity (e : ℤ) :
    ((2 * e + 1) - e) * ((2 * e + 1) - (2 * e - 1)) = 2 * e + 2 := by
  ring

/-- The common distance identity at the same phase. -/
theorem coxeterConicDistanceIdentity (e : ℤ) :
    ((2 * e + 1) - (e + 1)) * ((2 * e + 1) - (2 * e - 1)) = 2 * e := by
  ring

theorem coxeterNumber_eq_twice_middleExponent (T : RankThreeType) :
    coxeterNumber T = 2 * middleExponent T := by
  cases T <;> decide

theorem twice_mirrorCount_eq_three_times_coxeterNumber (T : RankThreeType) :
    2 * mirrorCount T = 3 * coxeterNumber T := by
  cases T <;> decide

/-- At the Coxeter-number field the complement has exactly `q+1` points. -/
theorem conicPhase_length (T : RankThreeType) :
    complementLength T (conicField T) = conicField T + 1 := by
  cases T <;> decide

/-- At the Coxeter-number field the complement-code distance is exactly `q-1`. -/
theorem conicPhase_distance (T : RankThreeType) :
    complementDistance T (conicField T) = conicField T - 1 := by
  cases T <;> decide

structure CertifiedPhaseProfile where
  fieldOrder : ℕ
  complementLength : ℕ
  codeDistance : ℕ
  projectiveCoxeterOrder : ℕ
  fullConicStabilizerOrder : ℕ
  coxeterNormalizerOrder : ℕ
  conjugateDecorationCount : ℕ
  deriving DecidableEq, Repr

/-- Compact output of the exact A3/B3 computation and inherited H3 certificates. -/
def certifiedPhaseProfile : RankThreeType → CertifiedPhaseProfile
  | .A3 => ⟨5, 6, 4, 24, 120, 24, 5⟩
  | .B3 => ⟨7, 8, 6, 24, 336, 24, 14⟩
  | .H3 => ⟨11, 12, 10, 60, 1320, 60, 22⟩

theorem certifiedProfile_matches_symbolicPhase (T : RankThreeType) :
    let profile := certifiedPhaseProfile T
    profile.fieldOrder = conicField T ∧
      profile.complementLength = complementLength T profile.fieldOrder ∧
      profile.codeDistance = complementDistance T profile.fieldOrder := by
  cases T <;> decide

theorem certifiedFullConicOrder (T : RankThreeType) :
    let profile := certifiedPhaseProfile T
    profile.fullConicStabilizerOrder =
      profile.fieldOrder * (profile.fieldOrder ^ 2 - 1) := by
  cases T <;> decide

theorem certifiedDecorationIndex (T : RankThreeType) :
    let profile := certifiedPhaseProfile T
    profile.coxeterNormalizerOrder * profile.conjugateDecorationCount =
      profile.fullConicStabilizerOrder := by
  cases T <;> decide

theorem certifiedDecorationCounts :
    allTypes.map (fun T => (certifiedPhaseProfile T).conjugateDecorationCount) = [5, 14, 22] := by
  decide

structure RankFourGateProfile where
  candidateFieldOrder : ℕ
  fieldExists : Bool
  complementSize : Option ℕ
  quadricSurfaceSizes : List ℕ
  deriving DecidableEq, Repr

/-- The complete first higher-rank point-count gate. -/
def rankFourGateProfiles : List RankFourGateProfile :=
  [ ⟨6, false, none, []⟩,
    ⟨9, true, some 48, [82, 100]⟩,
    ⟨7, true, some 32, [50, 64]⟩,
    ⟨13, true, some 96, [170, 196]⟩,
    ⟨31, true, some 480, [962, 1024]⟩ ]

/-- No irreducible rank-four candidate passes the `q=h+1` quadric-cardinality gate. -/
theorem rankFourGate_closed :
    rankFourGateProfiles.all (fun profile =>
      match profile.complementSize with
      | none => true
      | some size => !(profile.quadricSurfaceSizes.contains size)) = true := by
  decide

#print axioms coxeterConicLengthIdentity
#print axioms coxeterConicDistanceIdentity
#print axioms conicPhase_length
#print axioms certifiedDecorationIndex
#print axioms rankFourGate_closed

end CoxeterPhase
end ClebschGateway
end RelativeConicArcs
