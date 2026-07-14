import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_67_168 : RowResult ⟨67, by decide⟩ ⟨168, by decide⟩ := by
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨67, by decide⟩) (orbitCodeOfNumber ⟨168, by decide⟩) 4 5 6)

theorem row_67_169 : RowResult ⟨67, by decide⟩ ⟨169, by decide⟩ := by
  have _previous := row_67_168
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_67_170 : RowResult ⟨67, by decide⟩ ⟨170, by decide⟩ := by
  have _previous := row_67_169
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨67, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) 1 2 7)

theorem row_67_171 : RowResult ⟨67, by decide⟩ ⟨171, by decide⟩ := by
  have _previous := row_67_170
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_67_172 : RowResult ⟨67, by decide⟩ ⟨172, by decide⟩ := by
  have _previous := row_67_171
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_67_173 : RowResult ⟨67, by decide⟩ ⟨173, by decide⟩ := by
  have _previous := row_67_172
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_67_174 : RowResult ⟨67, by decide⟩ ⟨174, by decide⟩ := by
  have _previous := row_67_173
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_67_175 : RowResult ⟨67, by decide⟩ ⟨175, by decide⟩ := by
  have _previous := row_67_174
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨67, by decide⟩) (orbitCodeOfNumber ⟨175, by decide⟩) 1 6 7)

theorem row_67_176 : RowResult ⟨67, by decide⟩ ⟨176, by decide⟩ := by
  have _previous := row_67_175
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨67, by decide⟩) (orbitCodeOfNumber ⟨176, by decide⟩) 1 6 7)

theorem row_67_177 : RowResult ⟨67, by decide⟩ ⟨177, by decide⟩ := by
  have _previous := row_67_176
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨67, by decide⟩) (orbitCodeOfNumber ⟨177, by decide⟩) 1 6 7)

theorem row_67_178 : RowResult ⟨67, by decide⟩ ⟨178, by decide⟩ := by
  have _previous := row_67_177
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨67, by decide⟩) (orbitCodeOfNumber ⟨178, by decide⟩) 1 6 7)

theorem row_67_179 : RowResult ⟨67, by decide⟩ ⟨179, by decide⟩ := by
  have _previous := row_67_178
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨67, by decide⟩) (orbitCodeOfNumber ⟨179, by decide⟩) 1 6 7)

theorem row_67_180 : RowResult ⟨67, by decide⟩ ⟨180, by decide⟩ := by
  have _previous := row_67_179
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨67, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) 1 2 6)

theorem row_67_181 : RowResult ⟨67, by decide⟩ ⟨181, by decide⟩ := by
  have _previous := row_67_180
  exact Or.inr ⟨orbitCodeOfNumber ⟨116, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
