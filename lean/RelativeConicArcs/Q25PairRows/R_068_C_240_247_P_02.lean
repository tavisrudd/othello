import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_68_240 : RowResult ⟨68, by decide⟩ ⟨240, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_68_241 : RowResult ⟨68, by decide⟩ ⟨241, by decide⟩ := by
  have _previous := row_68_240
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_68_242 : RowResult ⟨68, by decide⟩ ⟨242, by decide⟩ := by
  have _previous := row_68_241
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_68_243 : RowResult ⟨68, by decide⟩ ⟨243, by decide⟩ := by
  have _previous := row_68_242
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨68, by decide⟩) (orbitCodeOfNumber ⟨243, by decide⟩) 1 4 6)

theorem row_68_244 : RowResult ⟨68, by decide⟩ ⟨244, by decide⟩ := by
  have _previous := row_68_243
  exact Or.inr ⟨orbitCodeOfNumber ⟨183, by decide⟩, by decide⟩

theorem row_68_245 : RowResult ⟨68, by decide⟩ ⟨245, by decide⟩ := by
  have _previous := row_68_244
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨68, by decide⟩) (orbitCodeOfNumber ⟨245, by decide⟩) 1 2 7)

theorem row_68_246 : RowResult ⟨68, by decide⟩ ⟨246, by decide⟩ := by
  have _previous := row_68_245
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_68_247 : RowResult ⟨68, by decide⟩ ⟨247, by decide⟩ := by
  have _previous := row_68_246
  exact Or.inr ⟨orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
