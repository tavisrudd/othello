import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_161_243 : RowResult ⟨161, by decide⟩ ⟨243, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_161_244 : RowResult ⟨161, by decide⟩ ⟨244, by decide⟩ := by
  have _previous := row_161_243
  exact Or.inr ⟨orbitCodeOfNumber ⟨60, by decide⟩, by decide⟩

theorem row_161_245 : RowResult ⟨161, by decide⟩ ⟨245, by decide⟩ := by
  have _previous := row_161_244
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨161, by decide⟩) (orbitCodeOfNumber ⟨245, by decide⟩) 1 2 7)

theorem row_161_246 : RowResult ⟨161, by decide⟩ ⟨246, by decide⟩ := by
  have _previous := row_161_245
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_161_247 : RowResult ⟨161, by decide⟩ ⟨247, by decide⟩ := by
  have _previous := row_161_246
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_161_248 : RowResult ⟨161, by decide⟩ ⟨248, by decide⟩ := by
  have _previous := row_161_247
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨161, by decide⟩) (orbitCodeOfNumber ⟨248, by decide⟩) 4 5 6)

theorem row_161_249 : RowResult ⟨161, by decide⟩ ⟨249, by decide⟩ := by
  have _previous := row_161_248
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_161_250 : RowResult ⟨161, by decide⟩ ⟨250, by decide⟩ := by
  have _previous := row_161_249
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨161, by decide⟩) (orbitCodeOfNumber ⟨250, by decide⟩) 0 6 7)

theorem row_161_251 : RowResult ⟨161, by decide⟩ ⟨251, by decide⟩ := by
  have _previous := row_161_250
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨161, by decide⟩) (orbitCodeOfNumber ⟨251, by decide⟩) 0 6 7)

theorem row_161_252 : RowResult ⟨161, by decide⟩ ⟨252, by decide⟩ := by
  have _previous := row_161_251
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨161, by decide⟩) (orbitCodeOfNumber ⟨252, by decide⟩) 0 6 7)

theorem row_161_253 : RowResult ⟨161, by decide⟩ ⟨253, by decide⟩ := by
  have _previous := row_161_252
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨161, by decide⟩) (orbitCodeOfNumber ⟨253, by decide⟩) 0 6 7)

theorem row_161_254 : RowResult ⟨161, by decide⟩ ⟨254, by decide⟩ := by
  have _previous := row_161_253
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨161, by decide⟩) (orbitCodeOfNumber ⟨254, by decide⟩) 0 6 7)

theorem row_161_255 : RowResult ⟨161, by decide⟩ ⟨255, by decide⟩ := by
  have _previous := row_161_254
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨161, by decide⟩) (orbitCodeOfNumber ⟨255, by decide⟩) 0 6 7)

theorem row_161_256 : RowResult ⟨161, by decide⟩ ⟨256, by decide⟩ := by
  have _previous := row_161_255
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨161, by decide⟩) (orbitCodeOfNumber ⟨256, by decide⟩) 0 6 7)

theorem row_161_257 : RowResult ⟨161, by decide⟩ ⟨257, by decide⟩ := by
  have _previous := row_161_256
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨161, by decide⟩) (orbitCodeOfNumber ⟨257, by decide⟩) 0 6 7)

theorem row_161_258 : RowResult ⟨161, by decide⟩ ⟨258, by decide⟩ := by
  have _previous := row_161_257
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨161, by decide⟩) (orbitCodeOfNumber ⟨258, by decide⟩) 0 6 7)

theorem row_161_259 : RowResult ⟨161, by decide⟩ ⟨259, by decide⟩ := by
  have _previous := row_161_258
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨161, by decide⟩) (orbitCodeOfNumber ⟨259, by decide⟩) 0 6 7)

theorem row_161_260 : RowResult ⟨161, by decide⟩ ⟨260, by decide⟩ := by
  have _previous := row_161_259
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨161, by decide⟩) (orbitCodeOfNumber ⟨260, by decide⟩) 0 6 7)

theorem row_161_261 : RowResult ⟨161, by decide⟩ ⟨261, by decide⟩ := by
  have _previous := row_161_260
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨161, by decide⟩) (orbitCodeOfNumber ⟨261, by decide⟩) 0 6 7)

end RelativeConicArcs.Q25PairCertificate
