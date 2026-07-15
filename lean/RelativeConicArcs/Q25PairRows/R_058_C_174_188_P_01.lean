import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_58_174 : RowResult ⟨58, by decide⟩ ⟨174, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨238, by decide⟩, by decide⟩

theorem row_58_175 : RowResult ⟨58, by decide⟩ ⟨175, by decide⟩ := by
  have _previous := row_58_174
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨58, by decide⟩) (orbitCodeOfNumber ⟨175, by decide⟩) 1 6 7)

theorem row_58_176 : RowResult ⟨58, by decide⟩ ⟨176, by decide⟩ := by
  have _previous := row_58_175
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨58, by decide⟩) (orbitCodeOfNumber ⟨176, by decide⟩) 1 6 7)

theorem row_58_177 : RowResult ⟨58, by decide⟩ ⟨177, by decide⟩ := by
  have _previous := row_58_176
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨58, by decide⟩) (orbitCodeOfNumber ⟨177, by decide⟩) 1 6 7)

theorem row_58_178 : RowResult ⟨58, by decide⟩ ⟨178, by decide⟩ := by
  have _previous := row_58_177
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨58, by decide⟩) (orbitCodeOfNumber ⟨178, by decide⟩) 1 6 7)

theorem row_58_179 : RowResult ⟨58, by decide⟩ ⟨179, by decide⟩ := by
  have _previous := row_58_178
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨58, by decide⟩) (orbitCodeOfNumber ⟨179, by decide⟩) 1 6 7)

theorem row_58_180 : RowResult ⟨58, by decide⟩ ⟨180, by decide⟩ := by
  have _previous := row_58_179
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨58, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) 1 2 6)

theorem row_58_181 : RowResult ⟨58, by decide⟩ ⟨181, by decide⟩ := by
  have _previous := row_58_180
  exact Or.inr ⟨orbitCodeOfNumber ⟨36, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_58_182 : RowResult ⟨58, by decide⟩ ⟨182, by decide⟩ := by
  have _previous := row_58_181
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_58_183 : RowResult ⟨58, by decide⟩ ⟨183, by decide⟩ := by
  have _previous := row_58_182
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨58, by decide⟩) (orbitCodeOfNumber ⟨183, by decide⟩) 1 4 6)

theorem row_58_184 : RowResult ⟨58, by decide⟩ ⟨184, by decide⟩ := by
  have _previous := row_58_183
  exact Or.inr ⟨orbitCodeOfNumber ⟨38, by decide⟩,
    orbitCodeOfNumber ⟨246, by decide⟩, by decide⟩

theorem row_58_185 : RowResult ⟨58, by decide⟩ ⟨185, by decide⟩ := by
  have _previous := row_58_184
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨58, by decide⟩) (orbitCodeOfNumber ⟨185, by decide⟩) 4 5 6)

theorem row_58_186 : RowResult ⟨58, by decide⟩ ⟨186, by decide⟩ := by
  have _previous := row_58_185
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨240, by decide⟩, by decide⟩

theorem row_58_187 : RowResult ⟨58, by decide⟩ ⟨187, by decide⟩ := by
  have _previous := row_58_186
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_58_188 : RowResult ⟨58, by decide⟩ ⟨188, by decide⟩ := by
  have _previous := row_58_187
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨58, by decide⟩) (orbitCodeOfNumber ⟨188, by decide⟩) 2 3 6)

end RelativeConicArcs.Q25PairCertificate
