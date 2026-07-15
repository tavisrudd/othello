import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_33_171 : RowResult ⟨33, by decide⟩ ⟨171, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_33_172 : RowResult ⟨33, by decide⟩ ⟨172, by decide⟩ := by
  have _previous := row_33_171
  exact Or.inr ⟨orbitCodeOfNumber ⟨61, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_33_173 : RowResult ⟨33, by decide⟩ ⟨173, by decide⟩ := by
  have _previous := row_33_172
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨33, by decide⟩) (orbitCodeOfNumber ⟨173, by decide⟩) 1 4 7)

theorem row_33_174 : RowResult ⟨33, by decide⟩ ⟨174, by decide⟩ := by
  have _previous := row_33_173
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_33_175 : RowResult ⟨33, by decide⟩ ⟨175, by decide⟩ := by
  have _previous := row_33_174
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨33, by decide⟩) (orbitCodeOfNumber ⟨175, by decide⟩) 1 6 7)

theorem row_33_176 : RowResult ⟨33, by decide⟩ ⟨176, by decide⟩ := by
  have _previous := row_33_175
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨33, by decide⟩) (orbitCodeOfNumber ⟨176, by decide⟩) 1 6 7)

theorem row_33_177 : RowResult ⟨33, by decide⟩ ⟨177, by decide⟩ := by
  have _previous := row_33_176
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨33, by decide⟩) (orbitCodeOfNumber ⟨177, by decide⟩) 1 6 7)

theorem row_33_178 : RowResult ⟨33, by decide⟩ ⟨178, by decide⟩ := by
  have _previous := row_33_177
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨33, by decide⟩) (orbitCodeOfNumber ⟨178, by decide⟩) 1 6 7)

theorem row_33_179 : RowResult ⟨33, by decide⟩ ⟨179, by decide⟩ := by
  have _previous := row_33_178
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨33, by decide⟩) (orbitCodeOfNumber ⟨179, by decide⟩) 1 6 7)

theorem row_33_180 : RowResult ⟨33, by decide⟩ ⟨180, by decide⟩ := by
  have _previous := row_33_179
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨33, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) 1 2 6)

theorem row_33_181 : RowResult ⟨33, by decide⟩ ⟨181, by decide⟩ := by
  have _previous := row_33_180
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨33, by decide⟩) (orbitCodeOfNumber ⟨181, by decide⟩) 2 5 6)

theorem row_33_182 : RowResult ⟨33, by decide⟩ ⟨182, by decide⟩ := by
  have _previous := row_33_181
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨33, by decide⟩) (orbitCodeOfNumber ⟨182, by decide⟩) 4 5 6)

theorem row_33_183 : RowResult ⟨33, by decide⟩ ⟨183, by decide⟩ := by
  have _previous := row_33_182
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨33, by decide⟩) (orbitCodeOfNumber ⟨183, by decide⟩) 1 4 6)

theorem row_33_184 : RowResult ⟨33, by decide⟩ ⟨184, by decide⟩ := by
  have _previous := row_33_183
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_33_185 : RowResult ⟨33, by decide⟩ ⟨185, by decide⟩ := by
  have _previous := row_33_184
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨246, by decide⟩, by decide⟩

theorem row_33_186 : RowResult ⟨33, by decide⟩ ⟨186, by decide⟩ := by
  have _previous := row_33_185
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨33, by decide⟩) (orbitCodeOfNumber ⟨186, by decide⟩) 2 4 7)

theorem row_33_187 : RowResult ⟨33, by decide⟩ ⟨187, by decide⟩ := by
  have _previous := row_33_186
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_33_188 : RowResult ⟨33, by decide⟩ ⟨188, by decide⟩ := by
  have _previous := row_33_187
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨33, by decide⟩) (orbitCodeOfNumber ⟨188, by decide⟩) 2 3 6)

end RelativeConicArcs.Q25PairCertificate
