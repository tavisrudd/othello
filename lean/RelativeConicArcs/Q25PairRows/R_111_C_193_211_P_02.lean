import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_111_193 : RowResult ⟨111, by decide⟩ ⟨193, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_111_194 : RowResult ⟨111, by decide⟩ ⟨194, by decide⟩ := by
  have _previous := row_111_193
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨246, by decide⟩, by decide⟩

theorem row_111_195 : RowResult ⟨111, by decide⟩ ⟨195, by decide⟩ := by
  have _previous := row_111_194
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨111, by decide⟩) (orbitCodeOfNumber ⟨195, by decide⟩) 1 2 7)

theorem row_111_196 : RowResult ⟨111, by decide⟩ ⟨196, by decide⟩ := by
  have _previous := row_111_195
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨111, by decide⟩) (orbitCodeOfNumber ⟨196, by decide⟩) 2 4 7)

theorem row_111_197 : RowResult ⟨111, by decide⟩ ⟨197, by decide⟩ := by
  have _previous := row_111_196
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨111, by decide⟩) (orbitCodeOfNumber ⟨197, by decide⟩) 2 5 6)

theorem row_111_198 : RowResult ⟨111, by decide⟩ ⟨198, by decide⟩ := by
  have _previous := row_111_197
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨111, by decide⟩) (orbitCodeOfNumber ⟨198, by decide⟩) 4 5 6)

theorem row_111_199 : RowResult ⟨111, by decide⟩ ⟨199, by decide⟩ := by
  have _previous := row_111_198
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_111_200 : RowResult ⟨111, by decide⟩ ⟨200, by decide⟩ := by
  have _previous := row_111_199
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨111, by decide⟩) (orbitCodeOfNumber ⟨200, by decide⟩) 1 6 7)

theorem row_111_201 : RowResult ⟨111, by decide⟩ ⟨201, by decide⟩ := by
  have _previous := row_111_200
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨111, by decide⟩) (orbitCodeOfNumber ⟨201, by decide⟩) 1 6 7)

theorem row_111_202 : RowResult ⟨111, by decide⟩ ⟨202, by decide⟩ := by
  have _previous := row_111_201
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨111, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) 1 6 7)

theorem row_111_203 : RowResult ⟨111, by decide⟩ ⟨203, by decide⟩ := by
  have _previous := row_111_202
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨111, by decide⟩) (orbitCodeOfNumber ⟨203, by decide⟩) 1 6 7)

theorem row_111_204 : RowResult ⟨111, by decide⟩ ⟨204, by decide⟩ := by
  have _previous := row_111_203
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨111, by decide⟩) (orbitCodeOfNumber ⟨204, by decide⟩) 1 6 7)

theorem row_111_205 : RowResult ⟨111, by decide⟩ ⟨205, by decide⟩ := by
  have _previous := row_111_204
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨111, by decide⟩) (orbitCodeOfNumber ⟨205, by decide⟩) 1 2 6)

theorem row_111_206 : RowResult ⟨111, by decide⟩ ⟨206, by decide⟩ := by
  have _previous := row_111_205
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_111_207 : RowResult ⟨111, by decide⟩ ⟨207, by decide⟩ := by
  have _previous := row_111_206
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨244, by decide⟩, by decide⟩

theorem row_111_208 : RowResult ⟨111, by decide⟩ ⟨208, by decide⟩ := by
  have _previous := row_111_207
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_111_209 : RowResult ⟨111, by decide⟩ ⟨209, by decide⟩ := by
  have _previous := row_111_208
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨111, by decide⟩) (orbitCodeOfNumber ⟨209, by decide⟩) 2 3 6)

theorem row_111_210 : RowResult ⟨111, by decide⟩ ⟨210, by decide⟩ := by
  have _previous := row_111_209
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨111, by decide⟩) (orbitCodeOfNumber ⟨210, by decide⟩) 4 5 6)

theorem row_111_211 : RowResult ⟨111, by decide⟩ ⟨211, by decide⟩ := by
  have _previous := row_111_210
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨111, by decide⟩) (orbitCodeOfNumber ⟨211, by decide⟩) 1 4 6)

end RelativeConicArcs.Q25PairCertificate
