import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_58_166 : RowResult ⟨58, by decide⟩ ⟨166, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨240, by decide⟩, by decide⟩

theorem row_58_167 : RowResult ⟨58, by decide⟩ ⟨167, by decide⟩ := by
  have _previous := row_58_166
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨246, by decide⟩, by decide⟩

theorem row_58_168 : RowResult ⟨58, by decide⟩ ⟨168, by decide⟩ := by
  have _previous := row_58_167
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_58_169 : RowResult ⟨58, by decide⟩ ⟨169, by decide⟩ := by
  have _previous := row_58_168
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨246, by decide⟩, by decide⟩

theorem row_58_170 : RowResult ⟨58, by decide⟩ ⟨170, by decide⟩ := by
  have _previous := row_58_169
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨58, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) 1 2 7)

theorem row_58_171 : RowResult ⟨58, by decide⟩ ⟨171, by decide⟩ := by
  have _previous := row_58_170
  exact Or.inr ⟨orbitCodeOfNumber ⟨36, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_58_172 : RowResult ⟨58, by decide⟩ ⟨172, by decide⟩ := by
  have _previous := row_58_171
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩,
    orbitCodeOfNumber ⟨246, by decide⟩, by decide⟩

theorem row_58_173 : RowResult ⟨58, by decide⟩ ⟨173, by decide⟩ := by
  have _previous := row_58_172
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨58, by decide⟩) (orbitCodeOfNumber ⟨173, by decide⟩) 1 4 7)

end RelativeConicArcs.Q25PairCertificate
