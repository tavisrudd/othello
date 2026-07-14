import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_134_166 : RowResult ⟨134, by decide⟩ ⟨166, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_134_167 : RowResult ⟨134, by decide⟩ ⟨167, by decide⟩ := by
  have _previous := row_134_166
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨134, by decide⟩) (orbitCodeOfNumber ⟨167, by decide⟩) 4 5 6)

theorem row_134_168 : RowResult ⟨134, by decide⟩ ⟨168, by decide⟩ := by
  have _previous := row_134_167
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_134_169 : RowResult ⟨134, by decide⟩ ⟨169, by decide⟩ := by
  have _previous := row_134_168
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_134_170 : RowResult ⟨134, by decide⟩ ⟨170, by decide⟩ := by
  have _previous := row_134_169
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨134, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) 1 2 7)

theorem row_134_171 : RowResult ⟨134, by decide⟩ ⟨171, by decide⟩ := by
  have _previous := row_134_170
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_134_172 : RowResult ⟨134, by decide⟩ ⟨172, by decide⟩ := by
  have _previous := row_134_171
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_134_173 : RowResult ⟨134, by decide⟩ ⟨173, by decide⟩ := by
  have _previous := row_134_172
  exact Or.inr ⟨orbitCodeOfNumber ⟨60, by decide⟩, by decide⟩

theorem row_134_174 : RowResult ⟨134, by decide⟩ ⟨174, by decide⟩ := by
  have _previous := row_134_173
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨134, by decide⟩) (orbitCodeOfNumber ⟨174, by decide⟩) 1 4 7)

theorem row_134_175 : RowResult ⟨134, by decide⟩ ⟨175, by decide⟩ := by
  have _previous := row_134_174
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨134, by decide⟩) (orbitCodeOfNumber ⟨175, by decide⟩) 1 6 7)

theorem row_134_176 : RowResult ⟨134, by decide⟩ ⟨176, by decide⟩ := by
  have _previous := row_134_175
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨134, by decide⟩) (orbitCodeOfNumber ⟨176, by decide⟩) 1 6 7)

theorem row_134_177 : RowResult ⟨134, by decide⟩ ⟨177, by decide⟩ := by
  have _previous := row_134_176
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨134, by decide⟩) (orbitCodeOfNumber ⟨177, by decide⟩) 1 6 7)

theorem row_134_178 : RowResult ⟨134, by decide⟩ ⟨178, by decide⟩ := by
  have _previous := row_134_177
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨134, by decide⟩) (orbitCodeOfNumber ⟨178, by decide⟩) 1 6 7)

theorem row_134_179 : RowResult ⟨134, by decide⟩ ⟨179, by decide⟩ := by
  have _previous := row_134_178
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨134, by decide⟩) (orbitCodeOfNumber ⟨179, by decide⟩) 1 6 7)

theorem row_134_180 : RowResult ⟨134, by decide⟩ ⟨180, by decide⟩ := by
  have _previous := row_134_179
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨134, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) 1 2 6)

end RelativeConicArcs.Q25PairCertificate
