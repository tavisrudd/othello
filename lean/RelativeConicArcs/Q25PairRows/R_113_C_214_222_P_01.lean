import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_113_214 : RowResult ⟨113, by decide⟩ ⟨214, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_113_215 : RowResult ⟨113, by decide⟩ ⟨215, by decide⟩ := by
  have _previous := row_113_214
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_113_216 : RowResult ⟨113, by decide⟩ ⟨216, by decide⟩ := by
  have _previous := row_113_215
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨113, by decide⟩) (orbitCodeOfNumber ⟨216, by decide⟩) 2 4 6)

theorem row_113_217 : RowResult ⟨113, by decide⟩ ⟨217, by decide⟩ := by
  have _previous := row_113_216
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_113_218 : RowResult ⟨113, by decide⟩ ⟨218, by decide⟩ := by
  have _previous := row_113_217
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨113, by decide⟩) (orbitCodeOfNumber ⟨218, by decide⟩) 1 4 7)

theorem row_113_219 : RowResult ⟨113, by decide⟩ ⟨219, by decide⟩ := by
  have _previous := row_113_218
  exact Or.inr ⟨orbitCodeOfNumber ⟨183, by decide⟩, by decide⟩

theorem row_113_220 : RowResult ⟨113, by decide⟩ ⟨220, by decide⟩ := by
  have _previous := row_113_219
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨113, by decide⟩) (orbitCodeOfNumber ⟨220, by decide⟩) 1 2 7)

theorem row_113_221 : RowResult ⟨113, by decide⟩ ⟨221, by decide⟩ := by
  have _previous := row_113_220
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_113_222 : RowResult ⟨113, by decide⟩ ⟨222, by decide⟩ := by
  have _previous := row_113_221
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
