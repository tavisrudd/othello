import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_164_232 : RowResult ⟨164, by decide⟩ ⟨232, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_164_233 : RowResult ⟨164, by decide⟩ ⟨233, by decide⟩ := by
  have _previous := row_164_232
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_164_234 : RowResult ⟨164, by decide⟩ ⟨234, by decide⟩ := by
  have _previous := row_164_233
  exact Or.inr ⟨orbitCodeOfNumber ⟨183, by decide⟩, by decide⟩

theorem row_164_235 : RowResult ⟨164, by decide⟩ ⟨235, by decide⟩ := by
  have _previous := row_164_234
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_164_236 : RowResult ⟨164, by decide⟩ ⟨236, by decide⟩ := by
  have _previous := row_164_235
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨164, by decide⟩) (orbitCodeOfNumber ⟨236, by decide⟩) 2 4 6)

theorem row_164_237 : RowResult ⟨164, by decide⟩ ⟨237, by decide⟩ := by
  have _previous := row_164_236
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_164_238 : RowResult ⟨164, by decide⟩ ⟨238, by decide⟩ := by
  have _previous := row_164_237
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨164, by decide⟩) (orbitCodeOfNumber ⟨238, by decide⟩) 2 5 6)

theorem row_164_239 : RowResult ⟨164, by decide⟩ ⟨239, by decide⟩ := by
  have _previous := row_164_238
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨164, by decide⟩) (orbitCodeOfNumber ⟨239, by decide⟩) 1 4 6)

theorem row_164_240 : RowResult ⟨164, by decide⟩ ⟨240, by decide⟩ := by
  have _previous := row_164_239
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_164_241 : RowResult ⟨164, by decide⟩ ⟨241, by decide⟩ := by
  have _previous := row_164_240
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨164, by decide⟩) (orbitCodeOfNumber ⟨241, by decide⟩) 2 5 7)

end RelativeConicArcs.Q25PairCertificate
