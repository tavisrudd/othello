import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_148_166 : RowResult ⟨148, by decide⟩ ⟨166, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_148_167 : RowResult ⟨148, by decide⟩ ⟨167, by decide⟩ := by
  have _previous := row_148_166
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_148_168 : RowResult ⟨148, by decide⟩ ⟨168, by decide⟩ := by
  have _previous := row_148_167
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨148, by decide⟩) (orbitCodeOfNumber ⟨168, by decide⟩) 2 5 6)

theorem row_148_169 : RowResult ⟨148, by decide⟩ ⟨169, by decide⟩ := by
  have _previous := row_148_168
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_148_170 : RowResult ⟨148, by decide⟩ ⟨170, by decide⟩ := by
  have _previous := row_148_169
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨148, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) 1 2 7)

theorem row_148_171 : RowResult ⟨148, by decide⟩ ⟨171, by decide⟩ := by
  have _previous := row_148_170
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_148_172 : RowResult ⟨148, by decide⟩ ⟨172, by decide⟩ := by
  have _previous := row_148_171
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨148, by decide⟩) (orbitCodeOfNumber ⟨172, by decide⟩) 2 5 7)

theorem row_148_173 : RowResult ⟨148, by decide⟩ ⟨173, by decide⟩ := by
  have _previous := row_148_172
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨148, by decide⟩) (orbitCodeOfNumber ⟨173, by decide⟩) 1 4 6)

theorem row_148_174 : RowResult ⟨148, by decide⟩ ⟨174, by decide⟩ := by
  have _previous := row_148_173
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_148_175 : RowResult ⟨148, by decide⟩ ⟨175, by decide⟩ := by
  have _previous := row_148_174
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨148, by decide⟩) (orbitCodeOfNumber ⟨175, by decide⟩) 1 6 7)

theorem row_148_176 : RowResult ⟨148, by decide⟩ ⟨176, by decide⟩ := by
  have _previous := row_148_175
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨148, by decide⟩) (orbitCodeOfNumber ⟨176, by decide⟩) 1 6 7)

theorem row_148_177 : RowResult ⟨148, by decide⟩ ⟨177, by decide⟩ := by
  have _previous := row_148_176
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨148, by decide⟩) (orbitCodeOfNumber ⟨177, by decide⟩) 1 6 7)

theorem row_148_178 : RowResult ⟨148, by decide⟩ ⟨178, by decide⟩ := by
  have _previous := row_148_177
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨148, by decide⟩) (orbitCodeOfNumber ⟨178, by decide⟩) 1 6 7)

theorem row_148_179 : RowResult ⟨148, by decide⟩ ⟨179, by decide⟩ := by
  have _previous := row_148_178
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨148, by decide⟩) (orbitCodeOfNumber ⟨179, by decide⟩) 1 6 7)

theorem row_148_180 : RowResult ⟨148, by decide⟩ ⟨180, by decide⟩ := by
  have _previous := row_148_179
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨148, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) 1 2 6)

theorem row_148_181 : RowResult ⟨148, by decide⟩ ⟨181, by decide⟩ := by
  have _previous := row_148_180
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
