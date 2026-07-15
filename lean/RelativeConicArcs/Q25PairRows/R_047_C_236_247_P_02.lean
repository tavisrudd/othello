import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_47_236 : RowResult ⟨47, by decide⟩ ⟨236, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨60, by decide⟩,
    orbitCodeOfNumber ⟨221, by decide⟩, by decide⟩

theorem row_47_237 : RowResult ⟨47, by decide⟩ ⟨237, by decide⟩ := by
  have _previous := row_47_236
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨47, by decide⟩) (orbitCodeOfNumber ⟨237, by decide⟩) 2 5 7)

theorem row_47_238 : RowResult ⟨47, by decide⟩ ⟨238, by decide⟩ := by
  have _previous := row_47_237
  exact Or.inr ⟨orbitCodeOfNumber ⟨60, by decide⟩,
    orbitCodeOfNumber ⟨224, by decide⟩, by decide⟩

theorem row_47_239 : RowResult ⟨47, by decide⟩ ⟨239, by decide⟩ := by
  have _previous := row_47_238
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨47, by decide⟩) (orbitCodeOfNumber ⟨239, by decide⟩) 2 3 6)

theorem row_47_240 : RowResult ⟨47, by decide⟩ ⟨240, by decide⟩ := by
  have _previous := row_47_239
  exact Or.inr ⟨orbitCodeOfNumber ⟨61, by decide⟩,
    orbitCodeOfNumber ⟨224, by decide⟩, by decide⟩

theorem row_47_241 : RowResult ⟨47, by decide⟩ ⟨241, by decide⟩ := by
  have _previous := row_47_240
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨47, by decide⟩) (orbitCodeOfNumber ⟨241, by decide⟩) 2 5 6)

theorem row_47_242 : RowResult ⟨47, by decide⟩ ⟨242, by decide⟩ := by
  have _previous := row_47_241
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩,
    orbitCodeOfNumber ⟨224, by decide⟩, by decide⟩

theorem row_47_243 : RowResult ⟨47, by decide⟩ ⟨243, by decide⟩ := by
  have _previous := row_47_242
  exact Or.inr ⟨orbitCodeOfNumber ⟨62, by decide⟩,
    orbitCodeOfNumber ⟨224, by decide⟩, by decide⟩

theorem row_47_244 : RowResult ⟨47, by decide⟩ ⟨244, by decide⟩ := by
  have _previous := row_47_243
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨47, by decide⟩) (orbitCodeOfNumber ⟨244, by decide⟩) 2 4 6)

theorem row_47_245 : RowResult ⟨47, by decide⟩ ⟨245, by decide⟩ := by
  have _previous := row_47_244
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨47, by decide⟩) (orbitCodeOfNumber ⟨245, by decide⟩) 1 2 7)

theorem row_47_246 : RowResult ⟨47, by decide⟩ ⟨246, by decide⟩ := by
  have _previous := row_47_245
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨47, by decide⟩) (orbitCodeOfNumber ⟨246, by decide⟩) 2 4 7)

theorem row_47_247 : RowResult ⟨47, by decide⟩ ⟨247, by decide⟩ := by
  have _previous := row_47_246
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨47, by decide⟩) (orbitCodeOfNumber ⟨247, by decide⟩) 1 4 6)

end RelativeConicArcs.Q25PairCertificate
