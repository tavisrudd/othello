import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_136_168 : RowResult ⟨136, by decide⟩ ⟨168, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_136_169 : RowResult ⟨136, by decide⟩ ⟨169, by decide⟩ := by
  have _previous := row_136_168
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_136_170 : RowResult ⟨136, by decide⟩ ⟨170, by decide⟩ := by
  have _previous := row_136_169
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨136, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) 1 2 7)

theorem row_136_171 : RowResult ⟨136, by decide⟩ ⟨171, by decide⟩ := by
  have _previous := row_136_170
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_136_172 : RowResult ⟨136, by decide⟩ ⟨172, by decide⟩ := by
  have _previous := row_136_171
  exact Or.inr ⟨orbitCodeOfNumber ⟨37, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_136_173 : RowResult ⟨136, by decide⟩ ⟨173, by decide⟩ := by
  have _previous := row_136_172
  exact Or.inr ⟨orbitCodeOfNumber ⟨38, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_136_174 : RowResult ⟨136, by decide⟩ ⟨174, by decide⟩ := by
  have _previous := row_136_173
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_136_175 : RowResult ⟨136, by decide⟩ ⟨175, by decide⟩ := by
  have _previous := row_136_174
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨136, by decide⟩) (orbitCodeOfNumber ⟨175, by decide⟩) 1 6 7)

theorem row_136_176 : RowResult ⟨136, by decide⟩ ⟨176, by decide⟩ := by
  have _previous := row_136_175
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨136, by decide⟩) (orbitCodeOfNumber ⟨176, by decide⟩) 1 6 7)

theorem row_136_177 : RowResult ⟨136, by decide⟩ ⟨177, by decide⟩ := by
  have _previous := row_136_176
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨136, by decide⟩) (orbitCodeOfNumber ⟨177, by decide⟩) 1 6 7)

theorem row_136_178 : RowResult ⟨136, by decide⟩ ⟨178, by decide⟩ := by
  have _previous := row_136_177
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨136, by decide⟩) (orbitCodeOfNumber ⟨178, by decide⟩) 1 6 7)

theorem row_136_179 : RowResult ⟨136, by decide⟩ ⟨179, by decide⟩ := by
  have _previous := row_136_178
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨136, by decide⟩) (orbitCodeOfNumber ⟨179, by decide⟩) 1 6 7)

theorem row_136_180 : RowResult ⟨136, by decide⟩ ⟨180, by decide⟩ := by
  have _previous := row_136_179
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨136, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) 1 2 6)

theorem row_136_181 : RowResult ⟨136, by decide⟩ ⟨181, by decide⟩ := by
  have _previous := row_136_180
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨136, by decide⟩) (orbitCodeOfNumber ⟨181, by decide⟩) 2 5 6)

end RelativeConicArcs.Q25PairCertificate
