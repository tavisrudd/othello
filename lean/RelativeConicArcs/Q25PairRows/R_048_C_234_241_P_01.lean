import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_48_234 : RowResult ⟨48, by decide⟩ ⟨234, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨63, by decide⟩,
    orbitCodeOfNumber ⟨222, by decide⟩, by decide⟩

theorem row_48_235 : RowResult ⟨48, by decide⟩ ⟨235, by decide⟩ := by
  have _previous := row_48_234
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩,
    orbitCodeOfNumber ⟨222, by decide⟩, by decide⟩

theorem row_48_236 : RowResult ⟨48, by decide⟩ ⟨236, by decide⟩ := by
  have _previous := row_48_235
  exact Or.inr ⟨orbitCodeOfNumber ⟨63, by decide⟩,
    orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

theorem row_48_237 : RowResult ⟨48, by decide⟩ ⟨237, by decide⟩ := by
  have _previous := row_48_236
  exact Or.inr ⟨orbitCodeOfNumber ⟨61, by decide⟩,
    orbitCodeOfNumber ⟨224, by decide⟩, by decide⟩

theorem row_48_238 : RowResult ⟨48, by decide⟩ ⟨238, by decide⟩ := by
  have _previous := row_48_237
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨48, by decide⟩) (orbitCodeOfNumber ⟨238, by decide⟩) 2 4 7)

theorem row_48_239 : RowResult ⟨48, by decide⟩ ⟨239, by decide⟩ := by
  have _previous := row_48_238
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨48, by decide⟩) (orbitCodeOfNumber ⟨239, by decide⟩) 2 3 6)

theorem row_48_240 : RowResult ⟨48, by decide⟩ ⟨240, by decide⟩ := by
  have _previous := row_48_239
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩,
    orbitCodeOfNumber ⟨224, by decide⟩, by decide⟩

theorem row_48_241 : RowResult ⟨48, by decide⟩ ⟨241, by decide⟩ := by
  have _previous := row_48_240
  exact Or.inr ⟨orbitCodeOfNumber ⟨63, by decide⟩,
    orbitCodeOfNumber ⟨224, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
