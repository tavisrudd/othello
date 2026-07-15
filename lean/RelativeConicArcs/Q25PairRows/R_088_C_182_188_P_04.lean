import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_88_182 : RowResult ⟨88, by decide⟩ ⟨182, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_88_183 : RowResult ⟨88, by decide⟩ ⟨183, by decide⟩ := by
  have _previous := row_88_182
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_88_184 : RowResult ⟨88, by decide⟩ ⟨184, by decide⟩ := by
  have _previous := row_88_183
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_88_185 : RowResult ⟨88, by decide⟩ ⟨185, by decide⟩ := by
  have _previous := row_88_184
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨88, by decide⟩) (orbitCodeOfNumber ⟨185, by decide⟩) 4 5 6)

theorem row_88_186 : RowResult ⟨88, by decide⟩ ⟨186, by decide⟩ := by
  have _previous := row_88_185
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_88_187 : RowResult ⟨88, by decide⟩ ⟨187, by decide⟩ := by
  have _previous := row_88_186
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_88_188 : RowResult ⟨88, by decide⟩ ⟨188, by decide⟩ := by
  have _previous := row_88_187
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨88, by decide⟩) (orbitCodeOfNumber ⟨188, by decide⟩) 1 4 6)

end RelativeConicArcs.Q25PairCertificate
