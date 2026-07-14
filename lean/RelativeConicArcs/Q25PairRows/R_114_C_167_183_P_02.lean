import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_114_167 : RowResult ⟨114, by decide⟩ ⟨167, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_114_168 : RowResult ⟨114, by decide⟩ ⟨168, by decide⟩ := by
  have _previous := row_114_167
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_114_169 : RowResult ⟨114, by decide⟩ ⟨169, by decide⟩ := by
  have _previous := row_114_168
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨114, by decide⟩) (orbitCodeOfNumber ⟨169, by decide⟩) 1 4 7)

theorem row_114_170 : RowResult ⟨114, by decide⟩ ⟨170, by decide⟩ := by
  have _previous := row_114_169
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨114, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) 1 2 7)

theorem row_114_171 : RowResult ⟨114, by decide⟩ ⟨171, by decide⟩ := by
  have _previous := row_114_170
  exact Or.inr ⟨orbitCodeOfNumber ⟨237, by decide⟩, by decide⟩

theorem row_114_172 : RowResult ⟨114, by decide⟩ ⟨172, by decide⟩ := by
  have _previous := row_114_171
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_114_173 : RowResult ⟨114, by decide⟩ ⟨173, by decide⟩ := by
  have _previous := row_114_172
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_114_174 : RowResult ⟨114, by decide⟩ ⟨174, by decide⟩ := by
  have _previous := row_114_173
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨114, by decide⟩) (orbitCodeOfNumber ⟨174, by decide⟩) 2 4 7)

theorem row_114_175 : RowResult ⟨114, by decide⟩ ⟨175, by decide⟩ := by
  have _previous := row_114_174
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨114, by decide⟩) (orbitCodeOfNumber ⟨175, by decide⟩) 1 6 7)

theorem row_114_176 : RowResult ⟨114, by decide⟩ ⟨176, by decide⟩ := by
  have _previous := row_114_175
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨114, by decide⟩) (orbitCodeOfNumber ⟨176, by decide⟩) 1 6 7)

theorem row_114_177 : RowResult ⟨114, by decide⟩ ⟨177, by decide⟩ := by
  have _previous := row_114_176
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨114, by decide⟩) (orbitCodeOfNumber ⟨177, by decide⟩) 1 6 7)

theorem row_114_178 : RowResult ⟨114, by decide⟩ ⟨178, by decide⟩ := by
  have _previous := row_114_177
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨114, by decide⟩) (orbitCodeOfNumber ⟨178, by decide⟩) 1 6 7)

theorem row_114_179 : RowResult ⟨114, by decide⟩ ⟨179, by decide⟩ := by
  have _previous := row_114_178
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨114, by decide⟩) (orbitCodeOfNumber ⟨179, by decide⟩) 1 6 7)

theorem row_114_180 : RowResult ⟨114, by decide⟩ ⟨180, by decide⟩ := by
  have _previous := row_114_179
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨114, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) 1 2 6)

theorem row_114_181 : RowResult ⟨114, by decide⟩ ⟨181, by decide⟩ := by
  have _previous := row_114_180
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨114, by decide⟩) (orbitCodeOfNumber ⟨181, by decide⟩) 2 5 7)

theorem row_114_182 : RowResult ⟨114, by decide⟩ ⟨182, by decide⟩ := by
  have _previous := row_114_181
  exact Or.inr ⟨orbitCodeOfNumber ⟨237, by decide⟩, by decide⟩

theorem row_114_183 : RowResult ⟨114, by decide⟩ ⟨183, by decide⟩ := by
  have _previous := row_114_182
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨114, by decide⟩) (orbitCodeOfNumber ⟨183, by decide⟩) 2 4 7)

end RelativeConicArcs.Q25PairCertificate
