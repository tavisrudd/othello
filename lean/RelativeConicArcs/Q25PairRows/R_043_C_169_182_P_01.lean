import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_43_169 : RowResult ⟨43, by decide⟩ ⟨169, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_43_170 : RowResult ⟨43, by decide⟩ ⟨170, by decide⟩ := by
  have _previous := row_43_169
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨43, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) 1 2 7)

theorem row_43_171 : RowResult ⟨43, by decide⟩ ⟨171, by decide⟩ := by
  have _previous := row_43_170
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨43, by decide⟩) (orbitCodeOfNumber ⟨171, by decide⟩) 2 5 7)

theorem row_43_172 : RowResult ⟨43, by decide⟩ ⟨172, by decide⟩ := by
  have _previous := row_43_171
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_43_173 : RowResult ⟨43, by decide⟩ ⟨173, by decide⟩ := by
  have _previous := row_43_172
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_43_174 : RowResult ⟨43, by decide⟩ ⟨174, by decide⟩ := by
  have _previous := row_43_173
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_43_175 : RowResult ⟨43, by decide⟩ ⟨175, by decide⟩ := by
  have _previous := row_43_174
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨43, by decide⟩) (orbitCodeOfNumber ⟨175, by decide⟩) 1 6 7)

theorem row_43_176 : RowResult ⟨43, by decide⟩ ⟨176, by decide⟩ := by
  have _previous := row_43_175
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨43, by decide⟩) (orbitCodeOfNumber ⟨176, by decide⟩) 1 6 7)

theorem row_43_177 : RowResult ⟨43, by decide⟩ ⟨177, by decide⟩ := by
  have _previous := row_43_176
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨43, by decide⟩) (orbitCodeOfNumber ⟨177, by decide⟩) 1 6 7)

theorem row_43_178 : RowResult ⟨43, by decide⟩ ⟨178, by decide⟩ := by
  have _previous := row_43_177
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨43, by decide⟩) (orbitCodeOfNumber ⟨178, by decide⟩) 1 6 7)

theorem row_43_179 : RowResult ⟨43, by decide⟩ ⟨179, by decide⟩ := by
  have _previous := row_43_178
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨43, by decide⟩) (orbitCodeOfNumber ⟨179, by decide⟩) 1 6 7)

theorem row_43_180 : RowResult ⟨43, by decide⟩ ⟨180, by decide⟩ := by
  have _previous := row_43_179
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨43, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) 1 2 6)

theorem row_43_181 : RowResult ⟨43, by decide⟩ ⟨181, by decide⟩ := by
  have _previous := row_43_180
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_43_182 : RowResult ⟨43, by decide⟩ ⟨182, by decide⟩ := by
  have _previous := row_43_181
  exact Or.inr ⟨orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
