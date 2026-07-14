import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_44_172 : RowResult ⟨44, by decide⟩ ⟨172, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_44_173 : RowResult ⟨44, by decide⟩ ⟨173, by decide⟩ := by
  have _previous := row_44_172
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_44_174 : RowResult ⟨44, by decide⟩ ⟨174, by decide⟩ := by
  have _previous := row_44_173
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨44, by decide⟩) (orbitCodeOfNumber ⟨174, by decide⟩) 2 5 6)

theorem row_44_175 : RowResult ⟨44, by decide⟩ ⟨175, by decide⟩ := by
  have _previous := row_44_174
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨44, by decide⟩) (orbitCodeOfNumber ⟨175, by decide⟩) 1 6 7)

theorem row_44_176 : RowResult ⟨44, by decide⟩ ⟨176, by decide⟩ := by
  have _previous := row_44_175
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨44, by decide⟩) (orbitCodeOfNumber ⟨176, by decide⟩) 1 6 7)

theorem row_44_177 : RowResult ⟨44, by decide⟩ ⟨177, by decide⟩ := by
  have _previous := row_44_176
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨44, by decide⟩) (orbitCodeOfNumber ⟨177, by decide⟩) 1 6 7)

theorem row_44_178 : RowResult ⟨44, by decide⟩ ⟨178, by decide⟩ := by
  have _previous := row_44_177
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨44, by decide⟩) (orbitCodeOfNumber ⟨178, by decide⟩) 1 6 7)

theorem row_44_179 : RowResult ⟨44, by decide⟩ ⟨179, by decide⟩ := by
  have _previous := row_44_178
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨44, by decide⟩) (orbitCodeOfNumber ⟨179, by decide⟩) 1 6 7)

theorem row_44_180 : RowResult ⟨44, by decide⟩ ⟨180, by decide⟩ := by
  have _previous := row_44_179
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨44, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) 1 2 6)

theorem row_44_181 : RowResult ⟨44, by decide⟩ ⟨181, by decide⟩ := by
  have _previous := row_44_180
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_44_182 : RowResult ⟨44, by decide⟩ ⟨182, by decide⟩ := by
  have _previous := row_44_181
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_44_183 : RowResult ⟨44, by decide⟩ ⟨183, by decide⟩ := by
  have _previous := row_44_182
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_44_184 : RowResult ⟨44, by decide⟩ ⟨184, by decide⟩ := by
  have _previous := row_44_183
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
