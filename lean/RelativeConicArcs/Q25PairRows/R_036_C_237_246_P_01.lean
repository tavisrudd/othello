import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_36_237 : RowResult ⟨36, by decide⟩ ⟨237, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨63, by decide⟩,
    orbitCodeOfNumber ⟨224, by decide⟩, by decide⟩

theorem row_36_238 : RowResult ⟨36, by decide⟩ ⟨238, by decide⟩ := by
  have _previous := row_36_237
  exact Or.inr ⟨orbitCodeOfNumber ⟨58, by decide⟩,
    orbitCodeOfNumber ⟨224, by decide⟩, by decide⟩

theorem row_36_239 : RowResult ⟨36, by decide⟩ ⟨239, by decide⟩ := by
  have _previous := row_36_238
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨36, by decide⟩) (orbitCodeOfNumber ⟨239, by decide⟩) 2 3 6)

theorem row_36_240 : RowResult ⟨36, by decide⟩ ⟨240, by decide⟩ := by
  have _previous := row_36_239
  exact Or.inr ⟨orbitCodeOfNumber ⟨58, by decide⟩,
    orbitCodeOfNumber ⟨217, by decide⟩, by decide⟩

theorem row_36_241 : RowResult ⟨36, by decide⟩ ⟨241, by decide⟩ := by
  have _previous := row_36_240
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨36, by decide⟩) (orbitCodeOfNumber ⟨241, by decide⟩) 1 4 7)

theorem row_36_242 : RowResult ⟨36, by decide⟩ ⟨242, by decide⟩ := by
  have _previous := row_36_241
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨36, by decide⟩) (orbitCodeOfNumber ⟨242, by decide⟩) 2 5 6)

theorem row_36_243 : RowResult ⟨36, by decide⟩ ⟨243, by decide⟩ := by
  have _previous := row_36_242
  exact Or.inr ⟨orbitCodeOfNumber ⟨58, by decide⟩,
    orbitCodeOfNumber ⟨224, by decide⟩, by decide⟩

theorem row_36_244 : RowResult ⟨36, by decide⟩ ⟨244, by decide⟩ := by
  have _previous := row_36_243
  exact Or.inr ⟨orbitCodeOfNumber ⟨58, by decide⟩,
    orbitCodeOfNumber ⟨218, by decide⟩, by decide⟩

theorem row_36_245 : RowResult ⟨36, by decide⟩ ⟨245, by decide⟩ := by
  have _previous := row_36_244
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨36, by decide⟩) (orbitCodeOfNumber ⟨245, by decide⟩) 1 2 7)

theorem row_36_246 : RowResult ⟨36, by decide⟩ ⟨246, by decide⟩ := by
  have _previous := row_36_245
  exact Or.inr ⟨orbitCodeOfNumber ⟨58, by decide⟩,
    orbitCodeOfNumber ⟨224, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
