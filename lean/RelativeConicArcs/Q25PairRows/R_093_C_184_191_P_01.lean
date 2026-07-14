import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_93_184 : RowResult ⟨93, by decide⟩ ⟨184, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_93_185 : RowResult ⟨93, by decide⟩ ⟨185, by decide⟩ := by
  have _previous := row_93_184
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_93_186 : RowResult ⟨93, by decide⟩ ⟨186, by decide⟩ := by
  have _previous := row_93_185
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_93_187 : RowResult ⟨93, by decide⟩ ⟨187, by decide⟩ := by
  have _previous := row_93_186
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_93_188 : RowResult ⟨93, by decide⟩ ⟨188, by decide⟩ := by
  have _previous := row_93_187
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨93, by decide⟩) (orbitCodeOfNumber ⟨188, by decide⟩) 1 4 7)

theorem row_93_189 : RowResult ⟨93, by decide⟩ ⟨189, by decide⟩ := by
  have _previous := row_93_188
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_93_190 : RowResult ⟨93, by decide⟩ ⟨190, by decide⟩ := by
  have _previous := row_93_189
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_93_191 : RowResult ⟨93, by decide⟩ ⟨191, by decide⟩ := by
  have _previous := row_93_190
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨93, by decide⟩) (orbitCodeOfNumber ⟨191, by decide⟩) 4 5 6)

end RelativeConicArcs.Q25PairCertificate
