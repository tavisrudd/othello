import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_94_138 : RowResult ⟨94, by decide⟩ ⟨138, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_94_139 : RowResult ⟨94, by decide⟩ ⟨139, by decide⟩ := by
  have _previous := row_94_138
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨94, by decide⟩) (orbitCodeOfNumber ⟨139, by decide⟩) 1 4 7)

theorem row_94_140 : RowResult ⟨94, by decide⟩ ⟨140, by decide⟩ := by
  have _previous := row_94_139
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_94_141 : RowResult ⟨94, by decide⟩ ⟨141, by decide⟩ := by
  have _previous := row_94_140
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_94_142 : RowResult ⟨94, by decide⟩ ⟨142, by decide⟩ := by
  have _previous := row_94_141
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨94, by decide⟩) (orbitCodeOfNumber ⟨142, by decide⟩) 2 5 6)

theorem row_94_143 : RowResult ⟨94, by decide⟩ ⟨143, by decide⟩ := by
  have _previous := row_94_142
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨94, by decide⟩) (orbitCodeOfNumber ⟨143, by decide⟩) 4 5 6)

theorem row_94_144 : RowResult ⟨94, by decide⟩ ⟨144, by decide⟩ := by
  have _previous := row_94_143
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨94, by decide⟩) (orbitCodeOfNumber ⟨144, by decide⟩) 1 4 6)

theorem row_94_145 : RowResult ⟨94, by decide⟩ ⟨145, by decide⟩ := by
  have _previous := row_94_144
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨94, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) 1 2 7)

theorem row_94_146 : RowResult ⟨94, by decide⟩ ⟨146, by decide⟩ := by
  have _previous := row_94_145
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_94_147 : RowResult ⟨94, by decide⟩ ⟨147, by decide⟩ := by
  have _previous := row_94_146
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨242, by decide⟩, by decide⟩

theorem row_94_148 : RowResult ⟨94, by decide⟩ ⟨148, by decide⟩ := by
  have _previous := row_94_147
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨246, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
