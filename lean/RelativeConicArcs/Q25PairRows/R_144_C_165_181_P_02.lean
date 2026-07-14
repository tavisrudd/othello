import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_144_165 : RowResult ⟨144, by decide⟩ ⟨165, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_144_166 : RowResult ⟨144, by decide⟩ ⟨166, by decide⟩ := by
  have _previous := row_144_165
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨144, by decide⟩) (orbitCodeOfNumber ⟨166, by decide⟩) 2 4 7)

theorem row_144_167 : RowResult ⟨144, by decide⟩ ⟨167, by decide⟩ := by
  have _previous := row_144_166
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨144, by decide⟩) (orbitCodeOfNumber ⟨167, by decide⟩) 2 5 6)

theorem row_144_168 : RowResult ⟨144, by decide⟩ ⟨168, by decide⟩ := by
  have _previous := row_144_167
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_144_169 : RowResult ⟨144, by decide⟩ ⟨169, by decide⟩ := by
  have _previous := row_144_168
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨144, by decide⟩) (orbitCodeOfNumber ⟨169, by decide⟩) 1 4 6)

theorem row_144_170 : RowResult ⟨144, by decide⟩ ⟨170, by decide⟩ := by
  have _previous := row_144_169
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨144, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) 1 2 7)

theorem row_144_171 : RowResult ⟨144, by decide⟩ ⟨171, by decide⟩ := by
  have _previous := row_144_170
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_144_172 : RowResult ⟨144, by decide⟩ ⟨172, by decide⟩ := by
  have _previous := row_144_171
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_144_173 : RowResult ⟨144, by decide⟩ ⟨173, by decide⟩ := by
  have _previous := row_144_172
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨144, by decide⟩) (orbitCodeOfNumber ⟨173, by decide⟩) 4 5 6)

theorem row_144_174 : RowResult ⟨144, by decide⟩ ⟨174, by decide⟩ := by
  have _previous := row_144_173
  exact Or.inr ⟨orbitCodeOfNumber ⟨237, by decide⟩, by decide⟩

theorem row_144_175 : RowResult ⟨144, by decide⟩ ⟨175, by decide⟩ := by
  have _previous := row_144_174
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨144, by decide⟩) (orbitCodeOfNumber ⟨175, by decide⟩) 1 6 7)

theorem row_144_176 : RowResult ⟨144, by decide⟩ ⟨176, by decide⟩ := by
  have _previous := row_144_175
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨144, by decide⟩) (orbitCodeOfNumber ⟨176, by decide⟩) 1 6 7)

theorem row_144_177 : RowResult ⟨144, by decide⟩ ⟨177, by decide⟩ := by
  have _previous := row_144_176
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨144, by decide⟩) (orbitCodeOfNumber ⟨177, by decide⟩) 1 6 7)

theorem row_144_178 : RowResult ⟨144, by decide⟩ ⟨178, by decide⟩ := by
  have _previous := row_144_177
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨144, by decide⟩) (orbitCodeOfNumber ⟨178, by decide⟩) 1 6 7)

theorem row_144_179 : RowResult ⟨144, by decide⟩ ⟨179, by decide⟩ := by
  have _previous := row_144_178
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨144, by decide⟩) (orbitCodeOfNumber ⟨179, by decide⟩) 1 6 7)

theorem row_144_180 : RowResult ⟨144, by decide⟩ ⟨180, by decide⟩ := by
  have _previous := row_144_179
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨144, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) 1 2 6)

theorem row_144_181 : RowResult ⟨144, by decide⟩ ⟨181, by decide⟩ := by
  have _previous := row_144_180
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
