import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_61_140 : RowResult ⟨61, by decide⟩ ⟨140, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_61_141 : RowResult ⟨61, by decide⟩ ⟨141, by decide⟩ := by
  have _previous := row_61_140
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨61, by decide⟩) (orbitCodeOfNumber ⟨141, by decide⟩) 1 4 7)

theorem row_61_142 : RowResult ⟨61, by decide⟩ ⟨142, by decide⟩ := by
  have _previous := row_61_141
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_61_143 : RowResult ⟨61, by decide⟩ ⟨143, by decide⟩ := by
  have _previous := row_61_142
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_61_144 : RowResult ⟨61, by decide⟩ ⟨144, by decide⟩ := by
  have _previous := row_61_143
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_61_145 : RowResult ⟨61, by decide⟩ ⟨145, by decide⟩ := by
  have _previous := row_61_144
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨61, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) 1 2 7)

theorem row_61_146 : RowResult ⟨61, by decide⟩ ⟨146, by decide⟩ := by
  have _previous := row_61_145
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_61_147 : RowResult ⟨61, by decide⟩ ⟨147, by decide⟩ := by
  have _previous := row_61_146
  exact Or.inr ⟨orbitCodeOfNumber ⟨38, by decide⟩,
    orbitCodeOfNumber ⟨242, by decide⟩, by decide⟩

theorem row_61_148 : RowResult ⟨61, by decide⟩ ⟨148, by decide⟩ := by
  have _previous := row_61_147
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨61, by decide⟩) (orbitCodeOfNumber ⟨148, by decide⟩) 4 5 6)

theorem row_61_149 : RowResult ⟨61, by decide⟩ ⟨149, by decide⟩ := by
  have _previous := row_61_148
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨61, by decide⟩) (orbitCodeOfNumber ⟨149, by decide⟩) 2 4 6)

theorem row_61_150 : RowResult ⟨61, by decide⟩ ⟨150, by decide⟩ := by
  have _previous := row_61_149
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨61, by decide⟩) (orbitCodeOfNumber ⟨150, by decide⟩) 1 6 7)

theorem row_61_151 : RowResult ⟨61, by decide⟩ ⟨151, by decide⟩ := by
  have _previous := row_61_150
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨61, by decide⟩) (orbitCodeOfNumber ⟨151, by decide⟩) 1 6 7)

theorem row_61_152 : RowResult ⟨61, by decide⟩ ⟨152, by decide⟩ := by
  have _previous := row_61_151
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨61, by decide⟩) (orbitCodeOfNumber ⟨152, by decide⟩) 1 6 7)

theorem row_61_153 : RowResult ⟨61, by decide⟩ ⟨153, by decide⟩ := by
  have _previous := row_61_152
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨61, by decide⟩) (orbitCodeOfNumber ⟨153, by decide⟩) 1 6 7)

theorem row_61_154 : RowResult ⟨61, by decide⟩ ⟨154, by decide⟩ := by
  have _previous := row_61_153
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨61, by decide⟩) (orbitCodeOfNumber ⟨154, by decide⟩) 1 6 7)

theorem row_61_155 : RowResult ⟨61, by decide⟩ ⟨155, by decide⟩ := by
  have _previous := row_61_154
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨61, by decide⟩) (orbitCodeOfNumber ⟨155, by decide⟩) 1 2 6)

end RelativeConicArcs.Q25PairCertificate
