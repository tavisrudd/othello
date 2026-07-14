import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_63_173 : RowResult ⟨63, by decide⟩ ⟨173, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

theorem row_63_174 : RowResult ⟨63, by decide⟩ ⟨174, by decide⟩ := by
  have _previous := row_63_173
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨63, by decide⟩) (orbitCodeOfNumber ⟨174, by decide⟩) 2 4 6)

theorem row_63_175 : RowResult ⟨63, by decide⟩ ⟨175, by decide⟩ := by
  have _previous := row_63_174
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨63, by decide⟩) (orbitCodeOfNumber ⟨175, by decide⟩) 1 6 7)

theorem row_63_176 : RowResult ⟨63, by decide⟩ ⟨176, by decide⟩ := by
  have _previous := row_63_175
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨63, by decide⟩) (orbitCodeOfNumber ⟨176, by decide⟩) 1 6 7)

theorem row_63_177 : RowResult ⟨63, by decide⟩ ⟨177, by decide⟩ := by
  have _previous := row_63_176
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨63, by decide⟩) (orbitCodeOfNumber ⟨177, by decide⟩) 1 6 7)

theorem row_63_178 : RowResult ⟨63, by decide⟩ ⟨178, by decide⟩ := by
  have _previous := row_63_177
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨63, by decide⟩) (orbitCodeOfNumber ⟨178, by decide⟩) 1 6 7)

theorem row_63_179 : RowResult ⟨63, by decide⟩ ⟨179, by decide⟩ := by
  have _previous := row_63_178
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨63, by decide⟩) (orbitCodeOfNumber ⟨179, by decide⟩) 1 6 7)

theorem row_63_180 : RowResult ⟨63, by decide⟩ ⟨180, by decide⟩ := by
  have _previous := row_63_179
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨63, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) 1 2 6)

theorem row_63_181 : RowResult ⟨63, by decide⟩ ⟨181, by decide⟩ := by
  have _previous := row_63_180
  exact Or.inr ⟨orbitCodeOfNumber ⟨237, by decide⟩, by decide⟩

theorem row_63_182 : RowResult ⟨63, by decide⟩ ⟨182, by decide⟩ := by
  have _previous := row_63_181
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_63_183 : RowResult ⟨63, by decide⟩ ⟨183, by decide⟩ := by
  have _previous := row_63_182
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨63, by decide⟩) (orbitCodeOfNumber ⟨183, by decide⟩) 2 5 6)

theorem row_63_184 : RowResult ⟨63, by decide⟩ ⟨184, by decide⟩ := by
  have _previous := row_63_183
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_63_185 : RowResult ⟨63, by decide⟩ ⟨185, by decide⟩ := by
  have _previous := row_63_184
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨63, by decide⟩) (orbitCodeOfNumber ⟨185, by decide⟩) 2 5 7)

theorem row_63_186 : RowResult ⟨63, by decide⟩ ⟨186, by decide⟩ := by
  have _previous := row_63_185
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨63, by decide⟩) (orbitCodeOfNumber ⟨186, by decide⟩) 2 4 6)

theorem row_63_187 : RowResult ⟨63, by decide⟩ ⟨187, by decide⟩ := by
  have _previous := row_63_186
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_63_188 : RowResult ⟨63, by decide⟩ ⟨188, by decide⟩ := by
  have _previous := row_63_187
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨63, by decide⟩) (orbitCodeOfNumber ⟨188, by decide⟩) 1 4 6)

theorem row_63_189 : RowResult ⟨63, by decide⟩ ⟨189, by decide⟩ := by
  have _previous := row_63_188
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
