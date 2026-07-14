import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_32_169 : RowResult ⟨32, by decide⟩ ⟨169, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_32_170 : RowResult ⟨32, by decide⟩ ⟨170, by decide⟩ := by
  have _previous := row_32_169
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨32, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) 1 2 7)

theorem row_32_171 : RowResult ⟨32, by decide⟩ ⟨171, by decide⟩ := by
  have _previous := row_32_170
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_32_172 : RowResult ⟨32, by decide⟩ ⟨172, by decide⟩ := by
  have _previous := row_32_171
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨32, by decide⟩) (orbitCodeOfNumber ⟨172, by decide⟩) 1 4 7)

theorem row_32_173 : RowResult ⟨32, by decide⟩ ⟨173, by decide⟩ := by
  have _previous := row_32_172
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_32_174 : RowResult ⟨32, by decide⟩ ⟨174, by decide⟩ := by
  have _previous := row_32_173
  exact Or.inr ⟨orbitCodeOfNumber ⟨231, by decide⟩, by decide⟩

theorem row_32_175 : RowResult ⟨32, by decide⟩ ⟨175, by decide⟩ := by
  have _previous := row_32_174
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨32, by decide⟩) (orbitCodeOfNumber ⟨175, by decide⟩) 1 6 7)

theorem row_32_176 : RowResult ⟨32, by decide⟩ ⟨176, by decide⟩ := by
  have _previous := row_32_175
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨32, by decide⟩) (orbitCodeOfNumber ⟨176, by decide⟩) 1 6 7)

theorem row_32_177 : RowResult ⟨32, by decide⟩ ⟨177, by decide⟩ := by
  have _previous := row_32_176
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨32, by decide⟩) (orbitCodeOfNumber ⟨177, by decide⟩) 1 6 7)

theorem row_32_178 : RowResult ⟨32, by decide⟩ ⟨178, by decide⟩ := by
  have _previous := row_32_177
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨32, by decide⟩) (orbitCodeOfNumber ⟨178, by decide⟩) 1 6 7)

theorem row_32_179 : RowResult ⟨32, by decide⟩ ⟨179, by decide⟩ := by
  have _previous := row_32_178
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨32, by decide⟩) (orbitCodeOfNumber ⟨179, by decide⟩) 1 6 7)

theorem row_32_180 : RowResult ⟨32, by decide⟩ ⟨180, by decide⟩ := by
  have _previous := row_32_179
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨32, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) 1 2 6)

theorem row_32_181 : RowResult ⟨32, by decide⟩ ⟨181, by decide⟩ := by
  have _previous := row_32_180
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨32, by decide⟩) (orbitCodeOfNumber ⟨181, by decide⟩) 4 5 6)

theorem row_32_182 : RowResult ⟨32, by decide⟩ ⟨182, by decide⟩ := by
  have _previous := row_32_181
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨32, by decide⟩) (orbitCodeOfNumber ⟨182, by decide⟩) 1 4 6)

theorem row_32_183 : RowResult ⟨32, by decide⟩ ⟨183, by decide⟩ := by
  have _previous := row_32_182
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_32_184 : RowResult ⟨32, by decide⟩ ⟨184, by decide⟩ := by
  have _previous := row_32_183
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨32, by decide⟩) (orbitCodeOfNumber ⟨184, by decide⟩) 2 4 7)

theorem row_32_185 : RowResult ⟨32, by decide⟩ ⟨185, by decide⟩ := by
  have _previous := row_32_184
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
