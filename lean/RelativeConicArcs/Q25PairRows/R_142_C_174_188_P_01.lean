import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_142_174 : RowResult ⟨142, by decide⟩ ⟨174, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_142_175 : RowResult ⟨142, by decide⟩ ⟨175, by decide⟩ := by
  have _previous := row_142_174
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨142, by decide⟩) (orbitCodeOfNumber ⟨175, by decide⟩) 1 6 7)

theorem row_142_176 : RowResult ⟨142, by decide⟩ ⟨176, by decide⟩ := by
  have _previous := row_142_175
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨142, by decide⟩) (orbitCodeOfNumber ⟨176, by decide⟩) 1 6 7)

theorem row_142_177 : RowResult ⟨142, by decide⟩ ⟨177, by decide⟩ := by
  have _previous := row_142_176
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨142, by decide⟩) (orbitCodeOfNumber ⟨177, by decide⟩) 1 6 7)

theorem row_142_178 : RowResult ⟨142, by decide⟩ ⟨178, by decide⟩ := by
  have _previous := row_142_177
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨142, by decide⟩) (orbitCodeOfNumber ⟨178, by decide⟩) 1 6 7)

theorem row_142_179 : RowResult ⟨142, by decide⟩ ⟨179, by decide⟩ := by
  have _previous := row_142_178
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨142, by decide⟩) (orbitCodeOfNumber ⟨179, by decide⟩) 1 6 7)

theorem row_142_180 : RowResult ⟨142, by decide⟩ ⟨180, by decide⟩ := by
  have _previous := row_142_179
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨142, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) 1 2 6)

theorem row_142_181 : RowResult ⟨142, by decide⟩ ⟨181, by decide⟩ := by
  have _previous := row_142_180
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_142_182 : RowResult ⟨142, by decide⟩ ⟨182, by decide⟩ := by
  have _previous := row_142_181
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_142_183 : RowResult ⟨142, by decide⟩ ⟨183, by decide⟩ := by
  have _previous := row_142_182
  exact Or.inr ⟨orbitCodeOfNumber ⟨38, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_142_184 : RowResult ⟨142, by decide⟩ ⟨184, by decide⟩ := by
  have _previous := row_142_183
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨142, by decide⟩) (orbitCodeOfNumber ⟨184, by decide⟩) 2 4 7)

theorem row_142_185 : RowResult ⟨142, by decide⟩ ⟨185, by decide⟩ := by
  have _previous := row_142_184
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_142_186 : RowResult ⟨142, by decide⟩ ⟨186, by decide⟩ := by
  have _previous := row_142_185
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_142_187 : RowResult ⟨142, by decide⟩ ⟨187, by decide⟩ := by
  have _previous := row_142_186
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨142, by decide⟩) (orbitCodeOfNumber ⟨187, by decide⟩) 1 4 7)

theorem row_142_188 : RowResult ⟨142, by decide⟩ ⟨188, by decide⟩ := by
  have _previous := row_142_187
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨142, by decide⟩) (orbitCodeOfNumber ⟨188, by decide⟩) 2 3 6)

end RelativeConicArcs.Q25PairCertificate
