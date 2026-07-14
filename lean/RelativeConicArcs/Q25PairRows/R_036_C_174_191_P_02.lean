import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_36_174 : RowResult ⟨36, by decide⟩ ⟨174, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_36_175 : RowResult ⟨36, by decide⟩ ⟨175, by decide⟩ := by
  have _previous := row_36_174
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨36, by decide⟩) (orbitCodeOfNumber ⟨175, by decide⟩) 1 6 7)

theorem row_36_176 : RowResult ⟨36, by decide⟩ ⟨176, by decide⟩ := by
  have _previous := row_36_175
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨36, by decide⟩) (orbitCodeOfNumber ⟨176, by decide⟩) 1 6 7)

theorem row_36_177 : RowResult ⟨36, by decide⟩ ⟨177, by decide⟩ := by
  have _previous := row_36_176
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨36, by decide⟩) (orbitCodeOfNumber ⟨177, by decide⟩) 1 6 7)

theorem row_36_178 : RowResult ⟨36, by decide⟩ ⟨178, by decide⟩ := by
  have _previous := row_36_177
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨36, by decide⟩) (orbitCodeOfNumber ⟨178, by decide⟩) 1 6 7)

theorem row_36_179 : RowResult ⟨36, by decide⟩ ⟨179, by decide⟩ := by
  have _previous := row_36_178
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨36, by decide⟩) (orbitCodeOfNumber ⟨179, by decide⟩) 1 6 7)

theorem row_36_180 : RowResult ⟨36, by decide⟩ ⟨180, by decide⟩ := by
  have _previous := row_36_179
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨36, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) 1 2 6)

theorem row_36_181 : RowResult ⟨36, by decide⟩ ⟨181, by decide⟩ := by
  have _previous := row_36_180
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_36_182 : RowResult ⟨36, by decide⟩ ⟨182, by decide⟩ := by
  have _previous := row_36_181
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_36_183 : RowResult ⟨36, by decide⟩ ⟨183, by decide⟩ := by
  have _previous := row_36_182
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_36_184 : RowResult ⟨36, by decide⟩ ⟨184, by decide⟩ := by
  have _previous := row_36_183
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨36, by decide⟩) (orbitCodeOfNumber ⟨184, by decide⟩) 2 4 6)

theorem row_36_185 : RowResult ⟨36, by decide⟩ ⟨185, by decide⟩ := by
  have _previous := row_36_184
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_36_186 : RowResult ⟨36, by decide⟩ ⟨186, by decide⟩ := by
  have _previous := row_36_185
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨36, by decide⟩) (orbitCodeOfNumber ⟨186, by decide⟩) 1 4 6)

theorem row_36_187 : RowResult ⟨36, by decide⟩ ⟨187, by decide⟩ := by
  have _previous := row_36_186
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_36_188 : RowResult ⟨36, by decide⟩ ⟨188, by decide⟩ := by
  have _previous := row_36_187
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨36, by decide⟩) (orbitCodeOfNumber ⟨188, by decide⟩) 2 3 6)

theorem row_36_189 : RowResult ⟨36, by decide⟩ ⟨189, by decide⟩ := by
  have _previous := row_36_188
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨36, by decide⟩) (orbitCodeOfNumber ⟨189, by decide⟩) 4 5 6)

theorem row_36_190 : RowResult ⟨36, by decide⟩ ⟨190, by decide⟩ := by
  have _previous := row_36_189
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨36, by decide⟩) (orbitCodeOfNumber ⟨190, by decide⟩) 2 4 7)

theorem row_36_191 : RowResult ⟨36, by decide⟩ ⟨191, by decide⟩ := by
  have _previous := row_36_190
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨36, by decide⟩) (orbitCodeOfNumber ⟨191, by decide⟩) 1 4 7)

end RelativeConicArcs.Q25PairCertificate
