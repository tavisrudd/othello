import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_59_244 : RowResult ⟨59, by decide⟩ ⟨244, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_59_245 : RowResult ⟨59, by decide⟩ ⟨245, by decide⟩ := by
  have _previous := row_59_244
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨59, by decide⟩) (orbitCodeOfNumber ⟨245, by decide⟩) 1 2 7)

theorem row_59_246 : RowResult ⟨59, by decide⟩ ⟨246, by decide⟩ := by
  have _previous := row_59_245
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_59_247 : RowResult ⟨59, by decide⟩ ⟨247, by decide⟩ := by
  have _previous := row_59_246
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_59_248 : RowResult ⟨59, by decide⟩ ⟨248, by decide⟩ := by
  have _previous := row_59_247
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_59_249 : RowResult ⟨59, by decide⟩ ⟨249, by decide⟩ := by
  have _previous := row_59_248
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨59, by decide⟩) (orbitCodeOfNumber ⟨249, by decide⟩) 1 4 7)

theorem row_59_250 : RowResult ⟨59, by decide⟩ ⟨250, by decide⟩ := by
  have _previous := row_59_249
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨59, by decide⟩) (orbitCodeOfNumber ⟨250, by decide⟩) 0 6 7)

theorem row_59_251 : RowResult ⟨59, by decide⟩ ⟨251, by decide⟩ := by
  have _previous := row_59_250
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨59, by decide⟩) (orbitCodeOfNumber ⟨251, by decide⟩) 0 6 7)

theorem row_59_252 : RowResult ⟨59, by decide⟩ ⟨252, by decide⟩ := by
  have _previous := row_59_251
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨59, by decide⟩) (orbitCodeOfNumber ⟨252, by decide⟩) 0 6 7)

theorem row_59_253 : RowResult ⟨59, by decide⟩ ⟨253, by decide⟩ := by
  have _previous := row_59_252
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨59, by decide⟩) (orbitCodeOfNumber ⟨253, by decide⟩) 0 6 7)

theorem row_59_254 : RowResult ⟨59, by decide⟩ ⟨254, by decide⟩ := by
  have _previous := row_59_253
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨59, by decide⟩) (orbitCodeOfNumber ⟨254, by decide⟩) 0 6 7)

theorem row_59_255 : RowResult ⟨59, by decide⟩ ⟨255, by decide⟩ := by
  have _previous := row_59_254
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨59, by decide⟩) (orbitCodeOfNumber ⟨255, by decide⟩) 0 6 7)

theorem row_59_256 : RowResult ⟨59, by decide⟩ ⟨256, by decide⟩ := by
  have _previous := row_59_255
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨59, by decide⟩) (orbitCodeOfNumber ⟨256, by decide⟩) 0 6 7)

theorem row_59_257 : RowResult ⟨59, by decide⟩ ⟨257, by decide⟩ := by
  have _previous := row_59_256
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨59, by decide⟩) (orbitCodeOfNumber ⟨257, by decide⟩) 0 6 7)

theorem row_59_258 : RowResult ⟨59, by decide⟩ ⟨258, by decide⟩ := by
  have _previous := row_59_257
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨59, by decide⟩) (orbitCodeOfNumber ⟨258, by decide⟩) 0 6 7)

theorem row_59_259 : RowResult ⟨59, by decide⟩ ⟨259, by decide⟩ := by
  have _previous := row_59_258
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨59, by decide⟩) (orbitCodeOfNumber ⟨259, by decide⟩) 0 6 7)

end RelativeConicArcs.Q25PairCertificate
