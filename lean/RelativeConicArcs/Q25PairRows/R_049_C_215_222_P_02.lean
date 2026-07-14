import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_49_215 : RowResult ⟨49, by decide⟩ ⟨215, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_49_216 : RowResult ⟨49, by decide⟩ ⟨216, by decide⟩ := by
  have _previous := row_49_215
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_49_217 : RowResult ⟨49, by decide⟩ ⟨217, by decide⟩ := by
  have _previous := row_49_216
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_49_218 : RowResult ⟨49, by decide⟩ ⟨218, by decide⟩ := by
  have _previous := row_49_217
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_49_219 : RowResult ⟨49, by decide⟩ ⟨219, by decide⟩ := by
  have _previous := row_49_218
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_49_220 : RowResult ⟨49, by decide⟩ ⟨220, by decide⟩ := by
  have _previous := row_49_219
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨49, by decide⟩) (orbitCodeOfNumber ⟨220, by decide⟩) 1 2 7)

theorem row_49_221 : RowResult ⟨49, by decide⟩ ⟨221, by decide⟩ := by
  have _previous := row_49_220
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_49_222 : RowResult ⟨49, by decide⟩ ⟨222, by decide⟩ := by
  have _previous := row_49_221
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨49, by decide⟩) (orbitCodeOfNumber ⟨222, by decide⟩) 2 4 6)

end RelativeConicArcs.Q25PairCertificate
