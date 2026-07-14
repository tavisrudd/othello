import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_115_171 : RowResult ⟨115, by decide⟩ ⟨171, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_115_172 : RowResult ⟨115, by decide⟩ ⟨172, by decide⟩ := by
  have _previous := row_115_171
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_115_173 : RowResult ⟨115, by decide⟩ ⟨173, by decide⟩ := by
  have _previous := row_115_172
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_115_174 : RowResult ⟨115, by decide⟩ ⟨174, by decide⟩ := by
  have _previous := row_115_173
  exact Or.inr ⟨orbitCodeOfNumber ⟨196, by decide⟩, by decide⟩

theorem row_115_175 : RowResult ⟨115, by decide⟩ ⟨175, by decide⟩ := by
  have _previous := row_115_174
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨115, by decide⟩) (orbitCodeOfNumber ⟨175, by decide⟩) 1 6 7)

theorem row_115_176 : RowResult ⟨115, by decide⟩ ⟨176, by decide⟩ := by
  have _previous := row_115_175
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨115, by decide⟩) (orbitCodeOfNumber ⟨176, by decide⟩) 1 6 7)

theorem row_115_177 : RowResult ⟨115, by decide⟩ ⟨177, by decide⟩ := by
  have _previous := row_115_176
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨115, by decide⟩) (orbitCodeOfNumber ⟨177, by decide⟩) 1 6 7)

theorem row_115_178 : RowResult ⟨115, by decide⟩ ⟨178, by decide⟩ := by
  have _previous := row_115_177
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨115, by decide⟩) (orbitCodeOfNumber ⟨178, by decide⟩) 1 6 7)

theorem row_115_179 : RowResult ⟨115, by decide⟩ ⟨179, by decide⟩ := by
  have _previous := row_115_178
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨115, by decide⟩) (orbitCodeOfNumber ⟨179, by decide⟩) 1 6 7)

theorem row_115_180 : RowResult ⟨115, by decide⟩ ⟨180, by decide⟩ := by
  have _previous := row_115_179
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨115, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) 1 2 6)

theorem row_115_181 : RowResult ⟨115, by decide⟩ ⟨181, by decide⟩ := by
  have _previous := row_115_180
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨115, by decide⟩) (orbitCodeOfNumber ⟨181, by decide⟩) 2 5 6)

theorem row_115_182 : RowResult ⟨115, by decide⟩ ⟨182, by decide⟩ := by
  have _previous := row_115_181
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_115_183 : RowResult ⟨115, by decide⟩ ⟨183, by decide⟩ := by
  have _previous := row_115_182
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨115, by decide⟩) (orbitCodeOfNumber ⟨183, by decide⟩) 4 5 6)

theorem row_115_184 : RowResult ⟨115, by decide⟩ ⟨184, by decide⟩ := by
  have _previous := row_115_183
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨115, by decide⟩) (orbitCodeOfNumber ⟨184, by decide⟩) 2 4 7)

theorem row_115_185 : RowResult ⟨115, by decide⟩ ⟨185, by decide⟩ := by
  have _previous := row_115_184
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨115, by decide⟩) (orbitCodeOfNumber ⟨185, by decide⟩) 1 4 7)

theorem row_115_186 : RowResult ⟨115, by decide⟩ ⟨186, by decide⟩ := by
  have _previous := row_115_185
  exact Or.inr ⟨orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
