import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_58_189 : RowResult ⟨58, by decide⟩ ⟨189, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_58_190 : RowResult ⟨58, by decide⟩ ⟨190, by decide⟩ := by
  have _previous := row_58_189
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_58_191 : RowResult ⟨58, by decide⟩ ⟨191, by decide⟩ := by
  have _previous := row_58_190
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_58_192 : RowResult ⟨58, by decide⟩ ⟨192, by decide⟩ := by
  have _previous := row_58_191
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_58_193 : RowResult ⟨58, by decide⟩ ⟨193, by decide⟩ := by
  have _previous := row_58_192
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_58_194 : RowResult ⟨58, by decide⟩ ⟨194, by decide⟩ := by
  have _previous := row_58_193
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨58, by decide⟩) (orbitCodeOfNumber ⟨194, by decide⟩) 2 4 7)

theorem row_58_195 : RowResult ⟨58, by decide⟩ ⟨195, by decide⟩ := by
  have _previous := row_58_194
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨58, by decide⟩) (orbitCodeOfNumber ⟨195, by decide⟩) 1 2 7)

theorem row_58_196 : RowResult ⟨58, by decide⟩ ⟨196, by decide⟩ := by
  have _previous := row_58_195
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
