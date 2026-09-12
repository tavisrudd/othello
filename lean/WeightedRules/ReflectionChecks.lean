import WeightedRules.Reflection

/-!
# Certificate rejection controls

Kernel reduction checks finite positive and negative examples. A one-coordinate
self-loop has many fixed costs, but its least information fixed point is infinity;
a fabricated zero is rejected even though it satisfies the equation. Coverage,
round and program mismatches are separate checks. These controls use no external
process or native evaluation.
-/

namespace WeightedRules

private def loopProgram : Program Cost 1 :=
  ⟨fun _ => infinity, [⟨0, 0, 0⟩]⟩

example : checkCertificate loopProgram 0 [infinity] = true := by decide
example : checkCertificate loopProgram 1 [⟨0, by decide⟩] = false := by decide
example : checkCertificate loopProgram 0 [] = false := by decide
example : checkCertificate loopProgram 0 [infinity, infinity] = false := by decide
example : checkCertificate loopProgram 2 [infinity] = false := by decide

private def baseProgram : Program Cost 1 := ⟨fun _ => ⟨7, by decide⟩, []⟩

example : checkCertificate baseProgram 1 [⟨7, by decide⟩] = true := by decide
example : checkCertificate baseProgram 0 [⟨7, by decide⟩] = false := by decide
example : checkCertificate baseProgram 1 [infinity] = false := by decide
example : checkCertificate baseProgram 1 [⟨6, by decide⟩] = false := by decide

end WeightedRules
