import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_119_149 : RowResult ⟨119, by decide⟩ ⟨149, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨60, by decide⟩, by decide⟩

theorem row_119_150 : RowResult ⟨119, by decide⟩ ⟨150, by decide⟩ := by
  have _previous := row_119_149
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨119, by decide⟩) (orbitCodeOfNumber ⟨150, by decide⟩) 1 6 7)

theorem row_119_151 : RowResult ⟨119, by decide⟩ ⟨151, by decide⟩ := by
  have _previous := row_119_150
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨119, by decide⟩) (orbitCodeOfNumber ⟨151, by decide⟩) 1 6 7)

theorem row_119_152 : RowResult ⟨119, by decide⟩ ⟨152, by decide⟩ := by
  have _previous := row_119_151
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨119, by decide⟩) (orbitCodeOfNumber ⟨152, by decide⟩) 1 6 7)

theorem row_119_153 : RowResult ⟨119, by decide⟩ ⟨153, by decide⟩ := by
  have _previous := row_119_152
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨119, by decide⟩) (orbitCodeOfNumber ⟨153, by decide⟩) 1 6 7)

theorem row_119_154 : RowResult ⟨119, by decide⟩ ⟨154, by decide⟩ := by
  have _previous := row_119_153
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨119, by decide⟩) (orbitCodeOfNumber ⟨154, by decide⟩) 1 6 7)

theorem row_119_155 : RowResult ⟨119, by decide⟩ ⟨155, by decide⟩ := by
  have _previous := row_119_154
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨119, by decide⟩) (orbitCodeOfNumber ⟨155, by decide⟩) 1 2 6)

theorem row_119_156 : RowResult ⟨119, by decide⟩ ⟨156, by decide⟩ := by
  have _previous := row_119_155
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨119, by decide⟩) (orbitCodeOfNumber ⟨156, by decide⟩) 2 5 6)

theorem row_119_157 : RowResult ⟨119, by decide⟩ ⟨157, by decide⟩ := by
  have _previous := row_119_156
  exact Or.inr ⟨orbitCodeOfNumber ⟨237, by decide⟩, by decide⟩

theorem row_119_158 : RowResult ⟨119, by decide⟩ ⟨158, by decide⟩ := by
  have _previous := row_119_157
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨119, by decide⟩) (orbitCodeOfNumber ⟨158, by decide⟩) 2 3 6)

theorem row_119_159 : RowResult ⟨119, by decide⟩ ⟨159, by decide⟩ := by
  have _previous := row_119_158
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_119_160 : RowResult ⟨119, by decide⟩ ⟨160, by decide⟩ := by
  have _previous := row_119_159
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_119_161 : RowResult ⟨119, by decide⟩ ⟨161, by decide⟩ := by
  have _previous := row_119_160
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_119_162 : RowResult ⟨119, by decide⟩ ⟨162, by decide⟩ := by
  have _previous := row_119_161
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
