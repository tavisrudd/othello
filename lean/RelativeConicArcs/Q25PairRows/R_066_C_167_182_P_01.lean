import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_66_167 : RowResult ⟨66, by decide⟩ ⟨167, by decide⟩ := by
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨66, by decide⟩) (orbitCodeOfNumber ⟨167, by decide⟩) 4 5 6)

theorem row_66_168 : RowResult ⟨66, by decide⟩ ⟨168, by decide⟩ := by
  have _previous := row_66_167
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_66_169 : RowResult ⟨66, by decide⟩ ⟨169, by decide⟩ := by
  have _previous := row_66_168
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_66_170 : RowResult ⟨66, by decide⟩ ⟨170, by decide⟩ := by
  have _previous := row_66_169
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨66, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) 1 2 7)

theorem row_66_171 : RowResult ⟨66, by decide⟩ ⟨171, by decide⟩ := by
  have _previous := row_66_170
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_66_172 : RowResult ⟨66, by decide⟩ ⟨172, by decide⟩ := by
  have _previous := row_66_171
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_66_173 : RowResult ⟨66, by decide⟩ ⟨173, by decide⟩ := by
  have _previous := row_66_172
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_66_174 : RowResult ⟨66, by decide⟩ ⟨174, by decide⟩ := by
  have _previous := row_66_173
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_66_175 : RowResult ⟨66, by decide⟩ ⟨175, by decide⟩ := by
  have _previous := row_66_174
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨66, by decide⟩) (orbitCodeOfNumber ⟨175, by decide⟩) 1 6 7)

theorem row_66_176 : RowResult ⟨66, by decide⟩ ⟨176, by decide⟩ := by
  have _previous := row_66_175
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨66, by decide⟩) (orbitCodeOfNumber ⟨176, by decide⟩) 1 6 7)

theorem row_66_177 : RowResult ⟨66, by decide⟩ ⟨177, by decide⟩ := by
  have _previous := row_66_176
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨66, by decide⟩) (orbitCodeOfNumber ⟨177, by decide⟩) 1 6 7)

theorem row_66_178 : RowResult ⟨66, by decide⟩ ⟨178, by decide⟩ := by
  have _previous := row_66_177
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨66, by decide⟩) (orbitCodeOfNumber ⟨178, by decide⟩) 1 6 7)

theorem row_66_179 : RowResult ⟨66, by decide⟩ ⟨179, by decide⟩ := by
  have _previous := row_66_178
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨66, by decide⟩) (orbitCodeOfNumber ⟨179, by decide⟩) 1 6 7)

theorem row_66_180 : RowResult ⟨66, by decide⟩ ⟨180, by decide⟩ := by
  have _previous := row_66_179
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨66, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) 1 2 6)

theorem row_66_181 : RowResult ⟨66, by decide⟩ ⟨181, by decide⟩ := by
  have _previous := row_66_180
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨66, by decide⟩) (orbitCodeOfNumber ⟨181, by decide⟩) 2 4 7)

theorem row_66_182 : RowResult ⟨66, by decide⟩ ⟨182, by decide⟩ := by
  have _previous := row_66_181
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨66, by decide⟩) (orbitCodeOfNumber ⟨182, by decide⟩) 4 5 6)

end RelativeConicArcs.Q25PairCertificate
