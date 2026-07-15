import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_94_234 : RowResult ⟨94, by decide⟩ ⟨234, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨222, by decide⟩, by decide⟩

theorem row_94_235 : RowResult ⟨94, by decide⟩ ⟨235, by decide⟩ := by
  have _previous := row_94_234
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨223, by decide⟩, by decide⟩

theorem row_94_236 : RowResult ⟨94, by decide⟩ ⟨236, by decide⟩ := by
  have _previous := row_94_235
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨218, by decide⟩, by decide⟩

theorem row_94_237 : RowResult ⟨94, by decide⟩ ⟨237, by decide⟩ := by
  have _previous := row_94_236
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨224, by decide⟩, by decide⟩

theorem row_94_238 : RowResult ⟨94, by decide⟩ ⟨238, by decide⟩ := by
  have _previous := row_94_237
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨224, by decide⟩, by decide⟩

theorem row_94_239 : RowResult ⟨94, by decide⟩ ⟨239, by decide⟩ := by
  have _previous := row_94_238
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨94, by decide⟩) (orbitCodeOfNumber ⟨239, by decide⟩) 1 4 7)

theorem row_94_240 : RowResult ⟨94, by decide⟩ ⟨240, by decide⟩ := by
  have _previous := row_94_239
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨224, by decide⟩, by decide⟩

theorem row_94_241 : RowResult ⟨94, by decide⟩ ⟨241, by decide⟩ := by
  have _previous := row_94_240
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨94, by decide⟩) (orbitCodeOfNumber ⟨241, by decide⟩) 4 5 6)

end RelativeConicArcs.Q25PairCertificate
