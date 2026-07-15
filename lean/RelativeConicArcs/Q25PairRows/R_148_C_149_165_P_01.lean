import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_148_149 : RowResult ⟨148, by decide⟩ ⟨149, by decide⟩ := by
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨148, by decide⟩) (orbitCodeOfNumber ⟨149, by decide⟩) 0 4 6)

theorem row_148_150 : RowResult ⟨148, by decide⟩ ⟨150, by decide⟩ := by
  have _previous := row_148_149
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨148, by decide⟩) (orbitCodeOfNumber ⟨150, by decide⟩) 1 6 7)

theorem row_148_151 : RowResult ⟨148, by decide⟩ ⟨151, by decide⟩ := by
  have _previous := row_148_150
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨148, by decide⟩) (orbitCodeOfNumber ⟨151, by decide⟩) 1 6 7)

theorem row_148_152 : RowResult ⟨148, by decide⟩ ⟨152, by decide⟩ := by
  have _previous := row_148_151
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨148, by decide⟩) (orbitCodeOfNumber ⟨152, by decide⟩) 1 6 7)

theorem row_148_153 : RowResult ⟨148, by decide⟩ ⟨153, by decide⟩ := by
  have _previous := row_148_152
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨148, by decide⟩) (orbitCodeOfNumber ⟨153, by decide⟩) 1 6 7)

theorem row_148_154 : RowResult ⟨148, by decide⟩ ⟨154, by decide⟩ := by
  have _previous := row_148_153
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨148, by decide⟩) (orbitCodeOfNumber ⟨154, by decide⟩) 1 6 7)

theorem row_148_155 : RowResult ⟨148, by decide⟩ ⟨155, by decide⟩ := by
  have _previous := row_148_154
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨148, by decide⟩) (orbitCodeOfNumber ⟨155, by decide⟩) 1 2 6)

theorem row_148_156 : RowResult ⟨148, by decide⟩ ⟨156, by decide⟩ := by
  have _previous := row_148_155
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨240, by decide⟩, by decide⟩

theorem row_148_157 : RowResult ⟨148, by decide⟩ ⟨157, by decide⟩ := by
  have _previous := row_148_156
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_148_158 : RowResult ⟨148, by decide⟩ ⟨158, by decide⟩ := by
  have _previous := row_148_157
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨148, by decide⟩) (orbitCodeOfNumber ⟨158, by decide⟩) 1 4 7)

theorem row_148_159 : RowResult ⟨148, by decide⟩ ⟨159, by decide⟩ := by
  have _previous := row_148_158
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨246, by decide⟩, by decide⟩

theorem row_148_160 : RowResult ⟨148, by decide⟩ ⟨160, by decide⟩ := by
  have _previous := row_148_159
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨148, by decide⟩) (orbitCodeOfNumber ⟨160, by decide⟩) 4 5 6)

theorem row_148_161 : RowResult ⟨148, by decide⟩ ⟨161, by decide⟩ := by
  have _previous := row_148_160
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_148_162 : RowResult ⟨148, by decide⟩ ⟨162, by decide⟩ := by
  have _previous := row_148_161
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨246, by decide⟩, by decide⟩

theorem row_148_163 : RowResult ⟨148, by decide⟩ ⟨163, by decide⟩ := by
  have _previous := row_148_162
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_148_164 : RowResult ⟨148, by decide⟩ ⟨164, by decide⟩ := by
  have _previous := row_148_163
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨148, by decide⟩) (orbitCodeOfNumber ⟨164, by decide⟩) 2 4 7)

theorem row_148_165 : RowResult ⟨148, by decide⟩ ⟨165, by decide⟩ := by
  have _previous := row_148_164
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨148, by decide⟩) (orbitCodeOfNumber ⟨165, by decide⟩) 2 4 6)

end RelativeConicArcs.Q25PairCertificate
