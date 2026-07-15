import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_41_165 : RowResult ⟨41, by decide⟩ ⟨165, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨62, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_41_166 : RowResult ⟨41, by decide⟩ ⟨166, by decide⟩ := by
  have _previous := row_41_165
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨41, by decide⟩) (orbitCodeOfNumber ⟨166, by decide⟩) 1 4 6)

theorem row_41_167 : RowResult ⟨41, by decide⟩ ⟨167, by decide⟩ := by
  have _previous := row_41_166
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_41_168 : RowResult ⟨41, by decide⟩ ⟨168, by decide⟩ := by
  have _previous := row_41_167
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨41, by decide⟩) (orbitCodeOfNumber ⟨168, by decide⟩) 2 5 7)

theorem row_41_169 : RowResult ⟨41, by decide⟩ ⟨169, by decide⟩ := by
  have _previous := row_41_168
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨41, by decide⟩) (orbitCodeOfNumber ⟨169, by decide⟩) 2 5 6)

theorem row_41_170 : RowResult ⟨41, by decide⟩ ⟨170, by decide⟩ := by
  have _previous := row_41_169
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨41, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) 1 2 7)

theorem row_41_171 : RowResult ⟨41, by decide⟩ ⟨171, by decide⟩ := by
  have _previous := row_41_170
  exact Or.inr ⟨orbitCodeOfNumber ⟨64, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_41_172 : RowResult ⟨41, by decide⟩ ⟨172, by decide⟩ := by
  have _previous := row_41_171
  exact Or.inr ⟨orbitCodeOfNumber ⟨58, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_41_173 : RowResult ⟨41, by decide⟩ ⟨173, by decide⟩ := by
  have _previous := row_41_172
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨41, by decide⟩) (orbitCodeOfNumber ⟨173, by decide⟩) 4 5 6)

theorem row_41_174 : RowResult ⟨41, by decide⟩ ⟨174, by decide⟩ := by
  have _previous := row_41_173
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨41, by decide⟩) (orbitCodeOfNumber ⟨174, by decide⟩) 2 4 7)

theorem row_41_175 : RowResult ⟨41, by decide⟩ ⟨175, by decide⟩ := by
  have _previous := row_41_174
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨41, by decide⟩) (orbitCodeOfNumber ⟨175, by decide⟩) 1 6 7)

theorem row_41_176 : RowResult ⟨41, by decide⟩ ⟨176, by decide⟩ := by
  have _previous := row_41_175
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨41, by decide⟩) (orbitCodeOfNumber ⟨176, by decide⟩) 1 6 7)

theorem row_41_177 : RowResult ⟨41, by decide⟩ ⟨177, by decide⟩ := by
  have _previous := row_41_176
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨41, by decide⟩) (orbitCodeOfNumber ⟨177, by decide⟩) 1 6 7)

theorem row_41_178 : RowResult ⟨41, by decide⟩ ⟨178, by decide⟩ := by
  have _previous := row_41_177
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨41, by decide⟩) (orbitCodeOfNumber ⟨178, by decide⟩) 1 6 7)

theorem row_41_179 : RowResult ⟨41, by decide⟩ ⟨179, by decide⟩ := by
  have _previous := row_41_178
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨41, by decide⟩) (orbitCodeOfNumber ⟨179, by decide⟩) 1 6 7)

theorem row_41_180 : RowResult ⟨41, by decide⟩ ⟨180, by decide⟩ := by
  have _previous := row_41_179
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨41, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) 1 2 6)

theorem row_41_181 : RowResult ⟨41, by decide⟩ ⟨181, by decide⟩ := by
  have _previous := row_41_180
  exact Or.inr ⟨orbitCodeOfNumber ⟨58, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_41_182 : RowResult ⟨41, by decide⟩ ⟨182, by decide⟩ := by
  have _previous := row_41_181
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨41, by decide⟩) (orbitCodeOfNumber ⟨182, by decide⟩) 2 5 6)

theorem row_41_183 : RowResult ⟨41, by decide⟩ ⟨183, by decide⟩ := by
  have _previous := row_41_182
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨41, by decide⟩) (orbitCodeOfNumber ⟨183, by decide⟩) 2 4 7)

theorem row_41_184 : RowResult ⟨41, by decide⟩ ⟨184, by decide⟩ := by
  have _previous := row_41_183
  exact Or.inr ⟨orbitCodeOfNumber ⟨58, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
