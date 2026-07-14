import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_116_193 : RowResult ⟨116, by decide⟩ ⟨193, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_116_194 : RowResult ⟨116, by decide⟩ ⟨194, by decide⟩ := by
  have _previous := row_116_193
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_116_195 : RowResult ⟨116, by decide⟩ ⟨195, by decide⟩ := by
  have _previous := row_116_194
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨116, by decide⟩) (orbitCodeOfNumber ⟨195, by decide⟩) 1 2 7)

theorem row_116_196 : RowResult ⟨116, by decide⟩ ⟨196, by decide⟩ := by
  have _previous := row_116_195
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨116, by decide⟩) (orbitCodeOfNumber ⟨196, by decide⟩) 2 5 6)

theorem row_116_197 : RowResult ⟨116, by decide⟩ ⟨197, by decide⟩ := by
  have _previous := row_116_196
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_116_198 : RowResult ⟨116, by decide⟩ ⟨198, by decide⟩ := by
  have _previous := row_116_197
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_116_199 : RowResult ⟨116, by decide⟩ ⟨199, by decide⟩ := by
  have _previous := row_116_198
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_116_200 : RowResult ⟨116, by decide⟩ ⟨200, by decide⟩ := by
  have _previous := row_116_199
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨116, by decide⟩) (orbitCodeOfNumber ⟨200, by decide⟩) 1 6 7)

theorem row_116_201 : RowResult ⟨116, by decide⟩ ⟨201, by decide⟩ := by
  have _previous := row_116_200
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨116, by decide⟩) (orbitCodeOfNumber ⟨201, by decide⟩) 1 6 7)

theorem row_116_202 : RowResult ⟨116, by decide⟩ ⟨202, by decide⟩ := by
  have _previous := row_116_201
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨116, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) 1 6 7)

theorem row_116_203 : RowResult ⟨116, by decide⟩ ⟨203, by decide⟩ := by
  have _previous := row_116_202
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨116, by decide⟩) (orbitCodeOfNumber ⟨203, by decide⟩) 1 6 7)

theorem row_116_204 : RowResult ⟨116, by decide⟩ ⟨204, by decide⟩ := by
  have _previous := row_116_203
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨116, by decide⟩) (orbitCodeOfNumber ⟨204, by decide⟩) 1 6 7)

theorem row_116_205 : RowResult ⟨116, by decide⟩ ⟨205, by decide⟩ := by
  have _previous := row_116_204
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨116, by decide⟩) (orbitCodeOfNumber ⟨205, by decide⟩) 1 2 6)

theorem row_116_206 : RowResult ⟨116, by decide⟩ ⟨206, by decide⟩ := by
  have _previous := row_116_205
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
