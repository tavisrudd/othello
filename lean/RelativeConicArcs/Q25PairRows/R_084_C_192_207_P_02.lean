import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_84_192 : RowResult ⟨84, by decide⟩ ⟨192, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_84_193 : RowResult ⟨84, by decide⟩ ⟨193, by decide⟩ := by
  have _previous := row_84_192
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_84_194 : RowResult ⟨84, by decide⟩ ⟨194, by decide⟩ := by
  have _previous := row_84_193
  exact Or.inr ⟨orbitCodeOfNumber ⟨237, by decide⟩, by decide⟩

theorem row_84_195 : RowResult ⟨84, by decide⟩ ⟨195, by decide⟩ := by
  have _previous := row_84_194
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨84, by decide⟩) (orbitCodeOfNumber ⟨195, by decide⟩) 1 2 7)

theorem row_84_196 : RowResult ⟨84, by decide⟩ ⟨196, by decide⟩ := by
  have _previous := row_84_195
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨84, by decide⟩) (orbitCodeOfNumber ⟨196, by decide⟩) 2 4 6)

theorem row_84_197 : RowResult ⟨84, by decide⟩ ⟨197, by decide⟩ := by
  have _previous := row_84_196
  exact Or.inr ⟨orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

theorem row_84_198 : RowResult ⟨84, by decide⟩ ⟨198, by decide⟩ := by
  have _previous := row_84_197
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_84_199 : RowResult ⟨84, by decide⟩ ⟨199, by decide⟩ := by
  have _previous := row_84_198
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨84, by decide⟩) (orbitCodeOfNumber ⟨199, by decide⟩) 1 4 7)

theorem row_84_200 : RowResult ⟨84, by decide⟩ ⟨200, by decide⟩ := by
  have _previous := row_84_199
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨84, by decide⟩) (orbitCodeOfNumber ⟨200, by decide⟩) 1 6 7)

theorem row_84_201 : RowResult ⟨84, by decide⟩ ⟨201, by decide⟩ := by
  have _previous := row_84_200
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨84, by decide⟩) (orbitCodeOfNumber ⟨201, by decide⟩) 1 6 7)

theorem row_84_202 : RowResult ⟨84, by decide⟩ ⟨202, by decide⟩ := by
  have _previous := row_84_201
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨84, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) 1 6 7)

theorem row_84_203 : RowResult ⟨84, by decide⟩ ⟨203, by decide⟩ := by
  have _previous := row_84_202
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨84, by decide⟩) (orbitCodeOfNumber ⟨203, by decide⟩) 1 6 7)

theorem row_84_204 : RowResult ⟨84, by decide⟩ ⟨204, by decide⟩ := by
  have _previous := row_84_203
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨84, by decide⟩) (orbitCodeOfNumber ⟨204, by decide⟩) 1 6 7)

theorem row_84_205 : RowResult ⟨84, by decide⟩ ⟨205, by decide⟩ := by
  have _previous := row_84_204
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨84, by decide⟩) (orbitCodeOfNumber ⟨205, by decide⟩) 1 2 6)

theorem row_84_206 : RowResult ⟨84, by decide⟩ ⟨206, by decide⟩ := by
  have _previous := row_84_205
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨84, by decide⟩) (orbitCodeOfNumber ⟨206, by decide⟩) 2 5 6)

theorem row_84_207 : RowResult ⟨84, by decide⟩ ⟨207, by decide⟩ := by
  have _previous := row_84_206
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
