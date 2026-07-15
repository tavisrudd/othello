import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_57_244 : RowResult ⟨57, by decide⟩ ⟨244, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨217, by decide⟩, by decide⟩

theorem row_57_245 : RowResult ⟨57, by decide⟩ ⟨245, by decide⟩ := by
  have _previous := row_57_244
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨57, by decide⟩) (orbitCodeOfNumber ⟨245, by decide⟩) 1 2 7)

theorem row_57_246 : RowResult ⟨57, by decide⟩ ⟨246, by decide⟩ := by
  have _previous := row_57_245
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨224, by decide⟩, by decide⟩

theorem row_57_247 : RowResult ⟨57, by decide⟩ ⟨247, by decide⟩ := by
  have _previous := row_57_246
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨57, by decide⟩) (orbitCodeOfNumber ⟨247, by decide⟩) 1 4 7)

theorem row_57_248 : RowResult ⟨57, by decide⟩ ⟨248, by decide⟩ := by
  have _previous := row_57_247
  exact Or.inr ⟨orbitCodeOfNumber ⟨37, by decide⟩,
    orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

theorem row_57_249 : RowResult ⟨57, by decide⟩ ⟨249, by decide⟩ := by
  have _previous := row_57_248
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨223, by decide⟩, by decide⟩

theorem row_57_250 : RowResult ⟨57, by decide⟩ ⟨250, by decide⟩ := by
  have _previous := row_57_249
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨57, by decide⟩) (orbitCodeOfNumber ⟨250, by decide⟩) 0 6 7)

theorem row_57_251 : RowResult ⟨57, by decide⟩ ⟨251, by decide⟩ := by
  have _previous := row_57_250
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨57, by decide⟩) (orbitCodeOfNumber ⟨251, by decide⟩) 0 6 7)

theorem row_57_252 : RowResult ⟨57, by decide⟩ ⟨252, by decide⟩ := by
  have _previous := row_57_251
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨57, by decide⟩) (orbitCodeOfNumber ⟨252, by decide⟩) 0 6 7)

theorem row_57_253 : RowResult ⟨57, by decide⟩ ⟨253, by decide⟩ := by
  have _previous := row_57_252
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨57, by decide⟩) (orbitCodeOfNumber ⟨253, by decide⟩) 0 6 7)

theorem row_57_254 : RowResult ⟨57, by decide⟩ ⟨254, by decide⟩ := by
  have _previous := row_57_253
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨57, by decide⟩) (orbitCodeOfNumber ⟨254, by decide⟩) 0 6 7)

theorem row_57_255 : RowResult ⟨57, by decide⟩ ⟨255, by decide⟩ := by
  have _previous := row_57_254
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨57, by decide⟩) (orbitCodeOfNumber ⟨255, by decide⟩) 0 6 7)

theorem row_57_256 : RowResult ⟨57, by decide⟩ ⟨256, by decide⟩ := by
  have _previous := row_57_255
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨57, by decide⟩) (orbitCodeOfNumber ⟨256, by decide⟩) 0 6 7)

theorem row_57_257 : RowResult ⟨57, by decide⟩ ⟨257, by decide⟩ := by
  have _previous := row_57_256
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨57, by decide⟩) (orbitCodeOfNumber ⟨257, by decide⟩) 0 6 7)

end RelativeConicArcs.Q25PairCertificate
