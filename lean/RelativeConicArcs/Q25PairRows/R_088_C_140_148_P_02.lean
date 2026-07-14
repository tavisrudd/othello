import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_88_140 : RowResult ⟨88, by decide⟩ ⟨140, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_88_141 : RowResult ⟨88, by decide⟩ ⟨141, by decide⟩ := by
  have _previous := row_88_140
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_88_142 : RowResult ⟨88, by decide⟩ ⟨142, by decide⟩ := by
  have _previous := row_88_141
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_88_143 : RowResult ⟨88, by decide⟩ ⟨143, by decide⟩ := by
  have _previous := row_88_142
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨88, by decide⟩) (orbitCodeOfNumber ⟨143, by decide⟩) 1 4 7)

theorem row_88_144 : RowResult ⟨88, by decide⟩ ⟨144, by decide⟩ := by
  have _previous := row_88_143
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_88_145 : RowResult ⟨88, by decide⟩ ⟨145, by decide⟩ := by
  have _previous := row_88_144
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨88, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) 1 2 7)

theorem row_88_146 : RowResult ⟨88, by decide⟩ ⟨146, by decide⟩ := by
  have _previous := row_88_145
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_88_147 : RowResult ⟨88, by decide⟩ ⟨147, by decide⟩ := by
  have _previous := row_88_146
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨88, by decide⟩) (orbitCodeOfNumber ⟨147, by decide⟩) 2 4 6)

theorem row_88_148 : RowResult ⟨88, by decide⟩ ⟨148, by decide⟩ := by
  have _previous := row_88_147
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
