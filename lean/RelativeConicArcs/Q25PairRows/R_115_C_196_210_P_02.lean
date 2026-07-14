import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_115_196 : RowResult ⟨115, by decide⟩ ⟨196, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_115_197 : RowResult ⟨115, by decide⟩ ⟨197, by decide⟩ := by
  have _previous := row_115_196
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨115, by decide⟩) (orbitCodeOfNumber ⟨197, by decide⟩) 2 4 6)

theorem row_115_198 : RowResult ⟨115, by decide⟩ ⟨198, by decide⟩ := by
  have _previous := row_115_197
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_115_199 : RowResult ⟨115, by decide⟩ ⟨199, by decide⟩ := by
  have _previous := row_115_198
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_115_200 : RowResult ⟨115, by decide⟩ ⟨200, by decide⟩ := by
  have _previous := row_115_199
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨115, by decide⟩) (orbitCodeOfNumber ⟨200, by decide⟩) 1 6 7)

theorem row_115_201 : RowResult ⟨115, by decide⟩ ⟨201, by decide⟩ := by
  have _previous := row_115_200
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨115, by decide⟩) (orbitCodeOfNumber ⟨201, by decide⟩) 1 6 7)

theorem row_115_202 : RowResult ⟨115, by decide⟩ ⟨202, by decide⟩ := by
  have _previous := row_115_201
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨115, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) 1 6 7)

theorem row_115_203 : RowResult ⟨115, by decide⟩ ⟨203, by decide⟩ := by
  have _previous := row_115_202
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨115, by decide⟩) (orbitCodeOfNumber ⟨203, by decide⟩) 1 6 7)

theorem row_115_204 : RowResult ⟨115, by decide⟩ ⟨204, by decide⟩ := by
  have _previous := row_115_203
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨115, by decide⟩) (orbitCodeOfNumber ⟨204, by decide⟩) 1 6 7)

theorem row_115_205 : RowResult ⟨115, by decide⟩ ⟨205, by decide⟩ := by
  have _previous := row_115_204
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨115, by decide⟩) (orbitCodeOfNumber ⟨205, by decide⟩) 1 2 6)

theorem row_115_206 : RowResult ⟨115, by decide⟩ ⟨206, by decide⟩ := by
  have _previous := row_115_205
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_115_207 : RowResult ⟨115, by decide⟩ ⟨207, by decide⟩ := by
  have _previous := row_115_206
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_115_208 : RowResult ⟨115, by decide⟩ ⟨208, by decide⟩ := by
  have _previous := row_115_207
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_115_209 : RowResult ⟨115, by decide⟩ ⟨209, by decide⟩ := by
  have _previous := row_115_208
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨115, by decide⟩) (orbitCodeOfNumber ⟨209, by decide⟩) 2 3 6)

theorem row_115_210 : RowResult ⟨115, by decide⟩ ⟨210, by decide⟩ := by
  have _previous := row_115_209
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨115, by decide⟩) (orbitCodeOfNumber ⟨210, by decide⟩) 1 4 7)

end RelativeConicArcs.Q25PairCertificate
