import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_163_189 : RowResult ⟨163, by decide⟩ ⟨189, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨246, by decide⟩, by decide⟩

theorem row_163_190 : RowResult ⟨163, by decide⟩ ⟨190, by decide⟩ := by
  have _previous := row_163_189
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_163_191 : RowResult ⟨163, by decide⟩ ⟨191, by decide⟩ := by
  have _previous := row_163_190
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_163_192 : RowResult ⟨163, by decide⟩ ⟨192, by decide⟩ := by
  have _previous := row_163_191
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨163, by decide⟩) (orbitCodeOfNumber ⟨192, by decide⟩) 2 4 6)

theorem row_163_193 : RowResult ⟨163, by decide⟩ ⟨193, by decide⟩ := by
  have _previous := row_163_192
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨163, by decide⟩) (orbitCodeOfNumber ⟨193, by decide⟩) 1 4 7)

theorem row_163_194 : RowResult ⟨163, by decide⟩ ⟨194, by decide⟩ := by
  have _previous := row_163_193
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨246, by decide⟩, by decide⟩

theorem row_163_195 : RowResult ⟨163, by decide⟩ ⟨195, by decide⟩ := by
  have _previous := row_163_194
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨163, by decide⟩) (orbitCodeOfNumber ⟨195, by decide⟩) 1 2 7)

theorem row_163_196 : RowResult ⟨163, by decide⟩ ⟨196, by decide⟩ := by
  have _previous := row_163_195
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_163_197 : RowResult ⟨163, by decide⟩ ⟨197, by decide⟩ := by
  have _previous := row_163_196
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_163_198 : RowResult ⟨163, by decide⟩ ⟨198, by decide⟩ := by
  have _previous := row_163_197
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨163, by decide⟩) (orbitCodeOfNumber ⟨198, by decide⟩) 4 5 6)

theorem row_163_199 : RowResult ⟨163, by decide⟩ ⟨199, by decide⟩ := by
  have _previous := row_163_198
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨163, by decide⟩) (orbitCodeOfNumber ⟨199, by decide⟩) 2 5 7)

theorem row_163_200 : RowResult ⟨163, by decide⟩ ⟨200, by decide⟩ := by
  have _previous := row_163_199
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨163, by decide⟩) (orbitCodeOfNumber ⟨200, by decide⟩) 1 6 7)

theorem row_163_201 : RowResult ⟨163, by decide⟩ ⟨201, by decide⟩ := by
  have _previous := row_163_200
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨163, by decide⟩) (orbitCodeOfNumber ⟨201, by decide⟩) 1 6 7)

theorem row_163_202 : RowResult ⟨163, by decide⟩ ⟨202, by decide⟩ := by
  have _previous := row_163_201
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨163, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) 1 6 7)

theorem row_163_203 : RowResult ⟨163, by decide⟩ ⟨203, by decide⟩ := by
  have _previous := row_163_202
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨163, by decide⟩) (orbitCodeOfNumber ⟨203, by decide⟩) 1 6 7)

theorem row_163_204 : RowResult ⟨163, by decide⟩ ⟨204, by decide⟩ := by
  have _previous := row_163_203
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨163, by decide⟩) (orbitCodeOfNumber ⟨204, by decide⟩) 1 6 7)

theorem row_163_205 : RowResult ⟨163, by decide⟩ ⟨205, by decide⟩ := by
  have _previous := row_163_204
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨163, by decide⟩) (orbitCodeOfNumber ⟨205, by decide⟩) 1 2 6)

end RelativeConicArcs.Q25PairCertificate
