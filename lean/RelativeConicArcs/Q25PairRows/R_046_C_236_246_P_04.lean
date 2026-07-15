import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_46_236 : RowResult ⟨46, by decide⟩ ⟨236, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨60, by decide⟩,
    orbitCodeOfNumber ⟨218, by decide⟩, by decide⟩

theorem row_46_237 : RowResult ⟨46, by decide⟩ ⟨237, by decide⟩ := by
  have _previous := row_46_236
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨224, by decide⟩, by decide⟩

theorem row_46_238 : RowResult ⟨46, by decide⟩ ⟨238, by decide⟩ := by
  have _previous := row_46_237
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨46, by decide⟩) (orbitCodeOfNumber ⟨238, by decide⟩) 2 5 6)

theorem row_46_239 : RowResult ⟨46, by decide⟩ ⟨239, by decide⟩ := by
  have _previous := row_46_238
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨46, by decide⟩) (orbitCodeOfNumber ⟨239, by decide⟩) 2 3 6)

theorem row_46_240 : RowResult ⟨46, by decide⟩ ⟨240, by decide⟩ := by
  have _previous := row_46_239
  exact Or.inr ⟨orbitCodeOfNumber ⟨58, by decide⟩,
    orbitCodeOfNumber ⟨224, by decide⟩, by decide⟩

theorem row_46_241 : RowResult ⟨46, by decide⟩ ⟨241, by decide⟩ := by
  have _previous := row_46_240
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨46, by decide⟩) (orbitCodeOfNumber ⟨241, by decide⟩) 2 5 7)

theorem row_46_242 : RowResult ⟨46, by decide⟩ ⟨242, by decide⟩ := by
  have _previous := row_46_241
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨224, by decide⟩, by decide⟩

theorem row_46_243 : RowResult ⟨46, by decide⟩ ⟨243, by decide⟩ := by
  have _previous := row_46_242
  exact Or.inr ⟨orbitCodeOfNumber ⟨58, by decide⟩,
    orbitCodeOfNumber ⟨224, by decide⟩, by decide⟩

theorem row_46_244 : RowResult ⟨46, by decide⟩ ⟨244, by decide⟩ := by
  have _previous := row_46_243
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩,
    orbitCodeOfNumber ⟨222, by decide⟩, by decide⟩

theorem row_46_245 : RowResult ⟨46, by decide⟩ ⟨245, by decide⟩ := by
  have _previous := row_46_244
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨46, by decide⟩) (orbitCodeOfNumber ⟨245, by decide⟩) 1 2 7)

theorem row_46_246 : RowResult ⟨46, by decide⟩ ⟨246, by decide⟩ := by
  have _previous := row_46_245
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨46, by decide⟩) (orbitCodeOfNumber ⟨246, by decide⟩) 1 4 6)

end RelativeConicArcs.Q25PairCertificate
