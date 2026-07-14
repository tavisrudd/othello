import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_63_240 : RowResult ⟨63, by decide⟩ ⟨240, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

theorem row_63_241 : RowResult ⟨63, by decide⟩ ⟨241, by decide⟩ := by
  have _previous := row_63_240
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_63_242 : RowResult ⟨63, by decide⟩ ⟨242, by decide⟩ := by
  have _previous := row_63_241
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_63_243 : RowResult ⟨63, by decide⟩ ⟨243, by decide⟩ := by
  have _previous := row_63_242
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨63, by decide⟩) (orbitCodeOfNumber ⟨243, by decide⟩) 1 4 7)

theorem row_63_244 : RowResult ⟨63, by decide⟩ ⟨244, by decide⟩ := by
  have _previous := row_63_243
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨63, by decide⟩) (orbitCodeOfNumber ⟨244, by decide⟩) 2 4 6)

theorem row_63_245 : RowResult ⟨63, by decide⟩ ⟨245, by decide⟩ := by
  have _previous := row_63_244
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨63, by decide⟩) (orbitCodeOfNumber ⟨245, by decide⟩) 1 2 7)

theorem row_63_246 : RowResult ⟨63, by decide⟩ ⟨246, by decide⟩ := by
  have _previous := row_63_245
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨63, by decide⟩) (orbitCodeOfNumber ⟨246, by decide⟩) 2 4 7)

theorem row_63_247 : RowResult ⟨63, by decide⟩ ⟨247, by decide⟩ := by
  have _previous := row_63_246
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_63_248 : RowResult ⟨63, by decide⟩ ⟨248, by decide⟩ := by
  have _previous := row_63_247
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_63_249 : RowResult ⟨63, by decide⟩ ⟨249, by decide⟩ := by
  have _previous := row_63_248
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨63, by decide⟩) (orbitCodeOfNumber ⟨249, by decide⟩) 4 5 6)

theorem row_63_250 : RowResult ⟨63, by decide⟩ ⟨250, by decide⟩ := by
  have _previous := row_63_249
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨63, by decide⟩) (orbitCodeOfNumber ⟨250, by decide⟩) 0 6 7)

theorem row_63_251 : RowResult ⟨63, by decide⟩ ⟨251, by decide⟩ := by
  have _previous := row_63_250
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨63, by decide⟩) (orbitCodeOfNumber ⟨251, by decide⟩) 0 6 7)

theorem row_63_252 : RowResult ⟨63, by decide⟩ ⟨252, by decide⟩ := by
  have _previous := row_63_251
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨63, by decide⟩) (orbitCodeOfNumber ⟨252, by decide⟩) 0 6 7)

theorem row_63_253 : RowResult ⟨63, by decide⟩ ⟨253, by decide⟩ := by
  have _previous := row_63_252
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨63, by decide⟩) (orbitCodeOfNumber ⟨253, by decide⟩) 0 6 7)

theorem row_63_254 : RowResult ⟨63, by decide⟩ ⟨254, by decide⟩ := by
  have _previous := row_63_253
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨63, by decide⟩) (orbitCodeOfNumber ⟨254, by decide⟩) 0 6 7)

theorem row_63_255 : RowResult ⟨63, by decide⟩ ⟨255, by decide⟩ := by
  have _previous := row_63_254
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨63, by decide⟩) (orbitCodeOfNumber ⟨255, by decide⟩) 0 6 7)

theorem row_63_256 : RowResult ⟨63, by decide⟩ ⟨256, by decide⟩ := by
  have _previous := row_63_255
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨63, by decide⟩) (orbitCodeOfNumber ⟨256, by decide⟩) 0 6 7)

theorem row_63_257 : RowResult ⟨63, by decide⟩ ⟨257, by decide⟩ := by
  have _previous := row_63_256
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨63, by decide⟩) (orbitCodeOfNumber ⟨257, by decide⟩) 0 6 7)

theorem row_63_258 : RowResult ⟨63, by decide⟩ ⟨258, by decide⟩ := by
  have _previous := row_63_257
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨63, by decide⟩) (orbitCodeOfNumber ⟨258, by decide⟩) 0 6 7)

theorem row_63_259 : RowResult ⟨63, by decide⟩ ⟨259, by decide⟩ := by
  have _previous := row_63_258
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨63, by decide⟩) (orbitCodeOfNumber ⟨259, by decide⟩) 0 6 7)

theorem row_63_260 : RowResult ⟨63, by decide⟩ ⟨260, by decide⟩ := by
  have _previous := row_63_259
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨63, by decide⟩) (orbitCodeOfNumber ⟨260, by decide⟩) 0 6 7)

theorem row_63_261 : RowResult ⟨63, by decide⟩ ⟨261, by decide⟩ := by
  have _previous := row_63_260
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨63, by decide⟩) (orbitCodeOfNumber ⟨261, by decide⟩) 0 6 7)

theorem row_63_262 : RowResult ⟨63, by decide⟩ ⟨262, by decide⟩ := by
  have _previous := row_63_261
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨63, by decide⟩) (orbitCodeOfNumber ⟨262, by decide⟩) 0 6 7)

theorem row_63_263 : RowResult ⟨63, by decide⟩ ⟨263, by decide⟩ := by
  have _previous := row_63_262
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨63, by decide⟩) (orbitCodeOfNumber ⟨263, by decide⟩) 0 6 7)

end RelativeConicArcs.Q25PairCertificate
