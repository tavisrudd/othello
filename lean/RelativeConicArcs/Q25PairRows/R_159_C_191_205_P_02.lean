import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_159_191 : RowResult ⟨159, by decide⟩ ⟨191, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_159_192 : RowResult ⟨159, by decide⟩ ⟨192, by decide⟩ := by
  have _previous := row_159_191
  exact Or.inr ⟨orbitCodeOfNumber ⟨116, by decide⟩, by decide⟩

theorem row_159_193 : RowResult ⟨159, by decide⟩ ⟨193, by decide⟩ := by
  have _previous := row_159_192
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_159_194 : RowResult ⟨159, by decide⟩ ⟨194, by decide⟩ := by
  have _previous := row_159_193
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨159, by decide⟩) (orbitCodeOfNumber ⟨194, by decide⟩) 2 4 7)

theorem row_159_195 : RowResult ⟨159, by decide⟩ ⟨195, by decide⟩ := by
  have _previous := row_159_194
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨159, by decide⟩) (orbitCodeOfNumber ⟨195, by decide⟩) 1 2 7)

theorem row_159_196 : RowResult ⟨159, by decide⟩ ⟨196, by decide⟩ := by
  have _previous := row_159_195
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_159_197 : RowResult ⟨159, by decide⟩ ⟨197, by decide⟩ := by
  have _previous := row_159_196
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_159_198 : RowResult ⟨159, by decide⟩ ⟨198, by decide⟩ := by
  have _previous := row_159_197
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_159_199 : RowResult ⟨159, by decide⟩ ⟨199, by decide⟩ := by
  have _previous := row_159_198
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨159, by decide⟩) (orbitCodeOfNumber ⟨199, by decide⟩) 1 4 7)

theorem row_159_200 : RowResult ⟨159, by decide⟩ ⟨200, by decide⟩ := by
  have _previous := row_159_199
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨159, by decide⟩) (orbitCodeOfNumber ⟨200, by decide⟩) 1 6 7)

theorem row_159_201 : RowResult ⟨159, by decide⟩ ⟨201, by decide⟩ := by
  have _previous := row_159_200
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨159, by decide⟩) (orbitCodeOfNumber ⟨201, by decide⟩) 1 6 7)

theorem row_159_202 : RowResult ⟨159, by decide⟩ ⟨202, by decide⟩ := by
  have _previous := row_159_201
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨159, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) 1 6 7)

theorem row_159_203 : RowResult ⟨159, by decide⟩ ⟨203, by decide⟩ := by
  have _previous := row_159_202
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨159, by decide⟩) (orbitCodeOfNumber ⟨203, by decide⟩) 1 6 7)

theorem row_159_204 : RowResult ⟨159, by decide⟩ ⟨204, by decide⟩ := by
  have _previous := row_159_203
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨159, by decide⟩) (orbitCodeOfNumber ⟨204, by decide⟩) 1 6 7)

theorem row_159_205 : RowResult ⟨159, by decide⟩ ⟨205, by decide⟩ := by
  have _previous := row_159_204
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨159, by decide⟩) (orbitCodeOfNumber ⟨205, by decide⟩) 1 2 6)

end RelativeConicArcs.Q25PairCertificate
