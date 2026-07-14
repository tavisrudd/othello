import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_148_191 : RowResult ⟨148, by decide⟩ ⟨191, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_148_192 : RowResult ⟨148, by decide⟩ ⟨192, by decide⟩ := by
  have _previous := row_148_191
  exact Or.inr ⟨orbitCodeOfNumber ⟨231, by decide⟩, by decide⟩

theorem row_148_193 : RowResult ⟨148, by decide⟩ ⟨193, by decide⟩ := by
  have _previous := row_148_192
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨148, by decide⟩) (orbitCodeOfNumber ⟨193, by decide⟩) 2 4 6)

theorem row_148_194 : RowResult ⟨148, by decide⟩ ⟨194, by decide⟩ := by
  have _previous := row_148_193
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_148_195 : RowResult ⟨148, by decide⟩ ⟨195, by decide⟩ := by
  have _previous := row_148_194
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨148, by decide⟩) (orbitCodeOfNumber ⟨195, by decide⟩) 1 2 7)

theorem row_148_196 : RowResult ⟨148, by decide⟩ ⟨196, by decide⟩ := by
  have _previous := row_148_195
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨148, by decide⟩) (orbitCodeOfNumber ⟨196, by decide⟩) 2 5 6)

theorem row_148_197 : RowResult ⟨148, by decide⟩ ⟨197, by decide⟩ := by
  have _previous := row_148_196
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_148_198 : RowResult ⟨148, by decide⟩ ⟨198, by decide⟩ := by
  have _previous := row_148_197
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨148, by decide⟩) (orbitCodeOfNumber ⟨198, by decide⟩) 1 4 6)

theorem row_148_199 : RowResult ⟨148, by decide⟩ ⟨199, by decide⟩ := by
  have _previous := row_148_198
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_148_200 : RowResult ⟨148, by decide⟩ ⟨200, by decide⟩ := by
  have _previous := row_148_199
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨148, by decide⟩) (orbitCodeOfNumber ⟨200, by decide⟩) 1 6 7)

theorem row_148_201 : RowResult ⟨148, by decide⟩ ⟨201, by decide⟩ := by
  have _previous := row_148_200
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨148, by decide⟩) (orbitCodeOfNumber ⟨201, by decide⟩) 1 6 7)

theorem row_148_202 : RowResult ⟨148, by decide⟩ ⟨202, by decide⟩ := by
  have _previous := row_148_201
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨148, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) 1 6 7)

theorem row_148_203 : RowResult ⟨148, by decide⟩ ⟨203, by decide⟩ := by
  have _previous := row_148_202
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨148, by decide⟩) (orbitCodeOfNumber ⟨203, by decide⟩) 1 6 7)

theorem row_148_204 : RowResult ⟨148, by decide⟩ ⟨204, by decide⟩ := by
  have _previous := row_148_203
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨148, by decide⟩) (orbitCodeOfNumber ⟨204, by decide⟩) 1 6 7)

theorem row_148_205 : RowResult ⟨148, by decide⟩ ⟨205, by decide⟩ := by
  have _previous := row_148_204
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨148, by decide⟩) (orbitCodeOfNumber ⟨205, by decide⟩) 1 2 6)

theorem row_148_206 : RowResult ⟨148, by decide⟩ ⟨206, by decide⟩ := by
  have _previous := row_148_205
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
