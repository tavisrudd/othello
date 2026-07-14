import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_34_187 : RowResult ⟨34, by decide⟩ ⟨187, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨116, by decide⟩, by decide⟩

theorem row_34_188 : RowResult ⟨34, by decide⟩ ⟨188, by decide⟩ := by
  have _previous := row_34_187
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨34, by decide⟩) (orbitCodeOfNumber ⟨188, by decide⟩) 2 3 6)

theorem row_34_189 : RowResult ⟨34, by decide⟩ ⟨189, by decide⟩ := by
  have _previous := row_34_188
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨34, by decide⟩) (orbitCodeOfNumber ⟨189, by decide⟩) 2 4 6)

theorem row_34_190 : RowResult ⟨34, by decide⟩ ⟨190, by decide⟩ := by
  have _previous := row_34_189
  exact Or.inr ⟨orbitCodeOfNumber ⟨116, by decide⟩, by decide⟩

theorem row_34_191 : RowResult ⟨34, by decide⟩ ⟨191, by decide⟩ := by
  have _previous := row_34_190
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨34, by decide⟩) (orbitCodeOfNumber ⟨191, by decide⟩) 2 5 7)

theorem row_34_192 : RowResult ⟨34, by decide⟩ ⟨192, by decide⟩ := by
  have _previous := row_34_191
  exact Or.inr ⟨orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

theorem row_34_193 : RowResult ⟨34, by decide⟩ ⟨193, by decide⟩ := by
  have _previous := row_34_192
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨34, by decide⟩) (orbitCodeOfNumber ⟨193, by decide⟩) 2 4 7)

theorem row_34_194 : RowResult ⟨34, by decide⟩ ⟨194, by decide⟩ := by
  have _previous := row_34_193
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨34, by decide⟩) (orbitCodeOfNumber ⟨194, by decide⟩) 2 5 6)

theorem row_34_195 : RowResult ⟨34, by decide⟩ ⟨195, by decide⟩ := by
  have _previous := row_34_194
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨34, by decide⟩) (orbitCodeOfNumber ⟨195, by decide⟩) 1 2 7)

theorem row_34_196 : RowResult ⟨34, by decide⟩ ⟨196, by decide⟩ := by
  have _previous := row_34_195
  exact Or.inr ⟨orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

theorem row_34_197 : RowResult ⟨34, by decide⟩ ⟨197, by decide⟩ := by
  have _previous := row_34_196
  exact Or.inr ⟨orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

theorem row_34_198 : RowResult ⟨34, by decide⟩ ⟨198, by decide⟩ := by
  have _previous := row_34_197
  exact Or.inr ⟨orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

theorem row_34_199 : RowResult ⟨34, by decide⟩ ⟨199, by decide⟩ := by
  have _previous := row_34_198
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨34, by decide⟩) (orbitCodeOfNumber ⟨199, by decide⟩) 1 4 7)

theorem row_34_200 : RowResult ⟨34, by decide⟩ ⟨200, by decide⟩ := by
  have _previous := row_34_199
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨34, by decide⟩) (orbitCodeOfNumber ⟨200, by decide⟩) 1 6 7)

theorem row_34_201 : RowResult ⟨34, by decide⟩ ⟨201, by decide⟩ := by
  have _previous := row_34_200
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨34, by decide⟩) (orbitCodeOfNumber ⟨201, by decide⟩) 1 6 7)

theorem row_34_202 : RowResult ⟨34, by decide⟩ ⟨202, by decide⟩ := by
  have _previous := row_34_201
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨34, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) 1 6 7)

theorem row_34_203 : RowResult ⟨34, by decide⟩ ⟨203, by decide⟩ := by
  have _previous := row_34_202
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨34, by decide⟩) (orbitCodeOfNumber ⟨203, by decide⟩) 1 6 7)

theorem row_34_204 : RowResult ⟨34, by decide⟩ ⟨204, by decide⟩ := by
  have _previous := row_34_203
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨34, by decide⟩) (orbitCodeOfNumber ⟨204, by decide⟩) 1 6 7)

theorem row_34_205 : RowResult ⟨34, by decide⟩ ⟨205, by decide⟩ := by
  have _previous := row_34_204
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨34, by decide⟩) (orbitCodeOfNumber ⟨205, by decide⟩) 1 2 6)

end RelativeConicArcs.Q25PairCertificate
