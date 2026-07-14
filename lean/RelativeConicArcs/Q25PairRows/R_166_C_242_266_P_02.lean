import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_166_242 : RowResult ⟨166, by decide⟩ ⟨242, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_166_243 : RowResult ⟨166, by decide⟩ ⟨243, by decide⟩ := by
  have _previous := row_166_242
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨166, by decide⟩) (orbitCodeOfNumber ⟨243, by decide⟩) 2 5 6)

theorem row_166_244 : RowResult ⟨166, by decide⟩ ⟨244, by decide⟩ := by
  have _previous := row_166_243
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_166_245 : RowResult ⟨166, by decide⟩ ⟨245, by decide⟩ := by
  have _previous := row_166_244
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨166, by decide⟩) (orbitCodeOfNumber ⟨245, by decide⟩) 1 2 7)

theorem row_166_246 : RowResult ⟨166, by decide⟩ ⟨246, by decide⟩ := by
  have _previous := row_166_245
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨166, by decide⟩) (orbitCodeOfNumber ⟨246, by decide⟩) 2 4 6)

theorem row_166_247 : RowResult ⟨166, by decide⟩ ⟨247, by decide⟩ := by
  have _previous := row_166_246
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_166_248 : RowResult ⟨166, by decide⟩ ⟨248, by decide⟩ := by
  have _previous := row_166_247
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_166_249 : RowResult ⟨166, by decide⟩ ⟨249, by decide⟩ := by
  have _previous := row_166_248
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨166, by decide⟩) (orbitCodeOfNumber ⟨249, by decide⟩) 2 4 7)

theorem row_166_250 : RowResult ⟨166, by decide⟩ ⟨250, by decide⟩ := by
  have _previous := row_166_249
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨166, by decide⟩) (orbitCodeOfNumber ⟨250, by decide⟩) 0 6 7)

theorem row_166_251 : RowResult ⟨166, by decide⟩ ⟨251, by decide⟩ := by
  have _previous := row_166_250
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨166, by decide⟩) (orbitCodeOfNumber ⟨251, by decide⟩) 0 6 7)

theorem row_166_252 : RowResult ⟨166, by decide⟩ ⟨252, by decide⟩ := by
  have _previous := row_166_251
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨166, by decide⟩) (orbitCodeOfNumber ⟨252, by decide⟩) 0 6 7)

theorem row_166_253 : RowResult ⟨166, by decide⟩ ⟨253, by decide⟩ := by
  have _previous := row_166_252
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨166, by decide⟩) (orbitCodeOfNumber ⟨253, by decide⟩) 0 6 7)

theorem row_166_254 : RowResult ⟨166, by decide⟩ ⟨254, by decide⟩ := by
  have _previous := row_166_253
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨166, by decide⟩) (orbitCodeOfNumber ⟨254, by decide⟩) 0 6 7)

theorem row_166_255 : RowResult ⟨166, by decide⟩ ⟨255, by decide⟩ := by
  have _previous := row_166_254
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨166, by decide⟩) (orbitCodeOfNumber ⟨255, by decide⟩) 0 6 7)

theorem row_166_256 : RowResult ⟨166, by decide⟩ ⟨256, by decide⟩ := by
  have _previous := row_166_255
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨166, by decide⟩) (orbitCodeOfNumber ⟨256, by decide⟩) 0 6 7)

theorem row_166_257 : RowResult ⟨166, by decide⟩ ⟨257, by decide⟩ := by
  have _previous := row_166_256
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨166, by decide⟩) (orbitCodeOfNumber ⟨257, by decide⟩) 0 6 7)

theorem row_166_258 : RowResult ⟨166, by decide⟩ ⟨258, by decide⟩ := by
  have _previous := row_166_257
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨166, by decide⟩) (orbitCodeOfNumber ⟨258, by decide⟩) 0 6 7)

theorem row_166_259 : RowResult ⟨166, by decide⟩ ⟨259, by decide⟩ := by
  have _previous := row_166_258
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨166, by decide⟩) (orbitCodeOfNumber ⟨259, by decide⟩) 0 6 7)

theorem row_166_260 : RowResult ⟨166, by decide⟩ ⟨260, by decide⟩ := by
  have _previous := row_166_259
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨166, by decide⟩) (orbitCodeOfNumber ⟨260, by decide⟩) 0 6 7)

theorem row_166_261 : RowResult ⟨166, by decide⟩ ⟨261, by decide⟩ := by
  have _previous := row_166_260
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨166, by decide⟩) (orbitCodeOfNumber ⟨261, by decide⟩) 0 6 7)

theorem row_166_262 : RowResult ⟨166, by decide⟩ ⟨262, by decide⟩ := by
  have _previous := row_166_261
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨166, by decide⟩) (orbitCodeOfNumber ⟨262, by decide⟩) 0 6 7)

theorem row_166_263 : RowResult ⟨166, by decide⟩ ⟨263, by decide⟩ := by
  have _previous := row_166_262
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨166, by decide⟩) (orbitCodeOfNumber ⟨263, by decide⟩) 0 6 7)

theorem row_166_264 : RowResult ⟨166, by decide⟩ ⟨264, by decide⟩ := by
  have _previous := row_166_263
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨166, by decide⟩) (orbitCodeOfNumber ⟨264, by decide⟩) 0 6 7)

theorem row_166_265 : RowResult ⟨166, by decide⟩ ⟨265, by decide⟩ := by
  have _previous := row_166_264
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨166, by decide⟩) (orbitCodeOfNumber ⟨265, by decide⟩) 0 6 7)

theorem row_166_266 : RowResult ⟨166, by decide⟩ ⟨266, by decide⟩ := by
  have _previous := row_166_265
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨166, by decide⟩) (orbitCodeOfNumber ⟨266, by decide⟩) 0 6 7)

end RelativeConicArcs.Q25PairCertificate
