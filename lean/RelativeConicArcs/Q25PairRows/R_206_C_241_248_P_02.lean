import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_206_241 : RowResult ⟨206, by decide⟩ ⟨241, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_206_242 : RowResult ⟨206, by decide⟩ ⟨242, by decide⟩ := by
  have _previous := row_206_241
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_206_243 : RowResult ⟨206, by decide⟩ ⟨243, by decide⟩ := by
  have _previous := row_206_242
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_206_244 : RowResult ⟨206, by decide⟩ ⟨244, by decide⟩ := by
  have _previous := row_206_243
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_206_245 : RowResult ⟨206, by decide⟩ ⟨245, by decide⟩ := by
  have _previous := row_206_244
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨206, by decide⟩) (orbitCodeOfNumber ⟨245, by decide⟩) 1 2 7)

theorem row_206_246 : RowResult ⟨206, by decide⟩ ⟨246, by decide⟩ := by
  have _previous := row_206_245
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨206, by decide⟩) (orbitCodeOfNumber ⟨246, by decide⟩) 1 4 7)

theorem row_206_247 : RowResult ⟨206, by decide⟩ ⟨247, by decide⟩ := by
  have _previous := row_206_246
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_206_248 : RowResult ⟨206, by decide⟩ ⟨248, by decide⟩ := by
  have _previous := row_206_247
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
