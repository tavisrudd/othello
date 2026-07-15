import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_214_238 : RowResult ⟨214, by decide⟩ ⟨238, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨37, by decide⟩,
    orbitCodeOfNumber ⟨199, by decide⟩, by decide⟩

theorem row_214_239 : RowResult ⟨214, by decide⟩ ⟨239, by decide⟩ := by
  have _previous := row_214_238
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨214, by decide⟩) (orbitCodeOfNumber ⟨239, by decide⟩) 1 4 6)

theorem row_214_240 : RowResult ⟨214, by decide⟩ ⟨240, by decide⟩ := by
  have _previous := row_214_239
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨199, by decide⟩, by decide⟩

theorem row_214_241 : RowResult ⟨214, by decide⟩ ⟨241, by decide⟩ := by
  have _previous := row_214_240
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨199, by decide⟩, by decide⟩

theorem row_214_242 : RowResult ⟨214, by decide⟩ ⟨242, by decide⟩ := by
  have _previous := row_214_241
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨214, by decide⟩) (orbitCodeOfNumber ⟨242, by decide⟩) 2 4 6)

theorem row_214_243 : RowResult ⟨214, by decide⟩ ⟨243, by decide⟩ := by
  have _previous := row_214_242
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨199, by decide⟩, by decide⟩

theorem row_214_244 : RowResult ⟨214, by decide⟩ ⟨244, by decide⟩ := by
  have _previous := row_214_243
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨214, by decide⟩) (orbitCodeOfNumber ⟨244, by decide⟩) 1 4 7)

theorem row_214_245 : RowResult ⟨214, by decide⟩ ⟨245, by decide⟩ := by
  have _previous := row_214_244
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨214, by decide⟩) (orbitCodeOfNumber ⟨245, by decide⟩) 1 2 7)

theorem row_214_246 : RowResult ⟨214, by decide⟩ ⟨246, by decide⟩ := by
  have _previous := row_214_245
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨198, by decide⟩, by decide⟩

theorem row_214_247 : RowResult ⟨214, by decide⟩ ⟨247, by decide⟩ := by
  have _previous := row_214_246
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨198, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
