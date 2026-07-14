import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_98_140 : RowResult ⟨98, by decide⟩ ⟨140, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_98_141 : RowResult ⟨98, by decide⟩ ⟨141, by decide⟩ := by
  have _previous := row_98_140
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨98, by decide⟩) (orbitCodeOfNumber ⟨141, by decide⟩) 2 4 7)

theorem row_98_142 : RowResult ⟨98, by decide⟩ ⟨142, by decide⟩ := by
  have _previous := row_98_141
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_98_143 : RowResult ⟨98, by decide⟩ ⟨143, by decide⟩ := by
  have _previous := row_98_142
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨98, by decide⟩) (orbitCodeOfNumber ⟨143, by decide⟩) 2 5 6)

theorem row_98_144 : RowResult ⟨98, by decide⟩ ⟨144, by decide⟩ := by
  have _previous := row_98_143
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_98_145 : RowResult ⟨98, by decide⟩ ⟨145, by decide⟩ := by
  have _previous := row_98_144
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨98, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) 1 2 7)

theorem row_98_146 : RowResult ⟨98, by decide⟩ ⟨146, by decide⟩ := by
  have _previous := row_98_145
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨98, by decide⟩) (orbitCodeOfNumber ⟨146, by decide⟩) 2 4 6)

theorem row_98_147 : RowResult ⟨98, by decide⟩ ⟨147, by decide⟩ := by
  have _previous := row_98_146
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_98_148 : RowResult ⟨98, by decide⟩ ⟨148, by decide⟩ := by
  have _previous := row_98_147
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨98, by decide⟩) (orbitCodeOfNumber ⟨148, by decide⟩) 1 4 6)

theorem row_98_149 : RowResult ⟨98, by decide⟩ ⟨149, by decide⟩ := by
  have _previous := row_98_148
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_98_150 : RowResult ⟨98, by decide⟩ ⟨150, by decide⟩ := by
  have _previous := row_98_149
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨98, by decide⟩) (orbitCodeOfNumber ⟨150, by decide⟩) 1 6 7)

theorem row_98_151 : RowResult ⟨98, by decide⟩ ⟨151, by decide⟩ := by
  have _previous := row_98_150
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨98, by decide⟩) (orbitCodeOfNumber ⟨151, by decide⟩) 1 6 7)

theorem row_98_152 : RowResult ⟨98, by decide⟩ ⟨152, by decide⟩ := by
  have _previous := row_98_151
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨98, by decide⟩) (orbitCodeOfNumber ⟨152, by decide⟩) 1 6 7)

theorem row_98_153 : RowResult ⟨98, by decide⟩ ⟨153, by decide⟩ := by
  have _previous := row_98_152
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨98, by decide⟩) (orbitCodeOfNumber ⟨153, by decide⟩) 1 6 7)

theorem row_98_154 : RowResult ⟨98, by decide⟩ ⟨154, by decide⟩ := by
  have _previous := row_98_153
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨98, by decide⟩) (orbitCodeOfNumber ⟨154, by decide⟩) 1 6 7)

theorem row_98_155 : RowResult ⟨98, by decide⟩ ⟨155, by decide⟩ := by
  have _previous := row_98_154
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨98, by decide⟩) (orbitCodeOfNumber ⟨155, by decide⟩) 1 2 6)

theorem row_98_156 : RowResult ⟨98, by decide⟩ ⟨156, by decide⟩ := by
  have _previous := row_98_155
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
