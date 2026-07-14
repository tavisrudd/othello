import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_190_232 : RowResult ⟨190, by decide⟩ ⟨232, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_190_233 : RowResult ⟨190, by decide⟩ ⟨233, by decide⟩ := by
  have _previous := row_190_232
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨190, by decide⟩) (orbitCodeOfNumber ⟨233, by decide⟩) 2 4 6)

theorem row_190_234 : RowResult ⟨190, by decide⟩ ⟨234, by decide⟩ := by
  have _previous := row_190_233
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨190, by decide⟩) (orbitCodeOfNumber ⟨234, by decide⟩) 2 4 7)

theorem row_190_235 : RowResult ⟨190, by decide⟩ ⟨235, by decide⟩ := by
  have _previous := row_190_234
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨190, by decide⟩) (orbitCodeOfNumber ⟨235, by decide⟩) 1 4 7)

theorem row_190_236 : RowResult ⟨190, by decide⟩ ⟨236, by decide⟩ := by
  have _previous := row_190_235
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_190_237 : RowResult ⟨190, by decide⟩ ⟨237, by decide⟩ := by
  have _previous := row_190_236
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_190_238 : RowResult ⟨190, by decide⟩ ⟨238, by decide⟩ := by
  have _previous := row_190_237
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_190_239 : RowResult ⟨190, by decide⟩ ⟨239, by decide⟩ := by
  have _previous := row_190_238
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨190, by decide⟩) (orbitCodeOfNumber ⟨239, by decide⟩) 2 3 6)

theorem row_190_240 : RowResult ⟨190, by decide⟩ ⟨240, by decide⟩ := by
  have _previous := row_190_239
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨190, by decide⟩) (orbitCodeOfNumber ⟨240, by decide⟩) 1 4 6)

theorem row_190_241 : RowResult ⟨190, by decide⟩ ⟨241, by decide⟩ := by
  have _previous := row_190_240
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_190_242 : RowResult ⟨190, by decide⟩ ⟨242, by decide⟩ := by
  have _previous := row_190_241
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
