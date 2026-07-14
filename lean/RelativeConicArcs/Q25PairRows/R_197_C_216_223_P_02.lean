import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_197_216 : RowResult ⟨197, by decide⟩ ⟨216, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_197_217 : RowResult ⟨197, by decide⟩ ⟨217, by decide⟩ := by
  have _previous := row_197_216
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_197_218 : RowResult ⟨197, by decide⟩ ⟨218, by decide⟩ := by
  have _previous := row_197_217
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_197_219 : RowResult ⟨197, by decide⟩ ⟨219, by decide⟩ := by
  have _previous := row_197_218
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_197_220 : RowResult ⟨197, by decide⟩ ⟨220, by decide⟩ := by
  have _previous := row_197_219
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨197, by decide⟩) (orbitCodeOfNumber ⟨220, by decide⟩) 1 2 7)

theorem row_197_221 : RowResult ⟨197, by decide⟩ ⟨221, by decide⟩ := by
  have _previous := row_197_220
  exact Or.inr ⟨orbitCodeOfNumber ⟨237, by decide⟩, by decide⟩

theorem row_197_222 : RowResult ⟨197, by decide⟩ ⟨222, by decide⟩ := by
  have _previous := row_197_221
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨197, by decide⟩) (orbitCodeOfNumber ⟨222, by decide⟩) 1 4 6)

theorem row_197_223 : RowResult ⟨197, by decide⟩ ⟨223, by decide⟩ := by
  have _previous := row_197_222
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
