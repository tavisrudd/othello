import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_187_233 : RowResult ⟨187, by decide⟩ ⟨233, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_187_234 : RowResult ⟨187, by decide⟩ ⟨234, by decide⟩ := by
  have _previous := row_187_233
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_187_235 : RowResult ⟨187, by decide⟩ ⟨235, by decide⟩ := by
  have _previous := row_187_234
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_187_236 : RowResult ⟨187, by decide⟩ ⟨236, by decide⟩ := by
  have _previous := row_187_235
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨187, by decide⟩) (orbitCodeOfNumber ⟨236, by decide⟩) 2 5 6)

theorem row_187_237 : RowResult ⟨187, by decide⟩ ⟨237, by decide⟩ := by
  have _previous := row_187_236
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨187, by decide⟩) (orbitCodeOfNumber ⟨237, by decide⟩) 1 4 6)

theorem row_187_238 : RowResult ⟨187, by decide⟩ ⟨238, by decide⟩ := by
  have _previous := row_187_237
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨187, by decide⟩) (orbitCodeOfNumber ⟨238, by decide⟩) 4 5 6)

theorem row_187_239 : RowResult ⟨187, by decide⟩ ⟨239, by decide⟩ := by
  have _previous := row_187_238
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨187, by decide⟩) (orbitCodeOfNumber ⟨239, by decide⟩) 2 3 6)

theorem row_187_240 : RowResult ⟨187, by decide⟩ ⟨240, by decide⟩ := by
  have _previous := row_187_239
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨187, by decide⟩) (orbitCodeOfNumber ⟨240, by decide⟩) 2 4 7)

theorem row_187_241 : RowResult ⟨187, by decide⟩ ⟨241, by decide⟩ := by
  have _previous := row_187_240
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_187_242 : RowResult ⟨187, by decide⟩ ⟨242, by decide⟩ := by
  have _previous := row_187_241
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨187, by decide⟩) (orbitCodeOfNumber ⟨242, by decide⟩) 1 4 7)

theorem row_187_243 : RowResult ⟨187, by decide⟩ ⟨243, by decide⟩ := by
  have _previous := row_187_242
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_187_244 : RowResult ⟨187, by decide⟩ ⟨244, by decide⟩ := by
  have _previous := row_187_243
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_187_245 : RowResult ⟨187, by decide⟩ ⟨245, by decide⟩ := by
  have _previous := row_187_244
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨187, by decide⟩) (orbitCodeOfNumber ⟨245, by decide⟩) 1 2 7)

end RelativeConicArcs.Q25PairCertificate
