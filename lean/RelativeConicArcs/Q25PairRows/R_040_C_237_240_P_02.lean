import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_40_237 : RowResult ⟨40, by decide⟩ ⟨237, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_40_238 : RowResult ⟨40, by decide⟩ ⟨238, by decide⟩ := by
  have _previous := row_40_237
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_40_239 : RowResult ⟨40, by decide⟩ ⟨239, by decide⟩ := by
  have _previous := row_40_238
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨40, by decide⟩) (orbitCodeOfNumber ⟨239, by decide⟩) 2 3 6)

theorem row_40_240 : RowResult ⟨40, by decide⟩ ⟨240, by decide⟩ := by
  have _previous := row_40_239
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨40, by decide⟩) (orbitCodeOfNumber ⟨240, by decide⟩) 1 4 6)

end RelativeConicArcs.Q25PairCertificate
