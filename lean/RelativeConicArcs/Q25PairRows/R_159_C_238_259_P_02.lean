import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_159_238 : RowResult ⟨159, by decide⟩ ⟨238, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨183, by decide⟩, by decide⟩

theorem row_159_239 : RowResult ⟨159, by decide⟩ ⟨239, by decide⟩ := by
  have _previous := row_159_238
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨159, by decide⟩) (orbitCodeOfNumber ⟨239, by decide⟩) 2 3 6)

theorem row_159_240 : RowResult ⟨159, by decide⟩ ⟨240, by decide⟩ := by
  have _previous := row_159_239
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨159, by decide⟩) (orbitCodeOfNumber ⟨240, by decide⟩) 2 5 6)

theorem row_159_241 : RowResult ⟨159, by decide⟩ ⟨241, by decide⟩ := by
  have _previous := row_159_240
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_159_242 : RowResult ⟨159, by decide⟩ ⟨242, by decide⟩ := by
  have _previous := row_159_241
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨159, by decide⟩) (orbitCodeOfNumber ⟨242, by decide⟩) 2 4 7)

theorem row_159_243 : RowResult ⟨159, by decide⟩ ⟨243, by decide⟩ := by
  have _previous := row_159_242
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_159_244 : RowResult ⟨159, by decide⟩ ⟨244, by decide⟩ := by
  have _previous := row_159_243
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨159, by decide⟩) (orbitCodeOfNumber ⟨244, by decide⟩) 2 5 7)

theorem row_159_245 : RowResult ⟨159, by decide⟩ ⟨245, by decide⟩ := by
  have _previous := row_159_244
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨159, by decide⟩) (orbitCodeOfNumber ⟨245, by decide⟩) 1 2 7)

theorem row_159_246 : RowResult ⟨159, by decide⟩ ⟨246, by decide⟩ := by
  have _previous := row_159_245
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_159_247 : RowResult ⟨159, by decide⟩ ⟨247, by decide⟩ := by
  have _previous := row_159_246
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨159, by decide⟩) (orbitCodeOfNumber ⟨247, by decide⟩) 2 4 6)

theorem row_159_248 : RowResult ⟨159, by decide⟩ ⟨248, by decide⟩ := by
  have _previous := row_159_247
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_159_249 : RowResult ⟨159, by decide⟩ ⟨249, by decide⟩ := by
  have _previous := row_159_248
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨159, by decide⟩) (orbitCodeOfNumber ⟨249, by decide⟩) 1 4 7)

theorem row_159_250 : RowResult ⟨159, by decide⟩ ⟨250, by decide⟩ := by
  have _previous := row_159_249
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨159, by decide⟩) (orbitCodeOfNumber ⟨250, by decide⟩) 0 6 7)

theorem row_159_251 : RowResult ⟨159, by decide⟩ ⟨251, by decide⟩ := by
  have _previous := row_159_250
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨159, by decide⟩) (orbitCodeOfNumber ⟨251, by decide⟩) 0 6 7)

theorem row_159_252 : RowResult ⟨159, by decide⟩ ⟨252, by decide⟩ := by
  have _previous := row_159_251
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨159, by decide⟩) (orbitCodeOfNumber ⟨252, by decide⟩) 0 6 7)

theorem row_159_253 : RowResult ⟨159, by decide⟩ ⟨253, by decide⟩ := by
  have _previous := row_159_252
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨159, by decide⟩) (orbitCodeOfNumber ⟨253, by decide⟩) 0 6 7)

theorem row_159_254 : RowResult ⟨159, by decide⟩ ⟨254, by decide⟩ := by
  have _previous := row_159_253
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨159, by decide⟩) (orbitCodeOfNumber ⟨254, by decide⟩) 0 6 7)

theorem row_159_255 : RowResult ⟨159, by decide⟩ ⟨255, by decide⟩ := by
  have _previous := row_159_254
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨159, by decide⟩) (orbitCodeOfNumber ⟨255, by decide⟩) 0 6 7)

theorem row_159_256 : RowResult ⟨159, by decide⟩ ⟨256, by decide⟩ := by
  have _previous := row_159_255
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨159, by decide⟩) (orbitCodeOfNumber ⟨256, by decide⟩) 0 6 7)

theorem row_159_257 : RowResult ⟨159, by decide⟩ ⟨257, by decide⟩ := by
  have _previous := row_159_256
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨159, by decide⟩) (orbitCodeOfNumber ⟨257, by decide⟩) 0 6 7)

theorem row_159_258 : RowResult ⟨159, by decide⟩ ⟨258, by decide⟩ := by
  have _previous := row_159_257
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨159, by decide⟩) (orbitCodeOfNumber ⟨258, by decide⟩) 0 6 7)

theorem row_159_259 : RowResult ⟨159, by decide⟩ ⟨259, by decide⟩ := by
  have _previous := row_159_258
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨159, by decide⟩) (orbitCodeOfNumber ⟨259, by decide⟩) 0 6 7)

end RelativeConicArcs.Q25PairCertificate
