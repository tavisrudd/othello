import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_192_193 : RowResult ⟨192, by decide⟩ ⟨193, by decide⟩ := by
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨192, by decide⟩) (orbitCodeOfNumber ⟨193, by decide⟩) 0 4 6)

theorem row_192_194 : RowResult ⟨192, by decide⟩ ⟨194, by decide⟩ := by
  have _previous := row_192_193
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨192, by decide⟩) (orbitCodeOfNumber ⟨194, by decide⟩) 0 4 6)

theorem row_192_195 : RowResult ⟨192, by decide⟩ ⟨195, by decide⟩ := by
  have _previous := row_192_194
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨192, by decide⟩) (orbitCodeOfNumber ⟨195, by decide⟩) 0 4 6)

theorem row_192_196 : RowResult ⟨192, by decide⟩ ⟨196, by decide⟩ := by
  have _previous := row_192_195
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨192, by decide⟩) (orbitCodeOfNumber ⟨196, by decide⟩) 0 4 6)

theorem row_192_197 : RowResult ⟨192, by decide⟩ ⟨197, by decide⟩ := by
  have _previous := row_192_196
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨192, by decide⟩) (orbitCodeOfNumber ⟨197, by decide⟩) 0 4 6)

theorem row_192_198 : RowResult ⟨192, by decide⟩ ⟨198, by decide⟩ := by
  have _previous := row_192_197
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨192, by decide⟩) (orbitCodeOfNumber ⟨198, by decide⟩) 0 4 6)

theorem row_192_199 : RowResult ⟨192, by decide⟩ ⟨199, by decide⟩ := by
  have _previous := row_192_198
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨192, by decide⟩) (orbitCodeOfNumber ⟨199, by decide⟩) 0 4 6)

theorem row_192_200 : RowResult ⟨192, by decide⟩ ⟨200, by decide⟩ := by
  have _previous := row_192_199
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨192, by decide⟩) (orbitCodeOfNumber ⟨200, by decide⟩) 1 6 7)

theorem row_192_201 : RowResult ⟨192, by decide⟩ ⟨201, by decide⟩ := by
  have _previous := row_192_200
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨192, by decide⟩) (orbitCodeOfNumber ⟨201, by decide⟩) 1 6 7)

theorem row_192_202 : RowResult ⟨192, by decide⟩ ⟨202, by decide⟩ := by
  have _previous := row_192_201
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨192, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) 1 6 7)

theorem row_192_203 : RowResult ⟨192, by decide⟩ ⟨203, by decide⟩ := by
  have _previous := row_192_202
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨192, by decide⟩) (orbitCodeOfNumber ⟨203, by decide⟩) 1 6 7)

theorem row_192_204 : RowResult ⟨192, by decide⟩ ⟨204, by decide⟩ := by
  have _previous := row_192_203
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨192, by decide⟩) (orbitCodeOfNumber ⟨204, by decide⟩) 1 6 7)

theorem row_192_205 : RowResult ⟨192, by decide⟩ ⟨205, by decide⟩ := by
  have _previous := row_192_204
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨192, by decide⟩) (orbitCodeOfNumber ⟨205, by decide⟩) 1 2 6)

theorem row_192_206 : RowResult ⟨192, by decide⟩ ⟨206, by decide⟩ := by
  have _previous := row_192_205
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨244, by decide⟩, by decide⟩

theorem row_192_207 : RowResult ⟨192, by decide⟩ ⟨207, by decide⟩ := by
  have _previous := row_192_206
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_192_208 : RowResult ⟨192, by decide⟩ ⟨208, by decide⟩ := by
  have _previous := row_192_207
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨240, by decide⟩, by decide⟩

theorem row_192_209 : RowResult ⟨192, by decide⟩ ⟨209, by decide⟩ := by
  have _previous := row_192_208
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨192, by decide⟩) (orbitCodeOfNumber ⟨209, by decide⟩) 2 3 6)

theorem row_192_210 : RowResult ⟨192, by decide⟩ ⟨210, by decide⟩ := by
  have _previous := row_192_209
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_192_211 : RowResult ⟨192, by decide⟩ ⟨211, by decide⟩ := by
  have _previous := row_192_210
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_192_212 : RowResult ⟨192, by decide⟩ ⟨212, by decide⟩ := by
  have _previous := row_192_211
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨192, by decide⟩) (orbitCodeOfNumber ⟨212, by decide⟩) 1 4 7)

theorem row_192_213 : RowResult ⟨192, by decide⟩ ⟨213, by decide⟩ := by
  have _previous := row_192_212
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨192, by decide⟩) (orbitCodeOfNumber ⟨213, by decide⟩) 2 5 6)

theorem row_192_214 : RowResult ⟨192, by decide⟩ ⟨214, by decide⟩ := by
  have _previous := row_192_213
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
