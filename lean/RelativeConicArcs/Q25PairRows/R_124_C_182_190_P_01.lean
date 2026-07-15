import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_124_182 : RowResult ⟨124, by decide⟩ ⟨182, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨36, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_124_183 : RowResult ⟨124, by decide⟩ ⟨183, by decide⟩ := by
  have _previous := row_124_182
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_124_184 : RowResult ⟨124, by decide⟩ ⟨184, by decide⟩ := by
  have _previous := row_124_183
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨124, by decide⟩) (orbitCodeOfNumber ⟨184, by decide⟩) 1 4 7)

theorem row_124_185 : RowResult ⟨124, by decide⟩ ⟨185, by decide⟩ := by
  have _previous := row_124_184
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_124_186 : RowResult ⟨124, by decide⟩ ⟨186, by decide⟩ := by
  have _previous := row_124_185
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_124_187 : RowResult ⟨124, by decide⟩ ⟨187, by decide⟩ := by
  have _previous := row_124_186
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_124_188 : RowResult ⟨124, by decide⟩ ⟨188, by decide⟩ := by
  have _previous := row_124_187
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨124, by decide⟩) (orbitCodeOfNumber ⟨188, by decide⟩) 2 3 6)

theorem row_124_189 : RowResult ⟨124, by decide⟩ ⟨189, by decide⟩ := by
  have _previous := row_124_188
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨243, by decide⟩, by decide⟩

theorem row_124_190 : RowResult ⟨124, by decide⟩ ⟨190, by decide⟩ := by
  have _previous := row_124_189
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨124, by decide⟩) (orbitCodeOfNumber ⟨190, by decide⟩) 2 5 6)

end RelativeConicArcs.Q25PairCertificate
