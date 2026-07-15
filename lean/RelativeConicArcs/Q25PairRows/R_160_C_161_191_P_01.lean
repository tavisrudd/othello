import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_160_161 : RowResult ⟨160, by decide⟩ ⟨161, by decide⟩ := by
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨160, by decide⟩) (orbitCodeOfNumber ⟨161, by decide⟩) 0 4 6)

theorem row_160_162 : RowResult ⟨160, by decide⟩ ⟨162, by decide⟩ := by
  have _previous := row_160_161
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨160, by decide⟩) (orbitCodeOfNumber ⟨162, by decide⟩) 0 4 6)

theorem row_160_163 : RowResult ⟨160, by decide⟩ ⟨163, by decide⟩ := by
  have _previous := row_160_162
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨160, by decide⟩) (orbitCodeOfNumber ⟨163, by decide⟩) 0 4 6)

theorem row_160_164 : RowResult ⟨160, by decide⟩ ⟨164, by decide⟩ := by
  have _previous := row_160_163
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨160, by decide⟩) (orbitCodeOfNumber ⟨164, by decide⟩) 0 4 6)

theorem row_160_165 : RowResult ⟨160, by decide⟩ ⟨165, by decide⟩ := by
  have _previous := row_160_164
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨160, by decide⟩) (orbitCodeOfNumber ⟨165, by decide⟩) 0 4 6)

theorem row_160_166 : RowResult ⟨160, by decide⟩ ⟨166, by decide⟩ := by
  have _previous := row_160_165
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨160, by decide⟩) (orbitCodeOfNumber ⟨166, by decide⟩) 0 4 6)

theorem row_160_167 : RowResult ⟨160, by decide⟩ ⟨167, by decide⟩ := by
  have _previous := row_160_166
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨160, by decide⟩) (orbitCodeOfNumber ⟨167, by decide⟩) 0 4 6)

theorem row_160_168 : RowResult ⟨160, by decide⟩ ⟨168, by decide⟩ := by
  have _previous := row_160_167
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨160, by decide⟩) (orbitCodeOfNumber ⟨168, by decide⟩) 0 4 6)

theorem row_160_169 : RowResult ⟨160, by decide⟩ ⟨169, by decide⟩ := by
  have _previous := row_160_168
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨160, by decide⟩) (orbitCodeOfNumber ⟨169, by decide⟩) 0 4 6)

theorem row_160_170 : RowResult ⟨160, by decide⟩ ⟨170, by decide⟩ := by
  have _previous := row_160_169
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨160, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) 0 4 6)

theorem row_160_171 : RowResult ⟨160, by decide⟩ ⟨171, by decide⟩ := by
  have _previous := row_160_170
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨160, by decide⟩) (orbitCodeOfNumber ⟨171, by decide⟩) 0 4 6)

theorem row_160_172 : RowResult ⟨160, by decide⟩ ⟨172, by decide⟩ := by
  have _previous := row_160_171
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨160, by decide⟩) (orbitCodeOfNumber ⟨172, by decide⟩) 0 4 6)

theorem row_160_173 : RowResult ⟨160, by decide⟩ ⟨173, by decide⟩ := by
  have _previous := row_160_172
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨160, by decide⟩) (orbitCodeOfNumber ⟨173, by decide⟩) 0 4 6)

theorem row_160_174 : RowResult ⟨160, by decide⟩ ⟨174, by decide⟩ := by
  have _previous := row_160_173
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨160, by decide⟩) (orbitCodeOfNumber ⟨174, by decide⟩) 0 4 6)

theorem row_160_175 : RowResult ⟨160, by decide⟩ ⟨175, by decide⟩ := by
  have _previous := row_160_174
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨160, by decide⟩) (orbitCodeOfNumber ⟨175, by decide⟩) 1 6 7)

theorem row_160_176 : RowResult ⟨160, by decide⟩ ⟨176, by decide⟩ := by
  have _previous := row_160_175
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨160, by decide⟩) (orbitCodeOfNumber ⟨176, by decide⟩) 1 6 7)

theorem row_160_177 : RowResult ⟨160, by decide⟩ ⟨177, by decide⟩ := by
  have _previous := row_160_176
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨160, by decide⟩) (orbitCodeOfNumber ⟨177, by decide⟩) 1 6 7)

theorem row_160_178 : RowResult ⟨160, by decide⟩ ⟨178, by decide⟩ := by
  have _previous := row_160_177
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨160, by decide⟩) (orbitCodeOfNumber ⟨178, by decide⟩) 1 6 7)

theorem row_160_179 : RowResult ⟨160, by decide⟩ ⟨179, by decide⟩ := by
  have _previous := row_160_178
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨160, by decide⟩) (orbitCodeOfNumber ⟨179, by decide⟩) 1 6 7)

theorem row_160_180 : RowResult ⟨160, by decide⟩ ⟨180, by decide⟩ := by
  have _previous := row_160_179
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨160, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) 1 2 6)

theorem row_160_181 : RowResult ⟨160, by decide⟩ ⟨181, by decide⟩ := by
  have _previous := row_160_180
  exact Or.inr ⟨orbitCodeOfNumber ⟨36, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_160_182 : RowResult ⟨160, by decide⟩ ⟨182, by decide⟩ := by
  have _previous := row_160_181
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨242, by decide⟩, by decide⟩

theorem row_160_183 : RowResult ⟨160, by decide⟩ ⟨183, by decide⟩ := by
  have _previous := row_160_182
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨243, by decide⟩, by decide⟩

theorem row_160_184 : RowResult ⟨160, by decide⟩ ⟨184, by decide⟩ := by
  have _previous := row_160_183
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨241, by decide⟩, by decide⟩

theorem row_160_185 : RowResult ⟨160, by decide⟩ ⟨185, by decide⟩ := by
  have _previous := row_160_184
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨160, by decide⟩) (orbitCodeOfNumber ⟨185, by decide⟩) 1 4 6)

theorem row_160_186 : RowResult ⟨160, by decide⟩ ⟨186, by decide⟩ := by
  have _previous := row_160_185
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨160, by decide⟩) (orbitCodeOfNumber ⟨186, by decide⟩) 2 5 6)

theorem row_160_187 : RowResult ⟨160, by decide⟩ ⟨187, by decide⟩ := by
  have _previous := row_160_186
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_160_188 : RowResult ⟨160, by decide⟩ ⟨188, by decide⟩ := by
  have _previous := row_160_187
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨160, by decide⟩) (orbitCodeOfNumber ⟨188, by decide⟩) 2 3 6)

theorem row_160_189 : RowResult ⟨160, by decide⟩ ⟨189, by decide⟩ := by
  have _previous := row_160_188
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨160, by decide⟩) (orbitCodeOfNumber ⟨189, by decide⟩) 2 4 6)

theorem row_160_190 : RowResult ⟨160, by decide⟩ ⟨190, by decide⟩ := by
  have _previous := row_160_189
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨160, by decide⟩) (orbitCodeOfNumber ⟨190, by decide⟩) 1 4 7)

theorem row_160_191 : RowResult ⟨160, by decide⟩ ⟨191, by decide⟩ := by
  have _previous := row_160_190
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨242, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
