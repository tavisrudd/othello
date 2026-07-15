import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_39_182 : RowResult ⟨39, by decide⟩ ⟨182, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨58, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_39_183 : RowResult ⟨39, by decide⟩ ⟨183, by decide⟩ := by
  have _previous := row_39_182
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_39_184 : RowResult ⟨39, by decide⟩ ⟨184, by decide⟩ := by
  have _previous := row_39_183
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_39_185 : RowResult ⟨39, by decide⟩ ⟨185, by decide⟩ := by
  have _previous := row_39_184
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_39_186 : RowResult ⟨39, by decide⟩ ⟨186, by decide⟩ := by
  have _previous := row_39_185
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_39_187 : RowResult ⟨39, by decide⟩ ⟨187, by decide⟩ := by
  have _previous := row_39_186
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨39, by decide⟩) (orbitCodeOfNumber ⟨187, by decide⟩) 4 5 6)

theorem row_39_188 : RowResult ⟨39, by decide⟩ ⟨188, by decide⟩ := by
  have _previous := row_39_187
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨39, by decide⟩) (orbitCodeOfNumber ⟨188, by decide⟩) 2 3 6)

theorem row_39_189 : RowResult ⟨39, by decide⟩ ⟨189, by decide⟩ := by
  have _previous := row_39_188
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨39, by decide⟩) (orbitCodeOfNumber ⟨189, by decide⟩) 1 4 6)

theorem row_39_190 : RowResult ⟨39, by decide⟩ ⟨190, by decide⟩ := by
  have _previous := row_39_189
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
