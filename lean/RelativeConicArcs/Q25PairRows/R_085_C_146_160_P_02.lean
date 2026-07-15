import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_85_146 : RowResult ⟨85, by decide⟩ ⟨146, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_85_147 : RowResult ⟨85, by decide⟩ ⟨147, by decide⟩ := by
  have _previous := row_85_146
  exact Or.inr ⟨orbitCodeOfNumber ⟨36, by decide⟩,
    orbitCodeOfNumber ⟨243, by decide⟩, by decide⟩

theorem row_85_148 : RowResult ⟨85, by decide⟩ ⟨148, by decide⟩ := by
  have _previous := row_85_147
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨243, by decide⟩, by decide⟩

theorem row_85_149 : RowResult ⟨85, by decide⟩ ⟨149, by decide⟩ := by
  have _previous := row_85_148
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨244, by decide⟩, by decide⟩

theorem row_85_150 : RowResult ⟨85, by decide⟩ ⟨150, by decide⟩ := by
  have _previous := row_85_149
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨85, by decide⟩) (orbitCodeOfNumber ⟨150, by decide⟩) 1 6 7)

theorem row_85_151 : RowResult ⟨85, by decide⟩ ⟨151, by decide⟩ := by
  have _previous := row_85_150
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨85, by decide⟩) (orbitCodeOfNumber ⟨151, by decide⟩) 1 6 7)

theorem row_85_152 : RowResult ⟨85, by decide⟩ ⟨152, by decide⟩ := by
  have _previous := row_85_151
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨85, by decide⟩) (orbitCodeOfNumber ⟨152, by decide⟩) 1 6 7)

theorem row_85_153 : RowResult ⟨85, by decide⟩ ⟨153, by decide⟩ := by
  have _previous := row_85_152
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨85, by decide⟩) (orbitCodeOfNumber ⟨153, by decide⟩) 1 6 7)

theorem row_85_154 : RowResult ⟨85, by decide⟩ ⟨154, by decide⟩ := by
  have _previous := row_85_153
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨85, by decide⟩) (orbitCodeOfNumber ⟨154, by decide⟩) 1 6 7)

theorem row_85_155 : RowResult ⟨85, by decide⟩ ⟨155, by decide⟩ := by
  have _previous := row_85_154
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨85, by decide⟩) (orbitCodeOfNumber ⟨155, by decide⟩) 1 2 6)

theorem row_85_156 : RowResult ⟨85, by decide⟩ ⟨156, by decide⟩ := by
  have _previous := row_85_155
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_85_157 : RowResult ⟨85, by decide⟩ ⟨157, by decide⟩ := by
  have _previous := row_85_156
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨85, by decide⟩) (orbitCodeOfNumber ⟨157, by decide⟩) 4 5 6)

theorem row_85_158 : RowResult ⟨85, by decide⟩ ⟨158, by decide⟩ := by
  have _previous := row_85_157
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨85, by decide⟩) (orbitCodeOfNumber ⟨158, by decide⟩) 2 3 6)

theorem row_85_159 : RowResult ⟨85, by decide⟩ ⟨159, by decide⟩ := by
  have _previous := row_85_158
  exact Or.inr ⟨orbitCodeOfNumber ⟨37, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_85_160 : RowResult ⟨85, by decide⟩ ⟨160, by decide⟩ := by
  have _previous := row_85_159
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨85, by decide⟩) (orbitCodeOfNumber ⟨160, by decide⟩) 1 4 6)

end RelativeConicArcs.Q25PairCertificate
