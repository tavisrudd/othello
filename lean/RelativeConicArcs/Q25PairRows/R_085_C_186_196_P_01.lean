import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_85_186 : RowResult ⟨85, by decide⟩ ⟨186, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_85_187 : RowResult ⟨85, by decide⟩ ⟨187, by decide⟩ := by
  have _previous := row_85_186
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨85, by decide⟩) (orbitCodeOfNumber ⟨187, by decide⟩) 4 5 6)

theorem row_85_188 : RowResult ⟨85, by decide⟩ ⟨188, by decide⟩ := by
  have _previous := row_85_187
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨85, by decide⟩) (orbitCodeOfNumber ⟨188, by decide⟩) 2 3 6)

theorem row_85_189 : RowResult ⟨85, by decide⟩ ⟨189, by decide⟩ := by
  have _previous := row_85_188
  exact Or.inr ⟨orbitCodeOfNumber ⟨37, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_85_190 : RowResult ⟨85, by decide⟩ ⟨190, by decide⟩ := by
  have _previous := row_85_189
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨85, by decide⟩) (orbitCodeOfNumber ⟨190, by decide⟩) 1 4 7)

theorem row_85_191 : RowResult ⟨85, by decide⟩ ⟨191, by decide⟩ := by
  have _previous := row_85_190
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_85_192 : RowResult ⟨85, by decide⟩ ⟨192, by decide⟩ := by
  have _previous := row_85_191
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨85, by decide⟩) (orbitCodeOfNumber ⟨192, by decide⟩) 2 4 7)

theorem row_85_193 : RowResult ⟨85, by decide⟩ ⟨193, by decide⟩ := by
  have _previous := row_85_192
  exact Or.inr ⟨orbitCodeOfNumber ⟨36, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_85_194 : RowResult ⟨85, by decide⟩ ⟨194, by decide⟩ := by
  have _previous := row_85_193
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨241, by decide⟩, by decide⟩

theorem row_85_195 : RowResult ⟨85, by decide⟩ ⟨195, by decide⟩ := by
  have _previous := row_85_194
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨85, by decide⟩) (orbitCodeOfNumber ⟨195, by decide⟩) 1 2 7)

theorem row_85_196 : RowResult ⟨85, by decide⟩ ⟨196, by decide⟩ := by
  have _previous := row_85_195
  exact Or.inr ⟨orbitCodeOfNumber ⟨37, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
