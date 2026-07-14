import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_121_193 : RowResult ⟨121, by decide⟩ ⟨193, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_121_194 : RowResult ⟨121, by decide⟩ ⟨194, by decide⟩ := by
  have _previous := row_121_193
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_121_195 : RowResult ⟨121, by decide⟩ ⟨195, by decide⟩ := by
  have _previous := row_121_194
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨121, by decide⟩) (orbitCodeOfNumber ⟨195, by decide⟩) 1 2 7)

theorem row_121_196 : RowResult ⟨121, by decide⟩ ⟨196, by decide⟩ := by
  have _previous := row_121_195
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨121, by decide⟩) (orbitCodeOfNumber ⟨196, by decide⟩) 1 4 6)

theorem row_121_197 : RowResult ⟨121, by decide⟩ ⟨197, by decide⟩ := by
  have _previous := row_121_196
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_121_198 : RowResult ⟨121, by decide⟩ ⟨198, by decide⟩ := by
  have _previous := row_121_197
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_121_199 : RowResult ⟨121, by decide⟩ ⟨199, by decide⟩ := by
  have _previous := row_121_198
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨121, by decide⟩) (orbitCodeOfNumber ⟨199, by decide⟩) 2 5 7)

theorem row_121_200 : RowResult ⟨121, by decide⟩ ⟨200, by decide⟩ := by
  have _previous := row_121_199
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨121, by decide⟩) (orbitCodeOfNumber ⟨200, by decide⟩) 1 6 7)

theorem row_121_201 : RowResult ⟨121, by decide⟩ ⟨201, by decide⟩ := by
  have _previous := row_121_200
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨121, by decide⟩) (orbitCodeOfNumber ⟨201, by decide⟩) 1 6 7)

theorem row_121_202 : RowResult ⟨121, by decide⟩ ⟨202, by decide⟩ := by
  have _previous := row_121_201
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨121, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) 1 6 7)

theorem row_121_203 : RowResult ⟨121, by decide⟩ ⟨203, by decide⟩ := by
  have _previous := row_121_202
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨121, by decide⟩) (orbitCodeOfNumber ⟨203, by decide⟩) 1 6 7)

theorem row_121_204 : RowResult ⟨121, by decide⟩ ⟨204, by decide⟩ := by
  have _previous := row_121_203
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨121, by decide⟩) (orbitCodeOfNumber ⟨204, by decide⟩) 1 6 7)

theorem row_121_205 : RowResult ⟨121, by decide⟩ ⟨205, by decide⟩ := by
  have _previous := row_121_204
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨121, by decide⟩) (orbitCodeOfNumber ⟨205, by decide⟩) 1 2 6)

theorem row_121_206 : RowResult ⟨121, by decide⟩ ⟨206, by decide⟩ := by
  have _previous := row_121_205
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨121, by decide⟩) (orbitCodeOfNumber ⟨206, by decide⟩) 1 4 7)

theorem row_121_207 : RowResult ⟨121, by decide⟩ ⟨207, by decide⟩ := by
  have _previous := row_121_206
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_121_208 : RowResult ⟨121, by decide⟩ ⟨208, by decide⟩ := by
  have _previous := row_121_207
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_121_209 : RowResult ⟨121, by decide⟩ ⟨209, by decide⟩ := by
  have _previous := row_121_208
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨121, by decide⟩) (orbitCodeOfNumber ⟨209, by decide⟩) 2 3 6)

end RelativeConicArcs.Q25PairCertificate
