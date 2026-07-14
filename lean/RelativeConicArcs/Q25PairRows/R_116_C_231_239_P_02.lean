import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_116_231 : RowResult ⟨116, by decide⟩ ⟨231, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_116_232 : RowResult ⟨116, by decide⟩ ⟨232, by decide⟩ := by
  have _previous := row_116_231
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨116, by decide⟩) (orbitCodeOfNumber ⟨232, by decide⟩) 4 5 6)

theorem row_116_233 : RowResult ⟨116, by decide⟩ ⟨233, by decide⟩ := by
  have _previous := row_116_232
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_116_234 : RowResult ⟨116, by decide⟩ ⟨234, by decide⟩ := by
  have _previous := row_116_233
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_116_235 : RowResult ⟨116, by decide⟩ ⟨235, by decide⟩ := by
  have _previous := row_116_234
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_116_236 : RowResult ⟨116, by decide⟩ ⟨236, by decide⟩ := by
  have _previous := row_116_235
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨116, by decide⟩) (orbitCodeOfNumber ⟨236, by decide⟩) 1 4 7)

theorem row_116_237 : RowResult ⟨116, by decide⟩ ⟨237, by decide⟩ := by
  have _previous := row_116_236
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_116_238 : RowResult ⟨116, by decide⟩ ⟨238, by decide⟩ := by
  have _previous := row_116_237
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_116_239 : RowResult ⟨116, by decide⟩ ⟨239, by decide⟩ := by
  have _previous := row_116_238
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨116, by decide⟩) (orbitCodeOfNumber ⟨239, by decide⟩) 2 3 6)

end RelativeConicArcs.Q25PairCertificate
