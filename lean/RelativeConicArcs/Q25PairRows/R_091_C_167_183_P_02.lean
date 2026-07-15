import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_91_167 : RowResult ⟨91, by decide⟩ ⟨167, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨38, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_91_168 : RowResult ⟨91, by decide⟩ ⟨168, by decide⟩ := by
  have _previous := row_91_167
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨91, by decide⟩) (orbitCodeOfNumber ⟨168, by decide⟩) 2 4 7)

theorem row_91_169 : RowResult ⟨91, by decide⟩ ⟨169, by decide⟩ := by
  have _previous := row_91_168
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨91, by decide⟩) (orbitCodeOfNumber ⟨169, by decide⟩) 2 4 6)

theorem row_91_170 : RowResult ⟨91, by decide⟩ ⟨170, by decide⟩ := by
  have _previous := row_91_169
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨91, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) 1 2 7)

theorem row_91_171 : RowResult ⟨91, by decide⟩ ⟨171, by decide⟩ := by
  have _previous := row_91_170
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_91_172 : RowResult ⟨91, by decide⟩ ⟨172, by decide⟩ := by
  have _previous := row_91_171
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_91_173 : RowResult ⟨91, by decide⟩ ⟨173, by decide⟩ := by
  have _previous := row_91_172
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_91_174 : RowResult ⟨91, by decide⟩ ⟨174, by decide⟩ := by
  have _previous := row_91_173
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨91, by decide⟩) (orbitCodeOfNumber ⟨174, by decide⟩) 4 5 6)

theorem row_91_175 : RowResult ⟨91, by decide⟩ ⟨175, by decide⟩ := by
  have _previous := row_91_174
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨91, by decide⟩) (orbitCodeOfNumber ⟨175, by decide⟩) 1 6 7)

theorem row_91_176 : RowResult ⟨91, by decide⟩ ⟨176, by decide⟩ := by
  have _previous := row_91_175
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨91, by decide⟩) (orbitCodeOfNumber ⟨176, by decide⟩) 1 6 7)

theorem row_91_177 : RowResult ⟨91, by decide⟩ ⟨177, by decide⟩ := by
  have _previous := row_91_176
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨91, by decide⟩) (orbitCodeOfNumber ⟨177, by decide⟩) 1 6 7)

theorem row_91_178 : RowResult ⟨91, by decide⟩ ⟨178, by decide⟩ := by
  have _previous := row_91_177
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨91, by decide⟩) (orbitCodeOfNumber ⟨178, by decide⟩) 1 6 7)

theorem row_91_179 : RowResult ⟨91, by decide⟩ ⟨179, by decide⟩ := by
  have _previous := row_91_178
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨91, by decide⟩) (orbitCodeOfNumber ⟨179, by decide⟩) 1 6 7)

theorem row_91_180 : RowResult ⟨91, by decide⟩ ⟨180, by decide⟩ := by
  have _previous := row_91_179
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨91, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) 1 2 6)

theorem row_91_181 : RowResult ⟨91, by decide⟩ ⟨181, by decide⟩ := by
  have _previous := row_91_180
  exact Or.inr ⟨orbitCodeOfNumber ⟨40, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_91_182 : RowResult ⟨91, by decide⟩ ⟨182, by decide⟩ := by
  have _previous := row_91_181
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨91, by decide⟩) (orbitCodeOfNumber ⟨182, by decide⟩) 2 4 6)

theorem row_91_183 : RowResult ⟨91, by decide⟩ ⟨183, by decide⟩ := by
  have _previous := row_91_182
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
