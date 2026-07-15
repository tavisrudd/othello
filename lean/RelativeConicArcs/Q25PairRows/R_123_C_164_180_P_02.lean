import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_123_164 : RowResult ⟨123, by decide⟩ ⟨164, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_123_165 : RowResult ⟨123, by decide⟩ ⟨165, by decide⟩ := by
  have _previous := row_123_164
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_123_166 : RowResult ⟨123, by decide⟩ ⟨166, by decide⟩ := by
  have _previous := row_123_165
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_123_167 : RowResult ⟨123, by decide⟩ ⟨167, by decide⟩ := by
  have _previous := row_123_166
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨123, by decide⟩) (orbitCodeOfNumber ⟨167, by decide⟩) 2 4 6)

theorem row_123_168 : RowResult ⟨123, by decide⟩ ⟨168, by decide⟩ := by
  have _previous := row_123_167
  exact Or.inr ⟨orbitCodeOfNumber ⟨42, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_123_169 : RowResult ⟨123, by decide⟩ ⟨169, by decide⟩ := by
  have _previous := row_123_168
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨123, by decide⟩) (orbitCodeOfNumber ⟨169, by decide⟩) 2 5 7)

theorem row_123_170 : RowResult ⟨123, by decide⟩ ⟨170, by decide⟩ := by
  have _previous := row_123_169
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨123, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) 1 2 7)

theorem row_123_171 : RowResult ⟨123, by decide⟩ ⟨171, by decide⟩ := by
  have _previous := row_123_170
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_123_172 : RowResult ⟨123, by decide⟩ ⟨172, by decide⟩ := by
  have _previous := row_123_171
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨123, by decide⟩) (orbitCodeOfNumber ⟨172, by decide⟩) 4 5 6)

theorem row_123_173 : RowResult ⟨123, by decide⟩ ⟨173, by decide⟩ := by
  have _previous := row_123_172
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨123, by decide⟩) (orbitCodeOfNumber ⟨173, by decide⟩) 1 4 6)

theorem row_123_174 : RowResult ⟨123, by decide⟩ ⟨174, by decide⟩ := by
  have _previous := row_123_173
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_123_175 : RowResult ⟨123, by decide⟩ ⟨175, by decide⟩ := by
  have _previous := row_123_174
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨123, by decide⟩) (orbitCodeOfNumber ⟨175, by decide⟩) 1 6 7)

theorem row_123_176 : RowResult ⟨123, by decide⟩ ⟨176, by decide⟩ := by
  have _previous := row_123_175
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨123, by decide⟩) (orbitCodeOfNumber ⟨176, by decide⟩) 1 6 7)

theorem row_123_177 : RowResult ⟨123, by decide⟩ ⟨177, by decide⟩ := by
  have _previous := row_123_176
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨123, by decide⟩) (orbitCodeOfNumber ⟨177, by decide⟩) 1 6 7)

theorem row_123_178 : RowResult ⟨123, by decide⟩ ⟨178, by decide⟩ := by
  have _previous := row_123_177
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨123, by decide⟩) (orbitCodeOfNumber ⟨178, by decide⟩) 1 6 7)

theorem row_123_179 : RowResult ⟨123, by decide⟩ ⟨179, by decide⟩ := by
  have _previous := row_123_178
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨123, by decide⟩) (orbitCodeOfNumber ⟨179, by decide⟩) 1 6 7)

theorem row_123_180 : RowResult ⟨123, by decide⟩ ⟨180, by decide⟩ := by
  have _previous := row_123_179
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨123, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) 1 2 6)

end RelativeConicArcs.Q25PairCertificate
