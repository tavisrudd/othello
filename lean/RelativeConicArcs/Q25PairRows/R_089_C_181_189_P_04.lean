import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_89_181 : RowResult ⟨89, by decide⟩ ⟨181, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨36, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_89_182 : RowResult ⟨89, by decide⟩ ⟨182, by decide⟩ := by
  have _previous := row_89_181
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_89_183 : RowResult ⟨89, by decide⟩ ⟨183, by decide⟩ := by
  have _previous := row_89_182
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨89, by decide⟩) (orbitCodeOfNumber ⟨183, by decide⟩) 2 5 7)

theorem row_89_184 : RowResult ⟨89, by decide⟩ ⟨184, by decide⟩ := by
  have _previous := row_89_183
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_89_185 : RowResult ⟨89, by decide⟩ ⟨185, by decide⟩ := by
  have _previous := row_89_184
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_89_186 : RowResult ⟨89, by decide⟩ ⟨186, by decide⟩ := by
  have _previous := row_89_185
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨89, by decide⟩) (orbitCodeOfNumber ⟨186, by decide⟩) 4 5 6)

theorem row_89_187 : RowResult ⟨89, by decide⟩ ⟨187, by decide⟩ := by
  have _previous := row_89_186
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨89, by decide⟩) (orbitCodeOfNumber ⟨187, by decide⟩) 2 5 6)

theorem row_89_188 : RowResult ⟨89, by decide⟩ ⟨188, by decide⟩ := by
  have _previous := row_89_187
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨89, by decide⟩) (orbitCodeOfNumber ⟨188, by decide⟩) 2 3 6)

theorem row_89_189 : RowResult ⟨89, by decide⟩ ⟨189, by decide⟩ := by
  have _previous := row_89_188
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨89, by decide⟩) (orbitCodeOfNumber ⟨189, by decide⟩) 1 4 6)

end RelativeConicArcs.Q25PairCertificate
