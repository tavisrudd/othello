import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_60_171 : RowResult ⟨60, by decide⟩ ⟨171, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_60_172 : RowResult ⟨60, by decide⟩ ⟨172, by decide⟩ := by
  have _previous := row_60_171
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨60, by decide⟩) (orbitCodeOfNumber ⟨172, by decide⟩) 2 5 7)

theorem row_60_173 : RowResult ⟨60, by decide⟩ ⟨173, by decide⟩ := by
  have _previous := row_60_172
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_60_174 : RowResult ⟨60, by decide⟩ ⟨174, by decide⟩ := by
  have _previous := row_60_173
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_60_175 : RowResult ⟨60, by decide⟩ ⟨175, by decide⟩ := by
  have _previous := row_60_174
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨60, by decide⟩) (orbitCodeOfNumber ⟨175, by decide⟩) 1 6 7)

theorem row_60_176 : RowResult ⟨60, by decide⟩ ⟨176, by decide⟩ := by
  have _previous := row_60_175
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨60, by decide⟩) (orbitCodeOfNumber ⟨176, by decide⟩) 1 6 7)

theorem row_60_177 : RowResult ⟨60, by decide⟩ ⟨177, by decide⟩ := by
  have _previous := row_60_176
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨60, by decide⟩) (orbitCodeOfNumber ⟨177, by decide⟩) 1 6 7)

theorem row_60_178 : RowResult ⟨60, by decide⟩ ⟨178, by decide⟩ := by
  have _previous := row_60_177
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨60, by decide⟩) (orbitCodeOfNumber ⟨178, by decide⟩) 1 6 7)

theorem row_60_179 : RowResult ⟨60, by decide⟩ ⟨179, by decide⟩ := by
  have _previous := row_60_178
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨60, by decide⟩) (orbitCodeOfNumber ⟨179, by decide⟩) 1 6 7)

theorem row_60_180 : RowResult ⟨60, by decide⟩ ⟨180, by decide⟩ := by
  have _previous := row_60_179
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨60, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) 1 2 6)

theorem row_60_181 : RowResult ⟨60, by decide⟩ ⟨181, by decide⟩ := by
  have _previous := row_60_180
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_60_182 : RowResult ⟨60, by decide⟩ ⟨182, by decide⟩ := by
  have _previous := row_60_181
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_60_183 : RowResult ⟨60, by decide⟩ ⟨183, by decide⟩ := by
  have _previous := row_60_182
  exact Or.inr ⟨orbitCodeOfNumber ⟨37, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_60_184 : RowResult ⟨60, by decide⟩ ⟨184, by decide⟩ := by
  have _previous := row_60_183
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨60, by decide⟩) (orbitCodeOfNumber ⟨184, by decide⟩) 2 4 7)

theorem row_60_185 : RowResult ⟨60, by decide⟩ ⟨185, by decide⟩ := by
  have _previous := row_60_184
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨60, by decide⟩) (orbitCodeOfNumber ⟨185, by decide⟩) 1 4 6)

end RelativeConicArcs.Q25PairCertificate
