import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_149_166 : RowResult ⟨149, by decide⟩ ⟨166, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨237, by decide⟩, by decide⟩

theorem row_149_167 : RowResult ⟨149, by decide⟩ ⟨167, by decide⟩ := by
  have _previous := row_149_166
  exact Or.inr ⟨orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

theorem row_149_168 : RowResult ⟨149, by decide⟩ ⟨168, by decide⟩ := by
  have _previous := row_149_167
  exact Or.inr ⟨orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

theorem row_149_169 : RowResult ⟨149, by decide⟩ ⟨169, by decide⟩ := by
  have _previous := row_149_168
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨149, by decide⟩) (orbitCodeOfNumber ⟨169, by decide⟩) 2 4 7)

theorem row_149_170 : RowResult ⟨149, by decide⟩ ⟨170, by decide⟩ := by
  have _previous := row_149_169
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨149, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) 1 2 7)

theorem row_149_171 : RowResult ⟨149, by decide⟩ ⟨171, by decide⟩ := by
  have _previous := row_149_170
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨149, by decide⟩) (orbitCodeOfNumber ⟨171, by decide⟩) 2 5 7)

theorem row_149_172 : RowResult ⟨149, by decide⟩ ⟨172, by decide⟩ := by
  have _previous := row_149_171
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_149_173 : RowResult ⟨149, by decide⟩ ⟨173, by decide⟩ := by
  have _previous := row_149_172
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨149, by decide⟩) (orbitCodeOfNumber ⟨173, by decide⟩) 2 4 6)

theorem row_149_174 : RowResult ⟨149, by decide⟩ ⟨174, by decide⟩ := by
  have _previous := row_149_173
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨149, by decide⟩) (orbitCodeOfNumber ⟨174, by decide⟩) 1 4 6)

theorem row_149_175 : RowResult ⟨149, by decide⟩ ⟨175, by decide⟩ := by
  have _previous := row_149_174
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨149, by decide⟩) (orbitCodeOfNumber ⟨175, by decide⟩) 1 6 7)

theorem row_149_176 : RowResult ⟨149, by decide⟩ ⟨176, by decide⟩ := by
  have _previous := row_149_175
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨149, by decide⟩) (orbitCodeOfNumber ⟨176, by decide⟩) 1 6 7)

theorem row_149_177 : RowResult ⟨149, by decide⟩ ⟨177, by decide⟩ := by
  have _previous := row_149_176
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨149, by decide⟩) (orbitCodeOfNumber ⟨177, by decide⟩) 1 6 7)

theorem row_149_178 : RowResult ⟨149, by decide⟩ ⟨178, by decide⟩ := by
  have _previous := row_149_177
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨149, by decide⟩) (orbitCodeOfNumber ⟨178, by decide⟩) 1 6 7)

theorem row_149_179 : RowResult ⟨149, by decide⟩ ⟨179, by decide⟩ := by
  have _previous := row_149_178
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨149, by decide⟩) (orbitCodeOfNumber ⟨179, by decide⟩) 1 6 7)

theorem row_149_180 : RowResult ⟨149, by decide⟩ ⟨180, by decide⟩ := by
  have _previous := row_149_179
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨149, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) 1 2 6)

theorem row_149_181 : RowResult ⟨149, by decide⟩ ⟨181, by decide⟩ := by
  have _previous := row_149_180
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_149_182 : RowResult ⟨149, by decide⟩ ⟨182, by decide⟩ := by
  have _previous := row_149_181
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
