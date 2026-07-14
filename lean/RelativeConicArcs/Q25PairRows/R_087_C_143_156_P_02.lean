import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_87_143 : RowResult ⟨87, by decide⟩ ⟨143, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_87_144 : RowResult ⟨87, by decide⟩ ⟨144, by decide⟩ := by
  have _previous := row_87_143
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_87_145 : RowResult ⟨87, by decide⟩ ⟨145, by decide⟩ := by
  have _previous := row_87_144
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨87, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) 1 2 7)

theorem row_87_146 : RowResult ⟨87, by decide⟩ ⟨146, by decide⟩ := by
  have _previous := row_87_145
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_87_147 : RowResult ⟨87, by decide⟩ ⟨147, by decide⟩ := by
  have _previous := row_87_146
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_87_148 : RowResult ⟨87, by decide⟩ ⟨148, by decide⟩ := by
  have _previous := row_87_147
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_87_149 : RowResult ⟨87, by decide⟩ ⟨149, by decide⟩ := by
  have _previous := row_87_148
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_87_150 : RowResult ⟨87, by decide⟩ ⟨150, by decide⟩ := by
  have _previous := row_87_149
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨87, by decide⟩) (orbitCodeOfNumber ⟨150, by decide⟩) 1 6 7)

theorem row_87_151 : RowResult ⟨87, by decide⟩ ⟨151, by decide⟩ := by
  have _previous := row_87_150
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨87, by decide⟩) (orbitCodeOfNumber ⟨151, by decide⟩) 1 6 7)

theorem row_87_152 : RowResult ⟨87, by decide⟩ ⟨152, by decide⟩ := by
  have _previous := row_87_151
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨87, by decide⟩) (orbitCodeOfNumber ⟨152, by decide⟩) 1 6 7)

theorem row_87_153 : RowResult ⟨87, by decide⟩ ⟨153, by decide⟩ := by
  have _previous := row_87_152
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨87, by decide⟩) (orbitCodeOfNumber ⟨153, by decide⟩) 1 6 7)

theorem row_87_154 : RowResult ⟨87, by decide⟩ ⟨154, by decide⟩ := by
  have _previous := row_87_153
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨87, by decide⟩) (orbitCodeOfNumber ⟨154, by decide⟩) 1 6 7)

theorem row_87_155 : RowResult ⟨87, by decide⟩ ⟨155, by decide⟩ := by
  have _previous := row_87_154
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨87, by decide⟩) (orbitCodeOfNumber ⟨155, by decide⟩) 1 2 6)

theorem row_87_156 : RowResult ⟨87, by decide⟩ ⟨156, by decide⟩ := by
  have _previous := row_87_155
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨87, by decide⟩) (orbitCodeOfNumber ⟨156, by decide⟩) 2 4 7)

end RelativeConicArcs.Q25PairCertificate
