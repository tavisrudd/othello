import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_31_191 : RowResult ⟨31, by decide⟩ ⟨191, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_31_192 : RowResult ⟨31, by decide⟩ ⟨192, by decide⟩ := by
  have _previous := row_31_191
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_31_193 : RowResult ⟨31, by decide⟩ ⟨193, by decide⟩ := by
  have _previous := row_31_192
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_31_194 : RowResult ⟨31, by decide⟩ ⟨194, by decide⟩ := by
  have _previous := row_31_193
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_31_195 : RowResult ⟨31, by decide⟩ ⟨195, by decide⟩ := by
  have _previous := row_31_194
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨31, by decide⟩) (orbitCodeOfNumber ⟨195, by decide⟩) 1 2 7)

theorem row_31_196 : RowResult ⟨31, by decide⟩ ⟨196, by decide⟩ := by
  have _previous := row_31_195
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨31, by decide⟩) (orbitCodeOfNumber ⟨196, by decide⟩) 1 4 7)

theorem row_31_197 : RowResult ⟨31, by decide⟩ ⟨197, by decide⟩ := by
  have _previous := row_31_196
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_31_198 : RowResult ⟨31, by decide⟩ ⟨198, by decide⟩ := by
  have _previous := row_31_197
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨31, by decide⟩) (orbitCodeOfNumber ⟨198, by decide⟩) 2 5 7)

theorem row_31_199 : RowResult ⟨31, by decide⟩ ⟨199, by decide⟩ := by
  have _previous := row_31_198
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_31_200 : RowResult ⟨31, by decide⟩ ⟨200, by decide⟩ := by
  have _previous := row_31_199
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨31, by decide⟩) (orbitCodeOfNumber ⟨200, by decide⟩) 1 6 7)

theorem row_31_201 : RowResult ⟨31, by decide⟩ ⟨201, by decide⟩ := by
  have _previous := row_31_200
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨31, by decide⟩) (orbitCodeOfNumber ⟨201, by decide⟩) 1 6 7)

theorem row_31_202 : RowResult ⟨31, by decide⟩ ⟨202, by decide⟩ := by
  have _previous := row_31_201
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨31, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) 1 6 7)

theorem row_31_203 : RowResult ⟨31, by decide⟩ ⟨203, by decide⟩ := by
  have _previous := row_31_202
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨31, by decide⟩) (orbitCodeOfNumber ⟨203, by decide⟩) 1 6 7)

theorem row_31_204 : RowResult ⟨31, by decide⟩ ⟨204, by decide⟩ := by
  have _previous := row_31_203
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨31, by decide⟩) (orbitCodeOfNumber ⟨204, by decide⟩) 1 6 7)

theorem row_31_205 : RowResult ⟨31, by decide⟩ ⟨205, by decide⟩ := by
  have _previous := row_31_204
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨31, by decide⟩) (orbitCodeOfNumber ⟨205, by decide⟩) 1 2 6)

theorem row_31_206 : RowResult ⟨31, by decide⟩ ⟨206, by decide⟩ := by
  have _previous := row_31_205
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨31, by decide⟩) (orbitCodeOfNumber ⟨206, by decide⟩) 1 4 6)

end RelativeConicArcs.Q25PairCertificate
