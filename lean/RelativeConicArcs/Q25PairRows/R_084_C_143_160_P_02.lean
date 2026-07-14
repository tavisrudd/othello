import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_84_143 : RowResult ⟨84, by decide⟩ ⟨143, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨237, by decide⟩, by decide⟩

theorem row_84_144 : RowResult ⟨84, by decide⟩ ⟨144, by decide⟩ := by
  have _previous := row_84_143
  exact Or.inr ⟨orbitCodeOfNumber ⟨237, by decide⟩, by decide⟩

theorem row_84_145 : RowResult ⟨84, by decide⟩ ⟨145, by decide⟩ := by
  have _previous := row_84_144
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨84, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) 1 2 7)

theorem row_84_146 : RowResult ⟨84, by decide⟩ ⟨146, by decide⟩ := by
  have _previous := row_84_145
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_84_147 : RowResult ⟨84, by decide⟩ ⟨147, by decide⟩ := by
  have _previous := row_84_146
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_84_148 : RowResult ⟨84, by decide⟩ ⟨148, by decide⟩ := by
  have _previous := row_84_147
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨84, by decide⟩) (orbitCodeOfNumber ⟨148, by decide⟩) 2 4 7)

theorem row_84_149 : RowResult ⟨84, by decide⟩ ⟨149, by decide⟩ := by
  have _previous := row_84_148
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨84, by decide⟩) (orbitCodeOfNumber ⟨149, by decide⟩) 1 4 7)

theorem row_84_150 : RowResult ⟨84, by decide⟩ ⟨150, by decide⟩ := by
  have _previous := row_84_149
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨84, by decide⟩) (orbitCodeOfNumber ⟨150, by decide⟩) 1 6 7)

theorem row_84_151 : RowResult ⟨84, by decide⟩ ⟨151, by decide⟩ := by
  have _previous := row_84_150
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨84, by decide⟩) (orbitCodeOfNumber ⟨151, by decide⟩) 1 6 7)

theorem row_84_152 : RowResult ⟨84, by decide⟩ ⟨152, by decide⟩ := by
  have _previous := row_84_151
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨84, by decide⟩) (orbitCodeOfNumber ⟨152, by decide⟩) 1 6 7)

theorem row_84_153 : RowResult ⟨84, by decide⟩ ⟨153, by decide⟩ := by
  have _previous := row_84_152
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨84, by decide⟩) (orbitCodeOfNumber ⟨153, by decide⟩) 1 6 7)

theorem row_84_154 : RowResult ⟨84, by decide⟩ ⟨154, by decide⟩ := by
  have _previous := row_84_153
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨84, by decide⟩) (orbitCodeOfNumber ⟨154, by decide⟩) 1 6 7)

theorem row_84_155 : RowResult ⟨84, by decide⟩ ⟨155, by decide⟩ := by
  have _previous := row_84_154
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨84, by decide⟩) (orbitCodeOfNumber ⟨155, by decide⟩) 1 2 6)

theorem row_84_156 : RowResult ⟨84, by decide⟩ ⟨156, by decide⟩ := by
  have _previous := row_84_155
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_84_157 : RowResult ⟨84, by decide⟩ ⟨157, by decide⟩ := by
  have _previous := row_84_156
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨84, by decide⟩) (orbitCodeOfNumber ⟨157, by decide⟩) 2 5 6)

theorem row_84_158 : RowResult ⟨84, by decide⟩ ⟨158, by decide⟩ := by
  have _previous := row_84_157
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨84, by decide⟩) (orbitCodeOfNumber ⟨158, by decide⟩) 2 3 6)

theorem row_84_159 : RowResult ⟨84, by decide⟩ ⟨159, by decide⟩ := by
  have _previous := row_84_158
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨84, by decide⟩) (orbitCodeOfNumber ⟨159, by decide⟩) 1 4 6)

theorem row_84_160 : RowResult ⟨84, by decide⟩ ⟨160, by decide⟩ := by
  have _previous := row_84_159
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
