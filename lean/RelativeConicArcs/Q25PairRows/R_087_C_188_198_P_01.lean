import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_87_188 : RowResult ⟨87, by decide⟩ ⟨188, by decide⟩ := by
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨87, by decide⟩) (orbitCodeOfNumber ⟨188, by decide⟩) 2 3 6)

theorem row_87_189 : RowResult ⟨87, by decide⟩ ⟨189, by decide⟩ := by
  have _previous := row_87_188
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨87, by decide⟩) (orbitCodeOfNumber ⟨189, by decide⟩) 4 5 6)

theorem row_87_190 : RowResult ⟨87, by decide⟩ ⟨190, by decide⟩ := by
  have _previous := row_87_189
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_87_191 : RowResult ⟨87, by decide⟩ ⟨191, by decide⟩ := by
  have _previous := row_87_190
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_87_192 : RowResult ⟨87, by decide⟩ ⟨192, by decide⟩ := by
  have _previous := row_87_191
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨87, by decide⟩) (orbitCodeOfNumber ⟨192, by decide⟩) 1 4 7)

theorem row_87_193 : RowResult ⟨87, by decide⟩ ⟨193, by decide⟩ := by
  have _previous := row_87_192
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_87_194 : RowResult ⟨87, by decide⟩ ⟨194, by decide⟩ := by
  have _previous := row_87_193
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_87_195 : RowResult ⟨87, by decide⟩ ⟨195, by decide⟩ := by
  have _previous := row_87_194
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨87, by decide⟩) (orbitCodeOfNumber ⟨195, by decide⟩) 1 2 7)

theorem row_87_196 : RowResult ⟨87, by decide⟩ ⟨196, by decide⟩ := by
  have _previous := row_87_195
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_87_197 : RowResult ⟨87, by decide⟩ ⟨197, by decide⟩ := by
  have _previous := row_87_196
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨87, by decide⟩) (orbitCodeOfNumber ⟨197, by decide⟩) 2 4 6)

theorem row_87_198 : RowResult ⟨87, by decide⟩ ⟨198, by decide⟩ := by
  have _previous := row_87_197
  exact Or.inr ⟨orbitCodeOfNumber ⟨38, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
