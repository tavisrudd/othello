import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_85_217 : RowResult ⟨85, by decide⟩ ⟨217, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨183, by decide⟩, by decide⟩

theorem row_85_218 : RowResult ⟨85, by decide⟩ ⟨218, by decide⟩ := by
  have _previous := row_85_217
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_85_219 : RowResult ⟨85, by decide⟩ ⟨219, by decide⟩ := by
  have _previous := row_85_218
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_85_220 : RowResult ⟨85, by decide⟩ ⟨220, by decide⟩ := by
  have _previous := row_85_219
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨85, by decide⟩) (orbitCodeOfNumber ⟨220, by decide⟩) 1 2 7)

theorem row_85_221 : RowResult ⟨85, by decide⟩ ⟨221, by decide⟩ := by
  have _previous := row_85_220
  exact Or.inr ⟨orbitCodeOfNumber ⟨237, by decide⟩, by decide⟩

theorem row_85_222 : RowResult ⟨85, by decide⟩ ⟨222, by decide⟩ := by
  have _previous := row_85_221
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_85_223 : RowResult ⟨85, by decide⟩ ⟨223, by decide⟩ := by
  have _previous := row_85_222
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
