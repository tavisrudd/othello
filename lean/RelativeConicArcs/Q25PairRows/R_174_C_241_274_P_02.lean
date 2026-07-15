import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_174_241 : RowResult ⟨174, by decide⟩ ⟨241, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨37, by decide⟩,
    orbitCodeOfNumber ⟨222, by decide⟩, by decide⟩

theorem row_174_242 : RowResult ⟨174, by decide⟩ ⟨242, by decide⟩ := by
  have _previous := row_174_241
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨221, by decide⟩, by decide⟩

theorem row_174_243 : RowResult ⟨174, by decide⟩ ⟨243, by decide⟩ := by
  have _previous := row_174_242
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨174, by decide⟩) (orbitCodeOfNumber ⟨243, by decide⟩) 4 5 6)

theorem row_174_244 : RowResult ⟨174, by decide⟩ ⟨244, by decide⟩ := by
  have _previous := row_174_243
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨174, by decide⟩) (orbitCodeOfNumber ⟨244, by decide⟩) 2 4 6)

theorem row_174_245 : RowResult ⟨174, by decide⟩ ⟨245, by decide⟩ := by
  have _previous := row_174_244
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨174, by decide⟩) (orbitCodeOfNumber ⟨245, by decide⟩) 1 2 7)

theorem row_174_246 : RowResult ⟨174, by decide⟩ ⟨246, by decide⟩ := by
  have _previous := row_174_245
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨174, by decide⟩) (orbitCodeOfNumber ⟨246, by decide⟩) 2 4 7)

theorem row_174_247 : RowResult ⟨174, by decide⟩ ⟨247, by decide⟩ := by
  have _previous := row_174_246
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

theorem row_174_248 : RowResult ⟨174, by decide⟩ ⟨248, by decide⟩ := by
  have _previous := row_174_247
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨222, by decide⟩, by decide⟩

theorem row_174_249 : RowResult ⟨174, by decide⟩ ⟨249, by decide⟩ := by
  have _previous := row_174_248
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨174, by decide⟩) (orbitCodeOfNumber ⟨249, by decide⟩) 1 4 6)

theorem row_174_250 : RowResult ⟨174, by decide⟩ ⟨250, by decide⟩ := by
  have _previous := row_174_249
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨174, by decide⟩) (orbitCodeOfNumber ⟨250, by decide⟩) 0 6 7)

theorem row_174_251 : RowResult ⟨174, by decide⟩ ⟨251, by decide⟩ := by
  have _previous := row_174_250
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨174, by decide⟩) (orbitCodeOfNumber ⟨251, by decide⟩) 0 6 7)

theorem row_174_252 : RowResult ⟨174, by decide⟩ ⟨252, by decide⟩ := by
  have _previous := row_174_251
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨174, by decide⟩) (orbitCodeOfNumber ⟨252, by decide⟩) 0 6 7)

theorem row_174_253 : RowResult ⟨174, by decide⟩ ⟨253, by decide⟩ := by
  have _previous := row_174_252
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨174, by decide⟩) (orbitCodeOfNumber ⟨253, by decide⟩) 0 6 7)

theorem row_174_254 : RowResult ⟨174, by decide⟩ ⟨254, by decide⟩ := by
  have _previous := row_174_253
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨174, by decide⟩) (orbitCodeOfNumber ⟨254, by decide⟩) 0 6 7)

theorem row_174_255 : RowResult ⟨174, by decide⟩ ⟨255, by decide⟩ := by
  have _previous := row_174_254
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨174, by decide⟩) (orbitCodeOfNumber ⟨255, by decide⟩) 0 6 7)

theorem row_174_256 : RowResult ⟨174, by decide⟩ ⟨256, by decide⟩ := by
  have _previous := row_174_255
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨174, by decide⟩) (orbitCodeOfNumber ⟨256, by decide⟩) 0 6 7)

theorem row_174_257 : RowResult ⟨174, by decide⟩ ⟨257, by decide⟩ := by
  have _previous := row_174_256
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨174, by decide⟩) (orbitCodeOfNumber ⟨257, by decide⟩) 0 6 7)

