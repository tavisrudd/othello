import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_62_148 : RowResult ⟨62, by decide⟩ ⟨148, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_62_149 : RowResult ⟨62, by decide⟩ ⟨149, by decide⟩ := by
  have _previous := row_62_148
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨62, by decide⟩) (orbitCodeOfNumber ⟨149, by decide⟩) 4 5 6)

theorem row_62_150 : RowResult ⟨62, by decide⟩ ⟨150, by decide⟩ := by
  have _previous := row_62_149
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨62, by decide⟩) (orbitCodeOfNumber ⟨150, by decide⟩) 1 6 7)

theorem row_62_151 : RowResult ⟨62, by decide⟩ ⟨151, by decide⟩ := by
  have _previous := row_62_150
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨62, by decide⟩) (orbitCodeOfNumber ⟨151, by decide⟩) 1 6 7)

theorem row_62_152 : RowResult ⟨62, by decide⟩ ⟨152, by decide⟩ := by
  have _previous := row_62_151
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨62, by decide⟩) (orbitCodeOfNumber ⟨152, by decide⟩) 1 6 7)

theorem row_62_153 : RowResult ⟨62, by decide⟩ ⟨153, by decide⟩ := by
  have _previous := row_62_152
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨62, by decide⟩) (orbitCodeOfNumber ⟨153, by decide⟩) 1 6 7)

theorem row_62_154 : RowResult ⟨62, by decide⟩ ⟨154, by decide⟩ := by
  have _previous := row_62_153
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨62, by decide⟩) (orbitCodeOfNumber ⟨154, by decide⟩) 1 6 7)

theorem row_62_155 : RowResult ⟨62, by decide⟩ ⟨155, by decide⟩ := by
  have _previous := row_62_154
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨62, by decide⟩) (orbitCodeOfNumber ⟨155, by decide⟩) 1 2 6)

theorem row_62_156 : RowResult ⟨62, by decide⟩ ⟨156, by decide⟩ := by
  have _previous := row_62_155
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_62_157 : RowResult ⟨62, by decide⟩ ⟨157, by decide⟩ := by
  have _previous := row_62_156
  exact Or.inr ⟨orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

theorem row_62_158 : RowResult ⟨62, by decide⟩ ⟨158, by decide⟩ := by
  have _previous := row_62_157
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨62, by decide⟩) (orbitCodeOfNumber ⟨158, by decide⟩) 2 3 6)

theorem row_62_159 : RowResult ⟨62, by decide⟩ ⟨159, by decide⟩ := by
  have _previous := row_62_158
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_62_160 : RowResult ⟨62, by decide⟩ ⟨160, by decide⟩ := by
  have _previous := row_62_159
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨62, by decide⟩) (orbitCodeOfNumber ⟨160, by decide⟩) 2 5 6)

theorem row_62_161 : RowResult ⟨62, by decide⟩ ⟨161, by decide⟩ := by
  have _previous := row_62_160
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨62, by decide⟩) (orbitCodeOfNumber ⟨161, by decide⟩) 4 5 6)

theorem row_62_162 : RowResult ⟨62, by decide⟩ ⟨162, by decide⟩ := by
  have _previous := row_62_161
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨62, by decide⟩) (orbitCodeOfNumber ⟨162, by decide⟩) 1 4 6)

end RelativeConicArcs.Q25PairCertificate
