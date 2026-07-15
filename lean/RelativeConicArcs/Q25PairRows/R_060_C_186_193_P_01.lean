import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_60_186 : RowResult ⟨60, by decide⟩ ⟨186, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_60_187 : RowResult ⟨60, by decide⟩ ⟨187, by decide⟩ := by
  have _previous := row_60_186
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_60_188 : RowResult ⟨60, by decide⟩ ⟨188, by decide⟩ := by
  have _previous := row_60_187
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨60, by decide⟩) (orbitCodeOfNumber ⟨188, by decide⟩) 2 3 6)

theorem row_60_189 : RowResult ⟨60, by decide⟩ ⟨189, by decide⟩ := by
  have _previous := row_60_188
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_60_190 : RowResult ⟨60, by decide⟩ ⟨190, by decide⟩ := by
  have _previous := row_60_189
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨60, by decide⟩) (orbitCodeOfNumber ⟨190, by decide⟩) 1 4 7)

theorem row_60_191 : RowResult ⟨60, by decide⟩ ⟨191, by decide⟩ := by
  have _previous := row_60_190
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_60_192 : RowResult ⟨60, by decide⟩ ⟨192, by decide⟩ := by
  have _previous := row_60_191
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_60_193 : RowResult ⟨60, by decide⟩ ⟨193, by decide⟩ := by
  have _previous := row_60_192
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
