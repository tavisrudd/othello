import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_37_164 : RowResult ⟨37, by decide⟩ ⟨164, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_37_165 : RowResult ⟨37, by decide⟩ ⟨165, by decide⟩ := by
  have _previous := row_37_164
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_37_166 : RowResult ⟨37, by decide⟩ ⟨166, by decide⟩ := by
  have _previous := row_37_165
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_37_167 : RowResult ⟨37, by decide⟩ ⟨167, by decide⟩ := by
  have _previous := row_37_166
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨37, by decide⟩) (orbitCodeOfNumber ⟨167, by decide⟩) 1 4 7)

theorem row_37_168 : RowResult ⟨37, by decide⟩ ⟨168, by decide⟩ := by
  have _previous := row_37_167
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_37_169 : RowResult ⟨37, by decide⟩ ⟨169, by decide⟩ := by
  have _previous := row_37_168
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨37, by decide⟩) (orbitCodeOfNumber ⟨169, by decide⟩) 2 4 7)

theorem row_37_170 : RowResult ⟨37, by decide⟩ ⟨170, by decide⟩ := by
  have _previous := row_37_169
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨37, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) 1 2 7)

theorem row_37_171 : RowResult ⟨37, by decide⟩ ⟨171, by decide⟩ := by
  have _previous := row_37_170
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_37_172 : RowResult ⟨37, by decide⟩ ⟨172, by decide⟩ := by
  have _previous := row_37_171
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_37_173 : RowResult ⟨37, by decide⟩ ⟨173, by decide⟩ := by
  have _previous := row_37_172
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨37, by decide⟩) (orbitCodeOfNumber ⟨173, by decide⟩) 2 4 6)

end RelativeConicArcs.Q25PairCertificate
