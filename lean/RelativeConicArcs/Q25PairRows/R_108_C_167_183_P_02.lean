import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_108_167 : RowResult ⟨108, by decide⟩ ⟨167, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨38, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_108_168 : RowResult ⟨108, by decide⟩ ⟨168, by decide⟩ := by
  have _previous := row_108_167
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_108_169 : RowResult ⟨108, by decide⟩ ⟨169, by decide⟩ := by
  have _previous := row_108_168
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_108_170 : RowResult ⟨108, by decide⟩ ⟨170, by decide⟩ := by
  have _previous := row_108_169
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨108, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) 1 2 7)

theorem row_108_171 : RowResult ⟨108, by decide⟩ ⟨171, by decide⟩ := by
  have _previous := row_108_170
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨108, by decide⟩) (orbitCodeOfNumber ⟨171, by decide⟩) 2 5 7)

theorem row_108_172 : RowResult ⟨108, by decide⟩ ⟨172, by decide⟩ := by
  have _previous := row_108_171
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_108_173 : RowResult ⟨108, by decide⟩ ⟨173, by decide⟩ := by
  have _previous := row_108_172
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨108, by decide⟩) (orbitCodeOfNumber ⟨173, by decide⟩) 1 4 7)

theorem row_108_174 : RowResult ⟨108, by decide⟩ ⟨174, by decide⟩ := by
  have _previous := row_108_173
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_108_175 : RowResult ⟨108, by decide⟩ ⟨175, by decide⟩ := by
  have _previous := row_108_174
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨108, by decide⟩) (orbitCodeOfNumber ⟨175, by decide⟩) 1 6 7)

theorem row_108_176 : RowResult ⟨108, by decide⟩ ⟨176, by decide⟩ := by
  have _previous := row_108_175
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨108, by decide⟩) (orbitCodeOfNumber ⟨176, by decide⟩) 1 6 7)

theorem row_108_177 : RowResult ⟨108, by decide⟩ ⟨177, by decide⟩ := by
  have _previous := row_108_176
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨108, by decide⟩) (orbitCodeOfNumber ⟨177, by decide⟩) 1 6 7)

theorem row_108_178 : RowResult ⟨108, by decide⟩ ⟨178, by decide⟩ := by
  have _previous := row_108_177
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨108, by decide⟩) (orbitCodeOfNumber ⟨178, by decide⟩) 1 6 7)

theorem row_108_179 : RowResult ⟨108, by decide⟩ ⟨179, by decide⟩ := by
  have _previous := row_108_178
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨108, by decide⟩) (orbitCodeOfNumber ⟨179, by decide⟩) 1 6 7)

theorem row_108_180 : RowResult ⟨108, by decide⟩ ⟨180, by decide⟩ := by
  have _previous := row_108_179
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨108, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) 1 2 6)

theorem row_108_181 : RowResult ⟨108, by decide⟩ ⟨181, by decide⟩ := by
  have _previous := row_108_180
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨243, by decide⟩, by decide⟩

theorem row_108_182 : RowResult ⟨108, by decide⟩ ⟨182, by decide⟩ := by
  have _previous := row_108_181
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨108, by decide⟩) (orbitCodeOfNumber ⟨182, by decide⟩) 2 4 7)

theorem row_108_183 : RowResult ⟨108, by decide⟩ ⟨183, by decide⟩ := by
  have _previous := row_108_182
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨108, by decide⟩) (orbitCodeOfNumber ⟨183, by decide⟩) 1 4 6)

end RelativeConicArcs.Q25PairCertificate
