import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_172_189 : RowResult ⟨172, by decide⟩ ⟨189, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨243, by decide⟩, by decide⟩

theorem row_172_190 : RowResult ⟨172, by decide⟩ ⟨190, by decide⟩ := by
  have _previous := row_172_189
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_172_191 : RowResult ⟨172, by decide⟩ ⟨191, by decide⟩ := by
  have _previous := row_172_190
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨172, by decide⟩) (orbitCodeOfNumber ⟨191, by decide⟩) 2 4 7)

theorem row_172_192 : RowResult ⟨172, by decide⟩ ⟨192, by decide⟩ := by
  have _previous := row_172_191
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨172, by decide⟩) (orbitCodeOfNumber ⟨192, by decide⟩) 4 5 6)

theorem row_172_193 : RowResult ⟨172, by decide⟩ ⟨193, by decide⟩ := by
  have _previous := row_172_192
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨246, by decide⟩, by decide⟩

theorem row_172_194 : RowResult ⟨172, by decide⟩ ⟨194, by decide⟩ := by
  have _previous := row_172_193
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨172, by decide⟩) (orbitCodeOfNumber ⟨194, by decide⟩) 2 4 6)

theorem row_172_195 : RowResult ⟨172, by decide⟩ ⟨195, by decide⟩ := by
  have _previous := row_172_194
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨172, by decide⟩) (orbitCodeOfNumber ⟨195, by decide⟩) 1 2 7)

theorem row_172_196 : RowResult ⟨172, by decide⟩ ⟨196, by decide⟩ := by
  have _previous := row_172_195
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨172, by decide⟩) (orbitCodeOfNumber ⟨196, by decide⟩) 2 5 6)

theorem row_172_197 : RowResult ⟨172, by decide⟩ ⟨197, by decide⟩ := by
  have _previous := row_172_196
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨172, by decide⟩) (orbitCodeOfNumber ⟨197, by decide⟩) 1 4 6)

theorem row_172_198 : RowResult ⟨172, by decide⟩ ⟨198, by decide⟩ := by
  have _previous := row_172_197
  exact Or.inr ⟨orbitCodeOfNumber ⟨37, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_172_199 : RowResult ⟨172, by decide⟩ ⟨199, by decide⟩ := by
  have _previous := row_172_198
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨243, by decide⟩, by decide⟩

theorem row_172_200 : RowResult ⟨172, by decide⟩ ⟨200, by decide⟩ := by
  have _previous := row_172_199
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨172, by decide⟩) (orbitCodeOfNumber ⟨200, by decide⟩) 1 6 7)

theorem row_172_201 : RowResult ⟨172, by decide⟩ ⟨201, by decide⟩ := by
  have _previous := row_172_200
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨172, by decide⟩) (orbitCodeOfNumber ⟨201, by decide⟩) 1 6 7)

theorem row_172_202 : RowResult ⟨172, by decide⟩ ⟨202, by decide⟩ := by
  have _previous := row_172_201
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨172, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) 1 6 7)

theorem row_172_203 : RowResult ⟨172, by decide⟩ ⟨203, by decide⟩ := by
  have _previous := row_172_202
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨172, by decide⟩) (orbitCodeOfNumber ⟨203, by decide⟩) 1 6 7)

theorem row_172_204 : RowResult ⟨172, by decide⟩ ⟨204, by decide⟩ := by
  have _previous := row_172_203
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨172, by decide⟩) (orbitCodeOfNumber ⟨204, by decide⟩) 1 6 7)

theorem row_172_205 : RowResult ⟨172, by decide⟩ ⟨205, by decide⟩ := by
  have _previous := row_172_204
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨172, by decide⟩) (orbitCodeOfNumber ⟨205, by decide⟩) 1 2 6)

theorem row_172_206 : RowResult ⟨172, by decide⟩ ⟨206, by decide⟩ := by
  have _previous := row_172_205
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨244, by decide⟩, by decide⟩

theorem row_172_207 : RowResult ⟨172, by decide⟩ ⟨207, by decide⟩ := by
  have _previous := row_172_206
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨172, by decide⟩) (orbitCodeOfNumber ⟨207, by decide⟩) 1 4 7)

end RelativeConicArcs.Q25PairCertificate
