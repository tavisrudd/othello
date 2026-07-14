import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_71_240 : RowResult ⟨71, by decide⟩ ⟨240, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_71_241 : RowResult ⟨71, by decide⟩ ⟨241, by decide⟩ := by
  have _previous := row_71_240
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_71_242 : RowResult ⟨71, by decide⟩ ⟨242, by decide⟩ := by
  have _previous := row_71_241
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_71_243 : RowResult ⟨71, by decide⟩ ⟨243, by decide⟩ := by
  have _previous := row_71_242
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨71, by decide⟩) (orbitCodeOfNumber ⟨243, by decide⟩) 4 5 6)

theorem row_71_244 : RowResult ⟨71, by decide⟩ ⟨244, by decide⟩ := by
  have _previous := row_71_243
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_71_245 : RowResult ⟨71, by decide⟩ ⟨245, by decide⟩ := by
  have _previous := row_71_244
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨71, by decide⟩) (orbitCodeOfNumber ⟨245, by decide⟩) 1 2 7)

theorem row_71_246 : RowResult ⟨71, by decide⟩ ⟨246, by decide⟩ := by
  have _previous := row_71_245
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨71, by decide⟩) (orbitCodeOfNumber ⟨246, by decide⟩) 1 4 6)

theorem row_71_247 : RowResult ⟨71, by decide⟩ ⟨247, by decide⟩ := by
  have _previous := row_71_246
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_71_248 : RowResult ⟨71, by decide⟩ ⟨248, by decide⟩ := by
  have _previous := row_71_247
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_71_249 : RowResult ⟨71, by decide⟩ ⟨249, by decide⟩ := by
  have _previous := row_71_248
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨71, by decide⟩) (orbitCodeOfNumber ⟨249, by decide⟩) 2 5 7)

theorem row_71_250 : RowResult ⟨71, by decide⟩ ⟨250, by decide⟩ := by
  have _previous := row_71_249
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨71, by decide⟩) (orbitCodeOfNumber ⟨250, by decide⟩) 0 6 7)

theorem row_71_251 : RowResult ⟨71, by decide⟩ ⟨251, by decide⟩ := by
  have _previous := row_71_250
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨71, by decide⟩) (orbitCodeOfNumber ⟨251, by decide⟩) 0 6 7)

theorem row_71_252 : RowResult ⟨71, by decide⟩ ⟨252, by decide⟩ := by
  have _previous := row_71_251
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨71, by decide⟩) (orbitCodeOfNumber ⟨252, by decide⟩) 0 6 7)

theorem row_71_253 : RowResult ⟨71, by decide⟩ ⟨253, by decide⟩ := by
  have _previous := row_71_252
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨71, by decide⟩) (orbitCodeOfNumber ⟨253, by decide⟩) 0 6 7)

theorem row_71_254 : RowResult ⟨71, by decide⟩ ⟨254, by decide⟩ := by
  have _previous := row_71_253
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨71, by decide⟩) (orbitCodeOfNumber ⟨254, by decide⟩) 0 6 7)

theorem row_71_255 : RowResult ⟨71, by decide⟩ ⟨255, by decide⟩ := by
  have _previous := row_71_254
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨71, by decide⟩) (orbitCodeOfNumber ⟨255, by decide⟩) 0 6 7)

theorem row_71_256 : RowResult ⟨71, by decide⟩ ⟨256, by decide⟩ := by
  have _previous := row_71_255
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨71, by decide⟩) (orbitCodeOfNumber ⟨256, by decide⟩) 0 6 7)

theorem row_71_257 : RowResult ⟨71, by decide⟩ ⟨257, by decide⟩ := by
  have _previous := row_71_256
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨71, by decide⟩) (orbitCodeOfNumber ⟨257, by decide⟩) 0 6 7)

theorem row_71_258 : RowResult ⟨71, by decide⟩ ⟨258, by decide⟩ := by
  have _previous := row_71_257
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨71, by decide⟩) (orbitCodeOfNumber ⟨258, by decide⟩) 0 6 7)

theorem row_71_259 : RowResult ⟨71, by decide⟩ ⟨259, by decide⟩ := by
  have _previous := row_71_258
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨71, by decide⟩) (orbitCodeOfNumber ⟨259, by decide⟩) 0 6 7)

theorem row_71_260 : RowResult ⟨71, by decide⟩ ⟨260, by decide⟩ := by
  have _previous := row_71_259
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨71, by decide⟩) (orbitCodeOfNumber ⟨260, by decide⟩) 0 6 7)

theorem row_71_261 : RowResult ⟨71, by decide⟩ ⟨261, by decide⟩ := by
  have _previous := row_71_260
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨71, by decide⟩) (orbitCodeOfNumber ⟨261, by decide⟩) 0 6 7)

theorem row_71_262 : RowResult ⟨71, by decide⟩ ⟨262, by decide⟩ := by
  have _previous := row_71_261
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨71, by decide⟩) (orbitCodeOfNumber ⟨262, by decide⟩) 0 6 7)

theorem row_71_263 : RowResult ⟨71, by decide⟩ ⟨263, by decide⟩ := by
  have _previous := row_71_262
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨71, by decide⟩) (orbitCodeOfNumber ⟨263, by decide⟩) 0 6 7)

theorem row_71_264 : RowResult ⟨71, by decide⟩ ⟨264, by decide⟩ := by
  have _previous := row_71_263
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨71, by decide⟩) (orbitCodeOfNumber ⟨264, by decide⟩) 0 6 7)

theorem row_71_265 : RowResult ⟨71, by decide⟩ ⟨265, by decide⟩ := by
  have _previous := row_71_264
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨71, by decide⟩) (orbitCodeOfNumber ⟨265, by decide⟩) 0 6 7)

theorem row_71_266 : RowResult ⟨71, by decide⟩ ⟨266, by decide⟩ := by
  have _previous := row_71_265
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨71, by decide⟩) (orbitCodeOfNumber ⟨266, by decide⟩) 0 6 7)

theorem row_71_267 : RowResult ⟨71, by decide⟩ ⟨267, by decide⟩ := by
  have _previous := row_71_266
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨71, by decide⟩) (orbitCodeOfNumber ⟨267, by decide⟩) 0 6 7)

theorem row_71_268 : RowResult ⟨71, by decide⟩ ⟨268, by decide⟩ := by
  have _previous := row_71_267
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨71, by decide⟩) (orbitCodeOfNumber ⟨268, by decide⟩) 0 6 7)

theorem row_71_269 : RowResult ⟨71, by decide⟩ ⟨269, by decide⟩ := by
  have _previous := row_71_268
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨71, by decide⟩) (orbitCodeOfNumber ⟨269, by decide⟩) 0 6 7)

theorem row_71_270 : RowResult ⟨71, by decide⟩ ⟨270, by decide⟩ := by
  have _previous := row_71_269
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨71, by decide⟩) (orbitCodeOfNumber ⟨270, by decide⟩) 0 6 7)

theorem row_71_271 : RowResult ⟨71, by decide⟩ ⟨271, by decide⟩ := by
  have _previous := row_71_270
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨71, by decide⟩) (orbitCodeOfNumber ⟨271, by decide⟩) 0 6 7)

end RelativeConicArcs.Q25PairCertificate
