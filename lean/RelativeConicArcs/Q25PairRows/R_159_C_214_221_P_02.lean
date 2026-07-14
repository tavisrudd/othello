import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_159_214 : RowResult ⟨159, by decide⟩ ⟨214, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_159_215 : RowResult ⟨159, by decide⟩ ⟨215, by decide⟩ := by
  have _previous := row_159_214
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_159_216 : RowResult ⟨159, by decide⟩ ⟨216, by decide⟩ := by
  have _previous := row_159_215
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_159_217 : RowResult ⟨159, by decide⟩ ⟨217, by decide⟩ := by
  have _previous := row_159_216
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_159_218 : RowResult ⟨159, by decide⟩ ⟨218, by decide⟩ := by
  have _previous := row_159_217
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_159_219 : RowResult ⟨159, by decide⟩ ⟨219, by decide⟩ := by
  have _previous := row_159_218
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_159_220 : RowResult ⟨159, by decide⟩ ⟨220, by decide⟩ := by
  have _previous := row_159_219
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨159, by decide⟩) (orbitCodeOfNumber ⟨220, by decide⟩) 1 2 7)

theorem row_159_221 : RowResult ⟨159, by decide⟩ ⟨221, by decide⟩ := by
  have _previous := row_159_220
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨159, by decide⟩) (orbitCodeOfNumber ⟨221, by decide⟩) 2 5 6)

end RelativeConicArcs.Q25PairCertificate
