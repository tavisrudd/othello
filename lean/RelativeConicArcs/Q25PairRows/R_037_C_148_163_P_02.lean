import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_37_148 : RowResult ⟨37, by decide⟩ ⟨148, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨63, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_37_149 : RowResult ⟨37, by decide⟩ ⟨149, by decide⟩ := by
  have _previous := row_37_148
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨37, by decide⟩) (orbitCodeOfNumber ⟨149, by decide⟩) 2 4 6)

theorem row_37_150 : RowResult ⟨37, by decide⟩ ⟨150, by decide⟩ := by
  have _previous := row_37_149
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨37, by decide⟩) (orbitCodeOfNumber ⟨150, by decide⟩) 1 6 7)

theorem row_37_151 : RowResult ⟨37, by decide⟩ ⟨151, by decide⟩ := by
  have _previous := row_37_150
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨37, by decide⟩) (orbitCodeOfNumber ⟨151, by decide⟩) 1 6 7)

theorem row_37_152 : RowResult ⟨37, by decide⟩ ⟨152, by decide⟩ := by
  have _previous := row_37_151
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨37, by decide⟩) (orbitCodeOfNumber ⟨152, by decide⟩) 1 6 7)

theorem row_37_153 : RowResult ⟨37, by decide⟩ ⟨153, by decide⟩ := by
  have _previous := row_37_152
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨37, by decide⟩) (orbitCodeOfNumber ⟨153, by decide⟩) 1 6 7)

theorem row_37_154 : RowResult ⟨37, by decide⟩ ⟨154, by decide⟩ := by
  have _previous := row_37_153
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨37, by decide⟩) (orbitCodeOfNumber ⟨154, by decide⟩) 1 6 7)

theorem row_37_155 : RowResult ⟨37, by decide⟩ ⟨155, by decide⟩ := by
  have _previous := row_37_154
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨37, by decide⟩) (orbitCodeOfNumber ⟨155, by decide⟩) 1 2 6)

theorem row_37_156 : RowResult ⟨37, by decide⟩ ⟨156, by decide⟩ := by
  have _previous := row_37_155
  exact Or.inr ⟨orbitCodeOfNumber ⟨64, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_37_157 : RowResult ⟨37, by decide⟩ ⟨157, by decide⟩ := by
  have _previous := row_37_156
  exact Or.inr ⟨orbitCodeOfNumber ⟨60, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_37_158 : RowResult ⟨37, by decide⟩ ⟨158, by decide⟩ := by
  have _previous := row_37_157
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨37, by decide⟩) (orbitCodeOfNumber ⟨158, by decide⟩) 2 3 6)

theorem row_37_159 : RowResult ⟨37, by decide⟩ ⟨159, by decide⟩ := by
  have _previous := row_37_158
  exact Or.inr ⟨orbitCodeOfNumber ⟨63, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_37_160 : RowResult ⟨37, by decide⟩ ⟨160, by decide⟩ := by
  have _previous := row_37_159
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_37_161 : RowResult ⟨37, by decide⟩ ⟨161, by decide⟩ := by
  have _previous := row_37_160
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨37, by decide⟩) (orbitCodeOfNumber ⟨161, by decide⟩) 2 5 7)

theorem row_37_162 : RowResult ⟨37, by decide⟩ ⟨162, by decide⟩ := by
  have _previous := row_37_161
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨37, by decide⟩) (orbitCodeOfNumber ⟨162, by decide⟩) 1 4 6)

theorem row_37_163 : RowResult ⟨37, by decide⟩ ⟨163, by decide⟩ := by
  have _previous := row_37_162
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
