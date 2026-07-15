import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_97_168 : RowResult ⟨97, by decide⟩ ⟨168, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_97_169 : RowResult ⟨97, by decide⟩ ⟨169, by decide⟩ := by
  have _previous := row_97_168
  exact Or.inr ⟨orbitCodeOfNumber ⟨36, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_97_170 : RowResult ⟨97, by decide⟩ ⟨170, by decide⟩ := by
  have _previous := row_97_169
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨97, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) 1 2 7)

theorem row_97_171 : RowResult ⟨97, by decide⟩ ⟨171, by decide⟩ := by
  have _previous := row_97_170
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_97_172 : RowResult ⟨97, by decide⟩ ⟨172, by decide⟩ := by
  have _previous := row_97_171
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨97, by decide⟩) (orbitCodeOfNumber ⟨172, by decide⟩) 1 4 6)

theorem row_97_173 : RowResult ⟨97, by decide⟩ ⟨173, by decide⟩ := by
  have _previous := row_97_172
  exact Or.inr ⟨orbitCodeOfNumber ⟨36, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_97_174 : RowResult ⟨97, by decide⟩ ⟨174, by decide⟩ := by
  have _previous := row_97_173
  exact Or.inr ⟨orbitCodeOfNumber ⟨36, by decide⟩,
    orbitCodeOfNumber ⟨242, by decide⟩, by decide⟩

theorem row_97_175 : RowResult ⟨97, by decide⟩ ⟨175, by decide⟩ := by
  have _previous := row_97_174
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨97, by decide⟩) (orbitCodeOfNumber ⟨175, by decide⟩) 1 6 7)

theorem row_97_176 : RowResult ⟨97, by decide⟩ ⟨176, by decide⟩ := by
  have _previous := row_97_175
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨97, by decide⟩) (orbitCodeOfNumber ⟨176, by decide⟩) 1 6 7)

theorem row_97_177 : RowResult ⟨97, by decide⟩ ⟨177, by decide⟩ := by
  have _previous := row_97_176
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨97, by decide⟩) (orbitCodeOfNumber ⟨177, by decide⟩) 1 6 7)

theorem row_97_178 : RowResult ⟨97, by decide⟩ ⟨178, by decide⟩ := by
  have _previous := row_97_177
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨97, by decide⟩) (orbitCodeOfNumber ⟨178, by decide⟩) 1 6 7)

theorem row_97_179 : RowResult ⟨97, by decide⟩ ⟨179, by decide⟩ := by
  have _previous := row_97_178
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨97, by decide⟩) (orbitCodeOfNumber ⟨179, by decide⟩) 1 6 7)

theorem row_97_180 : RowResult ⟨97, by decide⟩ ⟨180, by decide⟩ := by
  have _previous := row_97_179
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨97, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) 1 2 6)

theorem row_97_181 : RowResult ⟨97, by decide⟩ ⟨181, by decide⟩ := by
  have _previous := row_97_180
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨97, by decide⟩) (orbitCodeOfNumber ⟨181, by decide⟩) 2 5 6)

theorem row_97_182 : RowResult ⟨97, by decide⟩ ⟨182, by decide⟩ := by
  have _previous := row_97_181
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨97, by decide⟩) (orbitCodeOfNumber ⟨182, by decide⟩) 1 4 7)

theorem row_97_183 : RowResult ⟨97, by decide⟩ ⟨183, by decide⟩ := by
  have _previous := row_97_182
  exact Or.inr ⟨orbitCodeOfNumber ⟨37, by decide⟩,
    orbitCodeOfNumber ⟨246, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
