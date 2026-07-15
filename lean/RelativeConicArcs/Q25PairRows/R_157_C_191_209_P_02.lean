import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_157_191 : RowResult ⟨157, by decide⟩ ⟨191, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_157_192 : RowResult ⟨157, by decide⟩ ⟨192, by decide⟩ := by
  have _previous := row_157_191
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_157_193 : RowResult ⟨157, by decide⟩ ⟨193, by decide⟩ := by
  have _previous := row_157_192
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_157_194 : RowResult ⟨157, by decide⟩ ⟨194, by decide⟩ := by
  have _previous := row_157_193
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_157_195 : RowResult ⟨157, by decide⟩ ⟨195, by decide⟩ := by
  have _previous := row_157_194
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨157, by decide⟩) (orbitCodeOfNumber ⟨195, by decide⟩) 1 2 7)

theorem row_157_196 : RowResult ⟨157, by decide⟩ ⟨196, by decide⟩ := by
  have _previous := row_157_195
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨157, by decide⟩) (orbitCodeOfNumber ⟨196, by decide⟩) 2 5 7)

theorem row_157_197 : RowResult ⟨157, by decide⟩ ⟨197, by decide⟩ := by
  have _previous := row_157_196
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨157, by decide⟩) (orbitCodeOfNumber ⟨197, by decide⟩) 1 4 7)

theorem row_157_198 : RowResult ⟨157, by decide⟩ ⟨198, by decide⟩ := by
  have _previous := row_157_197
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_157_199 : RowResult ⟨157, by decide⟩ ⟨199, by decide⟩ := by
  have _previous := row_157_198
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨244, by decide⟩, by decide⟩

theorem row_157_200 : RowResult ⟨157, by decide⟩ ⟨200, by decide⟩ := by
  have _previous := row_157_199
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨157, by decide⟩) (orbitCodeOfNumber ⟨200, by decide⟩) 1 6 7)

theorem row_157_201 : RowResult ⟨157, by decide⟩ ⟨201, by decide⟩ := by
  have _previous := row_157_200
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨157, by decide⟩) (orbitCodeOfNumber ⟨201, by decide⟩) 1 6 7)

theorem row_157_202 : RowResult ⟨157, by decide⟩ ⟨202, by decide⟩ := by
  have _previous := row_157_201
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨157, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) 1 6 7)

theorem row_157_203 : RowResult ⟨157, by decide⟩ ⟨203, by decide⟩ := by
  have _previous := row_157_202
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨157, by decide⟩) (orbitCodeOfNumber ⟨203, by decide⟩) 1 6 7)

theorem row_157_204 : RowResult ⟨157, by decide⟩ ⟨204, by decide⟩ := by
  have _previous := row_157_203
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨157, by decide⟩) (orbitCodeOfNumber ⟨204, by decide⟩) 1 6 7)

theorem row_157_205 : RowResult ⟨157, by decide⟩ ⟨205, by decide⟩ := by
  have _previous := row_157_204
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨157, by decide⟩) (orbitCodeOfNumber ⟨205, by decide⟩) 1 2 6)

theorem row_157_206 : RowResult ⟨157, by decide⟩ ⟨206, by decide⟩ := by
  have _previous := row_157_205
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨157, by decide⟩) (orbitCodeOfNumber ⟨206, by decide⟩) 2 4 6)

theorem row_157_207 : RowResult ⟨157, by decide⟩ ⟨207, by decide⟩ := by
  have _previous := row_157_206
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨157, by decide⟩) (orbitCodeOfNumber ⟨207, by decide⟩) 1 4 6)

theorem row_157_208 : RowResult ⟨157, by decide⟩ ⟨208, by decide⟩ := by
  have _previous := row_157_207
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨157, by decide⟩) (orbitCodeOfNumber ⟨208, by decide⟩) 4 5 6)

theorem row_157_209 : RowResult ⟨157, by decide⟩ ⟨209, by decide⟩ := by
  have _previous := row_157_208
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨157, by decide⟩) (orbitCodeOfNumber ⟨209, by decide⟩) 2 3 6)

end RelativeConicArcs.Q25PairCertificate
