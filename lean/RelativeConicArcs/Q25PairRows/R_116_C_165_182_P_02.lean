import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_116_165 : RowResult ⟨116, by decide⟩ ⟨165, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨243, by decide⟩, by decide⟩

theorem row_116_166 : RowResult ⟨116, by decide⟩ ⟨166, by decide⟩ := by
  have _previous := row_116_165
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨116, by decide⟩) (orbitCodeOfNumber ⟨166, by decide⟩) 1 4 6)

theorem row_116_167 : RowResult ⟨116, by decide⟩ ⟨167, by decide⟩ := by
  have _previous := row_116_166
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_116_168 : RowResult ⟨116, by decide⟩ ⟨168, by decide⟩ := by
  have _previous := row_116_167
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨116, by decide⟩) (orbitCodeOfNumber ⟨168, by decide⟩) 2 5 6)

theorem row_116_169 : RowResult ⟨116, by decide⟩ ⟨169, by decide⟩ := by
  have _previous := row_116_168
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨116, by decide⟩) (orbitCodeOfNumber ⟨169, by decide⟩) 4 5 6)

theorem row_116_170 : RowResult ⟨116, by decide⟩ ⟨170, by decide⟩ := by
  have _previous := row_116_169
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨116, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) 1 2 7)

theorem row_116_171 : RowResult ⟨116, by decide⟩ ⟨171, by decide⟩ := by
  have _previous := row_116_170
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_116_172 : RowResult ⟨116, by decide⟩ ⟨172, by decide⟩ := by
  have _previous := row_116_171
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨116, by decide⟩) (orbitCodeOfNumber ⟨172, by decide⟩) 2 5 7)

theorem row_116_173 : RowResult ⟨116, by decide⟩ ⟨173, by decide⟩ := by
  have _previous := row_116_172
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_116_174 : RowResult ⟨116, by decide⟩ ⟨174, by decide⟩ := by
  have _previous := row_116_173
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨116, by decide⟩) (orbitCodeOfNumber ⟨174, by decide⟩) 2 4 6)

theorem row_116_175 : RowResult ⟨116, by decide⟩ ⟨175, by decide⟩ := by
  have _previous := row_116_174
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨116, by decide⟩) (orbitCodeOfNumber ⟨175, by decide⟩) 1 6 7)

theorem row_116_176 : RowResult ⟨116, by decide⟩ ⟨176, by decide⟩ := by
  have _previous := row_116_175
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨116, by decide⟩) (orbitCodeOfNumber ⟨176, by decide⟩) 1 6 7)

theorem row_116_177 : RowResult ⟨116, by decide⟩ ⟨177, by decide⟩ := by
  have _previous := row_116_176
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨116, by decide⟩) (orbitCodeOfNumber ⟨177, by decide⟩) 1 6 7)

theorem row_116_178 : RowResult ⟨116, by decide⟩ ⟨178, by decide⟩ := by
  have _previous := row_116_177
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨116, by decide⟩) (orbitCodeOfNumber ⟨178, by decide⟩) 1 6 7)

theorem row_116_179 : RowResult ⟨116, by decide⟩ ⟨179, by decide⟩ := by
  have _previous := row_116_178
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨116, by decide⟩) (orbitCodeOfNumber ⟨179, by decide⟩) 1 6 7)

theorem row_116_180 : RowResult ⟨116, by decide⟩ ⟨180, by decide⟩ := by
  have _previous := row_116_179
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨116, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) 1 2 6)

theorem row_116_181 : RowResult ⟨116, by decide⟩ ⟨181, by decide⟩ := by
  have _previous := row_116_180
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨243, by decide⟩, by decide⟩

theorem row_116_182 : RowResult ⟨116, by decide⟩ ⟨182, by decide⟩ := by
  have _previous := row_116_181
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
