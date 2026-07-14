import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_122_223 : RowResult ⟨122, by decide⟩ ⟨223, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨237, by decide⟩, by decide⟩

theorem row_122_224 : RowResult ⟨122, by decide⟩ ⟨224, by decide⟩ := by
  have _previous := row_122_223
  exact Or.inr ⟨orbitCodeOfNumber ⟨231, by decide⟩, by decide⟩

theorem row_122_225 : RowResult ⟨122, by decide⟩ ⟨225, by decide⟩ := by
  have _previous := row_122_224
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨122, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) 1 6 7)

theorem row_122_226 : RowResult ⟨122, by decide⟩ ⟨226, by decide⟩ := by
  have _previous := row_122_225
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨122, by decide⟩) (orbitCodeOfNumber ⟨226, by decide⟩) 1 6 7)

theorem row_122_227 : RowResult ⟨122, by decide⟩ ⟨227, by decide⟩ := by
  have _previous := row_122_226
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨122, by decide⟩) (orbitCodeOfNumber ⟨227, by decide⟩) 1 6 7)

theorem row_122_228 : RowResult ⟨122, by decide⟩ ⟨228, by decide⟩ := by
  have _previous := row_122_227
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨122, by decide⟩) (orbitCodeOfNumber ⟨228, by decide⟩) 1 6 7)

theorem row_122_229 : RowResult ⟨122, by decide⟩ ⟨229, by decide⟩ := by
  have _previous := row_122_228
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨122, by decide⟩) (orbitCodeOfNumber ⟨229, by decide⟩) 1 6 7)

theorem row_122_230 : RowResult ⟨122, by decide⟩ ⟨230, by decide⟩ := by
  have _previous := row_122_229
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨122, by decide⟩) (orbitCodeOfNumber ⟨230, by decide⟩) 1 2 6)

theorem row_122_231 : RowResult ⟨122, by decide⟩ ⟨231, by decide⟩ := by
  have _previous := row_122_230
  exact Or.inr ⟨orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

theorem row_122_232 : RowResult ⟨122, by decide⟩ ⟨232, by decide⟩ := by
  have _previous := row_122_231
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨122, by decide⟩) (orbitCodeOfNumber ⟨232, by decide⟩) 1 4 7)

theorem row_122_233 : RowResult ⟨122, by decide⟩ ⟨233, by decide⟩ := by
  have _previous := row_122_232
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_122_234 : RowResult ⟨122, by decide⟩ ⟨234, by decide⟩ := by
  have _previous := row_122_233
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨122, by decide⟩) (orbitCodeOfNumber ⟨234, by decide⟩) 2 5 6)

theorem row_122_235 : RowResult ⟨122, by decide⟩ ⟨235, by decide⟩ := by
  have _previous := row_122_234
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_122_236 : RowResult ⟨122, by decide⟩ ⟨236, by decide⟩ := by
  have _previous := row_122_235
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
