import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_49_138 : RowResult ⟨49, by decide⟩ ⟨138, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_49_139 : RowResult ⟨49, by decide⟩ ⟨139, by decide⟩ := by
  have _previous := row_49_138
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨49, by decide⟩) (orbitCodeOfNumber ⟨139, by decide⟩) 2 5 7)

theorem row_49_140 : RowResult ⟨49, by decide⟩ ⟨140, by decide⟩ := by
  have _previous := row_49_139
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨49, by decide⟩) (orbitCodeOfNumber ⟨140, by decide⟩) 2 4 6)

theorem row_49_141 : RowResult ⟨49, by decide⟩ ⟨141, by decide⟩ := by
  have _previous := row_49_140
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_49_142 : RowResult ⟨49, by decide⟩ ⟨142, by decide⟩ := by
  have _previous := row_49_141
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨49, by decide⟩) (orbitCodeOfNumber ⟨142, by decide⟩) 2 5 6)

theorem row_49_143 : RowResult ⟨49, by decide⟩ ⟨143, by decide⟩ := by
  have _previous := row_49_142
  exact Or.inr ⟨orbitCodeOfNumber ⟨167, by decide⟩, by decide⟩

theorem row_49_144 : RowResult ⟨49, by decide⟩ ⟨144, by decide⟩ := by
  have _previous := row_49_143
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_49_145 : RowResult ⟨49, by decide⟩ ⟨145, by decide⟩ := by
  have _previous := row_49_144
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨49, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) 1 2 7)

theorem row_49_146 : RowResult ⟨49, by decide⟩ ⟨146, by decide⟩ := by
  have _previous := row_49_145
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_49_147 : RowResult ⟨49, by decide⟩ ⟨147, by decide⟩ := by
  have _previous := row_49_146
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_49_148 : RowResult ⟨49, by decide⟩ ⟨148, by decide⟩ := by
  have _previous := row_49_147
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨49, by decide⟩) (orbitCodeOfNumber ⟨148, by decide⟩) 4 5 6)

theorem row_49_149 : RowResult ⟨49, by decide⟩ ⟨149, by decide⟩ := by
  have _previous := row_49_148
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨49, by decide⟩) (orbitCodeOfNumber ⟨149, by decide⟩) 1 4 6)

end RelativeConicArcs.Q25PairCertificate
