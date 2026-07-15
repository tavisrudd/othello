import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_157_246 : RowResult ⟨157, by decide⟩ ⟨246, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨224, by decide⟩, by decide⟩

theorem row_157_247 : RowResult ⟨157, by decide⟩ ⟨247, by decide⟩ := by
  have _previous := row_157_246
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨157, by decide⟩) (orbitCodeOfNumber ⟨247, by decide⟩) 1 4 7)

theorem row_157_248 : RowResult ⟨157, by decide⟩ ⟨248, by decide⟩ := by
  have _previous := row_157_247
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨224, by decide⟩, by decide⟩

theorem row_157_249 : RowResult ⟨157, by decide⟩ ⟨249, by decide⟩ := by
  have _previous := row_157_248
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨223, by decide⟩, by decide⟩

theorem row_157_250 : RowResult ⟨157, by decide⟩ ⟨250, by decide⟩ := by
  have _previous := row_157_249
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨157, by decide⟩) (orbitCodeOfNumber ⟨250, by decide⟩) 0 6 7)

theorem row_157_251 : RowResult ⟨157, by decide⟩ ⟨251, by decide⟩ := by
  have _previous := row_157_250
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨157, by decide⟩) (orbitCodeOfNumber ⟨251, by decide⟩) 0 6 7)

theorem row_157_252 : RowResult ⟨157, by decide⟩ ⟨252, by decide⟩ := by
  have _previous := row_157_251
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨157, by decide⟩) (orbitCodeOfNumber ⟨252, by decide⟩) 0 6 7)

theorem row_157_253 : RowResult ⟨157, by decide⟩ ⟨253, by decide⟩ := by
  have _previous := row_157_252
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨157, by decide⟩) (orbitCodeOfNumber ⟨253, by decide⟩) 0 6 7)

theorem row_157_254 : RowResult ⟨157, by decide⟩ ⟨254, by decide⟩ := by
  have _previous := row_157_253
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨157, by decide⟩) (orbitCodeOfNumber ⟨254, by decide⟩) 0 6 7)

theorem row_157_255 : RowResult ⟨157, by decide⟩ ⟨255, by decide⟩ := by
  have _previous := row_157_254
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨157, by decide⟩) (orbitCodeOfNumber ⟨255, by decide⟩) 0 6 7)

theorem row_157_256 : RowResult ⟨157, by decide⟩ ⟨256, by decide⟩ := by
  have _previous := row_157_255
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨157, by decide⟩) (orbitCodeOfNumber ⟨256, by decide⟩) 0 6 7)

theorem row_157_257 : RowResult ⟨157, by decide⟩ ⟨257, by decide⟩ := by
  have _previous := row_157_256
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨157, by decide⟩) (orbitCodeOfNumber ⟨257, by decide⟩) 0 6 7)

end RelativeConicArcs.Q25PairCertificate
