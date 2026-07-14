import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_65_166 : RowResult ⟨65, by decide⟩ ⟨166, by decide⟩ := by
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨65, by decide⟩) (orbitCodeOfNumber ⟨166, by decide⟩) 4 5 6)

theorem row_65_167 : RowResult ⟨65, by decide⟩ ⟨167, by decide⟩ := by
  have _previous := row_65_166
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨65, by decide⟩) (orbitCodeOfNumber ⟨167, by decide⟩) 2 4 7)

theorem row_65_168 : RowResult ⟨65, by decide⟩ ⟨168, by decide⟩ := by
  have _previous := row_65_167
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_65_169 : RowResult ⟨65, by decide⟩ ⟨169, by decide⟩ := by
  have _previous := row_65_168
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_65_170 : RowResult ⟨65, by decide⟩ ⟨170, by decide⟩ := by
  have _previous := row_65_169
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨65, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) 1 2 7)

theorem row_65_171 : RowResult ⟨65, by decide⟩ ⟨171, by decide⟩ := by
  have _previous := row_65_170
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨65, by decide⟩) (orbitCodeOfNumber ⟨171, by decide⟩) 2 5 7)

theorem row_65_172 : RowResult ⟨65, by decide⟩ ⟨172, by decide⟩ := by
  have _previous := row_65_171
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_65_173 : RowResult ⟨65, by decide⟩ ⟨173, by decide⟩ := by
  have _previous := row_65_172
  exact Or.inr ⟨orbitCodeOfNumber ⟨237, by decide⟩, by decide⟩

theorem row_65_174 : RowResult ⟨65, by decide⟩ ⟨174, by decide⟩ := by
  have _previous := row_65_173
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_65_175 : RowResult ⟨65, by decide⟩ ⟨175, by decide⟩ := by
  have _previous := row_65_174
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨65, by decide⟩) (orbitCodeOfNumber ⟨175, by decide⟩) 1 6 7)

theorem row_65_176 : RowResult ⟨65, by decide⟩ ⟨176, by decide⟩ := by
  have _previous := row_65_175
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨65, by decide⟩) (orbitCodeOfNumber ⟨176, by decide⟩) 1 6 7)

theorem row_65_177 : RowResult ⟨65, by decide⟩ ⟨177, by decide⟩ := by
  have _previous := row_65_176
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨65, by decide⟩) (orbitCodeOfNumber ⟨177, by decide⟩) 1 6 7)

theorem row_65_178 : RowResult ⟨65, by decide⟩ ⟨178, by decide⟩ := by
  have _previous := row_65_177
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨65, by decide⟩) (orbitCodeOfNumber ⟨178, by decide⟩) 1 6 7)

theorem row_65_179 : RowResult ⟨65, by decide⟩ ⟨179, by decide⟩ := by
  have _previous := row_65_178
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨65, by decide⟩) (orbitCodeOfNumber ⟨179, by decide⟩) 1 6 7)

theorem row_65_180 : RowResult ⟨65, by decide⟩ ⟨180, by decide⟩ := by
  have _previous := row_65_179
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨65, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) 1 2 6)

theorem row_65_181 : RowResult ⟨65, by decide⟩ ⟨181, by decide⟩ := by
  have _previous := row_65_180
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨65, by decide⟩) (orbitCodeOfNumber ⟨181, by decide⟩) 4 5 6)

theorem row_65_182 : RowResult ⟨65, by decide⟩ ⟨182, by decide⟩ := by
  have _previous := row_65_181
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
