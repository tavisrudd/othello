import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_36_164 : RowResult ⟨36, by decide⟩ ⟨164, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_36_165 : RowResult ⟨36, by decide⟩ ⟨165, by decide⟩ := by
  have _previous := row_36_164
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_36_166 : RowResult ⟨36, by decide⟩ ⟨166, by decide⟩ := by
  have _previous := row_36_165
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨36, by decide⟩) (orbitCodeOfNumber ⟨166, by decide⟩) 1 4 7)

theorem row_36_167 : RowResult ⟨36, by decide⟩ ⟨167, by decide⟩ := by
  have _previous := row_36_166
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_36_168 : RowResult ⟨36, by decide⟩ ⟨168, by decide⟩ := by
  have _previous := row_36_167
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨36, by decide⟩) (orbitCodeOfNumber ⟨168, by decide⟩) 2 5 6)

theorem row_36_169 : RowResult ⟨36, by decide⟩ ⟨169, by decide⟩ := by
  have _previous := row_36_168
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_36_170 : RowResult ⟨36, by decide⟩ ⟨170, by decide⟩ := by
  have _previous := row_36_169
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨36, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) 1 2 7)

theorem row_36_171 : RowResult ⟨36, by decide⟩ ⟨171, by decide⟩ := by
  have _previous := row_36_170
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_36_172 : RowResult ⟨36, by decide⟩ ⟨172, by decide⟩ := by
  have _previous := row_36_171
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨36, by decide⟩) (orbitCodeOfNumber ⟨172, by decide⟩) 2 5 7)

theorem row_36_173 : RowResult ⟨36, by decide⟩ ⟨173, by decide⟩ := by
  have _previous := row_36_172
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
