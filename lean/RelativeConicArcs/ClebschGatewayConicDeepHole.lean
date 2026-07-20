import Mathlib.Tactic

/-!
# A field-order bound and recorded finite-classification profiles

The geometric input to the first theorem is the incidence inequality obtained by covering the
`q^2` points off a nonsingular conic with the fifteen secants of a six-arc.  The exact finite-field
geometry represented by `recordedProfiles` is not checked in this module: the profiles are literal
external-input records.  Lean proves arithmetic and Boolean statements about those records only.
In particular, no theorem here connects them to semilinear equivalence classes or proves that they
exhaust a geometric census.
-/

namespace RelativeConicArcs
namespace ClebschGateway
namespace ConicDeepHole

/-- If fifteen lines, each contributing at most `q+1` off-conic points, cover all `q^2`
off-conic points, then the field order is at most fifteen. -/
theorem fieldOrder_le_fifteen (q : ℕ) (cover : q * q ≤ 15 * (q + 1)) : q ≤ 15 := by
  by_contra h
  have h16 : 16 ≤ q := by omega
  have growth : 16 * q ≤ q * q := Nat.mul_le_mul_right q h16
  omega

/-- The invariant fields retained from an external finite classification.  Values of this type do
not by themselves carry a witness or a proof of their geometric meaning. -/
structure RecordedProfile where
  locusSize : ℕ
  containingNonsingularConics : ℕ
  semilinearStabilizerOrder : ℕ
  fullConic : Bool
  deriving DecidableEq, Repr

/-- The four externally supplied profile rows.  This definition records claimed output; it is not a
checker for semilinear classes or completeness of the underlying search. -/
def recordedProfiles (q : ℕ) : List RecordedProfile :=
  if q = 8 then
    [⟨4, 6, 12, false⟩]
  else if q = 9 then
    [⟨6, 1, 6, false⟩, ⟨7, 1, 6, false⟩]
  else if q = 11 then
    [⟨12, 1, 60, true⟩]
  else
    []

/-- The recorded list is empty away from the three field orders represented in the definition. -/
theorem recordedProfiles_eq_nil_of_other
    (q : ℕ) (h8 : q ≠ 8) (h9 : q ≠ 9) (h11 : q ≠ 11) :
    recordedProfiles q = [] := by
  simp [recordedProfiles, h8, h9, h11]

/-- The recorded profile list at field-order label eight. -/
theorem recordedProfiles_8 :
    recordedProfiles 8 = [⟨4, 6, 12, false⟩] := by
  decide

/-- The recorded profile list at field-order label nine. -/
theorem recordedProfiles_9 :
    recordedProfiles 9 = [⟨6, 1, 6, false⟩, ⟨7, 1, 6, false⟩] := by
  decide

/-- The recorded profile list at field-order label eleven. -/
theorem recordedProfiles_11 :
    recordedProfiles 11 = [⟨12, 1, 60, true⟩] := by
  decide

/-- Among the recorded rows, the Boolean `fullConic` field occurs exactly at `q=11`.  This theorem
does not establish that the rows form a complete geometric census. -/
theorem recordedFullConicField (q : ℕ) :
    (recordedProfiles q).any (fun profile => profile.fullConic) = true ↔ q = 11 := by
  simp only [recordedProfiles]
  split_ifs with h8 h9 h11 <;> simp_all

#print axioms fieldOrder_le_fifteen
#print axioms recordedProfiles_eq_nil_of_other
#print axioms recordedFullConicField

end ConicDeepHole
end ClebschGateway
end RelativeConicArcs
