import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_90_191 : RowResult ⟨90, by decide⟩ ⟨191, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_90_192 : RowResult ⟨90, by decide⟩ ⟨192, by decide⟩ := by
  have _previous := row_90_191
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨244, by decide⟩, by decide⟩

theorem row_90_193 : RowResult ⟨90, by decide⟩ ⟨193, by decide⟩ := by
  have _previous := row_90_192
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨90, by decide⟩) (orbitCodeOfNumber ⟨193, by decide⟩) 4 5 6)

theorem row_90_194 : RowResult ⟨90, by decide⟩ ⟨194, by decide⟩ := by
  have _previous := row_90_193
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_90_195 : RowResult ⟨90, by decide⟩ ⟨195, by decide⟩ := by
  have _previous := row_90_194
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨90, by decide⟩) (orbitCodeOfNumber ⟨195, by decide⟩) 1 2 7)

theorem row_90_196 : RowResult ⟨90, by decide⟩ ⟨196, by decide⟩ := by
  have _previous := row_90_195
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_90_197 : RowResult ⟨90, by decide⟩ ⟨197, by decide⟩ := by
  have _previous := row_90_196
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨246, by decide⟩, by decide⟩

theorem row_90_198 : RowResult ⟨90, by decide⟩ ⟨198, by decide⟩ := by
  have _previous := row_90_197
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨90, by decide⟩) (orbitCodeOfNumber ⟨198, by decide⟩) 2 4 6)

theorem row_90_199 : RowResult ⟨90, by decide⟩ ⟨199, by decide⟩ := by
  have _previous := row_90_198
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨90, by decide⟩) (orbitCodeOfNumber ⟨199, by decide⟩) 2 5 7)

theorem row_90_200 : RowResult ⟨90, by decide⟩ ⟨200, by decide⟩ := by
  have _previous := row_90_199
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨90, by decide⟩) (orbitCodeOfNumber ⟨200, by decide⟩) 1 6 7)

theorem row_90_201 : RowResult ⟨90, by decide⟩ ⟨201, by decide⟩ := by
  have _previous := row_90_200
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨90, by decide⟩) (orbitCodeOfNumber ⟨201, by decide⟩) 1 6 7)

theorem row_90_202 : RowResult ⟨90, by decide⟩ ⟨202, by decide⟩ := by
  have _previous := row_90_201
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨90, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) 1 6 7)

theorem row_90_203 : RowResult ⟨90, by decide⟩ ⟨203, by decide⟩ := by
  have _previous := row_90_202
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨90, by decide⟩) (orbitCodeOfNumber ⟨203, by decide⟩) 1 6 7)

theorem row_90_204 : RowResult ⟨90, by decide⟩ ⟨204, by decide⟩ := by
  have _previous := row_90_203
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨90, by decide⟩) (orbitCodeOfNumber ⟨204, by decide⟩) 1 6 7)

theorem row_90_205 : RowResult ⟨90, by decide⟩ ⟨205, by decide⟩ := by
  have _previous := row_90_204
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨90, by decide⟩) (orbitCodeOfNumber ⟨205, by decide⟩) 1 2 6)

theorem row_90_206 : RowResult ⟨90, by decide⟩ ⟨206, by decide⟩ := by
  have _previous := row_90_205
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
