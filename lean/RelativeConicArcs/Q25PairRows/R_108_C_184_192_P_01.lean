import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_108_184 : RowResult ⟨108, by decide⟩ ⟨184, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_108_185 : RowResult ⟨108, by decide⟩ ⟨185, by decide⟩ := by
  have _previous := row_108_184
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_108_186 : RowResult ⟨108, by decide⟩ ⟨186, by decide⟩ := by
  have _previous := row_108_185
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_108_187 : RowResult ⟨108, by decide⟩ ⟨187, by decide⟩ := by
  have _previous := row_108_186
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨108, by decide⟩) (orbitCodeOfNumber ⟨187, by decide⟩) 2 5 7)

theorem row_108_188 : RowResult ⟨108, by decide⟩ ⟨188, by decide⟩ := by
  have _previous := row_108_187
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨108, by decide⟩) (orbitCodeOfNumber ⟨188, by decide⟩) 2 3 6)

theorem row_108_189 : RowResult ⟨108, by decide⟩ ⟨189, by decide⟩ := by
  have _previous := row_108_188
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨108, by decide⟩) (orbitCodeOfNumber ⟨189, by decide⟩) 4 5 6)

theorem row_108_190 : RowResult ⟨108, by decide⟩ ⟨190, by decide⟩ := by
  have _previous := row_108_189
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_108_191 : RowResult ⟨108, by decide⟩ ⟨191, by decide⟩ := by
  have _previous := row_108_190
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_108_192 : RowResult ⟨108, by decide⟩ ⟨192, by decide⟩ := by
  have _previous := row_108_191
  exact Or.inr ⟨orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
