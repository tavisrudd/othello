import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_132_183 : RowResult ⟨132, by decide⟩ ⟨183, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_132_184 : RowResult ⟨132, by decide⟩ ⟨184, by decide⟩ := by
  have _previous := row_132_183
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_132_185 : RowResult ⟨132, by decide⟩ ⟨185, by decide⟩ := by
  have _previous := row_132_184
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_132_186 : RowResult ⟨132, by decide⟩ ⟨186, by decide⟩ := by
  have _previous := row_132_185
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_132_187 : RowResult ⟨132, by decide⟩ ⟨187, by decide⟩ := by
  have _previous := row_132_186
  exact Or.inr ⟨orbitCodeOfNumber ⟨116, by decide⟩, by decide⟩

theorem row_132_188 : RowResult ⟨132, by decide⟩ ⟨188, by decide⟩ := by
  have _previous := row_132_187
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨132, by decide⟩) (orbitCodeOfNumber ⟨188, by decide⟩) 2 3 6)

theorem row_132_189 : RowResult ⟨132, by decide⟩ ⟨189, by decide⟩ := by
  have _previous := row_132_188
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
