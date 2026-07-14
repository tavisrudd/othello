import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_143_194 : RowResult ⟨143, by decide⟩ ⟨194, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_143_195 : RowResult ⟨143, by decide⟩ ⟨195, by decide⟩ := by
  have _previous := row_143_194
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨143, by decide⟩) (orbitCodeOfNumber ⟨195, by decide⟩) 1 2 7)

theorem row_143_196 : RowResult ⟨143, by decide⟩ ⟨196, by decide⟩ := by
  have _previous := row_143_195
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_143_197 : RowResult ⟨143, by decide⟩ ⟨197, by decide⟩ := by
  have _previous := row_143_196
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_143_198 : RowResult ⟨143, by decide⟩ ⟨198, by decide⟩ := by
  have _previous := row_143_197
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_143_199 : RowResult ⟨143, by decide⟩ ⟨199, by decide⟩ := by
  have _previous := row_143_198
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_143_200 : RowResult ⟨143, by decide⟩ ⟨200, by decide⟩ := by
  have _previous := row_143_199
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨143, by decide⟩) (orbitCodeOfNumber ⟨200, by decide⟩) 1 6 7)

theorem row_143_201 : RowResult ⟨143, by decide⟩ ⟨201, by decide⟩ := by
  have _previous := row_143_200
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨143, by decide⟩) (orbitCodeOfNumber ⟨201, by decide⟩) 1 6 7)

theorem row_143_202 : RowResult ⟨143, by decide⟩ ⟨202, by decide⟩ := by
  have _previous := row_143_201
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨143, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) 1 6 7)

theorem row_143_203 : RowResult ⟨143, by decide⟩ ⟨203, by decide⟩ := by
  have _previous := row_143_202
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨143, by decide⟩) (orbitCodeOfNumber ⟨203, by decide⟩) 1 6 7)

theorem row_143_204 : RowResult ⟨143, by decide⟩ ⟨204, by decide⟩ := by
  have _previous := row_143_203
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨143, by decide⟩) (orbitCodeOfNumber ⟨204, by decide⟩) 1 6 7)

theorem row_143_205 : RowResult ⟨143, by decide⟩ ⟨205, by decide⟩ := by
  have _previous := row_143_204
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨143, by decide⟩) (orbitCodeOfNumber ⟨205, by decide⟩) 1 2 6)

theorem row_143_206 : RowResult ⟨143, by decide⟩ ⟨206, by decide⟩ := by
  have _previous := row_143_205
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
