import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_132_190 : RowResult ⟨132, by decide⟩ ⟨190, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_132_191 : RowResult ⟨132, by decide⟩ ⟨191, by decide⟩ := by
  have _previous := row_132_190
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨244, by decide⟩, by decide⟩

theorem row_132_192 : RowResult ⟨132, by decide⟩ ⟨192, by decide⟩ := by
  have _previous := row_132_191
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨132, by decide⟩) (orbitCodeOfNumber ⟨192, by decide⟩) 2 4 7)

theorem row_132_193 : RowResult ⟨132, by decide⟩ ⟨193, by decide⟩ := by
  have _previous := row_132_192
  exact Or.inr ⟨orbitCodeOfNumber ⟨36, by decide⟩,
    orbitCodeOfNumber ⟨240, by decide⟩, by decide⟩

theorem row_132_194 : RowResult ⟨132, by decide⟩ ⟨194, by decide⟩ := by
  have _previous := row_132_193
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨241, by decide⟩, by decide⟩

theorem row_132_195 : RowResult ⟨132, by decide⟩ ⟨195, by decide⟩ := by
  have _previous := row_132_194
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨132, by decide⟩) (orbitCodeOfNumber ⟨195, by decide⟩) 1 2 7)

theorem row_132_196 : RowResult ⟨132, by decide⟩ ⟨196, by decide⟩ := by
  have _previous := row_132_195
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨244, by decide⟩, by decide⟩

theorem row_132_197 : RowResult ⟨132, by decide⟩ ⟨197, by decide⟩ := by
  have _previous := row_132_196
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨132, by decide⟩) (orbitCodeOfNumber ⟨197, by decide⟩) 1 4 7)

theorem row_132_198 : RowResult ⟨132, by decide⟩ ⟨198, by decide⟩ := by
  have _previous := row_132_197
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨244, by decide⟩, by decide⟩

theorem row_132_199 : RowResult ⟨132, by decide⟩ ⟨199, by decide⟩ := by
  have _previous := row_132_198
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨132, by decide⟩) (orbitCodeOfNumber ⟨199, by decide⟩) 2 5 7)

theorem row_132_200 : RowResult ⟨132, by decide⟩ ⟨200, by decide⟩ := by
  have _previous := row_132_199
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨132, by decide⟩) (orbitCodeOfNumber ⟨200, by decide⟩) 1 6 7)

theorem row_132_201 : RowResult ⟨132, by decide⟩ ⟨201, by decide⟩ := by
  have _previous := row_132_200
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨132, by decide⟩) (orbitCodeOfNumber ⟨201, by decide⟩) 1 6 7)

theorem row_132_202 : RowResult ⟨132, by decide⟩ ⟨202, by decide⟩ := by
  have _previous := row_132_201
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨132, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) 1 6 7)

theorem row_132_203 : RowResult ⟨132, by decide⟩ ⟨203, by decide⟩ := by
  have _previous := row_132_202
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨132, by decide⟩) (orbitCodeOfNumber ⟨203, by decide⟩) 1 6 7)

theorem row_132_204 : RowResult ⟨132, by decide⟩ ⟨204, by decide⟩ := by
  have _previous := row_132_203
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨132, by decide⟩) (orbitCodeOfNumber ⟨204, by decide⟩) 1 6 7)

theorem row_132_205 : RowResult ⟨132, by decide⟩ ⟨205, by decide⟩ := by
  have _previous := row_132_204
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨132, by decide⟩) (orbitCodeOfNumber ⟨205, by decide⟩) 1 2 6)

end RelativeConicArcs.Q25PairCertificate
