import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_46_147 : RowResult ⟨46, by decide⟩ ⟨147, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_46_148 : RowResult ⟨46, by decide⟩ ⟨148, by decide⟩ := by
  have _previous := row_46_147
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨46, by decide⟩) (orbitCodeOfNumber ⟨148, by decide⟩) 2 5 6)

theorem row_46_149 : RowResult ⟨46, by decide⟩ ⟨149, by decide⟩ := by
  have _previous := row_46_148
  exact Or.inr ⟨orbitCodeOfNumber ⟨183, by decide⟩, by decide⟩

theorem row_46_150 : RowResult ⟨46, by decide⟩ ⟨150, by decide⟩ := by
  have _previous := row_46_149
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨46, by decide⟩) (orbitCodeOfNumber ⟨150, by decide⟩) 1 6 7)

theorem row_46_151 : RowResult ⟨46, by decide⟩ ⟨151, by decide⟩ := by
  have _previous := row_46_150
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨46, by decide⟩) (orbitCodeOfNumber ⟨151, by decide⟩) 1 6 7)

theorem row_46_152 : RowResult ⟨46, by decide⟩ ⟨152, by decide⟩ := by
  have _previous := row_46_151
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨46, by decide⟩) (orbitCodeOfNumber ⟨152, by decide⟩) 1 6 7)

theorem row_46_153 : RowResult ⟨46, by decide⟩ ⟨153, by decide⟩ := by
  have _previous := row_46_152
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨46, by decide⟩) (orbitCodeOfNumber ⟨153, by decide⟩) 1 6 7)

theorem row_46_154 : RowResult ⟨46, by decide⟩ ⟨154, by decide⟩ := by
  have _previous := row_46_153
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨46, by decide⟩) (orbitCodeOfNumber ⟨154, by decide⟩) 1 6 7)

theorem row_46_155 : RowResult ⟨46, by decide⟩ ⟨155, by decide⟩ := by
  have _previous := row_46_154
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨46, by decide⟩) (orbitCodeOfNumber ⟨155, by decide⟩) 1 2 6)

theorem row_46_156 : RowResult ⟨46, by decide⟩ ⟨156, by decide⟩ := by
  have _previous := row_46_155
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨46, by decide⟩) (orbitCodeOfNumber ⟨156, by decide⟩) 1 4 7)

theorem row_46_157 : RowResult ⟨46, by decide⟩ ⟨157, by decide⟩ := by
  have _previous := row_46_156
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨46, by decide⟩) (orbitCodeOfNumber ⟨157, by decide⟩) 2 4 7)

theorem row_46_158 : RowResult ⟨46, by decide⟩ ⟨158, by decide⟩ := by
  have _previous := row_46_157
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨46, by decide⟩) (orbitCodeOfNumber ⟨158, by decide⟩) 2 3 6)

theorem row_46_159 : RowResult ⟨46, by decide⟩ ⟨159, by decide⟩ := by
  have _previous := row_46_158
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_46_160 : RowResult ⟨46, by decide⟩ ⟨160, by decide⟩ := by
  have _previous := row_46_159
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_46_161 : RowResult ⟨46, by decide⟩ ⟨161, by decide⟩ := by
  have _previous := row_46_160
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_46_162 : RowResult ⟨46, by decide⟩ ⟨162, by decide⟩ := by
  have _previous := row_46_161
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨46, by decide⟩) (orbitCodeOfNumber ⟨162, by decide⟩) 4 5 6)

theorem row_46_163 : RowResult ⟨46, by decide⟩ ⟨163, by decide⟩ := by
  have _previous := row_46_162
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_46_164 : RowResult ⟨46, by decide⟩ ⟨164, by decide⟩ := by
  have _previous := row_46_163
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨46, by decide⟩) (orbitCodeOfNumber ⟨164, by decide⟩) 2 5 7)

theorem row_46_165 : RowResult ⟨46, by decide⟩ ⟨165, by decide⟩ := by
  have _previous := row_46_164
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨46, by decide⟩) (orbitCodeOfNumber ⟨165, by decide⟩) 2 5 6)

end RelativeConicArcs.Q25PairCertificate
