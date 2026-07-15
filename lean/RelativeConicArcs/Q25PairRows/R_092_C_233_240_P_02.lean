import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_92_233 : RowResult ⟨92, by decide⟩ ⟨233, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨41, by decide⟩,
    orbitCodeOfNumber ⟨222, by decide⟩, by decide⟩

theorem row_92_234 : RowResult ⟨92, by decide⟩ ⟨234, by decide⟩ := by
  have _previous := row_92_233
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨223, by decide⟩, by decide⟩

theorem row_92_235 : RowResult ⟨92, by decide⟩ ⟨235, by decide⟩ := by
  have _previous := row_92_234
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨223, by decide⟩, by decide⟩

theorem row_92_236 : RowResult ⟨92, by decide⟩ ⟨236, by decide⟩ := by
  have _previous := row_92_235
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨221, by decide⟩, by decide⟩

theorem row_92_237 : RowResult ⟨92, by decide⟩ ⟨237, by decide⟩ := by
  have _previous := row_92_236
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨92, by decide⟩) (orbitCodeOfNumber ⟨237, by decide⟩) 1 4 7)

theorem row_92_238 : RowResult ⟨92, by decide⟩ ⟨238, by decide⟩ := by
  have _previous := row_92_237
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨223, by decide⟩, by decide⟩

theorem row_92_239 : RowResult ⟨92, by decide⟩ ⟨239, by decide⟩ := by
  have _previous := row_92_238
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨92, by decide⟩) (orbitCodeOfNumber ⟨239, by decide⟩) 2 3 6)

theorem row_92_240 : RowResult ⟨92, by decide⟩ ⟨240, by decide⟩ := by
  have _previous := row_92_239
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨222, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
