import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_47_171 : RowResult ⟨47, by decide⟩ ⟨171, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_47_172 : RowResult ⟨47, by decide⟩ ⟨172, by decide⟩ := by
  have _previous := row_47_171
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨47, by decide⟩) (orbitCodeOfNumber ⟨172, by decide⟩) 1 4 6)

theorem row_47_173 : RowResult ⟨47, by decide⟩ ⟨173, by decide⟩ := by
  have _previous := row_47_172
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_47_174 : RowResult ⟨47, by decide⟩ ⟨174, by decide⟩ := by
  have _previous := row_47_173
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨47, by decide⟩) (orbitCodeOfNumber ⟨174, by decide⟩) 2 4 6)

theorem row_47_175 : RowResult ⟨47, by decide⟩ ⟨175, by decide⟩ := by
  have _previous := row_47_174
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨47, by decide⟩) (orbitCodeOfNumber ⟨175, by decide⟩) 1 6 7)

theorem row_47_176 : RowResult ⟨47, by decide⟩ ⟨176, by decide⟩ := by
  have _previous := row_47_175
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨47, by decide⟩) (orbitCodeOfNumber ⟨176, by decide⟩) 1 6 7)

theorem row_47_177 : RowResult ⟨47, by decide⟩ ⟨177, by decide⟩ := by
  have _previous := row_47_176
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨47, by decide⟩) (orbitCodeOfNumber ⟨177, by decide⟩) 1 6 7)

theorem row_47_178 : RowResult ⟨47, by decide⟩ ⟨178, by decide⟩ := by
  have _previous := row_47_177
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨47, by decide⟩) (orbitCodeOfNumber ⟨178, by decide⟩) 1 6 7)

theorem row_47_179 : RowResult ⟨47, by decide⟩ ⟨179, by decide⟩ := by
  have _previous := row_47_178
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨47, by decide⟩) (orbitCodeOfNumber ⟨179, by decide⟩) 1 6 7)

theorem row_47_180 : RowResult ⟨47, by decide⟩ ⟨180, by decide⟩ := by
  have _previous := row_47_179
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨47, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) 1 2 6)

theorem row_47_181 : RowResult ⟨47, by decide⟩ ⟨181, by decide⟩ := by
  have _previous := row_47_180
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_47_182 : RowResult ⟨47, by decide⟩ ⟨182, by decide⟩ := by
  have _previous := row_47_181
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨47, by decide⟩) (orbitCodeOfNumber ⟨182, by decide⟩) 1 4 7)

theorem row_47_183 : RowResult ⟨47, by decide⟩ ⟨183, by decide⟩ := by
  have _previous := row_47_182
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_47_184 : RowResult ⟨47, by decide⟩ ⟨184, by decide⟩ := by
  have _previous := row_47_183
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_47_185 : RowResult ⟨47, by decide⟩ ⟨185, by decide⟩ := by
  have _previous := row_47_184
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_47_186 : RowResult ⟨47, by decide⟩ ⟨186, by decide⟩ := by
  have _previous := row_47_185
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨47, by decide⟩) (orbitCodeOfNumber ⟨186, by decide⟩) 2 4 6)

end RelativeConicArcs.Q25PairCertificate
