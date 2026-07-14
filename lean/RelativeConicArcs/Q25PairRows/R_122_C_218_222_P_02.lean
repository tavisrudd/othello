import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_122_218 : RowResult ⟨122, by decide⟩ ⟨218, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_122_219 : RowResult ⟨122, by decide⟩ ⟨219, by decide⟩ := by
  have _previous := row_122_218
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_122_220 : RowResult ⟨122, by decide⟩ ⟨220, by decide⟩ := by
  have _previous := row_122_219
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨122, by decide⟩) (orbitCodeOfNumber ⟨220, by decide⟩) 1 2 7)

theorem row_122_221 : RowResult ⟨122, by decide⟩ ⟨221, by decide⟩ := by
  have _previous := row_122_220
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_122_222 : RowResult ⟨122, by decide⟩ ⟨222, by decide⟩ := by
  have _previous := row_122_221
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨122, by decide⟩) (orbitCodeOfNumber ⟨222, by decide⟩) 1 4 6)

end RelativeConicArcs.Q25PairCertificate
