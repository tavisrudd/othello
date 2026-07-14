import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_34_132 : RowResult ⟨34, by decide⟩ ⟨132, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

theorem row_34_133 : RowResult ⟨34, by decide⟩ ⟨133, by decide⟩ := by
  have _previous := row_34_132
  exact Or.inr ⟨orbitCodeOfNumber ⟨60, by decide⟩, by decide⟩

theorem row_34_134 : RowResult ⟨34, by decide⟩ ⟨134, by decide⟩ := by
  have _previous := row_34_133
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨34, by decide⟩) (orbitCodeOfNumber ⟨134, by decide⟩) 1 4 6)

end RelativeConicArcs.Q25PairCertificate
