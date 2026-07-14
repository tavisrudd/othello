import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_58_243 : RowResult ⟨58, by decide⟩ ⟨243, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_58_244 : RowResult ⟨58, by decide⟩ ⟨244, by decide⟩ := by
  have _previous := row_58_243
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_58_245 : RowResult ⟨58, by decide⟩ ⟨245, by decide⟩ := by
  have _previous := row_58_244
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨58, by decide⟩) (orbitCodeOfNumber ⟨245, by decide⟩) 1 2 7)

theorem row_58_246 : RowResult ⟨58, by decide⟩ ⟨246, by decide⟩ := by
  have _previous := row_58_245
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_58_247 : RowResult ⟨58, by decide⟩ ⟨247, by decide⟩ := by
  have _previous := row_58_246
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨58, by decide⟩) (orbitCodeOfNumber ⟨247, by decide⟩) 2 4 6)

theorem row_58_248 : RowResult ⟨58, by decide⟩ ⟨248, by decide⟩ := by
  have _previous := row_58_247
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨58, by decide⟩) (orbitCodeOfNumber ⟨248, by decide⟩) 1 4 7)

theorem row_58_249 : RowResult ⟨58, by decide⟩ ⟨249, by decide⟩ := by
  have _previous := row_58_248
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_58_250 : RowResult ⟨58, by decide⟩ ⟨250, by decide⟩ := by
  have _previous := row_58_249
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨58, by decide⟩) (orbitCodeOfNumber ⟨250, by decide⟩) 0 6 7)

theorem row_58_251 : RowResult ⟨58, by decide⟩ ⟨251, by decide⟩ := by
  have _previous := row_58_250
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨58, by decide⟩) (orbitCodeOfNumber ⟨251, by decide⟩) 0 6 7)

theorem row_58_252 : RowResult ⟨58, by decide⟩ ⟨252, by decide⟩ := by
  have _previous := row_58_251
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨58, by decide⟩) (orbitCodeOfNumber ⟨252, by decide⟩) 0 6 7)

theorem row_58_253 : RowResult ⟨58, by decide⟩ ⟨253, by decide⟩ := by
  have _previous := row_58_252
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨58, by decide⟩) (orbitCodeOfNumber ⟨253, by decide⟩) 0 6 7)

theorem row_58_254 : RowResult ⟨58, by decide⟩ ⟨254, by decide⟩ := by
  have _previous := row_58_253
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨58, by decide⟩) (orbitCodeOfNumber ⟨254, by decide⟩) 0 6 7)

theorem row_58_255 : RowResult ⟨58, by decide⟩ ⟨255, by decide⟩ := by
  have _previous := row_58_254
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨58, by decide⟩) (orbitCodeOfNumber ⟨255, by decide⟩) 0 6 7)

theorem row_58_256 : RowResult ⟨58, by decide⟩ ⟨256, by decide⟩ := by
  have _previous := row_58_255
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨58, by decide⟩) (orbitCodeOfNumber ⟨256, by decide⟩) 0 6 7)

theorem row_58_257 : RowResult ⟨58, by decide⟩ ⟨257, by decide⟩ := by
  have _previous := row_58_256
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨58, by decide⟩) (orbitCodeOfNumber ⟨257, by decide⟩) 0 6 7)

theorem row_58_258 : RowResult ⟨58, by decide⟩ ⟨258, by decide⟩ := by
  have _previous := row_58_257
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨58, by decide⟩) (orbitCodeOfNumber ⟨258, by decide⟩) 0 6 7)

end RelativeConicArcs.Q25PairCertificate
