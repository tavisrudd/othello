import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_168_232 : RowResult ⟨168, by decide⟩ ⟨232, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

theorem row_168_233 : RowResult ⟨168, by decide⟩ ⟨233, by decide⟩ := by
  have _previous := row_168_232
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨224, by decide⟩, by decide⟩

theorem row_168_234 : RowResult ⟨168, by decide⟩ ⟨234, by decide⟩ := by
  have _previous := row_168_233
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨223, by decide⟩, by decide⟩

theorem row_168_235 : RowResult ⟨168, by decide⟩ ⟨235, by decide⟩ := by
  have _previous := row_168_234
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨223, by decide⟩, by decide⟩

theorem row_168_236 : RowResult ⟨168, by decide⟩ ⟨236, by decide⟩ := by
  have _previous := row_168_235
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨224, by decide⟩, by decide⟩

theorem row_168_237 : RowResult ⟨168, by decide⟩ ⟨237, by decide⟩ := by
  have _previous := row_168_236
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨224, by decide⟩, by decide⟩

theorem row_168_238 : RowResult ⟨168, by decide⟩ ⟨238, by decide⟩ := by
  have _previous := row_168_237
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨168, by decide⟩) (orbitCodeOfNumber ⟨238, by decide⟩) 1 4 7)

theorem row_168_239 : RowResult ⟨168, by decide⟩ ⟨239, by decide⟩ := by
  have _previous := row_168_238
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨168, by decide⟩) (orbitCodeOfNumber ⟨239, by decide⟩) 2 3 6)

end RelativeConicArcs.Q25PairCertificate
