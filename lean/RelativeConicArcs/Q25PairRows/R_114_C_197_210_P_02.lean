import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_114_197 : RowResult ⟨114, by decide⟩ ⟨197, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨246, by decide⟩, by decide⟩

theorem row_114_198 : RowResult ⟨114, by decide⟩ ⟨198, by decide⟩ := by
  have _previous := row_114_197
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_114_199 : RowResult ⟨114, by decide⟩ ⟨199, by decide⟩ := by
  have _previous := row_114_198
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨243, by decide⟩, by decide⟩

theorem row_114_200 : RowResult ⟨114, by decide⟩ ⟨200, by decide⟩ := by
  have _previous := row_114_199
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨114, by decide⟩) (orbitCodeOfNumber ⟨200, by decide⟩) 1 6 7)

theorem row_114_201 : RowResult ⟨114, by decide⟩ ⟨201, by decide⟩ := by
  have _previous := row_114_200
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨114, by decide⟩) (orbitCodeOfNumber ⟨201, by decide⟩) 1 6 7)

theorem row_114_202 : RowResult ⟨114, by decide⟩ ⟨202, by decide⟩ := by
  have _previous := row_114_201
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨114, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) 1 6 7)

theorem row_114_203 : RowResult ⟨114, by decide⟩ ⟨203, by decide⟩ := by
  have _previous := row_114_202
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨114, by decide⟩) (orbitCodeOfNumber ⟨203, by decide⟩) 1 6 7)

theorem row_114_204 : RowResult ⟨114, by decide⟩ ⟨204, by decide⟩ := by
  have _previous := row_114_203
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨114, by decide⟩) (orbitCodeOfNumber ⟨204, by decide⟩) 1 6 7)

theorem row_114_205 : RowResult ⟨114, by decide⟩ ⟨205, by decide⟩ := by
  have _previous := row_114_204
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨114, by decide⟩) (orbitCodeOfNumber ⟨205, by decide⟩) 1 2 6)

theorem row_114_206 : RowResult ⟨114, by decide⟩ ⟨206, by decide⟩ := by
  have _previous := row_114_205
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨114, by decide⟩) (orbitCodeOfNumber ⟨206, by decide⟩) 2 4 7)

theorem row_114_207 : RowResult ⟨114, by decide⟩ ⟨207, by decide⟩ := by
  have _previous := row_114_206
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨246, by decide⟩, by decide⟩

theorem row_114_208 : RowResult ⟨114, by decide⟩ ⟨208, by decide⟩ := by
  have _previous := row_114_207
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_114_209 : RowResult ⟨114, by decide⟩ ⟨209, by decide⟩ := by
  have _previous := row_114_208
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨114, by decide⟩) (orbitCodeOfNumber ⟨209, by decide⟩) 2 3 6)

theorem row_114_210 : RowResult ⟨114, by decide⟩ ⟨210, by decide⟩ := by
  have _previous := row_114_209
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
