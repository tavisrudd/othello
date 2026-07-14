import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_172_233 : RowResult ⟨172, by decide⟩ ⟨233, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_172_234 : RowResult ⟨172, by decide⟩ ⟨234, by decide⟩ := by
  have _previous := row_172_233
  exact Or.inr ⟨orbitCodeOfNumber ⟨183, by decide⟩, by decide⟩

theorem row_172_235 : RowResult ⟨172, by decide⟩ ⟨235, by decide⟩ := by
  have _previous := row_172_234
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨172, by decide⟩) (orbitCodeOfNumber ⟨235, by decide⟩) 2 4 7)

theorem row_172_236 : RowResult ⟨172, by decide⟩ ⟨236, by decide⟩ := by
  have _previous := row_172_235
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_172_237 : RowResult ⟨172, by decide⟩ ⟨237, by decide⟩ := by
  have _previous := row_172_236
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_172_238 : RowResult ⟨172, by decide⟩ ⟨238, by decide⟩ := by
  have _previous := row_172_237
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_172_239 : RowResult ⟨172, by decide⟩ ⟨239, by decide⟩ := by
  have _previous := row_172_238
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨172, by decide⟩) (orbitCodeOfNumber ⟨239, by decide⟩) 2 3 6)

theorem row_172_240 : RowResult ⟨172, by decide⟩ ⟨240, by decide⟩ := by
  have _previous := row_172_239
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_172_241 : RowResult ⟨172, by decide⟩ ⟨241, by decide⟩ := by
  have _previous := row_172_240
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨172, by decide⟩) (orbitCodeOfNumber ⟨241, by decide⟩) 4 5 6)

theorem row_172_242 : RowResult ⟨172, by decide⟩ ⟨242, by decide⟩ := by
  have _previous := row_172_241
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨172, by decide⟩) (orbitCodeOfNumber ⟨242, by decide⟩) 2 5 6)

end RelativeConicArcs.Q25PairCertificate
