import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_37_174 : RowResult ⟨37, by decide⟩ ⟨174, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_37_175 : RowResult ⟨37, by decide⟩ ⟨175, by decide⟩ := by
  have _previous := row_37_174
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨37, by decide⟩) (orbitCodeOfNumber ⟨175, by decide⟩) 1 6 7)

theorem row_37_176 : RowResult ⟨37, by decide⟩ ⟨176, by decide⟩ := by
  have _previous := row_37_175
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨37, by decide⟩) (orbitCodeOfNumber ⟨176, by decide⟩) 1 6 7)

theorem row_37_177 : RowResult ⟨37, by decide⟩ ⟨177, by decide⟩ := by
  have _previous := row_37_176
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨37, by decide⟩) (orbitCodeOfNumber ⟨177, by decide⟩) 1 6 7)

theorem row_37_178 : RowResult ⟨37, by decide⟩ ⟨178, by decide⟩ := by
  have _previous := row_37_177
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨37, by decide⟩) (orbitCodeOfNumber ⟨178, by decide⟩) 1 6 7)

theorem row_37_179 : RowResult ⟨37, by decide⟩ ⟨179, by decide⟩ := by
  have _previous := row_37_178
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨37, by decide⟩) (orbitCodeOfNumber ⟨179, by decide⟩) 1 6 7)

theorem row_37_180 : RowResult ⟨37, by decide⟩ ⟨180, by decide⟩ := by
  have _previous := row_37_179
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨37, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) 1 2 6)

theorem row_37_181 : RowResult ⟨37, by decide⟩ ⟨181, by decide⟩ := by
  have _previous := row_37_180
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_37_182 : RowResult ⟨37, by decide⟩ ⟨182, by decide⟩ := by
  have _previous := row_37_181
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_37_183 : RowResult ⟨37, by decide⟩ ⟨183, by decide⟩ := by
  have _previous := row_37_182
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_37_184 : RowResult ⟨37, by decide⟩ ⟨184, by decide⟩ := by
  have _previous := row_37_183
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨37, by decide⟩) (orbitCodeOfNumber ⟨184, by decide⟩) 2 5 6)

theorem row_37_185 : RowResult ⟨37, by decide⟩ ⟨185, by decide⟩ := by
  have _previous := row_37_184
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨37, by decide⟩) (orbitCodeOfNumber ⟨185, by decide⟩) 4 5 6)

theorem row_37_186 : RowResult ⟨37, by decide⟩ ⟨186, by decide⟩ := by
  have _previous := row_37_185
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_37_187 : RowResult ⟨37, by decide⟩ ⟨187, by decide⟩ := by
  have _previous := row_37_186
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨37, by decide⟩) (orbitCodeOfNumber ⟨187, by decide⟩) 1 4 6)

theorem row_37_188 : RowResult ⟨37, by decide⟩ ⟨188, by decide⟩ := by
  have _previous := row_37_187
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨37, by decide⟩) (orbitCodeOfNumber ⟨188, by decide⟩) 2 3 6)

theorem row_37_189 : RowResult ⟨37, by decide⟩ ⟨189, by decide⟩ := by
  have _previous := row_37_188
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_37_190 : RowResult ⟨37, by decide⟩ ⟨190, by decide⟩ := by
  have _previous := row_37_189
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨37, by decide⟩) (orbitCodeOfNumber ⟨190, by decide⟩) 2 5 7)

end RelativeConicArcs.Q25PairCertificate
