import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_160_241 : RowResult ⟨160, by decide⟩ ⟨241, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨37, by decide⟩,
    orbitCodeOfNumber ⟨224, by decide⟩, by decide⟩

theorem row_160_242 : RowResult ⟨160, by decide⟩ ⟨242, by decide⟩ := by
  have _previous := row_160_241
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨223, by decide⟩, by decide⟩

theorem row_160_243 : RowResult ⟨160, by decide⟩ ⟨243, by decide⟩ := by
  have _previous := row_160_242
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨222, by decide⟩, by decide⟩

theorem row_160_244 : RowResult ⟨160, by decide⟩ ⟨244, by decide⟩ := by
  have _previous := row_160_243
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨160, by decide⟩) (orbitCodeOfNumber ⟨244, by decide⟩) 2 5 6)

theorem row_160_245 : RowResult ⟨160, by decide⟩ ⟨245, by decide⟩ := by
  have _previous := row_160_244
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨160, by decide⟩) (orbitCodeOfNumber ⟨245, by decide⟩) 1 2 7)

theorem row_160_246 : RowResult ⟨160, by decide⟩ ⟨246, by decide⟩ := by
  have _previous := row_160_245
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨160, by decide⟩) (orbitCodeOfNumber ⟨246, by decide⟩) 2 5 7)

theorem row_160_247 : RowResult ⟨160, by decide⟩ ⟨247, by decide⟩ := by
  have _previous := row_160_246
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨160, by decide⟩) (orbitCodeOfNumber ⟨247, by decide⟩) 4 5 6)

theorem row_160_248 : RowResult ⟨160, by decide⟩ ⟨248, by decide⟩ := by
  have _previous := row_160_247
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨224, by decide⟩, by decide⟩

theorem row_160_249 : RowResult ⟨160, by decide⟩ ⟨249, by decide⟩ := by
  have _previous := row_160_248
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨160, by decide⟩) (orbitCodeOfNumber ⟨249, by decide⟩) 2 4 6)

theorem row_160_250 : RowResult ⟨160, by decide⟩ ⟨250, by decide⟩ := by
  have _previous := row_160_249
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨160, by decide⟩) (orbitCodeOfNumber ⟨250, by decide⟩) 0 6 7)

theorem row_160_251 : RowResult ⟨160, by decide⟩ ⟨251, by decide⟩ := by
  have _previous := row_160_250
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨160, by decide⟩) (orbitCodeOfNumber ⟨251, by decide⟩) 0 6 7)

theorem row_160_252 : RowResult ⟨160, by decide⟩ ⟨252, by decide⟩ := by
  have _previous := row_160_251
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨160, by decide⟩) (orbitCodeOfNumber ⟨252, by decide⟩) 0 6 7)

theorem row_160_253 : RowResult ⟨160, by decide⟩ ⟨253, by decide⟩ := by
  have _previous := row_160_252
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨160, by decide⟩) (orbitCodeOfNumber ⟨253, by decide⟩) 0 6 7)

theorem row_160_254 : RowResult ⟨160, by decide⟩ ⟨254, by decide⟩ := by
  have _previous := row_160_253
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨160, by decide⟩) (orbitCodeOfNumber ⟨254, by decide⟩) 0 6 7)

theorem row_160_255 : RowResult ⟨160, by decide⟩ ⟨255, by decide⟩ := by
  have _previous := row_160_254
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨160, by decide⟩) (orbitCodeOfNumber ⟨255, by decide⟩) 0 6 7)

theorem row_160_256 : RowResult ⟨160, by decide⟩ ⟨256, by decide⟩ := by
  have _previous := row_160_255
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨160, by decide⟩) (orbitCodeOfNumber ⟨256, by decide⟩) 0 6 7)

theorem row_160_257 : RowResult ⟨160, by decide⟩ ⟨257, by decide⟩ := by
  have _previous := row_160_256
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨160, by decide⟩) (orbitCodeOfNumber ⟨257, by decide⟩) 0 6 7)

theorem row_160_258 : RowResult ⟨160, by decide⟩ ⟨258, by decide⟩ := by
  have _previous := row_160_257
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨160, by decide⟩) (orbitCodeOfNumber ⟨258, by decide⟩) 0 6 7)

theorem row_160_259 : RowResult ⟨160, by decide⟩ ⟨259, by decide⟩ := by
  have _previous := row_160_258
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨160, by decide⟩) (orbitCodeOfNumber ⟨259, by decide⟩) 0 6 7)

theorem row_160_260 : RowResult ⟨160, by decide⟩ ⟨260, by decide⟩ := by
  have _previous := row_160_259
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨160, by decide⟩) (orbitCodeOfNumber ⟨260, by decide⟩) 0 6 7)

end RelativeConicArcs.Q25PairCertificate
