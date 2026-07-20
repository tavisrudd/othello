import Mathlib.Tactic

/-!
# C398: the universal field bound and checked finite-classification interface

The geometric input to the first theorem is the incidence inequality obtained by covering the
`q^2` points off a nonsingular conic with the fifteen secants of a six-arc.  The exact finite-field
geometry behind `certifiedProfiles` is checked by the adjacent external C398 certificate; this
module deliberately records its small paper-facing interface rather than pretending that a JSON
computation is a kernel proof.
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

/-- Compact output type for the exact semilinear certificate. -/
structure CertifiedProfile where
  locusSize : ℕ
  containingNonsingularConics : ℕ
  semilinearStabilizerOrder : ℕ
  fullConic : Bool
  deriving DecidableEq, Repr

/-- The four surviving semilinear classes.  Polynomial-basis coordinates and representatives stay
in the external certificate; only invariant profile data cross the paper-facing seam. -/
def certifiedProfiles (q : ℕ) : List CertifiedProfile :=
  if q = 8 then
    [⟨4, 6, 12, false⟩]
  else if q = 9 then
    [⟨6, 1, 6, false⟩, ⟨7, 1, 6, false⟩]
  else if q = 11 then
    [⟨12, 1, 60, true⟩]
  else
    []

theorem certifiedProfiles_eq_nil_of_other
    (q : ℕ) (h8 : q ≠ 8) (h9 : q ≠ 9) (h11 : q ≠ 11) :
    certifiedProfiles q = [] := by
  simp [certifiedProfiles, h8, h9, h11]

theorem certifiedProfiles_8 :
    certifiedProfiles 8 = [⟨4, 6, 12, false⟩] := by
  decide

theorem certifiedProfiles_9 :
    certifiedProfiles 9 = [⟨6, 1, 6, false⟩, ⟨7, 1, 6, false⟩] := by
  decide

theorem certifiedProfiles_11 :
    certifiedProfiles 11 = [⟨12, 1, 60, true⟩] := by
  decide

/-- The external census has a full-conic row exactly at `q=11`. -/
theorem certifiedFullConicField (q : ℕ) :
    (certifiedProfiles q).any (fun profile => profile.fullConic) = true ↔ q = 11 := by
  simp only [certifiedProfiles]
  split_ifs with h8 h9 h11 <;> simp_all

#print axioms fieldOrder_le_fifteen
#print axioms certifiedProfiles_eq_nil_of_other
#print axioms certifiedFullConicField

end ConicDeepHole
end ClebschGateway
end RelativeConicArcs
