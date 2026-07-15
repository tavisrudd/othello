import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_37_191 : RowResult ⟨37, by decide⟩ ⟨191, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_37_192 : RowResult ⟨37, by decide⟩ ⟨192, by decide⟩ := by
  have _previous := row_37_191
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨37, by decide⟩) (orbitCodeOfNumber ⟨192, by decide⟩) 1 4 7)

theorem row_37_193 : RowResult ⟨37, by decide⟩ ⟨193, by decide⟩ := by
  have _previous := row_37_192
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_37_194 : RowResult ⟨37, by decide⟩ ⟨194, by decide⟩ := by
  have _previous := row_37_193
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_37_195 : RowResult ⟨37, by decide⟩ ⟨195, by decide⟩ := by
  have _previous := row_37_194
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨37, by decide⟩) (orbitCodeOfNumber ⟨195, by decide⟩) 1 2 7)

theorem row_37_196 : RowResult ⟨37, by decide⟩ ⟨196, by decide⟩ := by
  have _previous := row_37_195
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_37_197 : RowResult ⟨37, by decide⟩ ⟨197, by decide⟩ := by
  have _previous := row_37_196
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨37, by decide⟩) (orbitCodeOfNumber ⟨197, by decide⟩) 2 4 7)

theorem row_37_198 : RowResult ⟨37, by decide⟩ ⟨198, by decide⟩ := by
  have _previous := row_37_197
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_37_199 : RowResult ⟨37, by decide⟩ ⟨199, by decide⟩ := by
  have _previous := row_37_198
  exact Or.inr ⟨orbitCodeOfNumber ⟨64, by decide⟩,
    orbitCodeOfNumber ⟨244, by decide⟩, by decide⟩

theorem row_37_200 : RowResult ⟨37, by decide⟩ ⟨200, by decide⟩ := by
  have _previous := row_37_199
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨37, by decide⟩) (orbitCodeOfNumber ⟨200, by decide⟩) 1 6 7)

theorem row_37_201 : RowResult ⟨37, by decide⟩ ⟨201, by decide⟩ := by
  have _previous := row_37_200
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨37, by decide⟩) (orbitCodeOfNumber ⟨201, by decide⟩) 1 6 7)

theorem row_37_202 : RowResult ⟨37, by decide⟩ ⟨202, by decide⟩ := by
  have _previous := row_37_201
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨37, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) 1 6 7)

theorem row_37_203 : RowResult ⟨37, by decide⟩ ⟨203, by decide⟩ := by
  have _previous := row_37_202
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨37, by decide⟩) (orbitCodeOfNumber ⟨203, by decide⟩) 1 6 7)

theorem row_37_204 : RowResult ⟨37, by decide⟩ ⟨204, by decide⟩ := by
  have _previous := row_37_203
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨37, by decide⟩) (orbitCodeOfNumber ⟨204, by decide⟩) 1 6 7)

theorem row_37_205 : RowResult ⟨37, by decide⟩ ⟨205, by decide⟩ := by
  have _previous := row_37_204
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨37, by decide⟩) (orbitCodeOfNumber ⟨205, by decide⟩) 1 2 6)

theorem row_37_206 : RowResult ⟨37, by decide⟩ ⟨206, by decide⟩ := by
  have _previous := row_37_205
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨37, by decide⟩) (orbitCodeOfNumber ⟨206, by decide⟩) 4 5 6)

end RelativeConicArcs.Q25PairCertificate
