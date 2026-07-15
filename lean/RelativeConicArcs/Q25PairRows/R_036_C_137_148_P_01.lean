import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_36_137 : RowResult ⟨36, by decide⟩ ⟨137, by decide⟩ := by
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨36, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) 2 3 6)

theorem row_36_138 : RowResult ⟨36, by decide⟩ ⟨138, by decide⟩ := by
  have _previous := row_36_137
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨36, by decide⟩) (orbitCodeOfNumber ⟨138, by decide⟩) 4 5 6)

theorem row_36_139 : RowResult ⟨36, by decide⟩ ⟨139, by decide⟩ := by
  have _previous := row_36_138
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_36_140 : RowResult ⟨36, by decide⟩ ⟨140, by decide⟩ := by
  have _previous := row_36_139
  exact Or.inr ⟨orbitCodeOfNumber ⟨58, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_36_141 : RowResult ⟨36, by decide⟩ ⟨141, by decide⟩ := by
  have _previous := row_36_140
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨36, by decide⟩) (orbitCodeOfNumber ⟨141, by decide⟩) 1 4 7)

theorem row_36_142 : RowResult ⟨36, by decide⟩ ⟨142, by decide⟩ := by
  have _previous := row_36_141
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_36_143 : RowResult ⟨36, by decide⟩ ⟨143, by decide⟩ := by
  have _previous := row_36_142
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨36, by decide⟩) (orbitCodeOfNumber ⟨143, by decide⟩) 2 4 6)

theorem row_36_144 : RowResult ⟨36, by decide⟩ ⟨144, by decide⟩ := by
  have _previous := row_36_143
  exact Or.inr ⟨orbitCodeOfNumber ⟨63, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_36_145 : RowResult ⟨36, by decide⟩ ⟨145, by decide⟩ := by
  have _previous := row_36_144
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨36, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) 1 2 7)

theorem row_36_146 : RowResult ⟨36, by decide⟩ ⟨146, by decide⟩ := by
  have _previous := row_36_145
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_36_147 : RowResult ⟨36, by decide⟩ ⟨147, by decide⟩ := by
  have _previous := row_36_146
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_36_148 : RowResult ⟨36, by decide⟩ ⟨148, by decide⟩ := by
  have _previous := row_36_147
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨36, by decide⟩) (orbitCodeOfNumber ⟨148, by decide⟩) 2 5 7)

end RelativeConicArcs.Q25PairCertificate
