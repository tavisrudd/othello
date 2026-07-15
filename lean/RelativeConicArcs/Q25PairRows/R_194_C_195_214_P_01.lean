import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_194_195 : RowResult ⟨194, by decide⟩ ⟨195, by decide⟩ := by
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨194, by decide⟩) (orbitCodeOfNumber ⟨195, by decide⟩) 0 4 6)

theorem row_194_196 : RowResult ⟨194, by decide⟩ ⟨196, by decide⟩ := by
  have _previous := row_194_195
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨194, by decide⟩) (orbitCodeOfNumber ⟨196, by decide⟩) 0 4 6)

theorem row_194_197 : RowResult ⟨194, by decide⟩ ⟨197, by decide⟩ := by
  have _previous := row_194_196
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨194, by decide⟩) (orbitCodeOfNumber ⟨197, by decide⟩) 0 4 6)

theorem row_194_198 : RowResult ⟨194, by decide⟩ ⟨198, by decide⟩ := by
  have _previous := row_194_197
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨194, by decide⟩) (orbitCodeOfNumber ⟨198, by decide⟩) 0 4 6)

theorem row_194_199 : RowResult ⟨194, by decide⟩ ⟨199, by decide⟩ := by
  have _previous := row_194_198
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨194, by decide⟩) (orbitCodeOfNumber ⟨199, by decide⟩) 0 4 6)

theorem row_194_200 : RowResult ⟨194, by decide⟩ ⟨200, by decide⟩ := by
  have _previous := row_194_199
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨194, by decide⟩) (orbitCodeOfNumber ⟨200, by decide⟩) 1 6 7)

theorem row_194_201 : RowResult ⟨194, by decide⟩ ⟨201, by decide⟩ := by
  have _previous := row_194_200
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨194, by decide⟩) (orbitCodeOfNumber ⟨201, by decide⟩) 1 6 7)

theorem row_194_202 : RowResult ⟨194, by decide⟩ ⟨202, by decide⟩ := by
  have _previous := row_194_201
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨194, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) 1 6 7)

theorem row_194_203 : RowResult ⟨194, by decide⟩ ⟨203, by decide⟩ := by
  have _previous := row_194_202
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨194, by decide⟩) (orbitCodeOfNumber ⟨203, by decide⟩) 1 6 7)

theorem row_194_204 : RowResult ⟨194, by decide⟩ ⟨204, by decide⟩ := by
  have _previous := row_194_203
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨194, by decide⟩) (orbitCodeOfNumber ⟨204, by decide⟩) 1 6 7)

theorem row_194_205 : RowResult ⟨194, by decide⟩ ⟨205, by decide⟩ := by
  have _previous := row_194_204
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨194, by decide⟩) (orbitCodeOfNumber ⟨205, by decide⟩) 1 2 6)

theorem row_194_206 : RowResult ⟨194, by decide⟩ ⟨206, by decide⟩ := by
  have _previous := row_194_205
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_194_207 : RowResult ⟨194, by decide⟩ ⟨207, by decide⟩ := by
  have _previous := row_194_206
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨194, by decide⟩) (orbitCodeOfNumber ⟨207, by decide⟩) 2 5 6)

theorem row_194_208 : RowResult ⟨194, by decide⟩ ⟨208, by decide⟩ := by
  have _previous := row_194_207
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨241, by decide⟩, by decide⟩

theorem row_194_209 : RowResult ⟨194, by decide⟩ ⟨209, by decide⟩ := by
  have _previous := row_194_208
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨194, by decide⟩) (orbitCodeOfNumber ⟨209, by decide⟩) 2 3 6)

theorem row_194_210 : RowResult ⟨194, by decide⟩ ⟨210, by decide⟩ := by
  have _previous := row_194_209
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_194_211 : RowResult ⟨194, by decide⟩ ⟨211, by decide⟩ := by
  have _previous := row_194_210
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_194_212 : RowResult ⟨194, by decide⟩ ⟨212, by decide⟩ := by
  have _previous := row_194_211
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨240, by decide⟩, by decide⟩

theorem row_194_213 : RowResult ⟨194, by decide⟩ ⟨213, by decide⟩ := by
  have _previous := row_194_212
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨240, by decide⟩, by decide⟩

theorem row_194_214 : RowResult ⟨194, by decide⟩ ⟨214, by decide⟩ := by
  have _previous := row_194_213
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨194, by decide⟩) (orbitCodeOfNumber ⟨214, by decide⟩) 1 4 7)

end RelativeConicArcs.Q25PairCertificate
