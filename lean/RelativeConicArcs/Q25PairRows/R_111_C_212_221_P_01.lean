import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_111_212 : RowResult ⟨111, by decide⟩ ⟨212, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_111_213 : RowResult ⟨111, by decide⟩ ⟨213, by decide⟩ := by
  have _previous := row_111_212
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_111_214 : RowResult ⟨111, by decide⟩ ⟨214, by decide⟩ := by
  have _previous := row_111_213
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_111_215 : RowResult ⟨111, by decide⟩ ⟨215, by decide⟩ := by
  have _previous := row_111_214
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨111, by decide⟩) (orbitCodeOfNumber ⟨215, by decide⟩) 2 4 7)

theorem row_111_216 : RowResult ⟨111, by decide⟩ ⟨216, by decide⟩ := by
  have _previous := row_111_215
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨111, by decide⟩) (orbitCodeOfNumber ⟨216, by decide⟩) 1 4 7)

theorem row_111_217 : RowResult ⟨111, by decide⟩ ⟨217, by decide⟩ := by
  have _previous := row_111_216
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨111, by decide⟩) (orbitCodeOfNumber ⟨217, by decide⟩) 2 4 6)

theorem row_111_218 : RowResult ⟨111, by decide⟩ ⟨218, by decide⟩ := by
  have _previous := row_111_217
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_111_219 : RowResult ⟨111, by decide⟩ ⟨219, by decide⟩ := by
  have _previous := row_111_218
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_111_220 : RowResult ⟨111, by decide⟩ ⟨220, by decide⟩ := by
  have _previous := row_111_219
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨111, by decide⟩) (orbitCodeOfNumber ⟨220, by decide⟩) 1 2 7)

theorem row_111_221 : RowResult ⟨111, by decide⟩ ⟨221, by decide⟩ := by
  have _previous := row_111_220
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
