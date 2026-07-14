import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_110_236 : RowResult ⟨110, by decide⟩ ⟨236, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_110_237 : RowResult ⟨110, by decide⟩ ⟨237, by decide⟩ := by
  have _previous := row_110_236
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨110, by decide⟩) (orbitCodeOfNumber ⟨237, by decide⟩) 2 4 7)

theorem row_110_238 : RowResult ⟨110, by decide⟩ ⟨238, by decide⟩ := by
  have _previous := row_110_237
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨110, by decide⟩) (orbitCodeOfNumber ⟨238, by decide⟩) 2 5 7)

theorem row_110_239 : RowResult ⟨110, by decide⟩ ⟨239, by decide⟩ := by
  have _previous := row_110_238
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨110, by decide⟩) (orbitCodeOfNumber ⟨239, by decide⟩) 2 3 6)

theorem row_110_240 : RowResult ⟨110, by decide⟩ ⟨240, by decide⟩ := by
  have _previous := row_110_239
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨110, by decide⟩) (orbitCodeOfNumber ⟨240, by decide⟩) 1 4 7)

theorem row_110_241 : RowResult ⟨110, by decide⟩ ⟨241, by decide⟩ := by
  have _previous := row_110_240
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨110, by decide⟩) (orbitCodeOfNumber ⟨241, by decide⟩) 2 4 6)

theorem row_110_242 : RowResult ⟨110, by decide⟩ ⟨242, by decide⟩ := by
  have _previous := row_110_241
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_110_243 : RowResult ⟨110, by decide⟩ ⟨243, by decide⟩ := by
  have _previous := row_110_242
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_110_244 : RowResult ⟨110, by decide⟩ ⟨244, by decide⟩ := by
  have _previous := row_110_243
  exact Or.inr ⟨orbitCodeOfNumber ⟨183, by decide⟩, by decide⟩

theorem row_110_245 : RowResult ⟨110, by decide⟩ ⟨245, by decide⟩ := by
  have _previous := row_110_244
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨110, by decide⟩) (orbitCodeOfNumber ⟨245, by decide⟩) 1 2 7)

theorem row_110_246 : RowResult ⟨110, by decide⟩ ⟨246, by decide⟩ := by
  have _previous := row_110_245
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_110_247 : RowResult ⟨110, by decide⟩ ⟨247, by decide⟩ := by
  have _previous := row_110_246
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
