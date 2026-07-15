import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_124_167 : RowResult ⟨124, by decide⟩ ⟨167, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_124_168 : RowResult ⟨124, by decide⟩ ⟨168, by decide⟩ := by
  have _previous := row_124_167
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_124_169 : RowResult ⟨124, by decide⟩ ⟨169, by decide⟩ := by
  have _previous := row_124_168
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_124_170 : RowResult ⟨124, by decide⟩ ⟨170, by decide⟩ := by
  have _previous := row_124_169
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨124, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) 1 2 7)

theorem row_124_171 : RowResult ⟨124, by decide⟩ ⟨171, by decide⟩ := by
  have _previous := row_124_170
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_124_172 : RowResult ⟨124, by decide⟩ ⟨172, by decide⟩ := by
  have _previous := row_124_171
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨244, by decide⟩, by decide⟩

theorem row_124_173 : RowResult ⟨124, by decide⟩ ⟨173, by decide⟩ := by
  have _previous := row_124_172
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨124, by decide⟩) (orbitCodeOfNumber ⟨173, by decide⟩) 4 5 6)

theorem row_124_174 : RowResult ⟨124, by decide⟩ ⟨174, by decide⟩ := by
  have _previous := row_124_173
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨124, by decide⟩) (orbitCodeOfNumber ⟨174, by decide⟩) 1 4 6)

theorem row_124_175 : RowResult ⟨124, by decide⟩ ⟨175, by decide⟩ := by
  have _previous := row_124_174
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨124, by decide⟩) (orbitCodeOfNumber ⟨175, by decide⟩) 1 6 7)

theorem row_124_176 : RowResult ⟨124, by decide⟩ ⟨176, by decide⟩ := by
  have _previous := row_124_175
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨124, by decide⟩) (orbitCodeOfNumber ⟨176, by decide⟩) 1 6 7)

theorem row_124_177 : RowResult ⟨124, by decide⟩ ⟨177, by decide⟩ := by
  have _previous := row_124_176
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨124, by decide⟩) (orbitCodeOfNumber ⟨177, by decide⟩) 1 6 7)

theorem row_124_178 : RowResult ⟨124, by decide⟩ ⟨178, by decide⟩ := by
  have _previous := row_124_177
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨124, by decide⟩) (orbitCodeOfNumber ⟨178, by decide⟩) 1 6 7)

theorem row_124_179 : RowResult ⟨124, by decide⟩ ⟨179, by decide⟩ := by
  have _previous := row_124_178
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨124, by decide⟩) (orbitCodeOfNumber ⟨179, by decide⟩) 1 6 7)

theorem row_124_180 : RowResult ⟨124, by decide⟩ ⟨180, by decide⟩ := by
  have _previous := row_124_179
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨124, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) 1 2 6)

theorem row_124_181 : RowResult ⟨124, by decide⟩ ⟨181, by decide⟩ := by
  have _previous := row_124_180
  exact Or.inr ⟨orbitCodeOfNumber ⟨36, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
