import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_47_148 : RowResult ⟨47, by decide⟩ ⟨148, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩,
    orbitCodeOfNumber ⟨243, by decide⟩, by decide⟩

theorem row_47_149 : RowResult ⟨47, by decide⟩ ⟨149, by decide⟩ := by
  have _previous := row_47_148
  exact Or.inr ⟨orbitCodeOfNumber ⟨60, by decide⟩,
    orbitCodeOfNumber ⟨240, by decide⟩, by decide⟩

theorem row_47_150 : RowResult ⟨47, by decide⟩ ⟨150, by decide⟩ := by
  have _previous := row_47_149
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨47, by decide⟩) (orbitCodeOfNumber ⟨150, by decide⟩) 1 6 7)

theorem row_47_151 : RowResult ⟨47, by decide⟩ ⟨151, by decide⟩ := by
  have _previous := row_47_150
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨47, by decide⟩) (orbitCodeOfNumber ⟨151, by decide⟩) 1 6 7)

theorem row_47_152 : RowResult ⟨47, by decide⟩ ⟨152, by decide⟩ := by
  have _previous := row_47_151
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨47, by decide⟩) (orbitCodeOfNumber ⟨152, by decide⟩) 1 6 7)

theorem row_47_153 : RowResult ⟨47, by decide⟩ ⟨153, by decide⟩ := by
  have _previous := row_47_152
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨47, by decide⟩) (orbitCodeOfNumber ⟨153, by decide⟩) 1 6 7)

theorem row_47_154 : RowResult ⟨47, by decide⟩ ⟨154, by decide⟩ := by
  have _previous := row_47_153
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨47, by decide⟩) (orbitCodeOfNumber ⟨154, by decide⟩) 1 6 7)

theorem row_47_155 : RowResult ⟨47, by decide⟩ ⟨155, by decide⟩ := by
  have _previous := row_47_154
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨47, by decide⟩) (orbitCodeOfNumber ⟨155, by decide⟩) 1 2 6)

theorem row_47_156 : RowResult ⟨47, by decide⟩ ⟨156, by decide⟩ := by
  have _previous := row_47_155
  exact Or.inr ⟨orbitCodeOfNumber ⟨61, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_47_157 : RowResult ⟨47, by decide⟩ ⟨157, by decide⟩ := by
  have _previous := row_47_156
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨47, by decide⟩) (orbitCodeOfNumber ⟨157, by decide⟩) 1 4 7)

theorem row_47_158 : RowResult ⟨47, by decide⟩ ⟨158, by decide⟩ := by
  have _previous := row_47_157
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨47, by decide⟩) (orbitCodeOfNumber ⟨158, by decide⟩) 2 3 6)

theorem row_47_159 : RowResult ⟨47, by decide⟩ ⟨159, by decide⟩ := by
  have _previous := row_47_158
  exact Or.inr ⟨orbitCodeOfNumber ⟨60, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_47_160 : RowResult ⟨47, by decide⟩ ⟨160, by decide⟩ := by
  have _previous := row_47_159
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨47, by decide⟩) (orbitCodeOfNumber ⟨160, by decide⟩) 2 4 7)

theorem row_47_161 : RowResult ⟨47, by decide⟩ ⟨161, by decide⟩ := by
  have _previous := row_47_160
  exact Or.inr ⟨orbitCodeOfNumber ⟨65, by decide⟩,
    orbitCodeOfNumber ⟨243, by decide⟩, by decide⟩

theorem row_47_162 : RowResult ⟨47, by decide⟩ ⟨162, by decide⟩ := by
  have _previous := row_47_161
  exact Or.inr ⟨orbitCodeOfNumber ⟨60, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_47_163 : RowResult ⟨47, by decide⟩ ⟨163, by decide⟩ := by
  have _previous := row_47_162
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨47, by decide⟩) (orbitCodeOfNumber ⟨163, by decide⟩) 4 5 6)

end RelativeConicArcs.Q25PairCertificate
