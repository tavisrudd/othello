import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_169_191 : RowResult ⟨169, by decide⟩ ⟨191, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_169_192 : RowResult ⟨169, by decide⟩ ⟨192, by decide⟩ := by
  have _previous := row_169_191
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_169_193 : RowResult ⟨169, by decide⟩ ⟨193, by decide⟩ := by
  have _previous := row_169_192
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_169_194 : RowResult ⟨169, by decide⟩ ⟨194, by decide⟩ := by
  have _previous := row_169_193
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨169, by decide⟩) (orbitCodeOfNumber ⟨194, by decide⟩) 1 4 6)

theorem row_169_195 : RowResult ⟨169, by decide⟩ ⟨195, by decide⟩ := by
  have _previous := row_169_194
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨169, by decide⟩) (orbitCodeOfNumber ⟨195, by decide⟩) 1 2 7)

theorem row_169_196 : RowResult ⟨169, by decide⟩ ⟨196, by decide⟩ := by
  have _previous := row_169_195
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_169_197 : RowResult ⟨169, by decide⟩ ⟨197, by decide⟩ := by
  have _previous := row_169_196
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨169, by decide⟩) (orbitCodeOfNumber ⟨197, by decide⟩) 2 5 7)

theorem row_169_198 : RowResult ⟨169, by decide⟩ ⟨198, by decide⟩ := by
  have _previous := row_169_197
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_169_199 : RowResult ⟨169, by decide⟩ ⟨199, by decide⟩ := by
  have _previous := row_169_198
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_169_200 : RowResult ⟨169, by decide⟩ ⟨200, by decide⟩ := by
  have _previous := row_169_199
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨169, by decide⟩) (orbitCodeOfNumber ⟨200, by decide⟩) 1 6 7)

theorem row_169_201 : RowResult ⟨169, by decide⟩ ⟨201, by decide⟩ := by
  have _previous := row_169_200
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨169, by decide⟩) (orbitCodeOfNumber ⟨201, by decide⟩) 1 6 7)

theorem row_169_202 : RowResult ⟨169, by decide⟩ ⟨202, by decide⟩ := by
  have _previous := row_169_201
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨169, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) 1 6 7)

theorem row_169_203 : RowResult ⟨169, by decide⟩ ⟨203, by decide⟩ := by
  have _previous := row_169_202
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨169, by decide⟩) (orbitCodeOfNumber ⟨203, by decide⟩) 1 6 7)

theorem row_169_204 : RowResult ⟨169, by decide⟩ ⟨204, by decide⟩ := by
  have _previous := row_169_203
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨169, by decide⟩) (orbitCodeOfNumber ⟨204, by decide⟩) 1 6 7)

theorem row_169_205 : RowResult ⟨169, by decide⟩ ⟨205, by decide⟩ := by
  have _previous := row_169_204
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨169, by decide⟩) (orbitCodeOfNumber ⟨205, by decide⟩) 1 2 6)

end RelativeConicArcs.Q25PairCertificate
