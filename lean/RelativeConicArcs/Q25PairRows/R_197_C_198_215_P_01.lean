import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_197_198 : RowResult ⟨197, by decide⟩ ⟨198, by decide⟩ := by
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨197, by decide⟩) (orbitCodeOfNumber ⟨198, by decide⟩) 0 4 6)

theorem row_197_199 : RowResult ⟨197, by decide⟩ ⟨199, by decide⟩ := by
  have _previous := row_197_198
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨197, by decide⟩) (orbitCodeOfNumber ⟨199, by decide⟩) 0 4 6)

theorem row_197_200 : RowResult ⟨197, by decide⟩ ⟨200, by decide⟩ := by
  have _previous := row_197_199
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨197, by decide⟩) (orbitCodeOfNumber ⟨200, by decide⟩) 1 6 7)

theorem row_197_201 : RowResult ⟨197, by decide⟩ ⟨201, by decide⟩ := by
  have _previous := row_197_200
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨197, by decide⟩) (orbitCodeOfNumber ⟨201, by decide⟩) 1 6 7)

theorem row_197_202 : RowResult ⟨197, by decide⟩ ⟨202, by decide⟩ := by
  have _previous := row_197_201
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨197, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) 1 6 7)

theorem row_197_203 : RowResult ⟨197, by decide⟩ ⟨203, by decide⟩ := by
  have _previous := row_197_202
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨197, by decide⟩) (orbitCodeOfNumber ⟨203, by decide⟩) 1 6 7)

theorem row_197_204 : RowResult ⟨197, by decide⟩ ⟨204, by decide⟩ := by
  have _previous := row_197_203
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨197, by decide⟩) (orbitCodeOfNumber ⟨204, by decide⟩) 1 6 7)

theorem row_197_205 : RowResult ⟨197, by decide⟩ ⟨205, by decide⟩ := by
  have _previous := row_197_204
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨197, by decide⟩) (orbitCodeOfNumber ⟨205, by decide⟩) 1 2 6)

theorem row_197_206 : RowResult ⟨197, by decide⟩ ⟨206, by decide⟩ := by
  have _previous := row_197_205
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_197_207 : RowResult ⟨197, by decide⟩ ⟨207, by decide⟩ := by
  have _previous := row_197_206
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨197, by decide⟩) (orbitCodeOfNumber ⟨207, by decide⟩) 1 4 7)

theorem row_197_208 : RowResult ⟨197, by decide⟩ ⟨208, by decide⟩ := by
  have _previous := row_197_207
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_197_209 : RowResult ⟨197, by decide⟩ ⟨209, by decide⟩ := by
  have _previous := row_197_208
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨197, by decide⟩) (orbitCodeOfNumber ⟨209, by decide⟩) 2 3 6)

theorem row_197_210 : RowResult ⟨197, by decide⟩ ⟨210, by decide⟩ := by
  have _previous := row_197_209
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨197, by decide⟩) (orbitCodeOfNumber ⟨210, by decide⟩) 2 5 7)

theorem row_197_211 : RowResult ⟨197, by decide⟩ ⟨211, by decide⟩ := by
  have _previous := row_197_210
  exact Or.inr ⟨orbitCodeOfNumber ⟨114, by decide⟩, by decide⟩

theorem row_197_212 : RowResult ⟨197, by decide⟩ ⟨212, by decide⟩ := by
  have _previous := row_197_211
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_197_213 : RowResult ⟨197, by decide⟩ ⟨213, by decide⟩ := by
  have _previous := row_197_212
  exact Or.inr ⟨orbitCodeOfNumber ⟨116, by decide⟩, by decide⟩

theorem row_197_214 : RowResult ⟨197, by decide⟩ ⟨214, by decide⟩ := by
  have _previous := row_197_213
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨197, by decide⟩) (orbitCodeOfNumber ⟨214, by decide⟩) 4 5 6)

theorem row_197_215 : RowResult ⟨197, by decide⟩ ⟨215, by decide⟩ := by
  have _previous := row_197_214
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
