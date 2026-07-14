import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_44_145 : RowResult ⟨44, by decide⟩ ⟨145, by decide⟩ := by
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨44, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) 1 2 7)

theorem row_44_146 : RowResult ⟨44, by decide⟩ ⟨146, by decide⟩ := by
  have _previous := row_44_145
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_44_147 : RowResult ⟨44, by decide⟩ ⟨147, by decide⟩ := by
  have _previous := row_44_146
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_44_148 : RowResult ⟨44, by decide⟩ ⟨148, by decide⟩ := by
  have _previous := row_44_147
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_44_149 : RowResult ⟨44, by decide⟩ ⟨149, by decide⟩ := by
  have _previous := row_44_148
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_44_150 : RowResult ⟨44, by decide⟩ ⟨150, by decide⟩ := by
  have _previous := row_44_149
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨44, by decide⟩) (orbitCodeOfNumber ⟨150, by decide⟩) 1 6 7)

theorem row_44_151 : RowResult ⟨44, by decide⟩ ⟨151, by decide⟩ := by
  have _previous := row_44_150
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨44, by decide⟩) (orbitCodeOfNumber ⟨151, by decide⟩) 1 6 7)

theorem row_44_152 : RowResult ⟨44, by decide⟩ ⟨152, by decide⟩ := by
  have _previous := row_44_151
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨44, by decide⟩) (orbitCodeOfNumber ⟨152, by decide⟩) 1 6 7)

theorem row_44_153 : RowResult ⟨44, by decide⟩ ⟨153, by decide⟩ := by
  have _previous := row_44_152
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨44, by decide⟩) (orbitCodeOfNumber ⟨153, by decide⟩) 1 6 7)

theorem row_44_154 : RowResult ⟨44, by decide⟩ ⟨154, by decide⟩ := by
  have _previous := row_44_153
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨44, by decide⟩) (orbitCodeOfNumber ⟨154, by decide⟩) 1 6 7)

theorem row_44_155 : RowResult ⟨44, by decide⟩ ⟨155, by decide⟩ := by
  have _previous := row_44_154
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨44, by decide⟩) (orbitCodeOfNumber ⟨155, by decide⟩) 1 2 6)

theorem row_44_156 : RowResult ⟨44, by decide⟩ ⟨156, by decide⟩ := by
  have _previous := row_44_155
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_44_157 : RowResult ⟨44, by decide⟩ ⟨157, by decide⟩ := by
  have _previous := row_44_156
  exact Or.inr ⟨orbitCodeOfNumber ⟨237, by decide⟩, by decide⟩

theorem row_44_158 : RowResult ⟨44, by decide⟩ ⟨158, by decide⟩ := by
  have _previous := row_44_157
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨44, by decide⟩) (orbitCodeOfNumber ⟨158, by decide⟩) 2 3 6)

end RelativeConicArcs.Q25PairCertificate
