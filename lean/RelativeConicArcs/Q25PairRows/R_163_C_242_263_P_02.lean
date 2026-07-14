import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_163_242 : RowResult ⟨163, by decide⟩ ⟨242, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_163_243 : RowResult ⟨163, by decide⟩ ⟨243, by decide⟩ := by
  have _previous := row_163_242
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨163, by decide⟩) (orbitCodeOfNumber ⟨243, by decide⟩) 1 4 7)

theorem row_163_244 : RowResult ⟨163, by decide⟩ ⟨244, by decide⟩ := by
  have _previous := row_163_243
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_163_245 : RowResult ⟨163, by decide⟩ ⟨245, by decide⟩ := by
  have _previous := row_163_244
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨163, by decide⟩) (orbitCodeOfNumber ⟨245, by decide⟩) 1 2 7)

theorem row_163_246 : RowResult ⟨163, by decide⟩ ⟨246, by decide⟩ := by
  have _previous := row_163_245
  exact Or.inr ⟨orbitCodeOfNumber ⟨183, by decide⟩, by decide⟩

theorem row_163_247 : RowResult ⟨163, by decide⟩ ⟨247, by decide⟩ := by
  have _previous := row_163_246
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨163, by decide⟩) (orbitCodeOfNumber ⟨247, by decide⟩) 2 4 7)

theorem row_163_248 : RowResult ⟨163, by decide⟩ ⟨248, by decide⟩ := by
  have _previous := row_163_247
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_163_249 : RowResult ⟨163, by decide⟩ ⟨249, by decide⟩ := by
  have _previous := row_163_248
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_163_250 : RowResult ⟨163, by decide⟩ ⟨250, by decide⟩ := by
  have _previous := row_163_249
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨163, by decide⟩) (orbitCodeOfNumber ⟨250, by decide⟩) 0 6 7)

theorem row_163_251 : RowResult ⟨163, by decide⟩ ⟨251, by decide⟩ := by
  have _previous := row_163_250
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨163, by decide⟩) (orbitCodeOfNumber ⟨251, by decide⟩) 0 6 7)

theorem row_163_252 : RowResult ⟨163, by decide⟩ ⟨252, by decide⟩ := by
  have _previous := row_163_251
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨163, by decide⟩) (orbitCodeOfNumber ⟨252, by decide⟩) 0 6 7)

theorem row_163_253 : RowResult ⟨163, by decide⟩ ⟨253, by decide⟩ := by
  have _previous := row_163_252
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨163, by decide⟩) (orbitCodeOfNumber ⟨253, by decide⟩) 0 6 7)

theorem row_163_254 : RowResult ⟨163, by decide⟩ ⟨254, by decide⟩ := by
  have _previous := row_163_253
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨163, by decide⟩) (orbitCodeOfNumber ⟨254, by decide⟩) 0 6 7)

theorem row_163_255 : RowResult ⟨163, by decide⟩ ⟨255, by decide⟩ := by
  have _previous := row_163_254
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨163, by decide⟩) (orbitCodeOfNumber ⟨255, by decide⟩) 0 6 7)

theorem row_163_256 : RowResult ⟨163, by decide⟩ ⟨256, by decide⟩ := by
  have _previous := row_163_255
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨163, by decide⟩) (orbitCodeOfNumber ⟨256, by decide⟩) 0 6 7)

theorem row_163_257 : RowResult ⟨163, by decide⟩ ⟨257, by decide⟩ := by
  have _previous := row_163_256
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨163, by decide⟩) (orbitCodeOfNumber ⟨257, by decide⟩) 0 6 7)

theorem row_163_258 : RowResult ⟨163, by decide⟩ ⟨258, by decide⟩ := by
  have _previous := row_163_257
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨163, by decide⟩) (orbitCodeOfNumber ⟨258, by decide⟩) 0 6 7)

theorem row_163_259 : RowResult ⟨163, by decide⟩ ⟨259, by decide⟩ := by
  have _previous := row_163_258
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨163, by decide⟩) (orbitCodeOfNumber ⟨259, by decide⟩) 0 6 7)

theorem row_163_260 : RowResult ⟨163, by decide⟩ ⟨260, by decide⟩ := by
  have _previous := row_163_259
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨163, by decide⟩) (orbitCodeOfNumber ⟨260, by decide⟩) 0 6 7)

theorem row_163_261 : RowResult ⟨163, by decide⟩ ⟨261, by decide⟩ := by
  have _previous := row_163_260
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨163, by decide⟩) (orbitCodeOfNumber ⟨261, by decide⟩) 0 6 7)

theorem row_163_262 : RowResult ⟨163, by decide⟩ ⟨262, by decide⟩ := by
  have _previous := row_163_261
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨163, by decide⟩) (orbitCodeOfNumber ⟨262, by decide⟩) 0 6 7)

theorem row_163_263 : RowResult ⟨163, by decide⟩ ⟨263, by decide⟩ := by
  have _previous := row_163_262
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨163, by decide⟩) (orbitCodeOfNumber ⟨263, by decide⟩) 0 6 7)

end RelativeConicArcs.Q25PairCertificate
