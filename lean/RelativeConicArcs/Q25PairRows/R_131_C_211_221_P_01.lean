import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_131_211 : RowResult ⟨131, by decide⟩ ⟨211, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_131_212 : RowResult ⟨131, by decide⟩ ⟨212, by decide⟩ := by
  have _previous := row_131_211
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_131_213 : RowResult ⟨131, by decide⟩ ⟨213, by decide⟩ := by
  have _previous := row_131_212
  exact Or.inr ⟨orbitCodeOfNumber ⟨183, by decide⟩, by decide⟩

theorem row_131_214 : RowResult ⟨131, by decide⟩ ⟨214, by decide⟩ := by
  have _previous := row_131_213
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_131_215 : RowResult ⟨131, by decide⟩ ⟨215, by decide⟩ := by
  have _previous := row_131_214
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_131_216 : RowResult ⟨131, by decide⟩ ⟨216, by decide⟩ := by
  have _previous := row_131_215
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨131, by decide⟩) (orbitCodeOfNumber ⟨216, by decide⟩) 2 4 7)

theorem row_131_217 : RowResult ⟨131, by decide⟩ ⟨217, by decide⟩ := by
  have _previous := row_131_216
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨131, by decide⟩) (orbitCodeOfNumber ⟨217, by decide⟩) 4 5 6)

theorem row_131_218 : RowResult ⟨131, by decide⟩ ⟨218, by decide⟩ := by
  have _previous := row_131_217
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_131_219 : RowResult ⟨131, by decide⟩ ⟨219, by decide⟩ := by
  have _previous := row_131_218
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨131, by decide⟩) (orbitCodeOfNumber ⟨219, by decide⟩) 2 5 7)

theorem row_131_220 : RowResult ⟨131, by decide⟩ ⟨220, by decide⟩ := by
  have _previous := row_131_219
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨131, by decide⟩) (orbitCodeOfNumber ⟨220, by decide⟩) 1 2 7)

theorem row_131_221 : RowResult ⟨131, by decide⟩ ⟨221, by decide⟩ := by
  have _previous := row_131_220
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨131, by decide⟩) (orbitCodeOfNumber ⟨221, by decide⟩) 1 4 7)

end RelativeConicArcs.Q25PairCertificate
