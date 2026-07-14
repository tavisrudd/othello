import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_63_223 : RowResult ⟨63, by decide⟩ ⟨223, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_63_224 : RowResult ⟨63, by decide⟩ ⟨224, by decide⟩ := by
  have _previous := row_63_223
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨63, by decide⟩) (orbitCodeOfNumber ⟨224, by decide⟩) 2 5 7)

theorem row_63_225 : RowResult ⟨63, by decide⟩ ⟨225, by decide⟩ := by
  have _previous := row_63_224
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨63, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) 1 6 7)

theorem row_63_226 : RowResult ⟨63, by decide⟩ ⟨226, by decide⟩ := by
  have _previous := row_63_225
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨63, by decide⟩) (orbitCodeOfNumber ⟨226, by decide⟩) 1 6 7)

theorem row_63_227 : RowResult ⟨63, by decide⟩ ⟨227, by decide⟩ := by
  have _previous := row_63_226
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨63, by decide⟩) (orbitCodeOfNumber ⟨227, by decide⟩) 1 6 7)

theorem row_63_228 : RowResult ⟨63, by decide⟩ ⟨228, by decide⟩ := by
  have _previous := row_63_227
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨63, by decide⟩) (orbitCodeOfNumber ⟨228, by decide⟩) 1 6 7)

theorem row_63_229 : RowResult ⟨63, by decide⟩ ⟨229, by decide⟩ := by
  have _previous := row_63_228
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨63, by decide⟩) (orbitCodeOfNumber ⟨229, by decide⟩) 1 6 7)

theorem row_63_230 : RowResult ⟨63, by decide⟩ ⟨230, by decide⟩ := by
  have _previous := row_63_229
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨63, by decide⟩) (orbitCodeOfNumber ⟨230, by decide⟩) 1 2 6)

theorem row_63_231 : RowResult ⟨63, by decide⟩ ⟨231, by decide⟩ := by
  have _previous := row_63_230
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_63_232 : RowResult ⟨63, by decide⟩ ⟨232, by decide⟩ := by
  have _previous := row_63_231
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨63, by decide⟩) (orbitCodeOfNumber ⟨232, by decide⟩) 2 5 7)

theorem row_63_233 : RowResult ⟨63, by decide⟩ ⟨233, by decide⟩ := by
  have _previous := row_63_232
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_63_234 : RowResult ⟨63, by decide⟩ ⟨234, by decide⟩ := by
  have _previous := row_63_233
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_63_235 : RowResult ⟨63, by decide⟩ ⟨235, by decide⟩ := by
  have _previous := row_63_234
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨63, by decide⟩) (orbitCodeOfNumber ⟨235, by decide⟩) 2 5 6)

theorem row_63_236 : RowResult ⟨63, by decide⟩ ⟨236, by decide⟩ := by
  have _previous := row_63_235
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_63_237 : RowResult ⟨63, by decide⟩ ⟨237, by decide⟩ := by
  have _previous := row_63_236
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_63_238 : RowResult ⟨63, by decide⟩ ⟨238, by decide⟩ := by
  have _previous := row_63_237
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨63, by decide⟩) (orbitCodeOfNumber ⟨238, by decide⟩) 1 4 6)

theorem row_63_239 : RowResult ⟨63, by decide⟩ ⟨239, by decide⟩ := by
  have _previous := row_63_238
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨63, by decide⟩) (orbitCodeOfNumber ⟨239, by decide⟩) 2 3 6)

end RelativeConicArcs.Q25PairCertificate
