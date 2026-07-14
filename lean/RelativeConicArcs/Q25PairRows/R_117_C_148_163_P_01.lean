import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_117_148 : RowResult ⟨117, by decide⟩ ⟨148, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_117_149 : RowResult ⟨117, by decide⟩ ⟨149, by decide⟩ := by
  have _previous := row_117_148
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨117, by decide⟩) (orbitCodeOfNumber ⟨149, by decide⟩) 2 4 6)

theorem row_117_150 : RowResult ⟨117, by decide⟩ ⟨150, by decide⟩ := by
  have _previous := row_117_149
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨117, by decide⟩) (orbitCodeOfNumber ⟨150, by decide⟩) 1 6 7)

theorem row_117_151 : RowResult ⟨117, by decide⟩ ⟨151, by decide⟩ := by
  have _previous := row_117_150
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨117, by decide⟩) (orbitCodeOfNumber ⟨151, by decide⟩) 1 6 7)

theorem row_117_152 : RowResult ⟨117, by decide⟩ ⟨152, by decide⟩ := by
  have _previous := row_117_151
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨117, by decide⟩) (orbitCodeOfNumber ⟨152, by decide⟩) 1 6 7)

theorem row_117_153 : RowResult ⟨117, by decide⟩ ⟨153, by decide⟩ := by
  have _previous := row_117_152
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨117, by decide⟩) (orbitCodeOfNumber ⟨153, by decide⟩) 1 6 7)

theorem row_117_154 : RowResult ⟨117, by decide⟩ ⟨154, by decide⟩ := by
  have _previous := row_117_153
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨117, by decide⟩) (orbitCodeOfNumber ⟨154, by decide⟩) 1 6 7)

theorem row_117_155 : RowResult ⟨117, by decide⟩ ⟨155, by decide⟩ := by
  have _previous := row_117_154
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨117, by decide⟩) (orbitCodeOfNumber ⟨155, by decide⟩) 1 2 6)

theorem row_117_156 : RowResult ⟨117, by decide⟩ ⟨156, by decide⟩ := by
  have _previous := row_117_155
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_117_157 : RowResult ⟨117, by decide⟩ ⟨157, by decide⟩ := by
  have _previous := row_117_156
  exact Or.inr ⟨orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

theorem row_117_158 : RowResult ⟨117, by decide⟩ ⟨158, by decide⟩ := by
  have _previous := row_117_157
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨117, by decide⟩) (orbitCodeOfNumber ⟨158, by decide⟩) 2 3 6)

theorem row_117_159 : RowResult ⟨117, by decide⟩ ⟨159, by decide⟩ := by
  have _previous := row_117_158
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_117_160 : RowResult ⟨117, by decide⟩ ⟨160, by decide⟩ := by
  have _previous := row_117_159
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨117, by decide⟩) (orbitCodeOfNumber ⟨160, by decide⟩) 2 5 7)

theorem row_117_161 : RowResult ⟨117, by decide⟩ ⟨161, by decide⟩ := by
  have _previous := row_117_160
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_117_162 : RowResult ⟨117, by decide⟩ ⟨162, by decide⟩ := by
  have _previous := row_117_161
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨117, by decide⟩) (orbitCodeOfNumber ⟨162, by decide⟩) 1 4 7)

theorem row_117_163 : RowResult ⟨117, by decide⟩ ⟨163, by decide⟩ := by
  have _previous := row_117_162
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
