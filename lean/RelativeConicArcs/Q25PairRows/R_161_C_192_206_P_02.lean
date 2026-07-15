import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_161_192 : RowResult ⟨161, by decide⟩ ⟨192, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨243, by decide⟩, by decide⟩

theorem row_161_193 : RowResult ⟨161, by decide⟩ ⟨193, by decide⟩ := by
  have _previous := row_161_192
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_161_194 : RowResult ⟨161, by decide⟩ ⟨194, by decide⟩ := by
  have _previous := row_161_193
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_161_195 : RowResult ⟨161, by decide⟩ ⟨195, by decide⟩ := by
  have _previous := row_161_194
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨161, by decide⟩) (orbitCodeOfNumber ⟨195, by decide⟩) 1 2 7)

theorem row_161_196 : RowResult ⟨161, by decide⟩ ⟨196, by decide⟩ := by
  have _previous := row_161_195
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨161, by decide⟩) (orbitCodeOfNumber ⟨196, by decide⟩) 4 5 6)

theorem row_161_197 : RowResult ⟨161, by decide⟩ ⟨197, by decide⟩ := by
  have _previous := row_161_196
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨246, by decide⟩, by decide⟩

theorem row_161_198 : RowResult ⟨161, by decide⟩ ⟨198, by decide⟩ := by
  have _previous := row_161_197
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_161_199 : RowResult ⟨161, by decide⟩ ⟨199, by decide⟩ := by
  have _previous := row_161_198
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨161, by decide⟩) (orbitCodeOfNumber ⟨199, by decide⟩) 2 4 7)

theorem row_161_200 : RowResult ⟨161, by decide⟩ ⟨200, by decide⟩ := by
  have _previous := row_161_199
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨161, by decide⟩) (orbitCodeOfNumber ⟨200, by decide⟩) 1 6 7)

theorem row_161_201 : RowResult ⟨161, by decide⟩ ⟨201, by decide⟩ := by
  have _previous := row_161_200
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨161, by decide⟩) (orbitCodeOfNumber ⟨201, by decide⟩) 1 6 7)

theorem row_161_202 : RowResult ⟨161, by decide⟩ ⟨202, by decide⟩ := by
  have _previous := row_161_201
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨161, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) 1 6 7)

theorem row_161_203 : RowResult ⟨161, by decide⟩ ⟨203, by decide⟩ := by
  have _previous := row_161_202
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨161, by decide⟩) (orbitCodeOfNumber ⟨203, by decide⟩) 1 6 7)

theorem row_161_204 : RowResult ⟨161, by decide⟩ ⟨204, by decide⟩ := by
  have _previous := row_161_203
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨161, by decide⟩) (orbitCodeOfNumber ⟨204, by decide⟩) 1 6 7)

theorem row_161_205 : RowResult ⟨161, by decide⟩ ⟨205, by decide⟩ := by
  have _previous := row_161_204
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨161, by decide⟩) (orbitCodeOfNumber ⟨205, by decide⟩) 1 2 6)

theorem row_161_206 : RowResult ⟨161, by decide⟩ ⟨206, by decide⟩ := by
  have _previous := row_161_205
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
