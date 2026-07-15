import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_156_192 : RowResult ⟨156, by decide⟩ ⟨192, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_156_193 : RowResult ⟨156, by decide⟩ ⟨193, by decide⟩ := by
  have _previous := row_156_192
  exact Or.inr ⟨orbitCodeOfNumber ⟨36, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_156_194 : RowResult ⟨156, by decide⟩ ⟨194, by decide⟩ := by
  have _previous := row_156_193
  exact Or.inr ⟨orbitCodeOfNumber ⟨37, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_156_195 : RowResult ⟨156, by decide⟩ ⟨195, by decide⟩ := by
  have _previous := row_156_194
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨156, by decide⟩) (orbitCodeOfNumber ⟨195, by decide⟩) 1 2 7)

theorem row_156_196 : RowResult ⟨156, by decide⟩ ⟨196, by decide⟩ := by
  have _previous := row_156_195
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨156, by decide⟩) (orbitCodeOfNumber ⟨196, by decide⟩) 1 4 7)

theorem row_156_197 : RowResult ⟨156, by decide⟩ ⟨197, by decide⟩ := by
  have _previous := row_156_196
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨156, by decide⟩) (orbitCodeOfNumber ⟨197, by decide⟩) 2 5 6)

theorem row_156_198 : RowResult ⟨156, by decide⟩ ⟨198, by decide⟩ := by
  have _previous := row_156_197
  exact Or.inr ⟨orbitCodeOfNumber ⟨36, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_156_199 : RowResult ⟨156, by decide⟩ ⟨199, by decide⟩ := by
  have _previous := row_156_198
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_156_200 : RowResult ⟨156, by decide⟩ ⟨200, by decide⟩ := by
  have _previous := row_156_199
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨156, by decide⟩) (orbitCodeOfNumber ⟨200, by decide⟩) 1 6 7)

theorem row_156_201 : RowResult ⟨156, by decide⟩ ⟨201, by decide⟩ := by
  have _previous := row_156_200
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨156, by decide⟩) (orbitCodeOfNumber ⟨201, by decide⟩) 1 6 7)

theorem row_156_202 : RowResult ⟨156, by decide⟩ ⟨202, by decide⟩ := by
  have _previous := row_156_201
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨156, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) 1 6 7)

theorem row_156_203 : RowResult ⟨156, by decide⟩ ⟨203, by decide⟩ := by
  have _previous := row_156_202
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨156, by decide⟩) (orbitCodeOfNumber ⟨203, by decide⟩) 1 6 7)

theorem row_156_204 : RowResult ⟨156, by decide⟩ ⟨204, by decide⟩ := by
  have _previous := row_156_203
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨156, by decide⟩) (orbitCodeOfNumber ⟨204, by decide⟩) 1 6 7)

theorem row_156_205 : RowResult ⟨156, by decide⟩ ⟨205, by decide⟩ := by
  have _previous := row_156_204
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨156, by decide⟩) (orbitCodeOfNumber ⟨205, by decide⟩) 1 2 6)

theorem row_156_206 : RowResult ⟨156, by decide⟩ ⟨206, by decide⟩ := by
  have _previous := row_156_205
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨156, by decide⟩) (orbitCodeOfNumber ⟨206, by decide⟩) 1 4 6)

theorem row_156_207 : RowResult ⟨156, by decide⟩ ⟨207, by decide⟩ := by
  have _previous := row_156_206
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨156, by decide⟩) (orbitCodeOfNumber ⟨207, by decide⟩) 4 5 6)

theorem row_156_208 : RowResult ⟨156, by decide⟩ ⟨208, by decide⟩ := by
  have _previous := row_156_207
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨156, by decide⟩) (orbitCodeOfNumber ⟨208, by decide⟩) 2 4 6)

theorem row_156_209 : RowResult ⟨156, by decide⟩ ⟨209, by decide⟩ := by
  have _previous := row_156_208
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨156, by decide⟩) (orbitCodeOfNumber ⟨209, by decide⟩) 2 3 6)

theorem row_156_210 : RowResult ⟨156, by decide⟩ ⟨210, by decide⟩ := by
  have _previous := row_156_209
  exact Or.inr ⟨orbitCodeOfNumber ⟨41, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
