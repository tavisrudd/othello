import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_136_182 : RowResult ⟨136, by decide⟩ ⟨182, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_136_183 : RowResult ⟨136, by decide⟩ ⟨183, by decide⟩ := by
  have _previous := row_136_182
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_136_184 : RowResult ⟨136, by decide⟩ ⟨184, by decide⟩ := by
  have _previous := row_136_183
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_136_185 : RowResult ⟨136, by decide⟩ ⟨185, by decide⟩ := by
  have _previous := row_136_184
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_136_186 : RowResult ⟨136, by decide⟩ ⟨186, by decide⟩ := by
  have _previous := row_136_185
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨136, by decide⟩) (orbitCodeOfNumber ⟨186, by decide⟩) 1 4 6)

theorem row_136_187 : RowResult ⟨136, by decide⟩ ⟨187, by decide⟩ := by
  have _previous := row_136_186
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨136, by decide⟩) (orbitCodeOfNumber ⟨187, by decide⟩) 4 5 6)

theorem row_136_188 : RowResult ⟨136, by decide⟩ ⟨188, by decide⟩ := by
  have _previous := row_136_187
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨136, by decide⟩) (orbitCodeOfNumber ⟨188, by decide⟩) 2 3 6)

theorem row_136_189 : RowResult ⟨136, by decide⟩ ⟨189, by decide⟩ := by
  have _previous := row_136_188
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_136_190 : RowResult ⟨136, by decide⟩ ⟨190, by decide⟩ := by
  have _previous := row_136_189
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_136_191 : RowResult ⟨136, by decide⟩ ⟨191, by decide⟩ := by
  have _previous := row_136_190
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨136, by decide⟩) (orbitCodeOfNumber ⟨191, by decide⟩) 1 4 7)

end RelativeConicArcs.Q25PairCertificate
