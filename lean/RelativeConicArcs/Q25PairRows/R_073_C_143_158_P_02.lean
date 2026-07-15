import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false
set_option linter.unusedVariables false

theorem row_73_143 : RowResult ⟨73, by decide⟩ ⟨143, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_73_144 : RowResult ⟨73, by decide⟩ ⟨144, by decide⟩ := by
  have _previous := row_73_143
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_73_145 : RowResult ⟨73, by decide⟩ ⟨145, by decide⟩ := by
  have _previous := row_73_144
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨73, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) 1 2 7)

theorem row_73_146 : RowResult ⟨73, by decide⟩ ⟨146, by decide⟩ := by
  have _previous := row_73_145
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_73_147 : RowResult ⟨73, by decide⟩ ⟨147, by decide⟩ := by
  have _previous := row_73_146
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_73_148 : RowResult ⟨73, by decide⟩ ⟨148, by decide⟩ := by
  have _previous := row_73_147
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨73, by decide⟩) (orbitCodeOfNumber ⟨148, by decide⟩) 1 4 6)

theorem row_73_149 : RowResult ⟨73, by decide⟩ ⟨149, by decide⟩ := by
  have _previous := row_73_148
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨244, by decide⟩, by decide⟩

theorem row_73_150 : RowResult ⟨73, by decide⟩ ⟨150, by decide⟩ := by
  have _previous := row_73_149
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨73, by decide⟩) (orbitCodeOfNumber ⟨150, by decide⟩) 1 6 7)

theorem row_73_151 : RowResult ⟨73, by decide⟩ ⟨151, by decide⟩ := by
  have _previous := row_73_150
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨73, by decide⟩) (orbitCodeOfNumber ⟨151, by decide⟩) 1 6 7)

theorem row_73_152 : RowResult ⟨73, by decide⟩ ⟨152, by decide⟩ := by
  have _previous := row_73_151
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨73, by decide⟩) (orbitCodeOfNumber ⟨152, by decide⟩) 1 6 7)

theorem row_73_153 : RowResult ⟨73, by decide⟩ ⟨153, by decide⟩ := by
  have _previous := row_73_152
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨73, by decide⟩) (orbitCodeOfNumber ⟨153, by decide⟩) 1 6 7)

theorem row_73_154 : RowResult ⟨73, by decide⟩ ⟨154, by decide⟩ := by
  have _previous := row_73_153
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨73, by decide⟩) (orbitCodeOfNumber ⟨154, by decide⟩) 1 6 7)

theorem row_73_155 : RowResult ⟨73, by decide⟩ ⟨155, by decide⟩ := by
  have _previous := row_73_154
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨73, by decide⟩) (orbitCodeOfNumber ⟨155, by decide⟩) 1 2 6)

theorem row_73_156 : RowResult ⟨73, by decide⟩ ⟨156, by decide⟩ := by
  have _previous := row_73_155
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_73_157 : RowResult ⟨73, by decide⟩ ⟨157, by decide⟩ := by
  have _previous := row_73_156
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨73, by decide⟩) (orbitCodeOfNumber ⟨157, by decide⟩) 2 4 7)

theorem row_73_158 : RowResult ⟨73, by decide⟩ ⟨158, by decide⟩ := by
  have _previous := row_73_157
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨73, by decide⟩) (orbitCodeOfNumber ⟨158, by decide⟩) 1 4 7)

end RelativeConicArcs.Q25PairCertificate
