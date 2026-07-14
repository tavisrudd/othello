import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_59_169 : RowResult ⟨59, by decide⟩ ⟨169, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_59_170 : RowResult ⟨59, by decide⟩ ⟨170, by decide⟩ := by
  have _previous := row_59_169
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨59, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) 1 2 7)

theorem row_59_171 : RowResult ⟨59, by decide⟩ ⟨171, by decide⟩ := by
  have _previous := row_59_170
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_59_172 : RowResult ⟨59, by decide⟩ ⟨172, by decide⟩ := by
  have _previous := row_59_171
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_59_173 : RowResult ⟨59, by decide⟩ ⟨173, by decide⟩ := by
  have _previous := row_59_172
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_59_174 : RowResult ⟨59, by decide⟩ ⟨174, by decide⟩ := by
  have _previous := row_59_173
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨59, by decide⟩) (orbitCodeOfNumber ⟨174, by decide⟩) 1 4 7)

theorem row_59_175 : RowResult ⟨59, by decide⟩ ⟨175, by decide⟩ := by
  have _previous := row_59_174
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨59, by decide⟩) (orbitCodeOfNumber ⟨175, by decide⟩) 1 6 7)

theorem row_59_176 : RowResult ⟨59, by decide⟩ ⟨176, by decide⟩ := by
  have _previous := row_59_175
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨59, by decide⟩) (orbitCodeOfNumber ⟨176, by decide⟩) 1 6 7)

theorem row_59_177 : RowResult ⟨59, by decide⟩ ⟨177, by decide⟩ := by
  have _previous := row_59_176
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨59, by decide⟩) (orbitCodeOfNumber ⟨177, by decide⟩) 1 6 7)

theorem row_59_178 : RowResult ⟨59, by decide⟩ ⟨178, by decide⟩ := by
  have _previous := row_59_177
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨59, by decide⟩) (orbitCodeOfNumber ⟨178, by decide⟩) 1 6 7)

theorem row_59_179 : RowResult ⟨59, by decide⟩ ⟨179, by decide⟩ := by
  have _previous := row_59_178
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨59, by decide⟩) (orbitCodeOfNumber ⟨179, by decide⟩) 1 6 7)

theorem row_59_180 : RowResult ⟨59, by decide⟩ ⟨180, by decide⟩ := by
  have _previous := row_59_179
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨59, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) 1 2 6)

theorem row_59_181 : RowResult ⟨59, by decide⟩ ⟨181, by decide⟩ := by
  have _previous := row_59_180
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_59_182 : RowResult ⟨59, by decide⟩ ⟨182, by decide⟩ := by
  have _previous := row_59_181
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨59, by decide⟩) (orbitCodeOfNumber ⟨182, by decide⟩) 2 4 7)

theorem row_59_183 : RowResult ⟨59, by decide⟩ ⟨183, by decide⟩ := by
  have _previous := row_59_182
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_59_184 : RowResult ⟨59, by decide⟩ ⟨184, by decide⟩ := by
  have _previous := row_59_183
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨59, by decide⟩) (orbitCodeOfNumber ⟨184, by decide⟩) 1 4 6)

end RelativeConicArcs.Q25PairCertificate
