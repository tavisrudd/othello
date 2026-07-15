import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_43_183 : RowResult ⟨43, by decide⟩ ⟨183, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_43_184 : RowResult ⟨43, by decide⟩ ⟨184, by decide⟩ := by
  have _previous := row_43_183
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_43_185 : RowResult ⟨43, by decide⟩ ⟨185, by decide⟩ := by
  have _previous := row_43_184
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_43_186 : RowResult ⟨43, by decide⟩ ⟨186, by decide⟩ := by
  have _previous := row_43_185
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_43_187 : RowResult ⟨43, by decide⟩ ⟨187, by decide⟩ := by
  have _previous := row_43_186
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨43, by decide⟩) (orbitCodeOfNumber ⟨187, by decide⟩) 2 5 7)

theorem row_43_188 : RowResult ⟨43, by decide⟩ ⟨188, by decide⟩ := by
  have _previous := row_43_187
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨43, by decide⟩) (orbitCodeOfNumber ⟨188, by decide⟩) 1 4 7)

theorem row_43_189 : RowResult ⟨43, by decide⟩ ⟨189, by decide⟩ := by
  have _previous := row_43_188
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_43_190 : RowResult ⟨43, by decide⟩ ⟨190, by decide⟩ := by
  have _previous := row_43_189
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨43, by decide⟩) (orbitCodeOfNumber ⟨190, by decide⟩) 4 5 6)

theorem row_43_191 : RowResult ⟨43, by decide⟩ ⟨191, by decide⟩ := by
  have _previous := row_43_190
  exact Or.inr ⟨orbitCodeOfNumber ⟨58, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_43_192 : RowResult ⟨43, by decide⟩ ⟨192, by decide⟩ := by
  have _previous := row_43_191
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨43, by decide⟩) (orbitCodeOfNumber ⟨192, by decide⟩) 2 4 7)

theorem row_43_193 : RowResult ⟨43, by decide⟩ ⟨193, by decide⟩ := by
  have _previous := row_43_192
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨43, by decide⟩) (orbitCodeOfNumber ⟨193, by decide⟩) 1 4 6)

end RelativeConicArcs.Q25PairCertificate
