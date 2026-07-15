import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_189_190 : RowResult ⟨189, by decide⟩ ⟨190, by decide⟩ := by
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨189, by decide⟩) (orbitCodeOfNumber ⟨190, by decide⟩) 0 4 6)

theorem row_189_191 : RowResult ⟨189, by decide⟩ ⟨191, by decide⟩ := by
  have _previous := row_189_190
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨189, by decide⟩) (orbitCodeOfNumber ⟨191, by decide⟩) 0 4 6)

theorem row_189_192 : RowResult ⟨189, by decide⟩ ⟨192, by decide⟩ := by
  have _previous := row_189_191
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨189, by decide⟩) (orbitCodeOfNumber ⟨192, by decide⟩) 0 4 6)

theorem row_189_193 : RowResult ⟨189, by decide⟩ ⟨193, by decide⟩ := by
  have _previous := row_189_192
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨189, by decide⟩) (orbitCodeOfNumber ⟨193, by decide⟩) 0 4 6)

theorem row_189_194 : RowResult ⟨189, by decide⟩ ⟨194, by decide⟩ := by
  have _previous := row_189_193
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨189, by decide⟩) (orbitCodeOfNumber ⟨194, by decide⟩) 0 4 6)

theorem row_189_195 : RowResult ⟨189, by decide⟩ ⟨195, by decide⟩ := by
  have _previous := row_189_194
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨189, by decide⟩) (orbitCodeOfNumber ⟨195, by decide⟩) 0 4 6)

theorem row_189_196 : RowResult ⟨189, by decide⟩ ⟨196, by decide⟩ := by
  have _previous := row_189_195
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨189, by decide⟩) (orbitCodeOfNumber ⟨196, by decide⟩) 0 4 6)

theorem row_189_197 : RowResult ⟨189, by decide⟩ ⟨197, by decide⟩ := by
  have _previous := row_189_196
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨189, by decide⟩) (orbitCodeOfNumber ⟨197, by decide⟩) 0 4 6)

theorem row_189_198 : RowResult ⟨189, by decide⟩ ⟨198, by decide⟩ := by
  have _previous := row_189_197
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨189, by decide⟩) (orbitCodeOfNumber ⟨198, by decide⟩) 0 4 6)

theorem row_189_199 : RowResult ⟨189, by decide⟩ ⟨199, by decide⟩ := by
  have _previous := row_189_198
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨189, by decide⟩) (orbitCodeOfNumber ⟨199, by decide⟩) 0 4 6)

theorem row_189_200 : RowResult ⟨189, by decide⟩ ⟨200, by decide⟩ := by
  have _previous := row_189_199
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨189, by decide⟩) (orbitCodeOfNumber ⟨200, by decide⟩) 1 6 7)

theorem row_189_201 : RowResult ⟨189, by decide⟩ ⟨201, by decide⟩ := by
  have _previous := row_189_200
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨189, by decide⟩) (orbitCodeOfNumber ⟨201, by decide⟩) 1 6 7)

theorem row_189_202 : RowResult ⟨189, by decide⟩ ⟨202, by decide⟩ := by
  have _previous := row_189_201
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨189, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) 1 6 7)

theorem row_189_203 : RowResult ⟨189, by decide⟩ ⟨203, by decide⟩ := by
  have _previous := row_189_202
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨189, by decide⟩) (orbitCodeOfNumber ⟨203, by decide⟩) 1 6 7)

theorem row_189_204 : RowResult ⟨189, by decide⟩ ⟨204, by decide⟩ := by
  have _previous := row_189_203
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨189, by decide⟩) (orbitCodeOfNumber ⟨204, by decide⟩) 1 6 7)

theorem row_189_205 : RowResult ⟨189, by decide⟩ ⟨205, by decide⟩ := by
  have _previous := row_189_204
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨189, by decide⟩) (orbitCodeOfNumber ⟨205, by decide⟩) 1 2 6)

theorem row_189_206 : RowResult ⟨189, by decide⟩ ⟨206, by decide⟩ := by
  have _previous := row_189_205
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨243, by decide⟩, by decide⟩

theorem row_189_207 : RowResult ⟨189, by decide⟩ ⟨207, by decide⟩ := by
  have _previous := row_189_206
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨189, by decide⟩) (orbitCodeOfNumber ⟨207, by decide⟩) 2 4 7)

theorem row_189_208 : RowResult ⟨189, by decide⟩ ⟨208, by decide⟩ := by
  have _previous := row_189_207
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨240, by decide⟩, by decide⟩

theorem row_189_209 : RowResult ⟨189, by decide⟩ ⟨209, by decide⟩ := by
  have _previous := row_189_208
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨189, by decide⟩) (orbitCodeOfNumber ⟨209, by decide⟩) 2 3 6)

theorem row_189_210 : RowResult ⟨189, by decide⟩ ⟨210, by decide⟩ := by
  have _previous := row_189_209
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_189_211 : RowResult ⟨189, by decide⟩ ⟨211, by decide⟩ := by
  have _previous := row_189_210
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_189_212 : RowResult ⟨189, by decide⟩ ⟨212, by decide⟩ := by
  have _previous := row_189_211
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨243, by decide⟩, by decide⟩

theorem row_189_213 : RowResult ⟨189, by decide⟩ ⟨213, by decide⟩ := by
  have _previous := row_189_212
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_189_214 : RowResult ⟨189, by decide⟩ ⟨214, by decide⟩ := by
  have _previous := row_189_213
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨189, by decide⟩) (orbitCodeOfNumber ⟨214, by decide⟩) 1 4 6)

end RelativeConicArcs.Q25PairCertificate
