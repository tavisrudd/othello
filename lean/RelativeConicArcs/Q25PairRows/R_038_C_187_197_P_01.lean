import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_38_187 : RowResult ⟨38, by decide⟩ ⟨187, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

theorem row_38_188 : RowResult ⟨38, by decide⟩ ⟨188, by decide⟩ := by
  have _previous := row_38_187
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨38, by decide⟩) (orbitCodeOfNumber ⟨188, by decide⟩) 1 4 6)

theorem row_38_189 : RowResult ⟨38, by decide⟩ ⟨189, by decide⟩ := by
  have _previous := row_38_188
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_38_190 : RowResult ⟨38, by decide⟩ ⟨190, by decide⟩ := by
  have _previous := row_38_189
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_38_191 : RowResult ⟨38, by decide⟩ ⟨191, by decide⟩ := by
  have _previous := row_38_190
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_38_192 : RowResult ⟨38, by decide⟩ ⟨192, by decide⟩ := by
  have _previous := row_38_191
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨38, by decide⟩) (orbitCodeOfNumber ⟨192, by decide⟩) 2 5 6)

theorem row_38_193 : RowResult ⟨38, by decide⟩ ⟨193, by decide⟩ := by
  have _previous := row_38_192
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨38, by decide⟩) (orbitCodeOfNumber ⟨193, by decide⟩) 1 4 7)

theorem row_38_194 : RowResult ⟨38, by decide⟩ ⟨194, by decide⟩ := by
  have _previous := row_38_193
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_38_195 : RowResult ⟨38, by decide⟩ ⟨195, by decide⟩ := by
  have _previous := row_38_194
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨38, by decide⟩) (orbitCodeOfNumber ⟨195, by decide⟩) 1 2 7)

theorem row_38_196 : RowResult ⟨38, by decide⟩ ⟨196, by decide⟩ := by
  have _previous := row_38_195
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨38, by decide⟩) (orbitCodeOfNumber ⟨196, by decide⟩) 2 4 6)

theorem row_38_197 : RowResult ⟨38, by decide⟩ ⟨197, by decide⟩ := by
  have _previous := row_38_196
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
