import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_99_166 : RowResult ⟨99, by decide⟩ ⟨166, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_99_167 : RowResult ⟨99, by decide⟩ ⟨167, by decide⟩ := by
  have _previous := row_99_166
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_99_168 : RowResult ⟨99, by decide⟩ ⟨168, by decide⟩ := by
  have _previous := row_99_167
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨99, by decide⟩) (orbitCodeOfNumber ⟨168, by decide⟩) 2 5 7)

theorem row_99_169 : RowResult ⟨99, by decide⟩ ⟨169, by decide⟩ := by
  have _previous := row_99_168
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨99, by decide⟩) (orbitCodeOfNumber ⟨169, by decide⟩) 2 5 6)

theorem row_99_170 : RowResult ⟨99, by decide⟩ ⟨170, by decide⟩ := by
  have _previous := row_99_169
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨99, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) 1 2 7)

theorem row_99_171 : RowResult ⟨99, by decide⟩ ⟨171, by decide⟩ := by
  have _previous := row_99_170
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨99, by decide⟩) (orbitCodeOfNumber ⟨171, by decide⟩) 2 4 6)

theorem row_99_172 : RowResult ⟨99, by decide⟩ ⟨172, by decide⟩ := by
  have _previous := row_99_171
  exact Or.inr ⟨orbitCodeOfNumber ⟨237, by decide⟩, by decide⟩

theorem row_99_173 : RowResult ⟨99, by decide⟩ ⟨173, by decide⟩ := by
  have _previous := row_99_172
  exact Or.inr ⟨orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

theorem row_99_174 : RowResult ⟨99, by decide⟩ ⟨174, by decide⟩ := by
  have _previous := row_99_173
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨99, by decide⟩) (orbitCodeOfNumber ⟨174, by decide⟩) 1 4 6)

theorem row_99_175 : RowResult ⟨99, by decide⟩ ⟨175, by decide⟩ := by
  have _previous := row_99_174
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨99, by decide⟩) (orbitCodeOfNumber ⟨175, by decide⟩) 1 6 7)

theorem row_99_176 : RowResult ⟨99, by decide⟩ ⟨176, by decide⟩ := by
  have _previous := row_99_175
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨99, by decide⟩) (orbitCodeOfNumber ⟨176, by decide⟩) 1 6 7)

theorem row_99_177 : RowResult ⟨99, by decide⟩ ⟨177, by decide⟩ := by
  have _previous := row_99_176
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨99, by decide⟩) (orbitCodeOfNumber ⟨177, by decide⟩) 1 6 7)

theorem row_99_178 : RowResult ⟨99, by decide⟩ ⟨178, by decide⟩ := by
  have _previous := row_99_177
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨99, by decide⟩) (orbitCodeOfNumber ⟨178, by decide⟩) 1 6 7)

theorem row_99_179 : RowResult ⟨99, by decide⟩ ⟨179, by decide⟩ := by
  have _previous := row_99_178
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨99, by decide⟩) (orbitCodeOfNumber ⟨179, by decide⟩) 1 6 7)

theorem row_99_180 : RowResult ⟨99, by decide⟩ ⟨180, by decide⟩ := by
  have _previous := row_99_179
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨99, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) 1 2 6)

theorem row_99_181 : RowResult ⟨99, by decide⟩ ⟨181, by decide⟩ := by
  have _previous := row_99_180
  exact Or.inr ⟨orbitCodeOfNumber ⟨116, by decide⟩, by decide⟩

theorem row_99_182 : RowResult ⟨99, by decide⟩ ⟨182, by decide⟩ := by
  have _previous := row_99_181
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨99, by decide⟩) (orbitCodeOfNumber ⟨182, by decide⟩) 2 5 6)

theorem row_99_183 : RowResult ⟨99, by decide⟩ ⟨183, by decide⟩ := by
  have _previous := row_99_182
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨99, by decide⟩) (orbitCodeOfNumber ⟨183, by decide⟩) 2 4 6)

theorem row_99_184 : RowResult ⟨99, by decide⟩ ⟨184, by decide⟩ := by
  have _previous := row_99_183
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨99, by decide⟩) (orbitCodeOfNumber ⟨184, by decide⟩) 1 4 7)

theorem row_99_185 : RowResult ⟨99, by decide⟩ ⟨185, by decide⟩ := by
  have _previous := row_99_184
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨99, by decide⟩) (orbitCodeOfNumber ⟨185, by decide⟩) 2 4 7)

theorem row_99_186 : RowResult ⟨99, by decide⟩ ⟨186, by decide⟩ := by
  have _previous := row_99_185
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
