import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_163_164 : RowResult ⟨163, by decide⟩ ⟨164, by decide⟩ := by
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨163, by decide⟩) (orbitCodeOfNumber ⟨164, by decide⟩) 0 4 6)

theorem row_163_165 : RowResult ⟨163, by decide⟩ ⟨165, by decide⟩ := by
  have _previous := row_163_164
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨163, by decide⟩) (orbitCodeOfNumber ⟨165, by decide⟩) 0 4 6)

theorem row_163_166 : RowResult ⟨163, by decide⟩ ⟨166, by decide⟩ := by
  have _previous := row_163_165
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨163, by decide⟩) (orbitCodeOfNumber ⟨166, by decide⟩) 0 4 6)

theorem row_163_167 : RowResult ⟨163, by decide⟩ ⟨167, by decide⟩ := by
  have _previous := row_163_166
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨163, by decide⟩) (orbitCodeOfNumber ⟨167, by decide⟩) 0 4 6)

theorem row_163_168 : RowResult ⟨163, by decide⟩ ⟨168, by decide⟩ := by
  have _previous := row_163_167
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨163, by decide⟩) (orbitCodeOfNumber ⟨168, by decide⟩) 0 4 6)

theorem row_163_169 : RowResult ⟨163, by decide⟩ ⟨169, by decide⟩ := by
  have _previous := row_163_168
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨163, by decide⟩) (orbitCodeOfNumber ⟨169, by decide⟩) 0 4 6)

theorem row_163_170 : RowResult ⟨163, by decide⟩ ⟨170, by decide⟩ := by
  have _previous := row_163_169
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨163, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) 0 4 6)

theorem row_163_171 : RowResult ⟨163, by decide⟩ ⟨171, by decide⟩ := by
  have _previous := row_163_170
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨163, by decide⟩) (orbitCodeOfNumber ⟨171, by decide⟩) 0 4 6)

theorem row_163_172 : RowResult ⟨163, by decide⟩ ⟨172, by decide⟩ := by
  have _previous := row_163_171
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨163, by decide⟩) (orbitCodeOfNumber ⟨172, by decide⟩) 0 4 6)

theorem row_163_173 : RowResult ⟨163, by decide⟩ ⟨173, by decide⟩ := by
  have _previous := row_163_172
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨163, by decide⟩) (orbitCodeOfNumber ⟨173, by decide⟩) 0 4 6)

theorem row_163_174 : RowResult ⟨163, by decide⟩ ⟨174, by decide⟩ := by
  have _previous := row_163_173
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨163, by decide⟩) (orbitCodeOfNumber ⟨174, by decide⟩) 0 4 6)

theorem row_163_175 : RowResult ⟨163, by decide⟩ ⟨175, by decide⟩ := by
  have _previous := row_163_174
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨163, by decide⟩) (orbitCodeOfNumber ⟨175, by decide⟩) 1 6 7)

theorem row_163_176 : RowResult ⟨163, by decide⟩ ⟨176, by decide⟩ := by
  have _previous := row_163_175
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨163, by decide⟩) (orbitCodeOfNumber ⟨176, by decide⟩) 1 6 7)

theorem row_163_177 : RowResult ⟨163, by decide⟩ ⟨177, by decide⟩ := by
  have _previous := row_163_176
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨163, by decide⟩) (orbitCodeOfNumber ⟨177, by decide⟩) 1 6 7)

theorem row_163_178 : RowResult ⟨163, by decide⟩ ⟨178, by decide⟩ := by
  have _previous := row_163_177
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨163, by decide⟩) (orbitCodeOfNumber ⟨178, by decide⟩) 1 6 7)

theorem row_163_179 : RowResult ⟨163, by decide⟩ ⟨179, by decide⟩ := by
  have _previous := row_163_178
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨163, by decide⟩) (orbitCodeOfNumber ⟨179, by decide⟩) 1 6 7)

theorem row_163_180 : RowResult ⟨163, by decide⟩ ⟨180, by decide⟩ := by
  have _previous := row_163_179
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨163, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) 1 2 6)

theorem row_163_181 : RowResult ⟨163, by decide⟩ ⟨181, by decide⟩ := by
  have _previous := row_163_180
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨163, by decide⟩) (orbitCodeOfNumber ⟨181, by decide⟩) 2 4 7)

theorem row_163_182 : RowResult ⟨163, by decide⟩ ⟨182, by decide⟩ := by
  have _previous := row_163_181
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_163_183 : RowResult ⟨163, by decide⟩ ⟨183, by decide⟩ := by
  have _previous := row_163_182
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_163_184 : RowResult ⟨163, by decide⟩ ⟨184, by decide⟩ := by
  have _previous := row_163_183
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨246, by decide⟩, by decide⟩

theorem row_163_185 : RowResult ⟨163, by decide⟩ ⟨185, by decide⟩ := by
  have _previous := row_163_184
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_163_186 : RowResult ⟨163, by decide⟩ ⟨186, by decide⟩ := by
  have _previous := row_163_185
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_163_187 : RowResult ⟨163, by decide⟩ ⟨187, by decide⟩ := by
  have _previous := row_163_186
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_163_188 : RowResult ⟨163, by decide⟩ ⟨188, by decide⟩ := by
  have _previous := row_163_187
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨163, by decide⟩) (orbitCodeOfNumber ⟨188, by decide⟩) 1 4 6)

end RelativeConicArcs.Q25PairCertificate
