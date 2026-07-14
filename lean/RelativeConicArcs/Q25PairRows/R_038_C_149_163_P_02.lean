import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_38_149 : RowResult ⟨38, by decide⟩ ⟨149, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_38_150 : RowResult ⟨38, by decide⟩ ⟨150, by decide⟩ := by
  have _previous := row_38_149
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨38, by decide⟩) (orbitCodeOfNumber ⟨150, by decide⟩) 1 6 7)

theorem row_38_151 : RowResult ⟨38, by decide⟩ ⟨151, by decide⟩ := by
  have _previous := row_38_150
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨38, by decide⟩) (orbitCodeOfNumber ⟨151, by decide⟩) 1 6 7)

theorem row_38_152 : RowResult ⟨38, by decide⟩ ⟨152, by decide⟩ := by
  have _previous := row_38_151
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨38, by decide⟩) (orbitCodeOfNumber ⟨152, by decide⟩) 1 6 7)

theorem row_38_153 : RowResult ⟨38, by decide⟩ ⟨153, by decide⟩ := by
  have _previous := row_38_152
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨38, by decide⟩) (orbitCodeOfNumber ⟨153, by decide⟩) 1 6 7)

theorem row_38_154 : RowResult ⟨38, by decide⟩ ⟨154, by decide⟩ := by
  have _previous := row_38_153
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨38, by decide⟩) (orbitCodeOfNumber ⟨154, by decide⟩) 1 6 7)

theorem row_38_155 : RowResult ⟨38, by decide⟩ ⟨155, by decide⟩ := by
  have _previous := row_38_154
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨38, by decide⟩) (orbitCodeOfNumber ⟨155, by decide⟩) 1 2 6)

theorem row_38_156 : RowResult ⟨38, by decide⟩ ⟨156, by decide⟩ := by
  have _previous := row_38_155
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨38, by decide⟩) (orbitCodeOfNumber ⟨156, by decide⟩) 4 5 6)

theorem row_38_157 : RowResult ⟨38, by decide⟩ ⟨157, by decide⟩ := by
  have _previous := row_38_156
  exact Or.inr ⟨orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

theorem row_38_158 : RowResult ⟨38, by decide⟩ ⟨158, by decide⟩ := by
  have _previous := row_38_157
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨38, by decide⟩) (orbitCodeOfNumber ⟨158, by decide⟩) 2 3 6)

theorem row_38_159 : RowResult ⟨38, by decide⟩ ⟨159, by decide⟩ := by
  have _previous := row_38_158
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_38_160 : RowResult ⟨38, by decide⟩ ⟨160, by decide⟩ := by
  have _previous := row_38_159
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_38_161 : RowResult ⟨38, by decide⟩ ⟨161, by decide⟩ := by
  have _previous := row_38_160
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_38_162 : RowResult ⟨38, by decide⟩ ⟨162, by decide⟩ := by
  have _previous := row_38_161
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_38_163 : RowResult ⟨38, by decide⟩ ⟨163, by decide⟩ := by
  have _previous := row_38_162
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨38, by decide⟩) (orbitCodeOfNumber ⟨163, by decide⟩) 1 4 6)

end RelativeConicArcs.Q25PairCertificate
