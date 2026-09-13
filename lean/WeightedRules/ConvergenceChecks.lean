import WeightedRules.ConvergenceReflection
import WeightedRules.ConvergenceSharpness

/-!
# Boundary cases for finite convergence

Kernel reduction checks an empty program, unsupported zero-cost cycles,
repeated rule factors, a chain attaining the scalar-round bound, and arithmetic
saturation. These controls accompany the universally quantified convergence
theorem; they do not substitute for its proof.
-/

namespace WeightedRules

/-- The empty program is accepted with zero rounds and an empty value list. -/
theorem empty_certificate_accepted : checkCertificate (zeroChainProgram 0) 0 [] = true := by
  decide

/-- One unsupported self-product has both infinity and zero as numerical fixed
points; its least information fixed point is infinity. -/
def unsupportedCycle : Program Cost 1 :=
  ⟨fun _ => infinity, [⟨0, 0, 0⟩]⟩

/-- Infinity is accepted for an unsupported cycle, while an unsupported zero
valuation fails the replay check despite satisfying the fixed-point equation. -/
theorem unsupported_cycle_controls :
    checkCertificate unsupportedCycle 1 [infinity] = true ∧
    step boundedMinPlus unsupportedCycle (fun _ => ⟨0, by decide⟩) =
      (fun _ => ⟨0, by decide⟩) ∧
    checkCertificate unsupportedCycle 1 [⟨0, by decide⟩] = false := by
  decide

/-- A three-coordinate chain needs its third round, including a rule with two
copies of a factor that changed in the preceding round. -/
theorem repeated_factor_controls :
    checkCertificate (zeroChainProgram 3) 3
      [⟨0, by decide⟩, ⟨0, by decide⟩, ⟨0, by decide⟩] = true ∧
    checkCertificate (zeroChainProgram 3) 2
      [⟨0, by decide⟩, ⟨0, by decide⟩, infinity] = false := by
  decide

/-- A product of two represented costs `2^31` saturates at infinity. -/
def saturatingProduct : Program Cost 2 :=
  ⟨fun i => if i.val = 0 then ⟨2147483648, by decide⟩ else infinity,
    [⟨1, 0, 0⟩]⟩

/-- Saturation preserves the fixed value at the sentinel; the checker rejects
the zero value that wrapping machine addition would produce. -/
theorem saturation_controls :
    checkCertificate saturatingProduct 2 [⟨2147483648, by decide⟩, infinity] = true ∧
    checkCertificate saturatingProduct 2
      [⟨2147483648, by decide⟩, ⟨0, by decide⟩] = false := by
  decide

end WeightedRules
