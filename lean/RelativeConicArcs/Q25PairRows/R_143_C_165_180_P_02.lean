import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_143_165 : RowResult ⟨143, by decide⟩ ⟨165, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_143_166 : RowResult ⟨143, by decide⟩ ⟨166, by decide⟩ := by
  have _previous := row_143_165
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_143_167 : RowResult ⟨143, by decide⟩ ⟨167, by decide⟩ := by
  have _previous := row_143_166
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_143_168 : RowResult ⟨143, by decide⟩ ⟨168, by decide⟩ := by
  have _previous := row_143_167
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨143, by decide⟩) (orbitCodeOfNumber ⟨168, by decide⟩) 1 4 6)

theorem row_143_169 : RowResult ⟨143, by decide⟩ ⟨169, by decide⟩ := by
  have _previous := row_143_168
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_143_170 : RowResult ⟨143, by decide⟩ ⟨170, by decide⟩ := by
  have _previous := row_143_169
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨143, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) 1 2 7)

theorem row_143_171 : RowResult ⟨143, by decide⟩ ⟨171, by decide⟩ := by
  have _previous := row_143_170
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨143, by decide⟩) (orbitCodeOfNumber ⟨171, by decide⟩) 2 5 6)

theorem row_143_172 : RowResult ⟨143, by decide⟩ ⟨172, by decide⟩ := by
  have _previous := row_143_171
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨143, by decide⟩) (orbitCodeOfNumber ⟨172, by decide⟩) 4 5 6)

theorem row_143_173 : RowResult ⟨143, by decide⟩ ⟨173, by decide⟩ := by
  have _previous := row_143_172
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_143_174 : RowResult ⟨143, by decide⟩ ⟨174, by decide⟩ := by
  have _previous := row_143_173
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_143_175 : RowResult ⟨143, by decide⟩ ⟨175, by decide⟩ := by
  have _previous := row_143_174
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨143, by decide⟩) (orbitCodeOfNumber ⟨175, by decide⟩) 1 6 7)

theorem row_143_176 : RowResult ⟨143, by decide⟩ ⟨176, by decide⟩ := by
  have _previous := row_143_175
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨143, by decide⟩) (orbitCodeOfNumber ⟨176, by decide⟩) 1 6 7)

theorem row_143_177 : RowResult ⟨143, by decide⟩ ⟨177, by decide⟩ := by
  have _previous := row_143_176
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨143, by decide⟩) (orbitCodeOfNumber ⟨177, by decide⟩) 1 6 7)

theorem row_143_178 : RowResult ⟨143, by decide⟩ ⟨178, by decide⟩ := by
  have _previous := row_143_177
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨143, by decide⟩) (orbitCodeOfNumber ⟨178, by decide⟩) 1 6 7)

theorem row_143_179 : RowResult ⟨143, by decide⟩ ⟨179, by decide⟩ := by
  have _previous := row_143_178
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨143, by decide⟩) (orbitCodeOfNumber ⟨179, by decide⟩) 1 6 7)

theorem row_143_180 : RowResult ⟨143, by decide⟩ ⟨180, by decide⟩ := by
  have _previous := row_143_179
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨143, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) 1 2 6)

end RelativeConicArcs.Q25PairCertificate
