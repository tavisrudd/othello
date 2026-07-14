import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_169_234 : RowResult ⟨169, by decide⟩ ⟨234, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_169_235 : RowResult ⟨169, by decide⟩ ⟨235, by decide⟩ := by
  have _previous := row_169_234
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_169_236 : RowResult ⟨169, by decide⟩ ⟨236, by decide⟩ := by
  have _previous := row_169_235
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_169_237 : RowResult ⟨169, by decide⟩ ⟨237, by decide⟩ := by
  have _previous := row_169_236
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_169_238 : RowResult ⟨169, by decide⟩ ⟨238, by decide⟩ := by
  have _previous := row_169_237
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨169, by decide⟩) (orbitCodeOfNumber ⟨238, by decide⟩) 2 4 7)

theorem row_169_239 : RowResult ⟨169, by decide⟩ ⟨239, by decide⟩ := by
  have _previous := row_169_238
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨169, by decide⟩) (orbitCodeOfNumber ⟨239, by decide⟩) 1 4 7)

theorem row_169_240 : RowResult ⟨169, by decide⟩ ⟨240, by decide⟩ := by
  have _previous := row_169_239
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_169_241 : RowResult ⟨169, by decide⟩ ⟨241, by decide⟩ := by
  have _previous := row_169_240
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
