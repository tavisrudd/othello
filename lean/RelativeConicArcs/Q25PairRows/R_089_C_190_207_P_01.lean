import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_89_190 : RowResult ⟨89, by decide⟩ ⟨190, by decide⟩ := by
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨89, by decide⟩) (orbitCodeOfNumber ⟨190, by decide⟩) 2 4 6)

theorem row_89_191 : RowResult ⟨89, by decide⟩ ⟨191, by decide⟩ := by
  have _previous := row_89_190
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_89_192 : RowResult ⟨89, by decide⟩ ⟨192, by decide⟩ := by
  have _previous := row_89_191
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_89_193 : RowResult ⟨89, by decide⟩ ⟨193, by decide⟩ := by
  have _previous := row_89_192
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_89_194 : RowResult ⟨89, by decide⟩ ⟨194, by decide⟩ := by
  have _previous := row_89_193
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨89, by decide⟩) (orbitCodeOfNumber ⟨194, by decide⟩) 1 4 7)

theorem row_89_195 : RowResult ⟨89, by decide⟩ ⟨195, by decide⟩ := by
  have _previous := row_89_194
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨89, by decide⟩) (orbitCodeOfNumber ⟨195, by decide⟩) 1 2 7)

theorem row_89_196 : RowResult ⟨89, by decide⟩ ⟨196, by decide⟩ := by
  have _previous := row_89_195
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨89, by decide⟩) (orbitCodeOfNumber ⟨196, by decide⟩) 2 4 7)

theorem row_89_197 : RowResult ⟨89, by decide⟩ ⟨197, by decide⟩ := by
  have _previous := row_89_196
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_89_198 : RowResult ⟨89, by decide⟩ ⟨198, by decide⟩ := by
  have _previous := row_89_197
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_89_199 : RowResult ⟨89, by decide⟩ ⟨199, by decide⟩ := by
  have _previous := row_89_198
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_89_200 : RowResult ⟨89, by decide⟩ ⟨200, by decide⟩ := by
  have _previous := row_89_199
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨89, by decide⟩) (orbitCodeOfNumber ⟨200, by decide⟩) 1 6 7)

theorem row_89_201 : RowResult ⟨89, by decide⟩ ⟨201, by decide⟩ := by
  have _previous := row_89_200
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨89, by decide⟩) (orbitCodeOfNumber ⟨201, by decide⟩) 1 6 7)

theorem row_89_202 : RowResult ⟨89, by decide⟩ ⟨202, by decide⟩ := by
  have _previous := row_89_201
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨89, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) 1 6 7)

theorem row_89_203 : RowResult ⟨89, by decide⟩ ⟨203, by decide⟩ := by
  have _previous := row_89_202
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨89, by decide⟩) (orbitCodeOfNumber ⟨203, by decide⟩) 1 6 7)

theorem row_89_204 : RowResult ⟨89, by decide⟩ ⟨204, by decide⟩ := by
  have _previous := row_89_203
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨89, by decide⟩) (orbitCodeOfNumber ⟨204, by decide⟩) 1 6 7)

theorem row_89_205 : RowResult ⟨89, by decide⟩ ⟨205, by decide⟩ := by
  have _previous := row_89_204
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨89, by decide⟩) (orbitCodeOfNumber ⟨205, by decide⟩) 1 2 6)

theorem row_89_206 : RowResult ⟨89, by decide⟩ ⟨206, by decide⟩ := by
  have _previous := row_89_205
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨89, by decide⟩) (orbitCodeOfNumber ⟨206, by decide⟩) 2 5 7)

theorem row_89_207 : RowResult ⟨89, by decide⟩ ⟨207, by decide⟩ := by
  have _previous := row_89_206
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨89, by decide⟩) (orbitCodeOfNumber ⟨207, by decide⟩) 4 5 6)

end RelativeConicArcs.Q25PairCertificate
