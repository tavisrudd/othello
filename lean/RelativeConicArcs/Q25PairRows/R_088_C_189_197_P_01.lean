import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_88_189 : RowResult ⟨88, by decide⟩ ⟨189, by decide⟩ := by
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨88, by decide⟩) (orbitCodeOfNumber ⟨189, by decide⟩) 2 5 6)

theorem row_88_190 : RowResult ⟨88, by decide⟩ ⟨190, by decide⟩ := by
  have _previous := row_88_189
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_88_191 : RowResult ⟨88, by decide⟩ ⟨191, by decide⟩ := by
  have _previous := row_88_190
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_88_192 : RowResult ⟨88, by decide⟩ ⟨192, by decide⟩ := by
  have _previous := row_88_191
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_88_193 : RowResult ⟨88, by decide⟩ ⟨193, by decide⟩ := by
  have _previous := row_88_192
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨88, by decide⟩) (orbitCodeOfNumber ⟨193, by decide⟩) 1 4 7)

theorem row_88_194 : RowResult ⟨88, by decide⟩ ⟨194, by decide⟩ := by
  have _previous := row_88_193
  exact Or.inr ⟨orbitCodeOfNumber ⟨237, by decide⟩, by decide⟩

theorem row_88_195 : RowResult ⟨88, by decide⟩ ⟨195, by decide⟩ := by
  have _previous := row_88_194
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨88, by decide⟩) (orbitCodeOfNumber ⟨195, by decide⟩) 1 2 7)

theorem row_88_196 : RowResult ⟨88, by decide⟩ ⟨196, by decide⟩ := by
  have _previous := row_88_195
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_88_197 : RowResult ⟨88, by decide⟩ ⟨197, by decide⟩ := by
  have _previous := row_88_196
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
