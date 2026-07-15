import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_38_173 : RowResult ⟨38, by decide⟩ ⟨173, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨62, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_38_174 : RowResult ⟨38, by decide⟩ ⟨174, by decide⟩ := by
  have _previous := row_38_173
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_38_175 : RowResult ⟨38, by decide⟩ ⟨175, by decide⟩ := by
  have _previous := row_38_174
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨38, by decide⟩) (orbitCodeOfNumber ⟨175, by decide⟩) 1 6 7)

theorem row_38_176 : RowResult ⟨38, by decide⟩ ⟨176, by decide⟩ := by
  have _previous := row_38_175
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨38, by decide⟩) (orbitCodeOfNumber ⟨176, by decide⟩) 1 6 7)

theorem row_38_177 : RowResult ⟨38, by decide⟩ ⟨177, by decide⟩ := by
  have _previous := row_38_176
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨38, by decide⟩) (orbitCodeOfNumber ⟨177, by decide⟩) 1 6 7)

theorem row_38_178 : RowResult ⟨38, by decide⟩ ⟨178, by decide⟩ := by
  have _previous := row_38_177
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨38, by decide⟩) (orbitCodeOfNumber ⟨178, by decide⟩) 1 6 7)

theorem row_38_179 : RowResult ⟨38, by decide⟩ ⟨179, by decide⟩ := by
  have _previous := row_38_178
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨38, by decide⟩) (orbitCodeOfNumber ⟨179, by decide⟩) 1 6 7)

theorem row_38_180 : RowResult ⟨38, by decide⟩ ⟨180, by decide⟩ := by
  have _previous := row_38_179
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨38, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) 1 2 6)

theorem row_38_181 : RowResult ⟨38, by decide⟩ ⟨181, by decide⟩ := by
  have _previous := row_38_180
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨38, by decide⟩) (orbitCodeOfNumber ⟨181, by decide⟩) 2 5 7)

theorem row_38_182 : RowResult ⟨38, by decide⟩ ⟨182, by decide⟩ := by
  have _previous := row_38_181
  exact Or.inr ⟨orbitCodeOfNumber ⟨58, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_38_183 : RowResult ⟨38, by decide⟩ ⟨183, by decide⟩ := by
  have _previous := row_38_182
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_38_184 : RowResult ⟨38, by decide⟩ ⟨184, by decide⟩ := by
  have _previous := row_38_183
  exact Or.inr ⟨orbitCodeOfNumber ⟨58, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_38_185 : RowResult ⟨38, by decide⟩ ⟨185, by decide⟩ := by
  have _previous := row_38_184
  exact Or.inr ⟨orbitCodeOfNumber ⟨61, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_38_186 : RowResult ⟨38, by decide⟩ ⟨186, by decide⟩ := by
  have _previous := row_38_185
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨38, by decide⟩) (orbitCodeOfNumber ⟨186, by decide⟩) 4 5 6)

end RelativeConicArcs.Q25PairCertificate
