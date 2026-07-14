import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_34_169 : RowResult ⟨34, by decide⟩ ⟨169, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_34_170 : RowResult ⟨34, by decide⟩ ⟨170, by decide⟩ := by
  have _previous := row_34_169
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨34, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) 1 2 7)

theorem row_34_171 : RowResult ⟨34, by decide⟩ ⟨171, by decide⟩ := by
  have _previous := row_34_170
  exact Or.inr ⟨orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

theorem row_34_172 : RowResult ⟨34, by decide⟩ ⟨172, by decide⟩ := by
  have _previous := row_34_171
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨34, by decide⟩) (orbitCodeOfNumber ⟨172, by decide⟩) 2 5 6)

theorem row_34_173 : RowResult ⟨34, by decide⟩ ⟨173, by decide⟩ := by
  have _previous := row_34_172
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨34, by decide⟩) (orbitCodeOfNumber ⟨173, by decide⟩) 2 5 7)

theorem row_34_174 : RowResult ⟨34, by decide⟩ ⟨174, by decide⟩ := by
  have _previous := row_34_173
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨34, by decide⟩) (orbitCodeOfNumber ⟨174, by decide⟩) 1 4 7)

theorem row_34_175 : RowResult ⟨34, by decide⟩ ⟨175, by decide⟩ := by
  have _previous := row_34_174
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨34, by decide⟩) (orbitCodeOfNumber ⟨175, by decide⟩) 1 6 7)

theorem row_34_176 : RowResult ⟨34, by decide⟩ ⟨176, by decide⟩ := by
  have _previous := row_34_175
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨34, by decide⟩) (orbitCodeOfNumber ⟨176, by decide⟩) 1 6 7)

theorem row_34_177 : RowResult ⟨34, by decide⟩ ⟨177, by decide⟩ := by
  have _previous := row_34_176
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨34, by decide⟩) (orbitCodeOfNumber ⟨177, by decide⟩) 1 6 7)

theorem row_34_178 : RowResult ⟨34, by decide⟩ ⟨178, by decide⟩ := by
  have _previous := row_34_177
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨34, by decide⟩) (orbitCodeOfNumber ⟨178, by decide⟩) 1 6 7)

theorem row_34_179 : RowResult ⟨34, by decide⟩ ⟨179, by decide⟩ := by
  have _previous := row_34_178
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨34, by decide⟩) (orbitCodeOfNumber ⟨179, by decide⟩) 1 6 7)

theorem row_34_180 : RowResult ⟨34, by decide⟩ ⟨180, by decide⟩ := by
  have _previous := row_34_179
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨34, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) 1 2 6)

theorem row_34_181 : RowResult ⟨34, by decide⟩ ⟨181, by decide⟩ := by
  have _previous := row_34_180
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_34_182 : RowResult ⟨34, by decide⟩ ⟨182, by decide⟩ := by
  have _previous := row_34_181
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_34_183 : RowResult ⟨34, by decide⟩ ⟨183, by decide⟩ := by
  have _previous := row_34_182
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨34, by decide⟩) (orbitCodeOfNumber ⟨183, by decide⟩) 4 5 6)

theorem row_34_184 : RowResult ⟨34, by decide⟩ ⟨184, by decide⟩ := by
  have _previous := row_34_183
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨34, by decide⟩) (orbitCodeOfNumber ⟨184, by decide⟩) 1 4 6)

theorem row_34_185 : RowResult ⟨34, by decide⟩ ⟨185, by decide⟩ := by
  have _previous := row_34_184
  exact Or.inr ⟨orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

theorem row_34_186 : RowResult ⟨34, by decide⟩ ⟨186, by decide⟩ := by
  have _previous := row_34_185
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
