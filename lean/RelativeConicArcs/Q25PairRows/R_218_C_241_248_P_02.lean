import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_218_241 : RowResult ⟨218, by decide⟩ ⟨241, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨199, by decide⟩, by decide⟩

theorem row_218_242 : RowResult ⟨218, by decide⟩ ⟨242, by decide⟩ := by
  have _previous := row_218_241
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨197, by decide⟩, by decide⟩

theorem row_218_243 : RowResult ⟨218, by decide⟩ ⟨243, by decide⟩ := by
  have _previous := row_218_242
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨218, by decide⟩) (orbitCodeOfNumber ⟨243, by decide⟩) 1 4 6)

theorem row_218_244 : RowResult ⟨218, by decide⟩ ⟨244, by decide⟩ := by
  have _previous := row_218_243
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨199, by decide⟩, by decide⟩

theorem row_218_245 : RowResult ⟨218, by decide⟩ ⟨245, by decide⟩ := by
  have _previous := row_218_244
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨218, by decide⟩) (orbitCodeOfNumber ⟨245, by decide⟩) 1 2 7)

theorem row_218_246 : RowResult ⟨218, by decide⟩ ⟨246, by decide⟩ := by
  have _previous := row_218_245
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨197, by decide⟩, by decide⟩

theorem row_218_247 : RowResult ⟨218, by decide⟩ ⟨247, by decide⟩ := by
  have _previous := row_218_246
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨198, by decide⟩, by decide⟩

theorem row_218_248 : RowResult ⟨218, by decide⟩ ⟨248, by decide⟩ := by
  have _previous := row_218_247
  exact Or.inr ⟨orbitCodeOfNumber ⟨36, by decide⟩,
    orbitCodeOfNumber ⟨192, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
