import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_41_213 : RowResult ⟨41, by decide⟩ ⟨213, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_41_214 : RowResult ⟨41, by decide⟩ ⟨214, by decide⟩ := by
  have _previous := row_41_213
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_41_215 : RowResult ⟨41, by decide⟩ ⟨215, by decide⟩ := by
  have _previous := row_41_214
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_41_216 : RowResult ⟨41, by decide⟩ ⟨216, by decide⟩ := by
  have _previous := row_41_215
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨41, by decide⟩) (orbitCodeOfNumber ⟨216, by decide⟩) 1 4 6)

theorem row_41_217 : RowResult ⟨41, by decide⟩ ⟨217, by decide⟩ := by
  have _previous := row_41_216
  exact Or.inr ⟨orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_41_218 : RowResult ⟨41, by decide⟩ ⟨218, by decide⟩ := by
  have _previous := row_41_217
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨41, by decide⟩) (orbitCodeOfNumber ⟨218, by decide⟩) 2 4 6)

theorem row_41_219 : RowResult ⟨41, by decide⟩ ⟨219, by decide⟩ := by
  have _previous := row_41_218
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_41_220 : RowResult ⟨41, by decide⟩ ⟨220, by decide⟩ := by
  have _previous := row_41_219
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨41, by decide⟩) (orbitCodeOfNumber ⟨220, by decide⟩) 1 2 7)

theorem row_41_221 : RowResult ⟨41, by decide⟩ ⟨221, by decide⟩ := by
  have _previous := row_41_220
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨41, by decide⟩) (orbitCodeOfNumber ⟨221, by decide⟩) 2 5 7)

theorem row_41_222 : RowResult ⟨41, by decide⟩ ⟨222, by decide⟩ := by
  have _previous := row_41_221
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨41, by decide⟩) (orbitCodeOfNumber ⟨222, by decide⟩) 4 5 6)

theorem row_41_223 : RowResult ⟨41, by decide⟩ ⟨223, by decide⟩ := by
  have _previous := row_41_222
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
