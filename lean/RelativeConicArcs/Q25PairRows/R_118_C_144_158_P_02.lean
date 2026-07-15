import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_118_144 : RowResult ⟨118, by decide⟩ ⟨144, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_118_145 : RowResult ⟨118, by decide⟩ ⟨145, by decide⟩ := by
  have _previous := row_118_144
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨118, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) 1 2 7)

theorem row_118_146 : RowResult ⟨118, by decide⟩ ⟨146, by decide⟩ := by
  have _previous := row_118_145
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_118_147 : RowResult ⟨118, by decide⟩ ⟨147, by decide⟩ := by
  have _previous := row_118_146
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨118, by decide⟩) (orbitCodeOfNumber ⟨147, by decide⟩) 2 4 7)

theorem row_118_148 : RowResult ⟨118, by decide⟩ ⟨148, by decide⟩ := by
  have _previous := row_118_147
  exact Or.inr ⟨orbitCodeOfNumber ⟨37, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_118_149 : RowResult ⟨118, by decide⟩ ⟨149, by decide⟩ := by
  have _previous := row_118_148
  exact Or.inr ⟨orbitCodeOfNumber ⟨40, by decide⟩,
    orbitCodeOfNumber ⟨246, by decide⟩, by decide⟩

theorem row_118_150 : RowResult ⟨118, by decide⟩ ⟨150, by decide⟩ := by
  have _previous := row_118_149
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨118, by decide⟩) (orbitCodeOfNumber ⟨150, by decide⟩) 1 6 7)

theorem row_118_151 : RowResult ⟨118, by decide⟩ ⟨151, by decide⟩ := by
  have _previous := row_118_150
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨118, by decide⟩) (orbitCodeOfNumber ⟨151, by decide⟩) 1 6 7)

theorem row_118_152 : RowResult ⟨118, by decide⟩ ⟨152, by decide⟩ := by
  have _previous := row_118_151
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨118, by decide⟩) (orbitCodeOfNumber ⟨152, by decide⟩) 1 6 7)

theorem row_118_153 : RowResult ⟨118, by decide⟩ ⟨153, by decide⟩ := by
  have _previous := row_118_152
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨118, by decide⟩) (orbitCodeOfNumber ⟨153, by decide⟩) 1 6 7)

theorem row_118_154 : RowResult ⟨118, by decide⟩ ⟨154, by decide⟩ := by
  have _previous := row_118_153
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨118, by decide⟩) (orbitCodeOfNumber ⟨154, by decide⟩) 1 6 7)

theorem row_118_155 : RowResult ⟨118, by decide⟩ ⟨155, by decide⟩ := by
  have _previous := row_118_154
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨118, by decide⟩) (orbitCodeOfNumber ⟨155, by decide⟩) 1 2 6)

theorem row_118_156 : RowResult ⟨118, by decide⟩ ⟨156, by decide⟩ := by
  have _previous := row_118_155
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_118_157 : RowResult ⟨118, by decide⟩ ⟨157, by decide⟩ := by
  have _previous := row_118_156
  exact Or.inr ⟨orbitCodeOfNumber ⟨36, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_118_158 : RowResult ⟨118, by decide⟩ ⟨158, by decide⟩ := by
  have _previous := row_118_157
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨118, by decide⟩) (orbitCodeOfNumber ⟨158, by decide⟩) 2 3 6)

end RelativeConicArcs.Q25PairCertificate
