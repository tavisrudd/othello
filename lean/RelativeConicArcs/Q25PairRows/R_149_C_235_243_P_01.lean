import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_149_235 : RowResult ⟨149, by decide⟩ ⟨235, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_149_236 : RowResult ⟨149, by decide⟩ ⟨236, by decide⟩ := by
  have _previous := row_149_235
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨149, by decide⟩) (orbitCodeOfNumber ⟨236, by decide⟩) 2 5 6)

theorem row_149_237 : RowResult ⟨149, by decide⟩ ⟨237, by decide⟩ := by
  have _previous := row_149_236
  exact Or.inr ⟨orbitCodeOfNumber ⟨183, by decide⟩, by decide⟩

theorem row_149_238 : RowResult ⟨149, by decide⟩ ⟨238, by decide⟩ := by
  have _previous := row_149_237
  exact Or.inr ⟨orbitCodeOfNumber ⟨183, by decide⟩, by decide⟩

theorem row_149_239 : RowResult ⟨149, by decide⟩ ⟨239, by decide⟩ := by
  have _previous := row_149_238
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨149, by decide⟩) (orbitCodeOfNumber ⟨239, by decide⟩) 2 3 6)

theorem row_149_240 : RowResult ⟨149, by decide⟩ ⟨240, by decide⟩ := by
  have _previous := row_149_239
  exact Or.inr ⟨orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

theorem row_149_241 : RowResult ⟨149, by decide⟩ ⟨241, by decide⟩ := by
  have _previous := row_149_240
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_149_242 : RowResult ⟨149, by decide⟩ ⟨242, by decide⟩ := by
  have _previous := row_149_241
  exact Or.inr ⟨orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

theorem row_149_243 : RowResult ⟨149, by decide⟩ ⟨243, by decide⟩ := by
  have _previous := row_149_242
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨149, by decide⟩) (orbitCodeOfNumber ⟨243, by decide⟩) 2 4 7)

end RelativeConicArcs.Q25PairCertificate
