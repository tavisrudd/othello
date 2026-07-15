import RelativeConicArcs.Q11A5PointOrbitsData

/-! Small semantic bridges for the Q11 A5 point-action data. -/

namespace RelativeConicArcs.Examples.Q11A5PointOrbits

open Q11Coding

private instance : Fact (Nat.Prime 11) := ⟨by decide⟩

/-- The local enumeration is the canonical Q11 projective enumeration used by the coding certificates. -/
theorem pointVec_eq_projectiveVec (p : PointIndex) : pointVec p = projectiveVec p := by
  unfold pointVec projectiveVec
  split_ifs <;> rfl

/-- The six indexed directions are exactly the existing certified witness columns. -/
theorem pointVec_witnessIndex (i : Fin 6) : pointVec (witnessIndex i) = witnessVec i := by
  fin_cases i <;> decide

end RelativeConicArcs.Examples.Q11A5PointOrbits
