import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_64_165 : RowResult ⟨64, by decide⟩ ⟨165, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨38, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_64_166 : RowResult ⟨64, by decide⟩ ⟨166, by decide⟩ := by
  have _previous := row_64_165
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_64_167 : RowResult ⟨64, by decide⟩ ⟨167, by decide⟩ := by
  have _previous := row_64_166
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_64_168 : RowResult ⟨64, by decide⟩ ⟨168, by decide⟩ := by
  have _previous := row_64_167
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_64_169 : RowResult ⟨64, by decide⟩ ⟨169, by decide⟩ := by
  have _previous := row_64_168
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨64, by decide⟩) (orbitCodeOfNumber ⟨169, by decide⟩) 1 4 7)

theorem row_64_170 : RowResult ⟨64, by decide⟩ ⟨170, by decide⟩ := by
  have _previous := row_64_169
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨64, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) 1 2 7)

theorem row_64_171 : RowResult ⟨64, by decide⟩ ⟨171, by decide⟩ := by
  have _previous := row_64_170
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_64_172 : RowResult ⟨64, by decide⟩ ⟨172, by decide⟩ := by
  have _previous := row_64_171
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨64, by decide⟩) (orbitCodeOfNumber ⟨172, by decide⟩) 2 4 6)

theorem row_64_173 : RowResult ⟨64, by decide⟩ ⟨173, by decide⟩ := by
  have _previous := row_64_172
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨64, by decide⟩) (orbitCodeOfNumber ⟨173, by decide⟩) 2 4 7)

theorem row_64_174 : RowResult ⟨64, by decide⟩ ⟨174, by decide⟩ := by
  have _previous := row_64_173
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_64_175 : RowResult ⟨64, by decide⟩ ⟨175, by decide⟩ := by
  have _previous := row_64_174
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨64, by decide⟩) (orbitCodeOfNumber ⟨175, by decide⟩) 1 6 7)

theorem row_64_176 : RowResult ⟨64, by decide⟩ ⟨176, by decide⟩ := by
  have _previous := row_64_175
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨64, by decide⟩) (orbitCodeOfNumber ⟨176, by decide⟩) 1 6 7)

theorem row_64_177 : RowResult ⟨64, by decide⟩ ⟨177, by decide⟩ := by
  have _previous := row_64_176
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨64, by decide⟩) (orbitCodeOfNumber ⟨177, by decide⟩) 1 6 7)

theorem row_64_178 : RowResult ⟨64, by decide⟩ ⟨178, by decide⟩ := by
  have _previous := row_64_177
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨64, by decide⟩) (orbitCodeOfNumber ⟨178, by decide⟩) 1 6 7)

theorem row_64_179 : RowResult ⟨64, by decide⟩ ⟨179, by decide⟩ := by
  have _previous := row_64_178
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨64, by decide⟩) (orbitCodeOfNumber ⟨179, by decide⟩) 1 6 7)

theorem row_64_180 : RowResult ⟨64, by decide⟩ ⟨180, by decide⟩ := by
  have _previous := row_64_179
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨64, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) 1 2 6)

end RelativeConicArcs.Q25PairCertificate
