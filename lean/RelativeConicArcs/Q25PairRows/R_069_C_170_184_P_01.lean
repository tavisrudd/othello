import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_69_170 : RowResult ⟨69, by decide⟩ ⟨170, by decide⟩ := by
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨69, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) 1 2 7)

theorem row_69_171 : RowResult ⟨69, by decide⟩ ⟨171, by decide⟩ := by
  have _previous := row_69_170
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_69_172 : RowResult ⟨69, by decide⟩ ⟨172, by decide⟩ := by
  have _previous := row_69_171
  exact Or.inr ⟨orbitCodeOfNumber ⟨183, by decide⟩, by decide⟩

theorem row_69_173 : RowResult ⟨69, by decide⟩ ⟨173, by decide⟩ := by
  have _previous := row_69_172
  exact Or.inr ⟨orbitCodeOfNumber ⟨237, by decide⟩, by decide⟩

theorem row_69_174 : RowResult ⟨69, by decide⟩ ⟨174, by decide⟩ := by
  have _previous := row_69_173
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_69_175 : RowResult ⟨69, by decide⟩ ⟨175, by decide⟩ := by
  have _previous := row_69_174
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨69, by decide⟩) (orbitCodeOfNumber ⟨175, by decide⟩) 1 6 7)

theorem row_69_176 : RowResult ⟨69, by decide⟩ ⟨176, by decide⟩ := by
  have _previous := row_69_175
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨69, by decide⟩) (orbitCodeOfNumber ⟨176, by decide⟩) 1 6 7)

theorem row_69_177 : RowResult ⟨69, by decide⟩ ⟨177, by decide⟩ := by
  have _previous := row_69_176
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨69, by decide⟩) (orbitCodeOfNumber ⟨177, by decide⟩) 1 6 7)

theorem row_69_178 : RowResult ⟨69, by decide⟩ ⟨178, by decide⟩ := by
  have _previous := row_69_177
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨69, by decide⟩) (orbitCodeOfNumber ⟨178, by decide⟩) 1 6 7)

theorem row_69_179 : RowResult ⟨69, by decide⟩ ⟨179, by decide⟩ := by
  have _previous := row_69_178
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨69, by decide⟩) (orbitCodeOfNumber ⟨179, by decide⟩) 1 6 7)

theorem row_69_180 : RowResult ⟨69, by decide⟩ ⟨180, by decide⟩ := by
  have _previous := row_69_179
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨69, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) 1 2 6)

theorem row_69_181 : RowResult ⟨69, by decide⟩ ⟨181, by decide⟩ := by
  have _previous := row_69_180
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨69, by decide⟩) (orbitCodeOfNumber ⟨181, by decide⟩) 2 4 6)

theorem row_69_182 : RowResult ⟨69, by decide⟩ ⟨182, by decide⟩ := by
  have _previous := row_69_181
  exact Or.inr ⟨orbitCodeOfNumber ⟨237, by decide⟩, by decide⟩

theorem row_69_183 : RowResult ⟨69, by decide⟩ ⟨183, by decide⟩ := by
  have _previous := row_69_182
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_69_184 : RowResult ⟨69, by decide⟩ ⟨184, by decide⟩ := by
  have _previous := row_69_183
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨69, by decide⟩) (orbitCodeOfNumber ⟨184, by decide⟩) 2 5 6)

end RelativeConicArcs.Q25PairCertificate
