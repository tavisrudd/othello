import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_138_167 : RowResult ⟨138, by decide⟩ ⟨167, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_138_168 : RowResult ⟨138, by decide⟩ ⟨168, by decide⟩ := by
  have _previous := row_138_167
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨138, by decide⟩) (orbitCodeOfNumber ⟨168, by decide⟩) 1 4 7)

theorem row_138_169 : RowResult ⟨138, by decide⟩ ⟨169, by decide⟩ := by
  have _previous := row_138_168
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_138_170 : RowResult ⟨138, by decide⟩ ⟨170, by decide⟩ := by
  have _previous := row_138_169
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨138, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) 1 2 7)

theorem row_138_171 : RowResult ⟨138, by decide⟩ ⟨171, by decide⟩ := by
  have _previous := row_138_170
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_138_172 : RowResult ⟨138, by decide⟩ ⟨172, by decide⟩ := by
  have _previous := row_138_171
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_138_173 : RowResult ⟨138, by decide⟩ ⟨173, by decide⟩ := by
  have _previous := row_138_172
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_138_174 : RowResult ⟨138, by decide⟩ ⟨174, by decide⟩ := by
  have _previous := row_138_173
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_138_175 : RowResult ⟨138, by decide⟩ ⟨175, by decide⟩ := by
  have _previous := row_138_174
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨138, by decide⟩) (orbitCodeOfNumber ⟨175, by decide⟩) 1 6 7)

theorem row_138_176 : RowResult ⟨138, by decide⟩ ⟨176, by decide⟩ := by
  have _previous := row_138_175
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨138, by decide⟩) (orbitCodeOfNumber ⟨176, by decide⟩) 1 6 7)

theorem row_138_177 : RowResult ⟨138, by decide⟩ ⟨177, by decide⟩ := by
  have _previous := row_138_176
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨138, by decide⟩) (orbitCodeOfNumber ⟨177, by decide⟩) 1 6 7)

theorem row_138_178 : RowResult ⟨138, by decide⟩ ⟨178, by decide⟩ := by
  have _previous := row_138_177
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨138, by decide⟩) (orbitCodeOfNumber ⟨178, by decide⟩) 1 6 7)

theorem row_138_179 : RowResult ⟨138, by decide⟩ ⟨179, by decide⟩ := by
  have _previous := row_138_178
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨138, by decide⟩) (orbitCodeOfNumber ⟨179, by decide⟩) 1 6 7)

theorem row_138_180 : RowResult ⟨138, by decide⟩ ⟨180, by decide⟩ := by
  have _previous := row_138_179
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨138, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) 1 2 6)

end RelativeConicArcs.Q25PairCertificate
