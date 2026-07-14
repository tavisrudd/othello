import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_142_165 : RowResult ⟨142, by decide⟩ ⟨165, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_142_166 : RowResult ⟨142, by decide⟩ ⟨166, by decide⟩ := by
  have _previous := row_142_165
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_142_167 : RowResult ⟨142, by decide⟩ ⟨167, by decide⟩ := by
  have _previous := row_142_166
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨142, by decide⟩) (orbitCodeOfNumber ⟨167, by decide⟩) 1 4 6)

theorem row_142_168 : RowResult ⟨142, by decide⟩ ⟨168, by decide⟩ := by
  have _previous := row_142_167
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_142_169 : RowResult ⟨142, by decide⟩ ⟨169, by decide⟩ := by
  have _previous := row_142_168
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_142_170 : RowResult ⟨142, by decide⟩ ⟨170, by decide⟩ := by
  have _previous := row_142_169
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨142, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) 1 2 7)

theorem row_142_171 : RowResult ⟨142, by decide⟩ ⟨171, by decide⟩ := by
  have _previous := row_142_170
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨142, by decide⟩) (orbitCodeOfNumber ⟨171, by decide⟩) 4 5 6)

theorem row_142_172 : RowResult ⟨142, by decide⟩ ⟨172, by decide⟩ := by
  have _previous := row_142_171
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_142_173 : RowResult ⟨142, by decide⟩ ⟨173, by decide⟩ := by
  have _previous := row_142_172
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
