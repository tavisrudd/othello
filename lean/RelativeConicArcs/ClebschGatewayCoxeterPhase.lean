import Mathlib.Tactic

/-!
# Arithmetic of the rank-three Coxeter-number conic phase

The symbolic identities at `q = h+1` are kernel proofs about the formulas defined below.  The
`A3`, `B3`, and `H3` profile values and the rank-four cardinality records are literal external
inputs.  This module does not derive arrangement complements, conic equalities, group normalizers,
or the completeness of the rank-four candidate list.  Its theorems about those records establish
only arithmetic consistency with the displayed formulas.
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

/-- The three irreducible rank-three Coxeter types represented by this interface. -/
def allTypes : List RankThreeType := [.A3, .B3, .H3]

/-- The Coxeter number for each of the three displayed types. -/
def coxeterNumber : RankThreeType → ℕ
  | .A3 => 4
  | .B3 => 6
  | .H3 => 10

/-- The middle exponent for each displayed rank-three type. -/
def middleExponent : RankThreeType → ℕ
  | .A3 => 2
  | .B3 => 3
  | .H3 => 5

/-- The number of projective reflection mirrors in each displayed type. -/
def mirrorCount : RankThreeType → ℕ
  | .A3 => 6
  | .B3 => 9
  | .H3 => 15

/-- The integer `h+1`, where `h` is the displayed Coxeter number.  This definition does not assert
that a finite field of that order exists. -/
def conicField : RankThreeType → ℕ := fun T => coxeterNumber T + 1

/-- The proposed projective arrangement-complement length formula.  Its geometric validity is not
proved in this module. -/
def complementLength (T : RankThreeType) (q : ℕ) : ℕ :=
  (q - middleExponent T) * (q - (coxeterNumber T - 1))

/-- The proposed minimum-distance formula for the complement evaluation code.  Its coding-theoretic
validity is not proved in this module. -/
def complementDistance (T : RankThreeType) (q : ℕ) : ℕ :=
  (q - (middleExponent T + 1)) * (q - (coxeterNumber T - 1))

/-- The common algebra behind the displayed `q=h+1` length formula, written with `h=2e`. -/
theorem coxeterConicLengthIdentity (e : ℤ) :
    ((2 * e + 1) - e) * ((2 * e + 1) - (2 * e - 1)) = 2 * e + 2 := by
  ring

/-- The common algebra behind the displayed distance formula at the same phase. -/
theorem coxeterConicDistanceIdentity (e : ℤ) :
    ((2 * e + 1) - (e + 1)) * ((2 * e + 1) - (2 * e - 1)) = 2 * e := by
  ring

/-- In the displayed rank-three table, the Coxeter number is twice the middle exponent. -/
theorem coxeterNumber_eq_twice_middleExponent (T : RankThreeType) :
    coxeterNumber T = 2 * middleExponent T := by
  cases T <;> decide

/-- In the displayed rank-three table, twice the mirror count is three times the Coxeter number. -/
theorem twice_mirrorCount_eq_three_times_coxeterNumber (T : RankThreeType) :
    2 * mirrorCount T = 3 * coxeterNumber T := by
  cases T <;> decide

/-- Substitution of `q=h+1` in the displayed length formula gives `q+1`. -/
theorem conicPhase_length (T : RankThreeType) :
    complementLength T (conicField T) = conicField T + 1 := by
  cases T <;> decide

/-- Substitution of `q=h+1` in the displayed distance formula gives `q-1`. -/
theorem conicPhase_distance (T : RankThreeType) :
    complementDistance T (conicField T) = conicField T - 1 := by
  cases T <;> decide

/-- Numeric fields retained from an external rank-three phase calculation.  A value carries no
geometric witness or certificate proof in Lean. -/
structure RecordedPhaseProfile where
  fieldOrder : ℕ
  complementLength : ℕ
  codeDistance : ℕ
  projectiveCoxeterOrder : ℕ
  fullConicStabilizerOrder : ℕ
  coxeterNormalizerOrder : ℕ
  conjugateDecorationCount : ℕ
  deriving DecidableEq, Repr

/-- The three externally supplied phase-profile rows. -/
def recordedPhaseProfile : RankThreeType → RecordedPhaseProfile
  | .A3 => ⟨5, 6, 4, 24, 120, 24, 5⟩
  | .B3 => ⟨7, 8, 6, 24, 336, 24, 14⟩
  | .H3 => ⟨11, 12, 10, 60, 1320, 60, 22⟩

/-- Each recorded field, length, and distance triple agrees arithmetically with the displayed
formulas. -/
theorem recordedProfile_matches_symbolicPhase (T : RankThreeType) :
    let profile := recordedPhaseProfile T
    profile.fieldOrder = conicField T ∧
      profile.complementLength = complementLength T profile.fieldOrder ∧
      profile.codeDistance = complementDistance T profile.fieldOrder := by
  cases T <;> decide

/-- Each recorded full-conic stabilizer order equals `q(q^2-1)` for its recorded `q`. -/
theorem recordedFullConicOrder (T : RankThreeType) :
    let profile := recordedPhaseProfile T
    profile.fullConicStabilizerOrder =
      profile.fieldOrder * (profile.fieldOrder ^ 2 - 1) := by
  cases T <;> decide

/-- Each recorded normalizer order times its recorded decoration count equals its recorded
full-conic stabilizer order. -/
theorem recordedDecorationIndex (T : RankThreeType) :
    let profile := recordedPhaseProfile T
    profile.coxeterNormalizerOrder * profile.conjugateDecorationCount =
      profile.fullConicStabilizerOrder := by
  cases T <;> decide

/-- The three recorded decoration-count values are 5, 14, and 22. -/
theorem recordedDecorationCounts :
    allTypes.map (fun T => (recordedPhaseProfile T).conjugateDecorationCount) = [5, 14, 22] := by
  decide

/-- One externally supplied rank-four cardinality comparison record. -/
structure RankFourCardinalityProfile where
  candidateFieldOrder : ℕ
  fieldExists : Bool
  complementSize : Option ℕ
  quadricSurfaceSizes : List ℕ
  deriving DecidableEq, Repr

/-- Five externally supplied rank-four cardinality records.  No theorem in this module proves that
the list exhausts a class of Coxeter types or reductions. -/
def recordedRankFourProfiles : List RankFourCardinalityProfile :=
  [ ⟨6, false, none, []⟩,
    ⟨9, true, some 48, [82, 100]⟩,
    ⟨7, true, some 32, [50, 64]⟩,
    ⟨13, true, some 96, [170, 196]⟩,
    ⟨31, true, some 480, [962, 1024]⟩ ]

/-- None of the five recorded complement sizes occurs in the corresponding recorded list of
quadric-surface sizes. -/
theorem recordedRankFourProfiles_fail_cardinality_test :
    recordedRankFourProfiles.all (fun profile =>
      match profile.complementSize with
      | none => true
      | some size => !(profile.quadricSurfaceSizes.contains size)) = true := by
  decide

#print axioms coxeterConicLengthIdentity
#print axioms coxeterConicDistanceIdentity
#print axioms conicPhase_length
#print axioms recordedDecorationIndex
#print axioms recordedRankFourProfiles_fail_cardinality_test

end CoxeterPhase
end ClebschGateway
end RelativeConicArcs
