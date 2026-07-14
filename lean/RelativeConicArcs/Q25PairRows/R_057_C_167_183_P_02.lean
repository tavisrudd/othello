import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_57_167 : RowResult ⟨57, by decide⟩ ⟨167, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_57_168 : RowResult ⟨57, by decide⟩ ⟨168, by decide⟩ := by
  have _previous := row_57_167
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨57, by decide⟩) (orbitCodeOfNumber ⟨168, by decide⟩) 2 5 7)

theorem row_57_169 : RowResult ⟨57, by decide⟩ ⟨169, by decide⟩ := by
  have _previous := row_57_168
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨57, by decide⟩) (orbitCodeOfNumber ⟨169, by decide⟩) 2 5 6)

theorem row_57_170 : RowResult ⟨57, by decide⟩ ⟨170, by decide⟩ := by
  have _previous := row_57_169
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨57, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) 1 2 7)

theorem row_57_171 : RowResult ⟨57, by decide⟩ ⟨171, by decide⟩ := by
  have _previous := row_57_170
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_57_172 : RowResult ⟨57, by decide⟩ ⟨172, by decide⟩ := by
  have _previous := row_57_171
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨57, by decide⟩) (orbitCodeOfNumber ⟨172, by decide⟩) 1 4 7)

theorem row_57_173 : RowResult ⟨57, by decide⟩ ⟨173, by decide⟩ := by
  have _previous := row_57_172
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_57_174 : RowResult ⟨57, by decide⟩ ⟨174, by decide⟩ := by
  have _previous := row_57_173
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_57_175 : RowResult ⟨57, by decide⟩ ⟨175, by decide⟩ := by
  have _previous := row_57_174
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨57, by decide⟩) (orbitCodeOfNumber ⟨175, by decide⟩) 1 6 7)

theorem row_57_176 : RowResult ⟨57, by decide⟩ ⟨176, by decide⟩ := by
  have _previous := row_57_175
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨57, by decide⟩) (orbitCodeOfNumber ⟨176, by decide⟩) 1 6 7)

theorem row_57_177 : RowResult ⟨57, by decide⟩ ⟨177, by decide⟩ := by
  have _previous := row_57_176
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨57, by decide⟩) (orbitCodeOfNumber ⟨177, by decide⟩) 1 6 7)

theorem row_57_178 : RowResult ⟨57, by decide⟩ ⟨178, by decide⟩ := by
  have _previous := row_57_177
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨57, by decide⟩) (orbitCodeOfNumber ⟨178, by decide⟩) 1 6 7)

theorem row_57_179 : RowResult ⟨57, by decide⟩ ⟨179, by decide⟩ := by
  have _previous := row_57_178
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨57, by decide⟩) (orbitCodeOfNumber ⟨179, by decide⟩) 1 6 7)

theorem row_57_180 : RowResult ⟨57, by decide⟩ ⟨180, by decide⟩ := by
  have _previous := row_57_179
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨57, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) 1 2 6)

theorem row_57_181 : RowResult ⟨57, by decide⟩ ⟨181, by decide⟩ := by
  have _previous := row_57_180
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_57_182 : RowResult ⟨57, by decide⟩ ⟨182, by decide⟩ := by
  have _previous := row_57_181
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨57, by decide⟩) (orbitCodeOfNumber ⟨182, by decide⟩) 1 4 6)

theorem row_57_183 : RowResult ⟨57, by decide⟩ ⟨183, by decide⟩ := by
  have _previous := row_57_182
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
