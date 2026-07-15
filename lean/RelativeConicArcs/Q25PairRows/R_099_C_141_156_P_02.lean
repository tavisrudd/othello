import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_99_141 : RowResult ⟨99, by decide⟩ ⟨141, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_99_142 : RowResult ⟨99, by decide⟩ ⟨142, by decide⟩ := by
  have _previous := row_99_141
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_99_143 : RowResult ⟨99, by decide⟩ ⟨143, by decide⟩ := by
  have _previous := row_99_142
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨99, by decide⟩) (orbitCodeOfNumber ⟨143, by decide⟩) 2 4 7)

theorem row_99_144 : RowResult ⟨99, by decide⟩ ⟨144, by decide⟩ := by
  have _previous := row_99_143
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_99_145 : RowResult ⟨99, by decide⟩ ⟨145, by decide⟩ := by
  have _previous := row_99_144
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨99, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) 1 2 7)

theorem row_99_146 : RowResult ⟨99, by decide⟩ ⟨146, by decide⟩ := by
  have _previous := row_99_145
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨99, by decide⟩) (orbitCodeOfNumber ⟨146, by decide⟩) 4 5 6)

theorem row_99_147 : RowResult ⟨99, by decide⟩ ⟨147, by decide⟩ := by
  have _previous := row_99_146
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨242, by decide⟩, by decide⟩

theorem row_99_148 : RowResult ⟨99, by decide⟩ ⟨148, by decide⟩ := by
  have _previous := row_99_147
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨244, by decide⟩, by decide⟩

theorem row_99_149 : RowResult ⟨99, by decide⟩ ⟨149, by decide⟩ := by
  have _previous := row_99_148
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨99, by decide⟩) (orbitCodeOfNumber ⟨149, by decide⟩) 1 4 6)

theorem row_99_150 : RowResult ⟨99, by decide⟩ ⟨150, by decide⟩ := by
  have _previous := row_99_149
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨99, by decide⟩) (orbitCodeOfNumber ⟨150, by decide⟩) 1 6 7)

theorem row_99_151 : RowResult ⟨99, by decide⟩ ⟨151, by decide⟩ := by
  have _previous := row_99_150
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨99, by decide⟩) (orbitCodeOfNumber ⟨151, by decide⟩) 1 6 7)

theorem row_99_152 : RowResult ⟨99, by decide⟩ ⟨152, by decide⟩ := by
  have _previous := row_99_151
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨99, by decide⟩) (orbitCodeOfNumber ⟨152, by decide⟩) 1 6 7)

theorem row_99_153 : RowResult ⟨99, by decide⟩ ⟨153, by decide⟩ := by
  have _previous := row_99_152
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨99, by decide⟩) (orbitCodeOfNumber ⟨153, by decide⟩) 1 6 7)

theorem row_99_154 : RowResult ⟨99, by decide⟩ ⟨154, by decide⟩ := by
  have _previous := row_99_153
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨99, by decide⟩) (orbitCodeOfNumber ⟨154, by decide⟩) 1 6 7)

theorem row_99_155 : RowResult ⟨99, by decide⟩ ⟨155, by decide⟩ := by
  have _previous := row_99_154
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨99, by decide⟩) (orbitCodeOfNumber ⟨155, by decide⟩) 1 2 6)

theorem row_99_156 : RowResult ⟨99, by decide⟩ ⟨156, by decide⟩ := by
  have _previous := row_99_155
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
