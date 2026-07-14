import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_87_234 : RowResult ⟨87, by decide⟩ ⟨234, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_87_235 : RowResult ⟨87, by decide⟩ ⟨235, by decide⟩ := by
  have _previous := row_87_234
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨87, by decide⟩) (orbitCodeOfNumber ⟨235, by decide⟩) 4 5 6)

theorem row_87_236 : RowResult ⟨87, by decide⟩ ⟨236, by decide⟩ := by
  have _previous := row_87_235
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_87_237 : RowResult ⟨87, by decide⟩ ⟨237, by decide⟩ := by
  have _previous := row_87_236
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨87, by decide⟩) (orbitCodeOfNumber ⟨237, by decide⟩) 1 4 6)

theorem row_87_238 : RowResult ⟨87, by decide⟩ ⟨238, by decide⟩ := by
  have _previous := row_87_237
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_87_239 : RowResult ⟨87, by decide⟩ ⟨239, by decide⟩ := by
  have _previous := row_87_238
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨87, by decide⟩) (orbitCodeOfNumber ⟨239, by decide⟩) 2 3 6)

theorem row_87_240 : RowResult ⟨87, by decide⟩ ⟨240, by decide⟩ := by
  have _previous := row_87_239
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_87_241 : RowResult ⟨87, by decide⟩ ⟨241, by decide⟩ := by
  have _previous := row_87_240
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_87_242 : RowResult ⟨87, by decide⟩ ⟨242, by decide⟩ := by
  have _previous := row_87_241
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨87, by decide⟩) (orbitCodeOfNumber ⟨242, by decide⟩) 1 4 7)

theorem row_87_243 : RowResult ⟨87, by decide⟩ ⟨243, by decide⟩ := by
  have _previous := row_87_242
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_87_244 : RowResult ⟨87, by decide⟩ ⟨244, by decide⟩ := by
  have _previous := row_87_243
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨87, by decide⟩) (orbitCodeOfNumber ⟨244, by decide⟩) 2 5 6)

theorem row_87_245 : RowResult ⟨87, by decide⟩ ⟨245, by decide⟩ := by
  have _previous := row_87_244
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨87, by decide⟩) (orbitCodeOfNumber ⟨245, by decide⟩) 1 2 7)

theorem row_87_246 : RowResult ⟨87, by decide⟩ ⟨246, by decide⟩ := by
  have _previous := row_87_245
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨87, by decide⟩) (orbitCodeOfNumber ⟨246, by decide⟩) 2 5 7)

end RelativeConicArcs.Q25PairCertificate