theorem row_174_258 : RowResult ⟨174, by decide⟩ ⟨258, by decide⟩ := by
  have _previous := row_174_257
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨174, by decide⟩) (orbitCodeOfNumber ⟨258, by decide⟩) 0 6 7)

theorem row_174_259 : RowResult ⟨174, by decide⟩ ⟨259, by decide⟩ := by
  have _previous := row_174_258
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨174, by decide⟩) (orbitCodeOfNumber ⟨259, by decide⟩) 0 6 7)

theorem row_174_260 : RowResult ⟨174, by decide⟩ ⟨260, by decide⟩ := by
  have _previous := row_174_259
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨174, by decide⟩) (orbitCodeOfNumber ⟨260, by decide⟩) 0 6 7)

theorem row_174_261 : RowResult ⟨174, by decide⟩ ⟨261, by decide⟩ := by
  have _previous := row_174_260
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨174, by decide⟩) (orbitCodeOfNumber ⟨261, by decide⟩) 0 6 7)

theorem row_174_262 : RowResult ⟨174, by decide⟩ ⟨262, by decide⟩ := by
  have _previous := row_174_261
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨174, by decide⟩) (orbitCodeOfNumber ⟨262, by decide⟩) 0 6 7)

theorem row_174_263 : RowResult ⟨174, by decide⟩ ⟨263, by decide⟩ := by
  have _previous := row_174_262
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨174, by decide⟩) (orbitCodeOfNumber ⟨263, by decide⟩) 0 6 7)

theorem row_174_264 : RowResult ⟨174, by decide⟩ ⟨264, by decide⟩ := by
  have _previous := row_174_263
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨174, by decide⟩) (orbitCodeOfNumber ⟨264, by decide⟩) 0 6 7)

theorem row_174_265 : RowResult ⟨174, by decide⟩ ⟨265, by decide⟩ := by
  have _previous := row_174_264
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨174, by decide⟩) (orbitCodeOfNumber ⟨265, by decide⟩) 0 6 7)

theorem row_174_266 : RowResult ⟨174, by decide⟩ ⟨266, by decide⟩ := by
  have _previous := row_174_265
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨174, by decide⟩) (orbitCodeOfNumber ⟨266, by decide⟩) 0 6 7)

theorem row_174_267 : RowResult ⟨174, by decide⟩ ⟨267, by decide⟩ := by
  have _previous := row_174_266
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨174, by decide⟩) (orbitCodeOfNumber ⟨267, by decide⟩) 0 6 7)

theorem row_174_268 : RowResult ⟨174, by decide⟩ ⟨268, by decide⟩ := by
  have _previous := row_174_267
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨174, by decide⟩) (orbitCodeOfNumber ⟨268, by decide⟩) 0 6 7)

theorem row_174_269 : RowResult ⟨174, by decide⟩ ⟨269, by decide⟩ := by
  have _previous := row_174_268
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨174, by decide⟩) (orbitCodeOfNumber ⟨269, by decide⟩) 0 6 7)

theorem row_174_270 : RowResult ⟨174, by decide⟩ ⟨270, by decide⟩ := by
  have _previous := row_174_269
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨174, by decide⟩) (orbitCodeOfNumber ⟨270, by decide⟩) 0 6 7)

theorem row_174_271 : RowResult ⟨174, by decide⟩ ⟨271, by decide⟩ := by
  have _previous := row_174_270
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨174, by decide⟩) (orbitCodeOfNumber ⟨271, by decide⟩) 0 6 7)

theorem row_174_272 : RowResult ⟨174, by decide⟩ ⟨272, by decide⟩ := by
  have _previous := row_174_271
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨174, by decide⟩) (orbitCodeOfNumber ⟨272, by decide⟩) 0 6 7)

theorem row_174_273 : RowResult ⟨174, by decide⟩ ⟨273, by decide⟩ := by
  have _previous := row_174_272
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨174, by decide⟩) (orbitCodeOfNumber ⟨273, by decide⟩) 0 6 7)

theorem row_174_274 : RowResult ⟨174, by decide⟩ ⟨274, by decide⟩ := by
  have _previous := row_174_273
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨174, by decide⟩) (orbitCodeOfNumber ⟨274, by decide⟩) 0 6 7)

end RelativeConicArcs.Q25PairCertificate
