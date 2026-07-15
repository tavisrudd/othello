import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_156_241 : RowResult ⟨156, by decide⟩ ⟨241, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨224, by decide⟩, by decide⟩

theorem row_156_242 : RowResult ⟨156, by decide⟩ ⟨242, by decide⟩ := by
  have _previous := row_156_241
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨224, by decide⟩, by decide⟩

theorem row_156_243 : RowResult ⟨156, by decide⟩ ⟨243, by decide⟩ := by
  have _previous := row_156_242
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨156, by decide⟩) (orbitCodeOfNumber ⟨243, by decide⟩) 2 4 6)

theorem row_156_244 : RowResult ⟨156, by decide⟩ ⟨244, by decide⟩ := by
  have _previous := row_156_243
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨222, by decide⟩, by decide⟩

theorem row_156_245 : RowResult ⟨156, by decide⟩ ⟨245, by decide⟩ := by
  have _previous := row_156_244
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨156, by decide⟩) (orbitCodeOfNumber ⟨245, by decide⟩) 1 2 7)

theorem row_156_246 : RowResult ⟨156, by decide⟩ ⟨246, by decide⟩ := by
  have _previous := row_156_245
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨156, by decide⟩) (orbitCodeOfNumber ⟨246, by decide⟩) 1 4 7)

theorem row_156_247 : RowResult ⟨156, by decide⟩ ⟨247, by decide⟩ := by
  have _previous := row_156_246
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨223, by decide⟩, by decide⟩

theorem row_156_248 : RowResult ⟨156, by decide⟩ ⟨248, by decide⟩ := by
  have _previous := row_156_247
  exact Or.inr ⟨orbitCodeOfNumber ⟨36, by decide⟩,
    orbitCodeOfNumber ⟨224, by decide⟩, by decide⟩

theorem row_156_249 : RowResult ⟨156, by decide⟩ ⟨249, by decide⟩ := by
  have _previous := row_156_248
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨223, by decide⟩, by decide⟩

theorem row_156_250 : RowResult ⟨156, by decide⟩ ⟨250, by decide⟩ := by
  have _previous := row_156_249
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨156, by decide⟩) (orbitCodeOfNumber ⟨250, by decide⟩) 0 6 7)

theorem row_156_251 : RowResult ⟨156, by decide⟩ ⟨251, by decide⟩ := by
  have _previous := row_156_250
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨156, by decide⟩) (orbitCodeOfNumber ⟨251, by decide⟩) 0 6 7)

theorem row_156_252 : RowResult ⟨156, by decide⟩ ⟨252, by decide⟩ := by
  have _previous := row_156_251
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨156, by decide⟩) (orbitCodeOfNumber ⟨252, by decide⟩) 0 6 7)

theorem row_156_253 : RowResult ⟨156, by decide⟩ ⟨253, by decide⟩ := by
  have _previous := row_156_252
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨156, by decide⟩) (orbitCodeOfNumber ⟨253, by decide⟩) 0 6 7)

theorem row_156_254 : RowResult ⟨156, by decide⟩ ⟨254, by decide⟩ := by
  have _previous := row_156_253
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨156, by decide⟩) (orbitCodeOfNumber ⟨254, by decide⟩) 0 6 7)

theorem row_156_255 : RowResult ⟨156, by decide⟩ ⟨255, by decide⟩ := by
  have _previous := row_156_254
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨156, by decide⟩) (orbitCodeOfNumber ⟨255, by decide⟩) 0 6 7)

theorem row_156_256 : RowResult ⟨156, by decide⟩ ⟨256, by decide⟩ := by
  have _previous := row_156_255
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨156, by decide⟩) (orbitCodeOfNumber ⟨256, by decide⟩) 0 6 7)

end RelativeConicArcs.Q25PairCertificate
