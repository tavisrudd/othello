import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_84_235 : RowResult ⟨84, by decide⟩ ⟨235, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨222, by decide⟩, by decide⟩

theorem row_84_236 : RowResult ⟨84, by decide⟩ ⟨236, by decide⟩ := by
  have _previous := row_84_235
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨221, by decide⟩, by decide⟩

theorem row_84_237 : RowResult ⟨84, by decide⟩ ⟨237, by decide⟩ := by
  have _previous := row_84_236
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨223, by decide⟩, by decide⟩

theorem row_84_238 : RowResult ⟨84, by decide⟩ ⟨238, by decide⟩ := by
  have _previous := row_84_237
  exact Or.inr ⟨orbitCodeOfNumber ⟨37, by decide⟩,
    orbitCodeOfNumber ⟨223, by decide⟩, by decide⟩

theorem row_84_239 : RowResult ⟨84, by decide⟩ ⟨239, by decide⟩ := by
  have _previous := row_84_238
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨84, by decide⟩) (orbitCodeOfNumber ⟨239, by decide⟩) 2 3 6)

theorem row_84_240 : RowResult ⟨84, by decide⟩ ⟨240, by decide⟩ := by
  have _previous := row_84_239
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨222, by decide⟩, by decide⟩

theorem row_84_241 : RowResult ⟨84, by decide⟩ ⟨241, by decide⟩ := by
  have _previous := row_84_240
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨217, by decide⟩, by decide⟩

theorem row_84_242 : RowResult ⟨84, by decide⟩ ⟨242, by decide⟩ := by
  have _previous := row_84_241
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨84, by decide⟩) (orbitCodeOfNumber ⟨242, by decide⟩) 2 4 6)

end RelativeConicArcs.Q25PairCertificate
