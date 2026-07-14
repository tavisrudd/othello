import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_109_169 : RowResult ⟨109, by decide⟩ ⟨169, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨237, by decide⟩, by decide⟩

theorem row_109_170 : RowResult ⟨109, by decide⟩ ⟨170, by decide⟩ := by
  have _previous := row_109_169
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨109, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) 1 2 7)

theorem row_109_171 : RowResult ⟨109, by decide⟩ ⟨171, by decide⟩ := by
  have _previous := row_109_170
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_109_172 : RowResult ⟨109, by decide⟩ ⟨172, by decide⟩ := by
  have _previous := row_109_171
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_109_173 : RowResult ⟨109, by decide⟩ ⟨173, by decide⟩ := by
  have _previous := row_109_172
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_109_174 : RowResult ⟨109, by decide⟩ ⟨174, by decide⟩ := by
  have _previous := row_109_173
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨109, by decide⟩) (orbitCodeOfNumber ⟨174, by decide⟩) 1 4 7)

theorem row_109_175 : RowResult ⟨109, by decide⟩ ⟨175, by decide⟩ := by
  have _previous := row_109_174
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨109, by decide⟩) (orbitCodeOfNumber ⟨175, by decide⟩) 1 6 7)

theorem row_109_176 : RowResult ⟨109, by decide⟩ ⟨176, by decide⟩ := by
  have _previous := row_109_175
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨109, by decide⟩) (orbitCodeOfNumber ⟨176, by decide⟩) 1 6 7)

theorem row_109_177 : RowResult ⟨109, by decide⟩ ⟨177, by decide⟩ := by
  have _previous := row_109_176
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨109, by decide⟩) (orbitCodeOfNumber ⟨177, by decide⟩) 1 6 7)

theorem row_109_178 : RowResult ⟨109, by decide⟩ ⟨178, by decide⟩ := by
  have _previous := row_109_177
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨109, by decide⟩) (orbitCodeOfNumber ⟨178, by decide⟩) 1 6 7)

theorem row_109_179 : RowResult ⟨109, by decide⟩ ⟨179, by decide⟩ := by
  have _previous := row_109_178
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨109, by decide⟩) (orbitCodeOfNumber ⟨179, by decide⟩) 1 6 7)

theorem row_109_180 : RowResult ⟨109, by decide⟩ ⟨180, by decide⟩ := by
  have _previous := row_109_179
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨109, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) 1 2 6)

theorem row_109_181 : RowResult ⟨109, by decide⟩ ⟨181, by decide⟩ := by
  have _previous := row_109_180
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_109_182 : RowResult ⟨109, by decide⟩ ⟨182, by decide⟩ := by
  have _previous := row_109_181
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
