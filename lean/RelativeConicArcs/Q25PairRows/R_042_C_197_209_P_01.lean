import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_42_197 : RowResult ⟨42, by decide⟩ ⟨197, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_42_198 : RowResult ⟨42, by decide⟩ ⟨198, by decide⟩ := by
  have _previous := row_42_197
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_42_199 : RowResult ⟨42, by decide⟩ ⟨199, by decide⟩ := by
  have _previous := row_42_198
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_42_200 : RowResult ⟨42, by decide⟩ ⟨200, by decide⟩ := by
  have _previous := row_42_199
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨42, by decide⟩) (orbitCodeOfNumber ⟨200, by decide⟩) 1 6 7)

theorem row_42_201 : RowResult ⟨42, by decide⟩ ⟨201, by decide⟩ := by
  have _previous := row_42_200
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨42, by decide⟩) (orbitCodeOfNumber ⟨201, by decide⟩) 1 6 7)

theorem row_42_202 : RowResult ⟨42, by decide⟩ ⟨202, by decide⟩ := by
  have _previous := row_42_201
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨42, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) 1 6 7)

theorem row_42_203 : RowResult ⟨42, by decide⟩ ⟨203, by decide⟩ := by
  have _previous := row_42_202
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨42, by decide⟩) (orbitCodeOfNumber ⟨203, by decide⟩) 1 6 7)

theorem row_42_204 : RowResult ⟨42, by decide⟩ ⟨204, by decide⟩ := by
  have _previous := row_42_203
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨42, by decide⟩) (orbitCodeOfNumber ⟨204, by decide⟩) 1 6 7)

theorem row_42_205 : RowResult ⟨42, by decide⟩ ⟨205, by decide⟩ := by
  have _previous := row_42_204
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨42, by decide⟩) (orbitCodeOfNumber ⟨205, by decide⟩) 1 2 6)

theorem row_42_206 : RowResult ⟨42, by decide⟩ ⟨206, by decide⟩ := by
  have _previous := row_42_205
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_42_207 : RowResult ⟨42, by decide⟩ ⟨207, by decide⟩ := by
  have _previous := row_42_206
  exact Or.inr ⟨orbitCodeOfNumber ⟨116, by decide⟩, by decide⟩

theorem row_42_208 : RowResult ⟨42, by decide⟩ ⟨208, by decide⟩ := by
  have _previous := row_42_207
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_42_209 : RowResult ⟨42, by decide⟩ ⟨209, by decide⟩ := by
  have _previous := row_42_208
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨42, by decide⟩) (orbitCodeOfNumber ⟨209, by decide⟩) 2 3 6)

end RelativeConicArcs.Q25PairCertificate
