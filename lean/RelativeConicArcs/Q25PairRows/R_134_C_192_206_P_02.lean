import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_134_192 : RowResult ⟨134, by decide⟩ ⟨192, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_134_193 : RowResult ⟨134, by decide⟩ ⟨193, by decide⟩ := by
  have _previous := row_134_192
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_134_194 : RowResult ⟨134, by decide⟩ ⟨194, by decide⟩ := by
  have _previous := row_134_193
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_134_195 : RowResult ⟨134, by decide⟩ ⟨195, by decide⟩ := by
  have _previous := row_134_194
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨134, by decide⟩) (orbitCodeOfNumber ⟨195, by decide⟩) 1 2 7)

theorem row_134_196 : RowResult ⟨134, by decide⟩ ⟨196, by decide⟩ := by
  have _previous := row_134_195
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_134_197 : RowResult ⟨134, by decide⟩ ⟨197, by decide⟩ := by
  have _previous := row_134_196
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_134_198 : RowResult ⟨134, by decide⟩ ⟨198, by decide⟩ := by
  have _previous := row_134_197
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨134, by decide⟩) (orbitCodeOfNumber ⟨198, by decide⟩) 2 4 6)

theorem row_134_199 : RowResult ⟨134, by decide⟩ ⟨199, by decide⟩ := by
  have _previous := row_134_198
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨134, by decide⟩) (orbitCodeOfNumber ⟨199, by decide⟩) 1 4 7)

theorem row_134_200 : RowResult ⟨134, by decide⟩ ⟨200, by decide⟩ := by
  have _previous := row_134_199
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨134, by decide⟩) (orbitCodeOfNumber ⟨200, by decide⟩) 1 6 7)

theorem row_134_201 : RowResult ⟨134, by decide⟩ ⟨201, by decide⟩ := by
  have _previous := row_134_200
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨134, by decide⟩) (orbitCodeOfNumber ⟨201, by decide⟩) 1 6 7)

theorem row_134_202 : RowResult ⟨134, by decide⟩ ⟨202, by decide⟩ := by
  have _previous := row_134_201
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨134, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) 1 6 7)

theorem row_134_203 : RowResult ⟨134, by decide⟩ ⟨203, by decide⟩ := by
  have _previous := row_134_202
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨134, by decide⟩) (orbitCodeOfNumber ⟨203, by decide⟩) 1 6 7)

theorem row_134_204 : RowResult ⟨134, by decide⟩ ⟨204, by decide⟩ := by
  have _previous := row_134_203
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨134, by decide⟩) (orbitCodeOfNumber ⟨204, by decide⟩) 1 6 7)

theorem row_134_205 : RowResult ⟨134, by decide⟩ ⟨205, by decide⟩ := by
  have _previous := row_134_204
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨134, by decide⟩) (orbitCodeOfNumber ⟨205, by decide⟩) 1 2 6)

theorem row_134_206 : RowResult ⟨134, by decide⟩ ⟨206, by decide⟩ := by
  have _previous := row_134_205
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
