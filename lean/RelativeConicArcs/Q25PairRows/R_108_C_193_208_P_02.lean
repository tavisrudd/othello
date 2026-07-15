import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_108_193 : RowResult ⟨108, by decide⟩ ⟨193, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_108_194 : RowResult ⟨108, by decide⟩ ⟨194, by decide⟩ := by
  have _previous := row_108_193
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_108_195 : RowResult ⟨108, by decide⟩ ⟨195, by decide⟩ := by
  have _previous := row_108_194
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨108, by decide⟩) (orbitCodeOfNumber ⟨195, by decide⟩) 1 2 7)

theorem row_108_196 : RowResult ⟨108, by decide⟩ ⟨196, by decide⟩ := by
  have _previous := row_108_195
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_108_197 : RowResult ⟨108, by decide⟩ ⟨197, by decide⟩ := by
  have _previous := row_108_196
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨246, by decide⟩, by decide⟩

theorem row_108_198 : RowResult ⟨108, by decide⟩ ⟨198, by decide⟩ := by
  have _previous := row_108_197
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨108, by decide⟩) (orbitCodeOfNumber ⟨198, by decide⟩) 1 4 7)

theorem row_108_199 : RowResult ⟨108, by decide⟩ ⟨199, by decide⟩ := by
  have _previous := row_108_198
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨244, by decide⟩, by decide⟩

theorem row_108_200 : RowResult ⟨108, by decide⟩ ⟨200, by decide⟩ := by
  have _previous := row_108_199
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨108, by decide⟩) (orbitCodeOfNumber ⟨200, by decide⟩) 1 6 7)

theorem row_108_201 : RowResult ⟨108, by decide⟩ ⟨201, by decide⟩ := by
  have _previous := row_108_200
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨108, by decide⟩) (orbitCodeOfNumber ⟨201, by decide⟩) 1 6 7)

theorem row_108_202 : RowResult ⟨108, by decide⟩ ⟨202, by decide⟩ := by
  have _previous := row_108_201
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨108, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) 1 6 7)

theorem row_108_203 : RowResult ⟨108, by decide⟩ ⟨203, by decide⟩ := by
  have _previous := row_108_202
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨108, by decide⟩) (orbitCodeOfNumber ⟨203, by decide⟩) 1 6 7)

theorem row_108_204 : RowResult ⟨108, by decide⟩ ⟨204, by decide⟩ := by
  have _previous := row_108_203
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨108, by decide⟩) (orbitCodeOfNumber ⟨204, by decide⟩) 1 6 7)

theorem row_108_205 : RowResult ⟨108, by decide⟩ ⟨205, by decide⟩ := by
  have _previous := row_108_204
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨108, by decide⟩) (orbitCodeOfNumber ⟨205, by decide⟩) 1 2 6)

theorem row_108_206 : RowResult ⟨108, by decide⟩ ⟨206, by decide⟩ := by
  have _previous := row_108_205
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨108, by decide⟩) (orbitCodeOfNumber ⟨206, by decide⟩) 2 4 6)

theorem row_108_207 : RowResult ⟨108, by decide⟩ ⟨207, by decide⟩ := by
  have _previous := row_108_206
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨244, by decide⟩, by decide⟩

theorem row_108_208 : RowResult ⟨108, by decide⟩ ⟨208, by decide⟩ := by
  have _previous := row_108_207
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨108, by decide⟩) (orbitCodeOfNumber ⟨208, by decide⟩) 1 4 6)

end RelativeConicArcs.Q25PairCertificate
