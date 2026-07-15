import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_146_147 : RowResult ⟨146, by decide⟩ ⟨147, by decide⟩ := by
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨146, by decide⟩) (orbitCodeOfNumber ⟨147, by decide⟩) 0 4 6)

theorem row_146_148 : RowResult ⟨146, by decide⟩ ⟨148, by decide⟩ := by
  have _previous := row_146_147
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨146, by decide⟩) (orbitCodeOfNumber ⟨148, by decide⟩) 0 4 6)

theorem row_146_149 : RowResult ⟨146, by decide⟩ ⟨149, by decide⟩ := by
  have _previous := row_146_148
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨146, by decide⟩) (orbitCodeOfNumber ⟨149, by decide⟩) 0 4 6)

theorem row_146_150 : RowResult ⟨146, by decide⟩ ⟨150, by decide⟩ := by
  have _previous := row_146_149
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨146, by decide⟩) (orbitCodeOfNumber ⟨150, by decide⟩) 1 6 7)

theorem row_146_151 : RowResult ⟨146, by decide⟩ ⟨151, by decide⟩ := by
  have _previous := row_146_150
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨146, by decide⟩) (orbitCodeOfNumber ⟨151, by decide⟩) 1 6 7)

theorem row_146_152 : RowResult ⟨146, by decide⟩ ⟨152, by decide⟩ := by
  have _previous := row_146_151
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨146, by decide⟩) (orbitCodeOfNumber ⟨152, by decide⟩) 1 6 7)

theorem row_146_153 : RowResult ⟨146, by decide⟩ ⟨153, by decide⟩ := by
  have _previous := row_146_152
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨146, by decide⟩) (orbitCodeOfNumber ⟨153, by decide⟩) 1 6 7)

theorem row_146_154 : RowResult ⟨146, by decide⟩ ⟨154, by decide⟩ := by
  have _previous := row_146_153
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨146, by decide⟩) (orbitCodeOfNumber ⟨154, by decide⟩) 1 6 7)

theorem row_146_155 : RowResult ⟨146, by decide⟩ ⟨155, by decide⟩ := by
  have _previous := row_146_154
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨146, by decide⟩) (orbitCodeOfNumber ⟨155, by decide⟩) 1 2 6)

theorem row_146_156 : RowResult ⟨146, by decide⟩ ⟨156, by decide⟩ := by
  have _previous := row_146_155
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨146, by decide⟩) (orbitCodeOfNumber ⟨156, by decide⟩) 1 4 7)

theorem row_146_157 : RowResult ⟨146, by decide⟩ ⟨157, by decide⟩ := by
  have _previous := row_146_156
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_146_158 : RowResult ⟨146, by decide⟩ ⟨158, by decide⟩ := by
  have _previous := row_146_157
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨146, by decide⟩) (orbitCodeOfNumber ⟨158, by decide⟩) 2 3 6)

theorem row_146_159 : RowResult ⟨146, by decide⟩ ⟨159, by decide⟩ := by
  have _previous := row_146_158
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨146, by decide⟩) (orbitCodeOfNumber ⟨159, by decide⟩) 2 4 6)

theorem row_146_160 : RowResult ⟨146, by decide⟩ ⟨160, by decide⟩ := by
  have _previous := row_146_159
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_146_161 : RowResult ⟨146, by decide⟩ ⟨161, by decide⟩ := by
  have _previous := row_146_160
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_146_162 : RowResult ⟨146, by decide⟩ ⟨162, by decide⟩ := by
  have _previous := row_146_161
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_146_163 : RowResult ⟨146, by decide⟩ ⟨163, by decide⟩ := by
  have _previous := row_146_162
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨146, by decide⟩) (orbitCodeOfNumber ⟨163, by decide⟩) 4 5 6)

theorem row_146_164 : RowResult ⟨146, by decide⟩ ⟨164, by decide⟩ := by
  have _previous := row_146_163
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_146_165 : RowResult ⟨146, by decide⟩ ⟨165, by decide⟩ := by
  have _previous := row_146_164
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨244, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
