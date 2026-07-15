import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_167_168 : RowResult ⟨167, by decide⟩ ⟨168, by decide⟩ := by
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨167, by decide⟩) (orbitCodeOfNumber ⟨168, by decide⟩) 0 4 6)

theorem row_167_169 : RowResult ⟨167, by decide⟩ ⟨169, by decide⟩ := by
  have _previous := row_167_168
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨167, by decide⟩) (orbitCodeOfNumber ⟨169, by decide⟩) 0 4 6)

theorem row_167_170 : RowResult ⟨167, by decide⟩ ⟨170, by decide⟩ := by
  have _previous := row_167_169
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨167, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) 0 4 6)

theorem row_167_171 : RowResult ⟨167, by decide⟩ ⟨171, by decide⟩ := by
  have _previous := row_167_170
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨167, by decide⟩) (orbitCodeOfNumber ⟨171, by decide⟩) 0 4 6)

theorem row_167_172 : RowResult ⟨167, by decide⟩ ⟨172, by decide⟩ := by
  have _previous := row_167_171
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨167, by decide⟩) (orbitCodeOfNumber ⟨172, by decide⟩) 0 4 6)

theorem row_167_173 : RowResult ⟨167, by decide⟩ ⟨173, by decide⟩ := by
  have _previous := row_167_172
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨167, by decide⟩) (orbitCodeOfNumber ⟨173, by decide⟩) 0 4 6)

theorem row_167_174 : RowResult ⟨167, by decide⟩ ⟨174, by decide⟩ := by
  have _previous := row_167_173
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨167, by decide⟩) (orbitCodeOfNumber ⟨174, by decide⟩) 0 4 6)

theorem row_167_175 : RowResult ⟨167, by decide⟩ ⟨175, by decide⟩ := by
  have _previous := row_167_174
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨167, by decide⟩) (orbitCodeOfNumber ⟨175, by decide⟩) 1 6 7)

theorem row_167_176 : RowResult ⟨167, by decide⟩ ⟨176, by decide⟩ := by
  have _previous := row_167_175
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨167, by decide⟩) (orbitCodeOfNumber ⟨176, by decide⟩) 1 6 7)

theorem row_167_177 : RowResult ⟨167, by decide⟩ ⟨177, by decide⟩ := by
  have _previous := row_167_176
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨167, by decide⟩) (orbitCodeOfNumber ⟨177, by decide⟩) 1 6 7)

theorem row_167_178 : RowResult ⟨167, by decide⟩ ⟨178, by decide⟩ := by
  have _previous := row_167_177
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨167, by decide⟩) (orbitCodeOfNumber ⟨178, by decide⟩) 1 6 7)

theorem row_167_179 : RowResult ⟨167, by decide⟩ ⟨179, by decide⟩ := by
  have _previous := row_167_178
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨167, by decide⟩) (orbitCodeOfNumber ⟨179, by decide⟩) 1 6 7)

theorem row_167_180 : RowResult ⟨167, by decide⟩ ⟨180, by decide⟩ := by
  have _previous := row_167_179
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨167, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) 1 2 6)

theorem row_167_181 : RowResult ⟨167, by decide⟩ ⟨181, by decide⟩ := by
  have _previous := row_167_180
  exact Or.inr ⟨orbitCodeOfNumber ⟨41, by decide⟩,
    orbitCodeOfNumber ⟨243, by decide⟩, by decide⟩

theorem row_167_182 : RowResult ⟨167, by decide⟩ ⟨182, by decide⟩ := by
  have _previous := row_167_181
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨167, by decide⟩) (orbitCodeOfNumber ⟨182, by decide⟩) 4 5 6)

theorem row_167_183 : RowResult ⟨167, by decide⟩ ⟨183, by decide⟩ := by
  have _previous := row_167_182
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_167_184 : RowResult ⟨167, by decide⟩ ⟨184, by decide⟩ := by
  have _previous := row_167_183
  exact Or.inr ⟨orbitCodeOfNumber ⟨38, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_167_185 : RowResult ⟨167, by decide⟩ ⟨185, by decide⟩ := by
  have _previous := row_167_184
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨167, by decide⟩) (orbitCodeOfNumber ⟨185, by decide⟩) 2 4 6)

theorem row_167_186 : RowResult ⟨167, by decide⟩ ⟨186, by decide⟩ := by
  have _previous := row_167_185
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_167_187 : RowResult ⟨167, by decide⟩ ⟨187, by decide⟩ := by
  have _previous := row_167_186
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨167, by decide⟩) (orbitCodeOfNumber ⟨187, by decide⟩) 1 4 7)

theorem row_167_188 : RowResult ⟨167, by decide⟩ ⟨188, by decide⟩ := by
  have _previous := row_167_187
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨167, by decide⟩) (orbitCodeOfNumber ⟨188, by decide⟩) 2 3 6)

theorem row_167_189 : RowResult ⟨167, by decide⟩ ⟨189, by decide⟩ := by
  have _previous := row_167_188
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨167, by decide⟩) (orbitCodeOfNumber ⟨189, by decide⟩) 2 5 6)

theorem row_167_190 : RowResult ⟨167, by decide⟩ ⟨190, by decide⟩ := by
  have _previous := row_167_189
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_167_191 : RowResult ⟨167, by decide⟩ ⟨191, by decide⟩ := by
  have _previous := row_167_190
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_167_192 : RowResult ⟨167, by decide⟩ ⟨192, by decide⟩ := by
  have _previous := row_167_191
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨167, by decide⟩) (orbitCodeOfNumber ⟨192, by decide⟩) 1 4 6)

theorem row_167_193 : RowResult ⟨167, by decide⟩ ⟨193, by decide⟩ := by
  have _previous := row_167_192
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨167, by decide⟩) (orbitCodeOfNumber ⟨193, by decide⟩) 2 5 7)

end RelativeConicArcs.Q25PairCertificate
