import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_146_191 : RowResult ⟨146, by decide⟩ ⟨191, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_146_192 : RowResult ⟨146, by decide⟩ ⟨192, by decide⟩ := by
  have _previous := row_146_191
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_146_193 : RowResult ⟨146, by decide⟩ ⟨193, by decide⟩ := by
  have _previous := row_146_192
  exact Or.inr ⟨orbitCodeOfNumber ⟨36, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_146_194 : RowResult ⟨146, by decide⟩ ⟨194, by decide⟩ := by
  have _previous := row_146_193
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨146, by decide⟩) (orbitCodeOfNumber ⟨194, by decide⟩) 2 4 7)

theorem row_146_195 : RowResult ⟨146, by decide⟩ ⟨195, by decide⟩ := by
  have _previous := row_146_194
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨146, by decide⟩) (orbitCodeOfNumber ⟨195, by decide⟩) 1 2 7)

theorem row_146_196 : RowResult ⟨146, by decide⟩ ⟨196, by decide⟩ := by
  have _previous := row_146_195
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨146, by decide⟩) (orbitCodeOfNumber ⟨196, by decide⟩) 1 4 6)

theorem row_146_197 : RowResult ⟨146, by decide⟩ ⟨197, by decide⟩ := by
  have _previous := row_146_196
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨244, by decide⟩, by decide⟩

theorem row_146_198 : RowResult ⟨146, by decide⟩ ⟨198, by decide⟩ := by
  have _previous := row_146_197
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨146, by decide⟩) (orbitCodeOfNumber ⟨198, by decide⟩) 4 5 6)

theorem row_146_199 : RowResult ⟨146, by decide⟩ ⟨199, by decide⟩ := by
  have _previous := row_146_198
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨146, by decide⟩) (orbitCodeOfNumber ⟨199, by decide⟩) 2 4 6)

theorem row_146_200 : RowResult ⟨146, by decide⟩ ⟨200, by decide⟩ := by
  have _previous := row_146_199
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨146, by decide⟩) (orbitCodeOfNumber ⟨200, by decide⟩) 1 6 7)

theorem row_146_201 : RowResult ⟨146, by decide⟩ ⟨201, by decide⟩ := by
  have _previous := row_146_200
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨146, by decide⟩) (orbitCodeOfNumber ⟨201, by decide⟩) 1 6 7)

theorem row_146_202 : RowResult ⟨146, by decide⟩ ⟨202, by decide⟩ := by
  have _previous := row_146_201
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨146, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) 1 6 7)

theorem row_146_203 : RowResult ⟨146, by decide⟩ ⟨203, by decide⟩ := by
  have _previous := row_146_202
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨146, by decide⟩) (orbitCodeOfNumber ⟨203, by decide⟩) 1 6 7)

theorem row_146_204 : RowResult ⟨146, by decide⟩ ⟨204, by decide⟩ := by
  have _previous := row_146_203
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨146, by decide⟩) (orbitCodeOfNumber ⟨204, by decide⟩) 1 6 7)

theorem row_146_205 : RowResult ⟨146, by decide⟩ ⟨205, by decide⟩ := by
  have _previous := row_146_204
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨146, by decide⟩) (orbitCodeOfNumber ⟨205, by decide⟩) 1 2 6)

theorem row_146_206 : RowResult ⟨146, by decide⟩ ⟨206, by decide⟩ := by
  have _previous := row_146_205
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨146, by decide⟩) (orbitCodeOfNumber ⟨206, by decide⟩) 1 4 7)

theorem row_146_207 : RowResult ⟨146, by decide⟩ ⟨207, by decide⟩ := by
  have _previous := row_146_206
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨146, by decide⟩) (orbitCodeOfNumber ⟨207, by decide⟩) 2 4 6)

theorem row_146_208 : RowResult ⟨146, by decide⟩ ⟨208, by decide⟩ := by
  have _previous := row_146_207
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_146_209 : RowResult ⟨146, by decide⟩ ⟨209, by decide⟩ := by
  have _previous := row_146_208
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨146, by decide⟩) (orbitCodeOfNumber ⟨209, by decide⟩) 2 3 6)

theorem row_146_210 : RowResult ⟨146, by decide⟩ ⟨210, by decide⟩ := by
  have _previous := row_146_209
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨146, by decide⟩) (orbitCodeOfNumber ⟨210, by decide⟩) 4 5 6)

theorem row_146_211 : RowResult ⟨146, by decide⟩ ⟨211, by decide⟩ := by
  have _previous := row_146_210
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
