import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_141_165 : RowResult ⟨141, by decide⟩ ⟨165, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨37, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_141_166 : RowResult ⟨141, by decide⟩ ⟨166, by decide⟩ := by
  have _previous := row_141_165
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨141, by decide⟩) (orbitCodeOfNumber ⟨166, by decide⟩) 1 4 6)

theorem row_141_167 : RowResult ⟨141, by decide⟩ ⟨167, by decide⟩ := by
  have _previous := row_141_166
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨141, by decide⟩) (orbitCodeOfNumber ⟨167, by decide⟩) 2 4 6)

theorem row_141_168 : RowResult ⟨141, by decide⟩ ⟨168, by decide⟩ := by
  have _previous := row_141_167
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_141_169 : RowResult ⟨141, by decide⟩ ⟨169, by decide⟩ := by
  have _previous := row_141_168
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_141_170 : RowResult ⟨141, by decide⟩ ⟨170, by decide⟩ := by
  have _previous := row_141_169
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨141, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) 1 2 7)

theorem row_141_171 : RowResult ⟨141, by decide⟩ ⟨171, by decide⟩ := by
  have _previous := row_141_170
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_141_172 : RowResult ⟨141, by decide⟩ ⟨172, by decide⟩ := by
  have _previous := row_141_171
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_141_173 : RowResult ⟨141, by decide⟩ ⟨173, by decide⟩ := by
  have _previous := row_141_172
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
