import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_72_173 : RowResult ⟨72, by decide⟩ ⟨173, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_72_174 : RowResult ⟨72, by decide⟩ ⟨174, by decide⟩ := by
  have _previous := row_72_173
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨72, by decide⟩) (orbitCodeOfNumber ⟨174, by decide⟩) 2 4 7)

theorem row_72_175 : RowResult ⟨72, by decide⟩ ⟨175, by decide⟩ := by
  have _previous := row_72_174
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨72, by decide⟩) (orbitCodeOfNumber ⟨175, by decide⟩) 1 6 7)

theorem row_72_176 : RowResult ⟨72, by decide⟩ ⟨176, by decide⟩ := by
  have _previous := row_72_175
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨72, by decide⟩) (orbitCodeOfNumber ⟨176, by decide⟩) 1 6 7)

theorem row_72_177 : RowResult ⟨72, by decide⟩ ⟨177, by decide⟩ := by
  have _previous := row_72_176
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨72, by decide⟩) (orbitCodeOfNumber ⟨177, by decide⟩) 1 6 7)

theorem row_72_178 : RowResult ⟨72, by decide⟩ ⟨178, by decide⟩ := by
  have _previous := row_72_177
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨72, by decide⟩) (orbitCodeOfNumber ⟨178, by decide⟩) 1 6 7)

theorem row_72_179 : RowResult ⟨72, by decide⟩ ⟨179, by decide⟩ := by
  have _previous := row_72_178
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨72, by decide⟩) (orbitCodeOfNumber ⟨179, by decide⟩) 1 6 7)

theorem row_72_180 : RowResult ⟨72, by decide⟩ ⟨180, by decide⟩ := by
  have _previous := row_72_179
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨72, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) 1 2 6)

theorem row_72_181 : RowResult ⟨72, by decide⟩ ⟨181, by decide⟩ := by
  have _previous := row_72_180
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨243, by decide⟩, by decide⟩

theorem row_72_182 : RowResult ⟨72, by decide⟩ ⟨182, by decide⟩ := by
  have _previous := row_72_181
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨72, by decide⟩) (orbitCodeOfNumber ⟨182, by decide⟩) 1 4 7)

theorem row_72_183 : RowResult ⟨72, by decide⟩ ⟨183, by decide⟩ := by
  have _previous := row_72_182
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨72, by decide⟩) (orbitCodeOfNumber ⟨183, by decide⟩) 2 4 7)

theorem row_72_184 : RowResult ⟨72, by decide⟩ ⟨184, by decide⟩ := by
  have _previous := row_72_183
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨246, by decide⟩, by decide⟩

theorem row_72_185 : RowResult ⟨72, by decide⟩ ⟨185, by decide⟩ := by
  have _previous := row_72_184
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_72_186 : RowResult ⟨72, by decide⟩ ⟨186, by decide⟩ := by
  have _previous := row_72_185
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_72_187 : RowResult ⟨72, by decide⟩ ⟨187, by decide⟩ := by
  have _previous := row_72_186
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨72, by decide⟩) (orbitCodeOfNumber ⟨187, by decide⟩) 2 4 6)

theorem row_72_188 : RowResult ⟨72, by decide⟩ ⟨188, by decide⟩ := by
  have _previous := row_72_187
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨72, by decide⟩) (orbitCodeOfNumber ⟨188, by decide⟩) 2 3 6)

theorem row_72_189 : RowResult ⟨72, by decide⟩ ⟨189, by decide⟩ := by
  have _previous := row_72_188
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨72, by decide⟩) (orbitCodeOfNumber ⟨189, by decide⟩) 2 5 7)

theorem row_72_190 : RowResult ⟨72, by decide⟩ ⟨190, by decide⟩ := by
  have _previous := row_72_189
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨72, by decide⟩) (orbitCodeOfNumber ⟨190, by decide⟩) 4 5 6)

theorem row_72_191 : RowResult ⟨72, by decide⟩ ⟨191, by decide⟩ := by
  have _previous := row_72_190
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
