import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_167_194 : RowResult ⟨167, by decide⟩ ⟨194, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_167_195 : RowResult ⟨167, by decide⟩ ⟨195, by decide⟩ := by
  have _previous := row_167_194
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨167, by decide⟩) (orbitCodeOfNumber ⟨195, by decide⟩) 1 2 7)

theorem row_167_196 : RowResult ⟨167, by decide⟩ ⟨196, by decide⟩ := by
  have _previous := row_167_195
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_167_197 : RowResult ⟨167, by decide⟩ ⟨197, by decide⟩ := by
  have _previous := row_167_196
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_167_198 : RowResult ⟨167, by decide⟩ ⟨198, by decide⟩ := by
  have _previous := row_167_197
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨167, by decide⟩) (orbitCodeOfNumber ⟨198, by decide⟩) 2 4 7)

theorem row_167_199 : RowResult ⟨167, by decide⟩ ⟨199, by decide⟩ := by
  have _previous := row_167_198
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_167_200 : RowResult ⟨167, by decide⟩ ⟨200, by decide⟩ := by
  have _previous := row_167_199
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨167, by decide⟩) (orbitCodeOfNumber ⟨200, by decide⟩) 1 6 7)

theorem row_167_201 : RowResult ⟨167, by decide⟩ ⟨201, by decide⟩ := by
  have _previous := row_167_200
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨167, by decide⟩) (orbitCodeOfNumber ⟨201, by decide⟩) 1 6 7)

theorem row_167_202 : RowResult ⟨167, by decide⟩ ⟨202, by decide⟩ := by
  have _previous := row_167_201
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨167, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) 1 6 7)

theorem row_167_203 : RowResult ⟨167, by decide⟩ ⟨203, by decide⟩ := by
  have _previous := row_167_202
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨167, by decide⟩) (orbitCodeOfNumber ⟨203, by decide⟩) 1 6 7)

theorem row_167_204 : RowResult ⟨167, by decide⟩ ⟨204, by decide⟩ := by
  have _previous := row_167_203
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨167, by decide⟩) (orbitCodeOfNumber ⟨204, by decide⟩) 1 6 7)

theorem row_167_205 : RowResult ⟨167, by decide⟩ ⟨205, by decide⟩ := by
  have _previous := row_167_204
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨167, by decide⟩) (orbitCodeOfNumber ⟨205, by decide⟩) 1 2 6)

theorem row_167_206 : RowResult ⟨167, by decide⟩ ⟨206, by decide⟩ := by
  have _previous := row_167_205
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_167_207 : RowResult ⟨167, by decide⟩ ⟨207, by decide⟩ := by
  have _previous := row_167_206
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨167, by decide⟩) (orbitCodeOfNumber ⟨207, by decide⟩) 2 5 7)

theorem row_167_208 : RowResult ⟨167, by decide⟩ ⟨208, by decide⟩ := by
  have _previous := row_167_207
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_167_209 : RowResult ⟨167, by decide⟩ ⟨209, by decide⟩ := by
  have _previous := row_167_208
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨167, by decide⟩) (orbitCodeOfNumber ⟨209, by decide⟩) 2 3 6)

end RelativeConicArcs.Q25PairCertificate
