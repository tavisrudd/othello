import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_139_174 : RowResult ⟨139, by decide⟩ ⟨174, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_139_175 : RowResult ⟨139, by decide⟩ ⟨175, by decide⟩ := by
  have _previous := row_139_174
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨139, by decide⟩) (orbitCodeOfNumber ⟨175, by decide⟩) 1 6 7)

theorem row_139_176 : RowResult ⟨139, by decide⟩ ⟨176, by decide⟩ := by
  have _previous := row_139_175
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨139, by decide⟩) (orbitCodeOfNumber ⟨176, by decide⟩) 1 6 7)

theorem row_139_177 : RowResult ⟨139, by decide⟩ ⟨177, by decide⟩ := by
  have _previous := row_139_176
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨139, by decide⟩) (orbitCodeOfNumber ⟨177, by decide⟩) 1 6 7)

theorem row_139_178 : RowResult ⟨139, by decide⟩ ⟨178, by decide⟩ := by
  have _previous := row_139_177
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨139, by decide⟩) (orbitCodeOfNumber ⟨178, by decide⟩) 1 6 7)

theorem row_139_179 : RowResult ⟨139, by decide⟩ ⟨179, by decide⟩ := by
  have _previous := row_139_178
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨139, by decide⟩) (orbitCodeOfNumber ⟨179, by decide⟩) 1 6 7)

theorem row_139_180 : RowResult ⟨139, by decide⟩ ⟨180, by decide⟩ := by
  have _previous := row_139_179
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨139, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) 1 2 6)

theorem row_139_181 : RowResult ⟨139, by decide⟩ ⟨181, by decide⟩ := by
  have _previous := row_139_180
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_139_182 : RowResult ⟨139, by decide⟩ ⟨182, by decide⟩ := by
  have _previous := row_139_181
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨139, by decide⟩) (orbitCodeOfNumber ⟨182, by decide⟩) 2 4 6)

theorem row_139_183 : RowResult ⟨139, by decide⟩ ⟨183, by decide⟩ := by
  have _previous := row_139_182
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_139_184 : RowResult ⟨139, by decide⟩ ⟨184, by decide⟩ := by
  have _previous := row_139_183
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨139, by decide⟩) (orbitCodeOfNumber ⟨184, by decide⟩) 2 5 7)

theorem row_139_185 : RowResult ⟨139, by decide⟩ ⟨185, by decide⟩ := by
  have _previous := row_139_184
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨139, by decide⟩) (orbitCodeOfNumber ⟨185, by decide⟩) 4 5 6)

theorem row_139_186 : RowResult ⟨139, by decide⟩ ⟨186, by decide⟩ := by
  have _previous := row_139_185
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_139_187 : RowResult ⟨139, by decide⟩ ⟨187, by decide⟩ := by
  have _previous := row_139_186
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_139_188 : RowResult ⟨139, by decide⟩ ⟨188, by decide⟩ := by
  have _previous := row_139_187
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨139, by decide⟩) (orbitCodeOfNumber ⟨188, by decide⟩) 2 3 6)

theorem row_139_189 : RowResult ⟨139, by decide⟩ ⟨189, by decide⟩ := by
  have _previous := row_139_188
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨139, by decide⟩) (orbitCodeOfNumber ⟨189, by decide⟩) 1 4 6)

theorem row_139_190 : RowResult ⟨139, by decide⟩ ⟨190, by decide⟩ := by
  have _previous := row_139_189
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
