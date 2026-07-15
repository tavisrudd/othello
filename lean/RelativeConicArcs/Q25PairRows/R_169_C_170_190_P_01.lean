import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_169_170 : RowResult ⟨169, by decide⟩ ⟨170, by decide⟩ := by
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨169, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) 0 4 6)

theorem row_169_171 : RowResult ⟨169, by decide⟩ ⟨171, by decide⟩ := by
  have _previous := row_169_170
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨169, by decide⟩) (orbitCodeOfNumber ⟨171, by decide⟩) 0 4 6)

theorem row_169_172 : RowResult ⟨169, by decide⟩ ⟨172, by decide⟩ := by
  have _previous := row_169_171
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨169, by decide⟩) (orbitCodeOfNumber ⟨172, by decide⟩) 0 4 6)

theorem row_169_173 : RowResult ⟨169, by decide⟩ ⟨173, by decide⟩ := by
  have _previous := row_169_172
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨169, by decide⟩) (orbitCodeOfNumber ⟨173, by decide⟩) 0 4 6)

theorem row_169_174 : RowResult ⟨169, by decide⟩ ⟨174, by decide⟩ := by
  have _previous := row_169_173
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨169, by decide⟩) (orbitCodeOfNumber ⟨174, by decide⟩) 0 4 6)

theorem row_169_175 : RowResult ⟨169, by decide⟩ ⟨175, by decide⟩ := by
  have _previous := row_169_174
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨169, by decide⟩) (orbitCodeOfNumber ⟨175, by decide⟩) 1 6 7)

theorem row_169_176 : RowResult ⟨169, by decide⟩ ⟨176, by decide⟩ := by
  have _previous := row_169_175
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨169, by decide⟩) (orbitCodeOfNumber ⟨176, by decide⟩) 1 6 7)

theorem row_169_177 : RowResult ⟨169, by decide⟩ ⟨177, by decide⟩ := by
  have _previous := row_169_176
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨169, by decide⟩) (orbitCodeOfNumber ⟨177, by decide⟩) 1 6 7)

theorem row_169_178 : RowResult ⟨169, by decide⟩ ⟨178, by decide⟩ := by
  have _previous := row_169_177
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨169, by decide⟩) (orbitCodeOfNumber ⟨178, by decide⟩) 1 6 7)

theorem row_169_179 : RowResult ⟨169, by decide⟩ ⟨179, by decide⟩ := by
  have _previous := row_169_178
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨169, by decide⟩) (orbitCodeOfNumber ⟨179, by decide⟩) 1 6 7)

theorem row_169_180 : RowResult ⟨169, by decide⟩ ⟨180, by decide⟩ := by
  have _previous := row_169_179
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨169, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) 1 2 6)

theorem row_169_181 : RowResult ⟨169, by decide⟩ ⟨181, by decide⟩ := by
  have _previous := row_169_180
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_169_182 : RowResult ⟨169, by decide⟩ ⟨182, by decide⟩ := by
  have _previous := row_169_181
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨169, by decide⟩) (orbitCodeOfNumber ⟨182, by decide⟩) 2 4 6)

theorem row_169_183 : RowResult ⟨169, by decide⟩ ⟨183, by decide⟩ := by
  have _previous := row_169_182
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_169_184 : RowResult ⟨169, by decide⟩ ⟨184, by decide⟩ := by
  have _previous := row_169_183
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨169, by decide⟩) (orbitCodeOfNumber ⟨184, by decide⟩) 4 5 6)

theorem row_169_185 : RowResult ⟨169, by decide⟩ ⟨185, by decide⟩ := by
  have _previous := row_169_184
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_169_186 : RowResult ⟨169, by decide⟩ ⟨186, by decide⟩ := by
  have _previous := row_169_185
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_169_187 : RowResult ⟨169, by decide⟩ ⟨187, by decide⟩ := by
  have _previous := row_169_186
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_169_188 : RowResult ⟨169, by decide⟩ ⟨188, by decide⟩ := by
  have _previous := row_169_187
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨169, by decide⟩) (orbitCodeOfNumber ⟨188, by decide⟩) 2 3 6)

theorem row_169_189 : RowResult ⟨169, by decide⟩ ⟨189, by decide⟩ := by
  have _previous := row_169_188
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨169, by decide⟩) (orbitCodeOfNumber ⟨189, by decide⟩) 1 4 7)

theorem row_169_190 : RowResult ⟨169, by decide⟩ ⟨190, by decide⟩ := by
  have _previous := row_169_189
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
