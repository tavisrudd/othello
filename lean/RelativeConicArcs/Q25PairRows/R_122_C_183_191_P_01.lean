import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_122_183 : RowResult ⟨122, by decide⟩ ⟨183, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨37, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_122_184 : RowResult ⟨122, by decide⟩ ⟨184, by decide⟩ := by
  have _previous := row_122_183
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩,
    orbitCodeOfNumber ⟨246, by decide⟩, by decide⟩

theorem row_122_185 : RowResult ⟨122, by decide⟩ ⟨185, by decide⟩ := by
  have _previous := row_122_184
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨122, by decide⟩) (orbitCodeOfNumber ⟨185, by decide⟩) 2 5 6)

theorem row_122_186 : RowResult ⟨122, by decide⟩ ⟨186, by decide⟩ := by
  have _previous := row_122_185
  exact Or.inr ⟨orbitCodeOfNumber ⟨37, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_122_187 : RowResult ⟨122, by decide⟩ ⟨187, by decide⟩ := by
  have _previous := row_122_186
  exact Or.inr ⟨orbitCodeOfNumber ⟨40, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_122_188 : RowResult ⟨122, by decide⟩ ⟨188, by decide⟩ := by
  have _previous := row_122_187
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨122, by decide⟩) (orbitCodeOfNumber ⟨188, by decide⟩) 2 3 6)

theorem row_122_189 : RowResult ⟨122, by decide⟩ ⟨189, by decide⟩ := by
  have _previous := row_122_188
  exact Or.inr ⟨orbitCodeOfNumber ⟨37, by decide⟩,
    orbitCodeOfNumber ⟨246, by decide⟩, by decide⟩

theorem row_122_190 : RowResult ⟨122, by decide⟩ ⟨190, by decide⟩ := by
  have _previous := row_122_189
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_122_191 : RowResult ⟨122, by decide⟩ ⟨191, by decide⟩ := by
  have _previous := row_122_190
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨122, by decide⟩) (orbitCodeOfNumber ⟨191, by decide⟩) 4 5 6)

end RelativeConicArcs.Q25PairCertificate
