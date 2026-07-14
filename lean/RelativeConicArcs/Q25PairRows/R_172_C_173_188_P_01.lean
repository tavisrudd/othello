import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_172_173 : RowResult ⟨172, by decide⟩ ⟨173, by decide⟩ := by
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨172, by decide⟩) (orbitCodeOfNumber ⟨173, by decide⟩) 0 4 6)

theorem row_172_174 : RowResult ⟨172, by decide⟩ ⟨174, by decide⟩ := by
  have _previous := row_172_173
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨172, by decide⟩) (orbitCodeOfNumber ⟨174, by decide⟩) 0 4 6)

theorem row_172_175 : RowResult ⟨172, by decide⟩ ⟨175, by decide⟩ := by
  have _previous := row_172_174
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨172, by decide⟩) (orbitCodeOfNumber ⟨175, by decide⟩) 1 6 7)

theorem row_172_176 : RowResult ⟨172, by decide⟩ ⟨176, by decide⟩ := by
  have _previous := row_172_175
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨172, by decide⟩) (orbitCodeOfNumber ⟨176, by decide⟩) 1 6 7)

theorem row_172_177 : RowResult ⟨172, by decide⟩ ⟨177, by decide⟩ := by
  have _previous := row_172_176
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨172, by decide⟩) (orbitCodeOfNumber ⟨177, by decide⟩) 1 6 7)

theorem row_172_178 : RowResult ⟨172, by decide⟩ ⟨178, by decide⟩ := by
  have _previous := row_172_177
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨172, by decide⟩) (orbitCodeOfNumber ⟨178, by decide⟩) 1 6 7)

theorem row_172_179 : RowResult ⟨172, by decide⟩ ⟨179, by decide⟩ := by
  have _previous := row_172_178
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨172, by decide⟩) (orbitCodeOfNumber ⟨179, by decide⟩) 1 6 7)

theorem row_172_180 : RowResult ⟨172, by decide⟩ ⟨180, by decide⟩ := by
  have _previous := row_172_179
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨172, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) 1 2 6)

theorem row_172_181 : RowResult ⟨172, by decide⟩ ⟨181, by decide⟩ := by
  have _previous := row_172_180
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_172_182 : RowResult ⟨172, by decide⟩ ⟨182, by decide⟩ := by
  have _previous := row_172_181
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨172, by decide⟩) (orbitCodeOfNumber ⟨182, by decide⟩) 1 4 7)

theorem row_172_183 : RowResult ⟨172, by decide⟩ ⟨183, by decide⟩ := by
  have _previous := row_172_182
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_172_184 : RowResult ⟨172, by decide⟩ ⟨184, by decide⟩ := by
  have _previous := row_172_183
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_172_185 : RowResult ⟨172, by decide⟩ ⟨185, by decide⟩ := by
  have _previous := row_172_184
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_172_186 : RowResult ⟨172, by decide⟩ ⟨186, by decide⟩ := by
  have _previous := row_172_185
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_172_187 : RowResult ⟨172, by decide⟩ ⟨187, by decide⟩ := by
  have _previous := row_172_186
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_172_188 : RowResult ⟨172, by decide⟩ ⟨188, by decide⟩ := by
  have _previous := row_172_187
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨172, by decide⟩) (orbitCodeOfNumber ⟨188, by decide⟩) 2 3 6)

end RelativeConicArcs.Q25PairCertificate
