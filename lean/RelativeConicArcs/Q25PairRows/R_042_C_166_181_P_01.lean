import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_42_166 : RowResult ⟨42, by decide⟩ ⟨166, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨58, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_42_167 : RowResult ⟨42, by decide⟩ ⟨167, by decide⟩ := by
  have _previous := row_42_166
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨42, by decide⟩) (orbitCodeOfNumber ⟨167, by decide⟩) 1 4 6)

theorem row_42_168 : RowResult ⟨42, by decide⟩ ⟨168, by decide⟩ := by
  have _previous := row_42_167
  exact Or.inr ⟨orbitCodeOfNumber ⟨64, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_42_169 : RowResult ⟨42, by decide⟩ ⟨169, by decide⟩ := by
  have _previous := row_42_168
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_42_170 : RowResult ⟨42, by decide⟩ ⟨170, by decide⟩ := by
  have _previous := row_42_169
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨42, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) 1 2 7)

theorem row_42_171 : RowResult ⟨42, by decide⟩ ⟨171, by decide⟩ := by
  have _previous := row_42_170
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨42, by decide⟩) (orbitCodeOfNumber ⟨171, by decide⟩) 2 4 6)

theorem row_42_172 : RowResult ⟨42, by decide⟩ ⟨172, by decide⟩ := by
  have _previous := row_42_171
  exact Or.inr ⟨orbitCodeOfNumber ⟨58, by decide⟩,
    orbitCodeOfNumber ⟨244, by decide⟩, by decide⟩

theorem row_42_173 : RowResult ⟨42, by decide⟩ ⟨173, by decide⟩ := by
  have _previous := row_42_172
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_42_174 : RowResult ⟨42, by decide⟩ ⟨174, by decide⟩ := by
  have _previous := row_42_173
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨42, by decide⟩) (orbitCodeOfNumber ⟨174, by decide⟩) 4 5 6)

theorem row_42_175 : RowResult ⟨42, by decide⟩ ⟨175, by decide⟩ := by
  have _previous := row_42_174
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨42, by decide⟩) (orbitCodeOfNumber ⟨175, by decide⟩) 1 6 7)

theorem row_42_176 : RowResult ⟨42, by decide⟩ ⟨176, by decide⟩ := by
  have _previous := row_42_175
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨42, by decide⟩) (orbitCodeOfNumber ⟨176, by decide⟩) 1 6 7)

theorem row_42_177 : RowResult ⟨42, by decide⟩ ⟨177, by decide⟩ := by
  have _previous := row_42_176
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨42, by decide⟩) (orbitCodeOfNumber ⟨177, by decide⟩) 1 6 7)

theorem row_42_178 : RowResult ⟨42, by decide⟩ ⟨178, by decide⟩ := by
  have _previous := row_42_177
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨42, by decide⟩) (orbitCodeOfNumber ⟨178, by decide⟩) 1 6 7)

theorem row_42_179 : RowResult ⟨42, by decide⟩ ⟨179, by decide⟩ := by
  have _previous := row_42_178
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨42, by decide⟩) (orbitCodeOfNumber ⟨179, by decide⟩) 1 6 7)

theorem row_42_180 : RowResult ⟨42, by decide⟩ ⟨180, by decide⟩ := by
  have _previous := row_42_179
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨42, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) 1 2 6)

theorem row_42_181 : RowResult ⟨42, by decide⟩ ⟨181, by decide⟩ := by
  have _previous := row_42_180
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
