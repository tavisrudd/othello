import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_171_172 : RowResult ⟨171, by decide⟩ ⟨172, by decide⟩ := by
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨171, by decide⟩) (orbitCodeOfNumber ⟨172, by decide⟩) 0 4 6)

theorem row_171_173 : RowResult ⟨171, by decide⟩ ⟨173, by decide⟩ := by
  have _previous := row_171_172
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨171, by decide⟩) (orbitCodeOfNumber ⟨173, by decide⟩) 0 4 6)

theorem row_171_174 : RowResult ⟨171, by decide⟩ ⟨174, by decide⟩ := by
  have _previous := row_171_173
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨171, by decide⟩) (orbitCodeOfNumber ⟨174, by decide⟩) 0 4 6)

theorem row_171_175 : RowResult ⟨171, by decide⟩ ⟨175, by decide⟩ := by
  have _previous := row_171_174
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨171, by decide⟩) (orbitCodeOfNumber ⟨175, by decide⟩) 1 6 7)

theorem row_171_176 : RowResult ⟨171, by decide⟩ ⟨176, by decide⟩ := by
  have _previous := row_171_175
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨171, by decide⟩) (orbitCodeOfNumber ⟨176, by decide⟩) 1 6 7)

theorem row_171_177 : RowResult ⟨171, by decide⟩ ⟨177, by decide⟩ := by
  have _previous := row_171_176
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨171, by decide⟩) (orbitCodeOfNumber ⟨177, by decide⟩) 1 6 7)

theorem row_171_178 : RowResult ⟨171, by decide⟩ ⟨178, by decide⟩ := by
  have _previous := row_171_177
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨171, by decide⟩) (orbitCodeOfNumber ⟨178, by decide⟩) 1 6 7)

theorem row_171_179 : RowResult ⟨171, by decide⟩ ⟨179, by decide⟩ := by
  have _previous := row_171_178
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨171, by decide⟩) (orbitCodeOfNumber ⟨179, by decide⟩) 1 6 7)

theorem row_171_180 : RowResult ⟨171, by decide⟩ ⟨180, by decide⟩ := by
  have _previous := row_171_179
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨171, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) 1 2 6)

theorem row_171_181 : RowResult ⟨171, by decide⟩ ⟨181, by decide⟩ := by
  have _previous := row_171_180
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨171, by decide⟩) (orbitCodeOfNumber ⟨181, by decide⟩) 1 4 7)

theorem row_171_182 : RowResult ⟨171, by decide⟩ ⟨182, by decide⟩ := by
  have _previous := row_171_181
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_171_183 : RowResult ⟨171, by decide⟩ ⟨183, by decide⟩ := by
  have _previous := row_171_182
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨171, by decide⟩) (orbitCodeOfNumber ⟨183, by decide⟩) 2 4 6)

theorem row_171_184 : RowResult ⟨171, by decide⟩ ⟨184, by decide⟩ := by
  have _previous := row_171_183
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_171_185 : RowResult ⟨171, by decide⟩ ⟨185, by decide⟩ := by
  have _previous := row_171_184
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨171, by decide⟩) (orbitCodeOfNumber ⟨185, by decide⟩) 2 4 7)

theorem row_171_186 : RowResult ⟨171, by decide⟩ ⟨186, by decide⟩ := by
  have _previous := row_171_185
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_171_187 : RowResult ⟨171, by decide⟩ ⟨187, by decide⟩ := by
  have _previous := row_171_186
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨171, by decide⟩) (orbitCodeOfNumber ⟨187, by decide⟩) 2 5 7)

theorem row_171_188 : RowResult ⟨171, by decide⟩ ⟨188, by decide⟩ := by
  have _previous := row_171_187
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨171, by decide⟩) (orbitCodeOfNumber ⟨188, by decide⟩) 2 3 6)

theorem row_171_189 : RowResult ⟨171, by decide⟩ ⟨189, by decide⟩ := by
  have _previous := row_171_188
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_171_190 : RowResult ⟨171, by decide⟩ ⟨190, by decide⟩ := by
  have _previous := row_171_189
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_171_191 : RowResult ⟨171, by decide⟩ ⟨191, by decide⟩ := by
  have _previous := row_171_190
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨171, by decide⟩) (orbitCodeOfNumber ⟨191, by decide⟩) 4 5 6)

theorem row_171_192 : RowResult ⟨171, by decide⟩ ⟨192, by decide⟩ := by
  have _previous := row_171_191
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
