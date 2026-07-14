import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_163_233 : RowResult ⟨163, by decide⟩ ⟨233, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_163_234 : RowResult ⟨163, by decide⟩ ⟨234, by decide⟩ := by
  have _previous := row_163_233
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_163_235 : RowResult ⟨163, by decide⟩ ⟨235, by decide⟩ := by
  have _previous := row_163_234
  exact Or.inr ⟨orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

theorem row_163_236 : RowResult ⟨163, by decide⟩ ⟨236, by decide⟩ := by
  have _previous := row_163_235
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨163, by decide⟩) (orbitCodeOfNumber ⟨236, by decide⟩) 2 5 7)

theorem row_163_237 : RowResult ⟨163, by decide⟩ ⟨237, by decide⟩ := by
  have _previous := row_163_236
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_163_238 : RowResult ⟨163, by decide⟩ ⟨238, by decide⟩ := by
  have _previous := row_163_237
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨163, by decide⟩) (orbitCodeOfNumber ⟨238, by decide⟩) 1 4 6)

theorem row_163_239 : RowResult ⟨163, by decide⟩ ⟨239, by decide⟩ := by
  have _previous := row_163_238
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨163, by decide⟩) (orbitCodeOfNumber ⟨239, by decide⟩) 2 3 6)

theorem row_163_240 : RowResult ⟨163, by decide⟩ ⟨240, by decide⟩ := by
  have _previous := row_163_239
  exact Or.inr ⟨orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

theorem row_163_241 : RowResult ⟨163, by decide⟩ ⟨241, by decide⟩ := by
  have _previous := row_163_240
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
