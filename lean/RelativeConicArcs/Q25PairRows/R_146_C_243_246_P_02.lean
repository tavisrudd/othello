import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_146_243 : RowResult ⟨146, by decide⟩ ⟨243, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_146_244 : RowResult ⟨146, by decide⟩ ⟨244, by decide⟩ := by
  have _previous := row_146_243
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_146_245 : RowResult ⟨146, by decide⟩ ⟨245, by decide⟩ := by
  have _previous := row_146_244
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨146, by decide⟩) (orbitCodeOfNumber ⟨245, by decide⟩) 1 2 7)

theorem row_146_246 : RowResult ⟨146, by decide⟩ ⟨246, by decide⟩ := by
  have _previous := row_146_245
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨146, by decide⟩) (orbitCodeOfNumber ⟨246, by decide⟩) 1 4 6)

end RelativeConicArcs.Q25PairCertificate
