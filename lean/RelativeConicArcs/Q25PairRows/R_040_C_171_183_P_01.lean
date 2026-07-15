import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_40_171 : RowResult ⟨40, by decide⟩ ⟨171, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_40_172 : RowResult ⟨40, by decide⟩ ⟨172, by decide⟩ := by
  have _previous := row_40_171
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨40, by decide⟩) (orbitCodeOfNumber ⟨172, by decide⟩) 4 5 6)

theorem row_40_173 : RowResult ⟨40, by decide⟩ ⟨173, by decide⟩ := by
  have _previous := row_40_172
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_40_174 : RowResult ⟨40, by decide⟩ ⟨174, by decide⟩ := by
  have _previous := row_40_173
  exact Or.inr ⟨orbitCodeOfNumber ⟨62, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_40_175 : RowResult ⟨40, by decide⟩ ⟨175, by decide⟩ := by
  have _previous := row_40_174
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨40, by decide⟩) (orbitCodeOfNumber ⟨175, by decide⟩) 1 6 7)

theorem row_40_176 : RowResult ⟨40, by decide⟩ ⟨176, by decide⟩ := by
  have _previous := row_40_175
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨40, by decide⟩) (orbitCodeOfNumber ⟨176, by decide⟩) 1 6 7)

theorem row_40_177 : RowResult ⟨40, by decide⟩ ⟨177, by decide⟩ := by
  have _previous := row_40_176
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨40, by decide⟩) (orbitCodeOfNumber ⟨177, by decide⟩) 1 6 7)

theorem row_40_178 : RowResult ⟨40, by decide⟩ ⟨178, by decide⟩ := by
  have _previous := row_40_177
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨40, by decide⟩) (orbitCodeOfNumber ⟨178, by decide⟩) 1 6 7)

theorem row_40_179 : RowResult ⟨40, by decide⟩ ⟨179, by decide⟩ := by
  have _previous := row_40_178
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨40, by decide⟩) (orbitCodeOfNumber ⟨179, by decide⟩) 1 6 7)

theorem row_40_180 : RowResult ⟨40, by decide⟩ ⟨180, by decide⟩ := by
  have _previous := row_40_179
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨40, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) 1 2 6)

theorem row_40_181 : RowResult ⟨40, by decide⟩ ⟨181, by decide⟩ := by
  have _previous := row_40_180
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_40_182 : RowResult ⟨40, by decide⟩ ⟨182, by decide⟩ := by
  have _previous := row_40_181
  exact Or.inr ⟨orbitCodeOfNumber ⟨61, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_40_183 : RowResult ⟨40, by decide⟩ ⟨183, by decide⟩ := by
  have _previous := row_40_182
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
