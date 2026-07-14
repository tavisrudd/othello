import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_88_166 : RowResult ⟨88, by decide⟩ ⟨166, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨237, by decide⟩, by decide⟩

theorem row_88_167 : RowResult ⟨88, by decide⟩ ⟨167, by decide⟩ := by
  have _previous := row_88_166
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨88, by decide⟩) (orbitCodeOfNumber ⟨167, by decide⟩) 2 5 7)

theorem row_88_168 : RowResult ⟨88, by decide⟩ ⟨168, by decide⟩ := by
  have _previous := row_88_167
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨88, by decide⟩) (orbitCodeOfNumber ⟨168, by decide⟩) 1 4 7)

theorem row_88_169 : RowResult ⟨88, by decide⟩ ⟨169, by decide⟩ := by
  have _previous := row_88_168
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_88_170 : RowResult ⟨88, by decide⟩ ⟨170, by decide⟩ := by
  have _previous := row_88_169
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨88, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) 1 2 7)

theorem row_88_171 : RowResult ⟨88, by decide⟩ ⟨171, by decide⟩ := by
  have _previous := row_88_170
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_88_172 : RowResult ⟨88, by decide⟩ ⟨172, by decide⟩ := by
  have _previous := row_88_171
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_88_173 : RowResult ⟨88, by decide⟩ ⟨173, by decide⟩ := by
  have _previous := row_88_172
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_88_174 : RowResult ⟨88, by decide⟩ ⟨174, by decide⟩ := by
  have _previous := row_88_173
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_88_175 : RowResult ⟨88, by decide⟩ ⟨175, by decide⟩ := by
  have _previous := row_88_174
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨88, by decide⟩) (orbitCodeOfNumber ⟨175, by decide⟩) 1 6 7)

theorem row_88_176 : RowResult ⟨88, by decide⟩ ⟨176, by decide⟩ := by
  have _previous := row_88_175
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨88, by decide⟩) (orbitCodeOfNumber ⟨176, by decide⟩) 1 6 7)

theorem row_88_177 : RowResult ⟨88, by decide⟩ ⟨177, by decide⟩ := by
  have _previous := row_88_176
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨88, by decide⟩) (orbitCodeOfNumber ⟨177, by decide⟩) 1 6 7)

theorem row_88_178 : RowResult ⟨88, by decide⟩ ⟨178, by decide⟩ := by
  have _previous := row_88_177
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨88, by decide⟩) (orbitCodeOfNumber ⟨178, by decide⟩) 1 6 7)

theorem row_88_179 : RowResult ⟨88, by decide⟩ ⟨179, by decide⟩ := by
  have _previous := row_88_178
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨88, by decide⟩) (orbitCodeOfNumber ⟨179, by decide⟩) 1 6 7)

theorem row_88_180 : RowResult ⟨88, by decide⟩ ⟨180, by decide⟩ := by
  have _previous := row_88_179
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨88, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) 1 2 6)

theorem row_88_181 : RowResult ⟨88, by decide⟩ ⟨181, by decide⟩ := by
  have _previous := row_88_180
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨88, by decide⟩) (orbitCodeOfNumber ⟨181, by decide⟩) 2 4 6)

end RelativeConicArcs.Q25PairCertificate
