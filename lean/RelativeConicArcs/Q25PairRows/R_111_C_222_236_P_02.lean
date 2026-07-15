import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_111_222 : RowResult ⟨111, by decide⟩ ⟨222, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_111_223 : RowResult ⟨111, by decide⟩ ⟨223, by decide⟩ := by
  have _previous := row_111_222
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨246, by decide⟩, by decide⟩

theorem row_111_224 : RowResult ⟨111, by decide⟩ ⟨224, by decide⟩ := by
  have _previous := row_111_223
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_111_225 : RowResult ⟨111, by decide⟩ ⟨225, by decide⟩ := by
  have _previous := row_111_224
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨111, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) 1 6 7)

theorem row_111_226 : RowResult ⟨111, by decide⟩ ⟨226, by decide⟩ := by
  have _previous := row_111_225
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨111, by decide⟩) (orbitCodeOfNumber ⟨226, by decide⟩) 1 6 7)

theorem row_111_227 : RowResult ⟨111, by decide⟩ ⟨227, by decide⟩ := by
  have _previous := row_111_226
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨111, by decide⟩) (orbitCodeOfNumber ⟨227, by decide⟩) 1 6 7)

theorem row_111_228 : RowResult ⟨111, by decide⟩ ⟨228, by decide⟩ := by
  have _previous := row_111_227
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨111, by decide⟩) (orbitCodeOfNumber ⟨228, by decide⟩) 1 6 7)

theorem row_111_229 : RowResult ⟨111, by decide⟩ ⟨229, by decide⟩ := by
  have _previous := row_111_228
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨111, by decide⟩) (orbitCodeOfNumber ⟨229, by decide⟩) 1 6 7)

theorem row_111_230 : RowResult ⟨111, by decide⟩ ⟨230, by decide⟩ := by
  have _previous := row_111_229
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨111, by decide⟩) (orbitCodeOfNumber ⟨230, by decide⟩) 1 2 6)

theorem row_111_231 : RowResult ⟨111, by decide⟩ ⟨231, by decide⟩ := by
  have _previous := row_111_230
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨223, by decide⟩, by decide⟩

theorem row_111_232 : RowResult ⟨111, by decide⟩ ⟨232, by decide⟩ := by
  have _previous := row_111_231
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨221, by decide⟩, by decide⟩

theorem row_111_233 : RowResult ⟨111, by decide⟩ ⟨233, by decide⟩ := by
  have _previous := row_111_232
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨111, by decide⟩) (orbitCodeOfNumber ⟨233, by decide⟩) 2 4 6)

theorem row_111_234 : RowResult ⟨111, by decide⟩ ⟨234, by decide⟩ := by
  have _previous := row_111_233
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨111, by decide⟩) (orbitCodeOfNumber ⟨234, by decide⟩) 2 4 7)

theorem row_111_235 : RowResult ⟨111, by decide⟩ ⟨235, by decide⟩ := by
  have _previous := row_111_234
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨223, by decide⟩, by decide⟩

theorem row_111_236 : RowResult ⟨111, by decide⟩ ⟨236, by decide⟩ := by
  have _previous := row_111_235
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨111, by decide⟩) (orbitCodeOfNumber ⟨236, by decide⟩) 1 4 6)

end RelativeConicArcs.Q25PairCertificate
