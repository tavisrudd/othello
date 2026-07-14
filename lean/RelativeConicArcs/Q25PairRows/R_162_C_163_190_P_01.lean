import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_162_163 : RowResult ⟨162, by decide⟩ ⟨163, by decide⟩ := by
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨162, by decide⟩) (orbitCodeOfNumber ⟨163, by decide⟩) 0 4 6)

theorem row_162_164 : RowResult ⟨162, by decide⟩ ⟨164, by decide⟩ := by
  have _previous := row_162_163
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨162, by decide⟩) (orbitCodeOfNumber ⟨164, by decide⟩) 0 4 6)

theorem row_162_165 : RowResult ⟨162, by decide⟩ ⟨165, by decide⟩ := by
  have _previous := row_162_164
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨162, by decide⟩) (orbitCodeOfNumber ⟨165, by decide⟩) 0 4 6)

theorem row_162_166 : RowResult ⟨162, by decide⟩ ⟨166, by decide⟩ := by
  have _previous := row_162_165
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨162, by decide⟩) (orbitCodeOfNumber ⟨166, by decide⟩) 0 4 6)

theorem row_162_167 : RowResult ⟨162, by decide⟩ ⟨167, by decide⟩ := by
  have _previous := row_162_166
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨162, by decide⟩) (orbitCodeOfNumber ⟨167, by decide⟩) 0 4 6)

theorem row_162_168 : RowResult ⟨162, by decide⟩ ⟨168, by decide⟩ := by
  have _previous := row_162_167
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨162, by decide⟩) (orbitCodeOfNumber ⟨168, by decide⟩) 0 4 6)

theorem row_162_169 : RowResult ⟨162, by decide⟩ ⟨169, by decide⟩ := by
  have _previous := row_162_168
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨162, by decide⟩) (orbitCodeOfNumber ⟨169, by decide⟩) 0 4 6)

theorem row_162_170 : RowResult ⟨162, by decide⟩ ⟨170, by decide⟩ := by
  have _previous := row_162_169
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨162, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) 0 4 6)

theorem row_162_171 : RowResult ⟨162, by decide⟩ ⟨171, by decide⟩ := by
  have _previous := row_162_170
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨162, by decide⟩) (orbitCodeOfNumber ⟨171, by decide⟩) 0 4 6)

theorem row_162_172 : RowResult ⟨162, by decide⟩ ⟨172, by decide⟩ := by
  have _previous := row_162_171
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨162, by decide⟩) (orbitCodeOfNumber ⟨172, by decide⟩) 0 4 6)

theorem row_162_173 : RowResult ⟨162, by decide⟩ ⟨173, by decide⟩ := by
  have _previous := row_162_172
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨162, by decide⟩) (orbitCodeOfNumber ⟨173, by decide⟩) 0 4 6)

theorem row_162_174 : RowResult ⟨162, by decide⟩ ⟨174, by decide⟩ := by
  have _previous := row_162_173
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨162, by decide⟩) (orbitCodeOfNumber ⟨174, by decide⟩) 0 4 6)

theorem row_162_175 : RowResult ⟨162, by decide⟩ ⟨175, by decide⟩ := by
  have _previous := row_162_174
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨162, by decide⟩) (orbitCodeOfNumber ⟨175, by decide⟩) 1 6 7)

theorem row_162_176 : RowResult ⟨162, by decide⟩ ⟨176, by decide⟩ := by
  have _previous := row_162_175
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨162, by decide⟩) (orbitCodeOfNumber ⟨176, by decide⟩) 1 6 7)

theorem row_162_177 : RowResult ⟨162, by decide⟩ ⟨177, by decide⟩ := by
  have _previous := row_162_176
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨162, by decide⟩) (orbitCodeOfNumber ⟨177, by decide⟩) 1 6 7)

theorem row_162_178 : RowResult ⟨162, by decide⟩ ⟨178, by decide⟩ := by
  have _previous := row_162_177
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨162, by decide⟩) (orbitCodeOfNumber ⟨178, by decide⟩) 1 6 7)

theorem row_162_179 : RowResult ⟨162, by decide⟩ ⟨179, by decide⟩ := by
  have _previous := row_162_178
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨162, by decide⟩) (orbitCodeOfNumber ⟨179, by decide⟩) 1 6 7)

theorem row_162_180 : RowResult ⟨162, by decide⟩ ⟨180, by decide⟩ := by
  have _previous := row_162_179
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨162, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) 1 2 6)

theorem row_162_181 : RowResult ⟨162, by decide⟩ ⟨181, by decide⟩ := by
  have _previous := row_162_180
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨162, by decide⟩) (orbitCodeOfNumber ⟨181, by decide⟩) 2 4 6)

theorem row_162_182 : RowResult ⟨162, by decide⟩ ⟨182, by decide⟩ := by
  have _previous := row_162_181
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨162, by decide⟩) (orbitCodeOfNumber ⟨182, by decide⟩) 2 5 7)

theorem row_162_183 : RowResult ⟨162, by decide⟩ ⟨183, by decide⟩ := by
  have _previous := row_162_182
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_162_184 : RowResult ⟨162, by decide⟩ ⟨184, by decide⟩ := by
  have _previous := row_162_183
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_162_185 : RowResult ⟨162, by decide⟩ ⟨185, by decide⟩ := by
  have _previous := row_162_184
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_162_186 : RowResult ⟨162, by decide⟩ ⟨186, by decide⟩ := by
  have _previous := row_162_185
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_162_187 : RowResult ⟨162, by decide⟩ ⟨187, by decide⟩ := by
  have _previous := row_162_186
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨162, by decide⟩) (orbitCodeOfNumber ⟨187, by decide⟩) 1 4 6)

theorem row_162_188 : RowResult ⟨162, by decide⟩ ⟨188, by decide⟩ := by
  have _previous := row_162_187
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨162, by decide⟩) (orbitCodeOfNumber ⟨188, by decide⟩) 2 3 6)

theorem row_162_189 : RowResult ⟨162, by decide⟩ ⟨189, by decide⟩ := by
  have _previous := row_162_188
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_162_190 : RowResult ⟨162, by decide⟩ ⟨190, by decide⟩ := by
  have _previous := row_162_189
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
