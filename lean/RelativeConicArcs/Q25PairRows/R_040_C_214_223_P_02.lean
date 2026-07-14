import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_40_214 : RowResult ⟨40, by decide⟩ ⟨214, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_40_215 : RowResult ⟨40, by decide⟩ ⟨215, by decide⟩ := by
  have _previous := row_40_214
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨40, by decide⟩) (orbitCodeOfNumber ⟨215, by decide⟩) 1 4 6)

theorem row_40_216 : RowResult ⟨40, by decide⟩ ⟨216, by decide⟩ := by
  have _previous := row_40_215
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_40_217 : RowResult ⟨40, by decide⟩ ⟨217, by decide⟩ := by
  have _previous := row_40_216
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_40_218 : RowResult ⟨40, by decide⟩ ⟨218, by decide⟩ := by
  have _previous := row_40_217
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨40, by decide⟩) (orbitCodeOfNumber ⟨218, by decide⟩) 2 4 7)

theorem row_40_219 : RowResult ⟨40, by decide⟩ ⟨219, by decide⟩ := by
  have _previous := row_40_218
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_40_220 : RowResult ⟨40, by decide⟩ ⟨220, by decide⟩ := by
  have _previous := row_40_219
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨40, by decide⟩) (orbitCodeOfNumber ⟨220, by decide⟩) 1 2 7)

theorem row_40_221 : RowResult ⟨40, by decide⟩ ⟨221, by decide⟩ := by
  have _previous := row_40_220
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨40, by decide⟩) (orbitCodeOfNumber ⟨221, by decide⟩) 4 5 6)

theorem row_40_222 : RowResult ⟨40, by decide⟩ ⟨222, by decide⟩ := by
  have _previous := row_40_221
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_40_223 : RowResult ⟨40, by decide⟩ ⟨223, by decide⟩ := by
  have _previous := row_40_222
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
